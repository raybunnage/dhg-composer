#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Service Monitoring...${NC}"

# Monitor Backend Services
check_backend() {
    if curl -s http://localhost:8000/health > /dev/null; then
        echo -e "${GREEN}Backend API: Running${NC}"
    else
        echo -e "${RED}Backend API: Not Responding${NC}"
    fi
}

# Monitor Frontend Services
check_frontend() {
    if curl -s http://localhost:3000 > /dev/null; then
        echo -e "${GREEN}Frontend: Running${NC}"
    else
        echo -e "${RED}Frontend: Not Responding${NC}"
    fi
}

# Monitor Database
check_database() {
    if psql -h localhost -U postgres -c '\q' 2>/dev/null; then
        echo -e "${GREEN}Database: Connected${NC}"
    else
        echo -e "${RED}Database: Connection Failed${NC}"
    fi
}

# Monitor System Resources
check_resources() {
    echo -e "\n${YELLOW}System Resources:${NC}"
    echo "CPU Usage: $(top -l 1 | grep "CPU usage" | awk '{print $3}')"
    echo "Memory Usage: $(top -l 1 | grep "PhysMem" | awk '{print $2}')"
    echo "Disk Usage: $(df -h / | awk 'NR==2 {print $5}')"
}

# Run all checks
check_backend
check_frontend
check_database
check_resources 