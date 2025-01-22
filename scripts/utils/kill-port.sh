#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PORT=5173

echo "🔍 Checking for processes on port $PORT..."

# Find process using the port
PID=$(lsof -t -i:$PORT)

if [ -n "$PID" ]; then
    echo -e "${YELLOW}Found process(es) using port $PORT:${NC}"
    lsof -i:$PORT
    
    echo -e "\n${YELLOW}Killing process(es)...${NC}"
    kill -9 $PID
    
    # Verify
    if ! lsof -i:$PORT > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Port $PORT is now free${NC}"
    else
        echo -e "${RED}✗ Failed to free port $PORT${NC}"
    fi
else
    echo -e "${GREEN}✓ Port $PORT is already free${NC}"
fi 