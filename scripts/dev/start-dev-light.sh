#!/bin/bash
# start-dev-light.sh - Start the development environment with minimal dependencies

# Get the project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."
BACKEND_DIR="$PROJECT_ROOT/backend"

# Function to kill process on port
kill_port() {
    local port=$1
    if lsof -ti:$port >/dev/null; then
        echo "Killing process on port $port..."
        lsof -ti:$port | xargs kill -9
    fi
}

# Kill any existing processes on the ports
kill_port 8001  # Backend port
kill_port 5173  # Frontend port

# Load environment variables - with better error checking
ENV_FILE="$BACKEND_DIR/.env.dev"
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: $ENV_FILE not found!"
    echo "Please create this file with your Supabase credentials."
    exit 1
fi

echo "Loading environment from $ENV_FILE"
set -a  # automatically export all variables
source "$ENV_FILE"
set +a

# Add backend/src to PYTHONPATH
export PYTHONPATH="$BACKEND_DIR/src:$PYTHONPATH"

# Install lightweight development requirements
echo "Installing lightweight development requirements..."
cd backend
source venv/bin/activate
uv pip install -r requirements/requirements.development.light.txt

# Start backend server in background
cd "$BACKEND_DIR"
python -m uvicorn src.app.main:app --reload --port 8001 &

# Start frontend server in background
cd "$PROJECT_ROOT/frontend"
npm run dev &

echo "Lightweight development servers started!"
echo "Backend running on http://localhost:8001"
echo "Frontend running on http://localhost:5173"
echo ""
echo "Note: This is a lightweight setup with minimal dependencies."
echo "Available tools:"
echo "- Auto-reload (watchfiles)"
echo "- Debug support (debugpy)"
echo "- Basic testing (pytest)"
echo "- Better console output (rich)"

# Wait for both processes
wait 