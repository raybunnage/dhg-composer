#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get current Git branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Determine environment based on branch
if [[ "$BRANCH" == "main" ]]; then
    ENV="production"
elif [[ "$BRANCH" == "development" ]]; then
    ENV="development"
else
    ENV="preview"
fi

echo "🔍 Checking environment files..."
echo "📁 Branch: $BRANCH"
echo "🌍 Environment: $ENV"
echo ""

# Function to check file existence and git status
check_file() {
    local file=$1
    local required=$2
    local should_be_in_git=$3
    
    printf "%-60s" "$file"
    
    if [ -f "$file" ]; then
        if [ "$should_be_in_git" = true ]; then
            if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
                echo -e "${GREEN}✓ [In Git]${NC}"
            else
                echo -e "${RED}✗ [Should be in Git]${NC}"
            fi
        else
            if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
                echo -e "${RED}✗ [Should NOT be in Git]${NC}"
            else
                echo -e "${GREEN}✓ [Protected]${NC}"
            fi
        fi
    else
        if [ "$required" = true ]; then
            echo -e "${RED}✗ [Missing]${NC}"
        else
            echo -e "${YELLOW}? [Optional]${NC}"
        fi
    fi
}

# DHG Baseline Frontend
echo -e "${BLUE}Frontend Environment Files:${NC}"
check_file "apps/dhg-baseline/frontend/.env" false false
check_file "apps/dhg-baseline/frontend/.env.local" false false
check_file "apps/dhg-baseline/frontend/.env.development" true false
check_file "apps/dhg-baseline/frontend/.env.production" true false
check_file "apps/dhg-baseline/frontend/.env.example" true true

# DHG Baseline Backend
echo -e "\n${BLUE}Backend Environment Files:${NC}"
check_file "apps/dhg-baseline/backend/.env" false false
check_file "apps/dhg-baseline/backend/.env.local" false false
check_file "apps/dhg-baseline/backend/.env.development" true false
check_file "apps/dhg-baseline/backend/.env.production" true false
check_file "apps/dhg-baseline/backend/.env.example" true true

# Root level files (should not exist)
echo -e "\n${BLUE}Root Level Files (Should Not Exist):${NC}"
check_file ".env" false false
check_file ".env.development" false false
check_file ".env.production" false false
check_file ".env.staging" false false

# Check backup directory
echo -e "\n${BLUE}Backup Status:${NC}"
if [ -d ".config_backups" ]; then
    LATEST_BACKUP=$(find .config_backups -type f -name "*.env*" -exec ls -lt {} + | head -n 1)
    if [ -n "$LATEST_BACKUP" ]; then
        echo -e "${GREEN}✓ Found backups${NC}"
        echo "Latest backup: $LATEST_BACKUP"
    else
        echo -e "${YELLOW}? No .env backups found${NC}"
    fi
else
    echo -e "${YELLOW}? No backup directory found${NC}"
fi

echo -e "\n${BLUE}Summary:${NC}"
echo "- Required files should exist and be protected from git"
echo "- Example files should exist and be tracked in git"
echo "- Local override files are optional but must be protected"
echo "- Root level env files should be moved to app directories"

echo -e "\n💡 Recommended actions:"
echo "1. Run ./scripts/utils/migrate-env-files.sh to fix structure"
echo "2. Run ./scripts/utils/verify-env-protection.sh to verify protection"
echo "3. Run ./scripts/utils/backup-config-env.sh to create backups" 