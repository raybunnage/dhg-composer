#!/bin/bash
# start-dev.sh
# Start the development environment

# Start backend
cd backend
source venv/bin/activate
uvicorn main:app --reload --port 8001 &

# Start frontend
cd ../frontend
npm run dev