#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 Verifying .env file protection..."

# Check .gitignore patterns
check_gitignore() {
    local patterns=(
        ".env"
        ".env.*"
        "/apps/**/.env"
        "/apps/**/.env.*"
        "!**/.env.example"
        ".config_backups/**/.env*"
    )
    
    local missing=()
    for pattern in "${patterns[@]}"; do
        if ! grep -q "^${pattern}$" .gitignore; then
            missing+=("$pattern")
        fi
    done
    
    if [ ${#missing[@]} -eq 0 ]; then
        echo -e "${GREEN}✓ .gitignore patterns are correct${NC}"
    else
        echo -e "${RED}✗ Missing .gitignore patterns:${NC}"
        printf '%s\n' "${missing[@]}"
    fi
}

# Check for unprotected env files
check_unprotected_files() {
    local unprotected=$(git ls-files | grep -E "\.env(\.|$)" | grep -v "\.env\.example$")
    if [ -n "$unprotected" ]; then
        echo -e "${RED}✗ Found unprotected .env files in git:${NC}"
        echo "$unprotected"
        return 1
    else
        echo -e "${GREEN}✓ No unprotected .env files in git${NC}"
    fi
}

# Verify required structure
verify_structure() {
    local app="dhg-baseline"
    local required_examples=(
        "apps/${app}/frontend/.env.example"
        "apps/${app}/backend/.env.example"
    )
    
    local missing=()
    for file in "${required_examples[@]}"; do
        if [ ! -f "$file" ]; then
            missing+=("$file")
        fi
    done
    
    if [ ${#missing[@]} -eq 0 ]; then
        echo -e "${GREEN}✓ Required example files exist${NC}"
    else
        echo -e "${RED}✗ Missing required example files:${NC}"
        printf '%s\n' "${missing[@]}"
    fi
}

# Main verification
echo "Checking .gitignore patterns..."
check_gitignore

echo -e "\nChecking for unprotected files..."
check_unprotected_files

echo -e "\nVerifying required structure..."
verify_structure

echo -e "\n💡 Recommended next steps:"
echo "1. Run ./scripts/utils/cleanup-env-files.sh to clean up old files"
echo "2. Run ./scripts/utils/backup-config-env.sh to backup current config"
echo "3. Update example files with sanitized values" 