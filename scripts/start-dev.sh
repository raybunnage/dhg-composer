#!/bin/bash
# start-dev.sh - Start the development environment

# Accept environment parameter (dev, staging, prod), default to dev
ENVIRONMENT=${1:-dev}
ENV_FILE="backend/.env.${ENVIRONMENT}"

# Create environment file from example if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    if [ -f "backend/.env.example" ]; then
        echo "Creating $ENV_FILE from example..."
        cp backend/.env.example "$ENV_FILE"
        echo "Created $ENV_FILE. Please update it with your values."
        echo "Edit $ENV_FILE now? [y/N]"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            ${EDITOR:-vim} "$ENV_FILE"
        fi
    else
        echo "Error: No .env.example file found in backend directory"
        exit 1
    fi
fi

# Load appropriate environment variables
echo "Loading environment from $ENV_FILE"
set -a  # automatically export all variables
source "$ENV_FILE"
set +a

# Kill any existing processes on the ports
kill -9 $(lsof -t -i:8001) 2>/dev/null || true
kill -9 $(lsof -t -i:5173) 2>/dev/null || true

# Start backend
cd backend
source venv/bin/activate
uvicorn main:app --reload --port 8001 &

# Start frontend
cd ../frontend
npm run dev &

echo "Development servers started!"
echo "Backend running on http://localhost:8001"
echo "Frontend running on http://localhost:5173"