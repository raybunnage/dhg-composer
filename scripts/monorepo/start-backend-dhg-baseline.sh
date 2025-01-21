#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to kill process on port 8001
kill_port_8001() {
    if lsof -ti:8001 >/dev/null; then
        echo -e "${YELLOW}Killing process on port 8001...${NC}"
        lsof -ti:8001 | xargs kill -9
        echo -e "${GREEN}Process on port 8001 killed.${NC}"
    else
        echo -e "${YELLOW}No process running on port 8001.${NC}"
    fi
}

# Handle command line arguments
case "$1" in
    "kill")
        echo -e "${YELLOW}Checking for processes on port 8001...${NC}"
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
        echo -e "${RED}Invalid argument: $1${NC}"
        echo "Usage: ./start-backend-dhg-baseline.sh [development|production|kill]"
        exit 1
        ;;
esac

# Change to the dhg-baseline backend directory
cd apps/dhg-baseline/backend || {
    echo -e "${RED}Failed to change to backend directory${NC}"
    exit 1
}

# Only continue if we're not in kill mode
echo -e "${GREEN}Starting DHG Baseline API in $ENV mode...${NC}"

# Kill any existing process on port 8001
kill_port_8001

if [ "$ENV" = "development" ]; then
    echo -e "${YELLOW}Installing development dependencies...${NC}"
    pip install -r requirements/requirements.development.light.txt
    echo -e "${GREEN}Starting development server...${NC}"
    uvicorn src.main:app --reload --host 0.0.0.0 --port 8001
elif [ "$ENV" = "production" ]; then
    echo -e "${YELLOW}Installing production dependencies...${NC}"
    pip install -r requirements/requirements.production.txt
    echo -e "${GREEN}Starting production server...${NC}"
    uvicorn src.main:app --host 0.0.0.0 --port 8001 --workers 4
fi 