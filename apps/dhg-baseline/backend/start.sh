#!/bin/bash

# Default environment to development
ENV=${1:-development}

echo "Starting DHG Baseline API in $ENV mode..."

if [ "$ENV" = "development" ]; then
    pip install -r requirements/requirements.development.light.txt
    uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
elif [ "$ENV" = "production" ]; then
    pip install -r requirements/requirements.production.txt
    uvicorn src.main:app --host 0.0.0.0 --port 8000 --workers 4
else
    echo "Unknown environment: $ENV"
    exit 1
fi 