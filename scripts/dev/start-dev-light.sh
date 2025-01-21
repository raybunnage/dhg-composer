#!/bin/bash
# Lightweight development environment startup for monorepo applications

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default ports
DEFAULT_BACKEND_PORT=8001
DEFAULT_FRONTEND_PORT=5173

# Function to display usage
show_usage() {
    echo -e "${YELLOW}Usage: $0 <app-name> [backend-port] [frontend-port]${NC}"
    echo "Example: $0 dhg-baseline 8001 5173"
    exit 1
}

# Function to kill process on port
kill_port() {
    local port=$1
    if lsof -ti:$port >/dev/null; then
        echo -e "${YELLOW}Killing process on port $port...${NC}"
        lsof -ti:$port | xargs kill -9
    fi
}

# Function to validate app exists
validate_app() {
    local app_name=$1
    if [ ! -d "apps/$app_name" ]; then
        echo -e "${RED}Error: Application '$app_name' not found in apps directory${NC}"
        exit 1
    fi
}

# Get the project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."

# Parse arguments
APP_NAME=$1
BACKEND_PORT=${2:-$DEFAULT_BACKEND_PORT}
FRONTEND_PORT=${3:-$DEFAULT_FRONTEND_PORT}

# Validate input
if [ -z "$APP_NAME" ]; then
    show_usage
fi

validate_app "$APP_NAME"

# Set application directories
APP_DIR="$PROJECT_ROOT/apps/$APP_NAME"
BACKEND_DIR="$APP_DIR/backend"
FRONTEND_DIR="$APP_DIR/frontend"

# Validate directories exist
if [ ! -d "$BACKEND_DIR" ] || [ ! -d "$FRONTEND_DIR" ]; then
    echo -e "${RED}Error: Invalid application structure. Missing backend or frontend directory${NC}"
    exit 1
}

# Kill any existing processes on the ports
kill_port $BACKEND_PORT
kill_port $FRONTEND_PORT

# Load environment variables
ENV_FILE="$BACKEND_DIR/.env.development"
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}Error: $ENV_FILE not found!${NC}"
    echo -e "${YELLOW}Creating .env.development from .env.example...${NC}"
    if [ -f "$BACKEND_DIR/.env.example" ]; then
        cp "$BACKEND_DIR/.env.example" "$ENV_FILE"
    else
        echo -e "${RED}Error: No .env.example found!${NC}"
        exit 1
    fi
fi

echo -e "${YELLOW}Loading environment from $ENV_FILE${NC}"
set -a
source "$ENV_FILE"
set +a

# Add backend/src to PYTHONPATH
export PYTHONPATH="$BACKEND_DIR/src:$PYTHONPATH"

# Install lightweight development requirements
echo -e "${YELLOW}Installing lightweight development requirements...${NC}"
cd "$BACKEND_DIR" || exit 1
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}Creating virtual environment...${NC}"
    python -m venv venv
fi
source venv/bin/activate
uv pip install -r requirements/requirements.development.light.txt || exit 1

# Start backend server in background
echo -e "${YELLOW}Starting backend server for $APP_NAME...${NC}"
python -m uvicorn src.app.main:app --reload --port $BACKEND_PORT &
BACKEND_PID=$!

# Start frontend server in background
echo -e "${YELLOW}Starting frontend server for $APP_NAME...${NC}"
cd "$FRONTEND_DIR" || exit 1
if [ ! -f "package.json" ]; then
    echo -e "${RED}Error: package.json not found in frontend directory${NC}"
    exit 1
fi

# Install frontend dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}Installing frontend dependencies...${NC}"
    yarn install
fi

# Set frontend port in vite config if needed
VITE_PORT=$FRONTEND_PORT yarn dev &
FRONTEND_PID=$!

# Function to cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}Cleaning up...${NC}"
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    deactivate 2>/dev/null
    exit
}

trap cleanup SIGINT SIGTERM

echo -e "${GREEN}Development servers started for $APP_NAME!${NC}"
echo "Backend running on http://localhost:$BACKEND_PORT"
echo "Frontend running on http://localhost:$FRONTEND_PORT"
echo -e "${YELLOW}Press Ctrl+C to stop all servers${NC}"

# Wait for both processes
wait 