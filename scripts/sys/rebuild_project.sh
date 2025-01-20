#!/bin/bash

echo "Starting project rebuild..."

# Kill any existing processes
echo "Killing existing processes..."
kill -9 $(lsof -t -i:8001) 2>/dev/null || true
kill -9 $(lsof -t -i:5173) 2>/dev/null || true

# Backend setup
echo "Setting up backend..."
echo "Creating virtual environment..."
python -m venv venv

echo "Upgrading pip..."
source venv/bin/activate
python -m pip install --upgrade pip
python -m pip install uv

# Install requirements based on environment
ENV=${ENV:-development}
DEV_MODE=${DEV_MODE:-full}  # New variable for development mode
echo "Installing $ENV requirements..."

case $ENV in
  development)
    if [ "$DEV_MODE" = "light" ]; then
      echo "Installing lightweight development requirements..."
      uv pip install -r backend/requirements/requirements.development.light.txt
    else
      echo "Installing full development requirements..."
      uv pip install -r backend/requirements/requirements.development.txt
    fi
    ;;
  staging)
    uv pip install -r backend/requirements/requirements.staging.txt
    ;;
  production)
    uv pip install -r backend/requirements/requirements.production.txt
    ;;
  *)
    echo "Unknown environment: $ENV"
    exit 1
    ;;
esac

# Frontend setup
echo "Setting up frontend..."
cd frontend

# Install npm dependencies
echo "Installing npm dependencies..."
npm install

cd ..

echo "Rebuild complete! To start the servers:"
echo "1. Backend: cd backend && source venv/bin/activate && uvicorn src.app.main:app --reload --port 8001"
echo "2. Frontend: cd frontend && npm run dev"
