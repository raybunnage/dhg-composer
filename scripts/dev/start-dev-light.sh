#!/bin/bash
# Lightweight development environment startup

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

set -e  # Exit on any error
trap 'echo -e "${RED}Error on line $LINENO${NC}"; exit 1' ERR

# Get the project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."
BACKEND_DIR="$PROJECT_ROOT/backend"

# Function to kill process on port
kill_port() {
    local port=$1
    if lsof -ti:$port >/dev/null; then
        echo -e "${YELLOW}Killing process on port $port...${NC}"
        lsof -ti:$port | xargs kill -9
    fi
}

# Kill any existing processes on the ports
kill_port 8001  # Backend port
kill_port 5173  # Frontend port

# Load environment variables
ENV_FILE="$BACKEND_DIR/.env.dev"
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}Error: $ENV_FILE not found!${NC}"
    exit 1
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
source venv/bin/activate
uv pip install -r requirements/requirements.development.light.txt || exit 1

# Start backend server in background
echo -e "${YELLOW}Starting backend server...${NC}"
python -m uvicorn src.app.main:app --reload --port 8001 &
BACKEND_PID=$!

# Start frontend server in background
echo -e "${YELLOW}Starting frontend server...${NC}"
cd "$PROJECT_ROOT/frontend" || exit 1
npm run dev &
FRONTEND_PID=$!

# Function to cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}Cleaning up...${NC}"
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    exit
}

trap cleanup SIGINT SIGTERM

echo -e "${GREEN}Development servers started!${NC}"
echo "Backend running on http://localhost:8001"
echo "Frontend running on http://localhost:5173"
echo -e "${YELLOW}Press Ctrl+C to stop all servers${NC}"

# Wait for both processes
wait 