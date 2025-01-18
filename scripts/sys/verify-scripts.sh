#!/bin/bash

# verify-scripts.sh
# Verifies all scripts are executable and tracked by git

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Verifying scripts setup..."

# Check if scripts are tracked by git
untracked_scripts=$(git ls-files --others --exclude-standard scripts/*.sh)
if [[ -n "$untracked_scripts" ]]; then
    echo -e "${RED}Warning: Found untracked scripts:${NC}"
    echo "$untracked_scripts"
    echo -e "${YELLOW}Run: git add scripts/*.sh${NC}"
fi

# Make all scripts executable
echo "Making scripts executable..."
chmod +x scripts/*.sh

# Verify each script
for script in scripts/*.sh; do
    if [[ -f "$script" ]]; then
        # Check if executable
        if [[ ! -x "$script" ]]; then
            echo -e "${RED}Error: $script is not executable${NC}"
            chmod +x "$script"
        fi
        
        # Check if tracked by git
        if ! git ls-files --error-unmatch "$script" >/dev/null 2>&1; then
            echo -e "${YELLOW}Warning: $script is not tracked by git${NC}"
        else
            echo -e "${GREEN}✓ $script is properly setup${NC}"
        fi
    fi
done

# List all tracked scripts
echo -e "\n${GREEN}Currently tracked scripts:${NC}"
git ls-files scripts/*.sh

echo -e "\n${YELLOW}Remember to commit any changes to scripts!${NC}" 