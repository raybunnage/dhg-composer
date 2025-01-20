#!/bin/bash
set -e  # Exit on any error

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

# Load environment variables
ENV_FILE="$BACKEND_DIR/.env.dev"
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: $ENV_FILE not found!"
    exit 1
fi

echo "Loading environment from $ENV_FILE"
set -a
source "$ENV_FILE"
set +a

# Add backend/src to PYTHONPATH
export PYTHONPATH="$BACKEND_DIR/src:$PYTHONPATH"

# Install lightweight development requirements
echo "Installing lightweight development requirements..."
cd "$BACKEND_DIR" || exit 1
source venv/bin/activate

# Install requirements and exit if it fails
uv pip install -r requirements/requirements.development.light.txt || exit 1

# Start backend server in background
echo "Starting backend server..."
python -m uvicorn src.app.main:app --reload --port 8001 &
BACKEND_PID=$!

# Start frontend server in background
echo "Starting frontend server..."
cd "$PROJECT_ROOT/frontend" || exit 1
npm run dev &
FRONTEND_PID=$!

# Function to cleanup on exit
cleanup() {
    echo "Cleaning up..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    exit
}

trap cleanup SIGINT SIGTERM

echo "Development servers started!"
echo "Backend running on http://localhost:8001"
echo "Frontend running on http://localhost:5173"
echo ""
echo "Press Ctrl+C to stop all servers"

# Wait for both processes
wait 