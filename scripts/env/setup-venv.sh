#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create virtual environment if it doesn't exist
if [ ! -d "backend/venv" ]; then
    python -m venv backend/venv
fi

# Activate virtual environment
source backend/venv/bin/activate

# Install dependencies based on environment
ENV=${1:-development}

case $ENV in
    development)
        uv pip sync backend/requirements/development.txt
        ;;
    staging)
        pip install -r backend/requirements/staging.txt
        ;;
    production)
        pip install -r backend/requirements/production.txt
        ;;
    *)
        echo -e "${RED}Invalid environment: $ENV${NC}"
        exit 1
        ;;
esac

echo -e "${GREEN}Virtual environment setup complete for $ENV environment${NC}" 