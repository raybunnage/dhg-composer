#!/bin/bash
# start-dev.sh - Start the development environment

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
echo "Loading environment from backend/.env.dev"
source "$BACKEND_DIR/.env.dev"

# Add backend/src to PYTHONPATH
export PYTHONPATH="$BACKEND_DIR/src:$PYTHONPATH"

# Install development requirements
echo "Installing development requirements..."
cd backend
source venv/bin/activate
uv pip install -r requirements/requirements.development.txt

# Start backend server in background
cd "$BACKEND_DIR"
python -m uvicorn src.app.main:app --reload --port 8001 &

# Start frontend server in background
cd "$PROJECT_ROOT/frontend"
npm run dev &

echo "Development servers started!"
echo "Backend running on http://localhost:8001"
echo "Frontend running on http://localhost:5173"

# Wait for both processes
wait