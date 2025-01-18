#!/bin/bash

echo "Starting project rebuild..."

# Kill any existing processes
echo "Killing existing processes..."
kill -9 $(lsof -t -i:8001) 2>/dev/null || true
kill -9 $(lsof -t -i:5173) 2>/dev/null || true

# Backend setup
echo "Setting up backend..."
cd backend

# Remove existing venv if it exists
if [ -d "venv" ]; then
    echo "Removing existing virtual environment..."
    rm -rf venv
fi

# Create and activate virtual environment
echo "Creating virtual environment..."
python -m venv venv
source venv/bin/activate

# Upgrade pip first
echo "Upgrading pip..."
pip install --upgrade pip

# Install requirements using pip first
echo "Installing requirements with pip..."
pip install -r requirements.txt

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
