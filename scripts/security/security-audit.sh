#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Security Audit...${NC}"

# Check for sensitive files
check_sensitive_files() {
    echo -e "\n${YELLOW}Checking for sensitive files...${NC}"
    find . -type f \( -name "*.env" -o -name "*.pem" -o -name "*.key" \) -not -path "*/node_modules/*" -not -path "*/.git/*"
}

# Check npm dependencies
check_npm_vulnerabilities() {
    echo -e "\n${YELLOW}Checking npm dependencies...${NC}"
    if [ -f "frontend/package.json" ]; then
        cd frontend && npm audit
        cd ..
    fi
}

# Check Python dependencies
check_python_vulnerabilities() {
    echo -e "\n${YELLOW}Checking Python dependencies...${NC}"
    if [ -f "backend/requirements.txt" ]; then
        safety check -r backend/requirements.txt
    fi
}

# Check git history for sensitive data
check_git_history() {
    echo -e "\n${YELLOW}Checking git history for sensitive data...${NC}"
    git log -p | grep -i "password\|secret\|key\|token"
}

# Check file permissions
check_permissions() {
    echo -e "\n${YELLOW}Checking file permissions...${NC}"
    find . -type f -perm /111 -not -path "*/node_modules/*" -not -path "*/.git/*"
}

# Run all checks
check_sensitive_files
check_npm_vulnerabilities
check_python_vulnerabilities
check_git_history
check_permissions 