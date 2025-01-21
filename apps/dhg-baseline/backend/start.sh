#!/bin/bash

# Function to kill process on port 8001
kill_port_8001() {
    if lsof -ti:8001 >/dev/null; then
        echo "Killing process on port 8001..."
        lsof -ti:8001 | xargs kill -9
        echo "Process on port 8001 killed."
    else
        echo "No process running on port 8001."
    fi
}

# Handle command line arguments
case "$1" in
    "kill")
        echo "Checking for processes on port 8001..."
        kill_port_8001
        exit 0
        ;;
    "development"|"")
        ENV="development"
        ;;
    "production")
        ENV="production"
        ;;
    *)
        echo "Invalid argument: $1"
        echo "Usage: ./start.sh [development|production|kill]"
        exit 1
        ;;
esac

# Only continue if we're not in kill mode
echo "Starting DHG Baseline API in $ENV mode..."

# Kill any existing process on port 8001
kill_port_8001

if [ "$ENV" = "development" ]; then
    pip install -r requirements/requirements.development.light.txt
    uvicorn src.main:app --reload --host 0.0.0.0 --port 8001
elif [ "$ENV" = "production" ]; then
    pip install -r requirements/requirements.production.txt
    uvicorn src.main:app --host 0.0.0.0 --port 8001 --workers 4
fi 