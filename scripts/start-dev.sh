#!/bin/bash
# start-dev.sh - Start the development environment

# Accept environment parameter (dev, staging, prod), default to dev
ENVIRONMENT=${1:-dev}
ENV_FILE="backend/.env.${ENVIRONMENT}"

# Verify environment file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: Environment file $ENV_FILE not found"
    echo "Please create it from .env.example:"
    echo "cp backend/.env.example $ENV_FILE"
    exit 1
fi

# Load appropriate environment variables
echo "Loading environment from $ENV_FILE"
export $(cat $ENV_FILE | xargs)

# Kill existing processes
kill -9 $(lsof -t -i:8001) 2>/dev/null || true
kill -9 $(lsof -t -i:5173) 2>/dev/null || true

# Start backend with specific env file
cd backend
source venv/bin/activate
uvicorn main:app --reload --port 8001 --env-file $ENV_FILE &

# Start frontend
cd ../frontend
npm run dev