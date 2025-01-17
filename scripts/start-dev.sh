#!/bin/bash
# start-dev.sh
# Start the development environment

# Check if port 8001 is in use and kill the process if found
PORT_PID=$(lsof -ti:8001)
if [ ! -z "$PORT_PID" ]; then
    echo "Port 8001 is in use. Killing process..."
    kill -9 $PORT_PID
fi

# Check if any Vite dev servers are running (default port 5173)
VITE_PID=$(lsof -ti:5173)
if [ ! -z "$VITE_PID" ]; then
    echo "Vite dev server is running. Killing process..."
    kill -9 $VITE_PID
fi


# Start backend
cd backend
source venv/bin/activate
uvicorn main:app --reload --port 8001 &

# Start frontend
cd ../frontend
npm run dev