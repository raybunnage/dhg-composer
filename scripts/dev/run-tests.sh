#!/bin/bash
# run-tests.sh
# Run tests for frontend and backend with improved output and error handling

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Error handling
set -e
trap 'echo -e "${RED}Error on line $LINENO${NC}"; exit 1' ERR

echo -e "${YELLOW}Running Frontend Tests...${NC}"
cd frontend
npm test
echo -e "${GREEN}Frontend tests completed${NC}\n"

echo -e "${YELLOW}Running Backend Tests...${NC}"
cd ../backend
pytest --verbosity=2 --showlocals --capture=no
echo -e "${GREEN}Backend tests completed${NC}"