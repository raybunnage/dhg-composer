#!/bin/bash

# Check if process is running on port 5173
if lsof -Pi :5173 -sTCP:LISTEN -t >/dev/null ; then
    echo "Process already running on port 5173. Stopping it..."
    lsof -ti :5173 | xargs kill -9
fi

echo "Starting DHG Baseline Frontend..."
npm run dev:frontend 