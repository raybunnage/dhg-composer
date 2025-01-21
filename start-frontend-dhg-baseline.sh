#!/bin/bash

# Function to kill process on port 5173
kill_port_5173() {
    if lsof -ti:5173 >/dev/null; then
        echo "Killing process on port 5173..."
        lsof -ti:5173 | xargs kill -9
        echo "Process on port 5173 killed."
    else
        echo "No process running on port 5173."
    fi
}

# Handle command line arguments
case "$1" in
    "kill")
        echo "Checking for processes on port 5173..."
        kill_port_5173
        exit 0
        ;;
    "")
        ;;
    *)
        echo "Invalid argument: $1"
        echo "Usage: ./start-frontend-dhg-baseline.sh [kill]"
        exit 1
        ;;
esac

# Kill any existing process on port 5173
kill_port_5173

echo "Starting DHG Baseline Frontend..."
npm run dev:frontend 