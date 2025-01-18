#!/bin/bash

echo "Starting project rebuild..."

# Kill any existing processes
echo "Killing existing processes..."
kill -9 $(lsof -t -i:8001) 2>/dev/null || true
kill -9 $(lsof -t -i:5173) 2>/dev/null || true

# Backend setup
echo "Setting up backend..."
cd backend
echo "Removing existing virtual environment..."
rm -rf venv
echo "Creating virtual environment..."
python -m venv venv
source venv/bin/activate
echo "Upgrading pip..."
uv pip install --upgrade pip
echo "Installing requirements with uv..."
uv pip install "fastapi[all]" "uvicorn[standard]" "python-dotenv" "supabase>=2.2.1" --deps
uv pip freeze > requirements.txt

cd ..

# Frontend setup
echo "Setting up frontend..."
cd frontend

# Install npm dependencies
echo "Installing npm dependencies..."
npm install

cd ..

echo "Rebuild complete! To start the servers:"
echo "1. Backend: cd backend && source venv/bin/activate && uvicorn main:app --reload --port 8001"
echo "2. Frontend: cd frontend && npm run dev"
