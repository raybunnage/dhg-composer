#!/bin/bash
# start-dev.sh - Start the development environment

# Accept environment parameter (dev, staging, prod), default to dev
ENVIRONMENT=${1:-dev}
ENV_FILE="backend/.env.${ENVIRONMENT}"

# Load appropriate environment variables
if [ -f "$ENV_FILE" ]; then
    echo "Loading environment from $ENV_FILE"
    export $(cat $ENV_FILE | xargs)
else
    echo "Warning: $ENV_FILE not found, using default .env"
fi

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