#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Making scripts executable...${NC}"

# Make the script itself executable first
chmod +x "$0"

# Count of scripts processed
count=0

# Make all .sh files in scripts directory executable
for script in scripts/*.sh; do
    if [ -f "$script" ]; then
        chmod +x "$script"
        echo -e "${GREEN}Made executable: ${NC}$script"
        ((count++))
    fi
done

echo -e "\n${GREEN}Complete! Made $count scripts executable.${NC}"

# List all executable scripts
echo -e "\n${YELLOW}Executable scripts:${NC}"
ls -l scripts/*.sh | grep "^-rwx" 