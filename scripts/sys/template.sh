#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Error handling
set -e  # Exit on error
trap 'echo -e "${RED}Error on line $LINENO${NC}"; exit 1' ERR

# Cleanup function
cleanup() {
    local exit_code=$?
    echo -e "\n${YELLOW}Cleaning up...${NC}"
    # Add cleanup tasks here
    exit $exit_code
}

# Handle interrupts
trap cleanup SIGINT SIGTERM EXIT

# Main script function
main() {
    # Your script content here
    cat << 'END_CONTENT'
    Your content here
END_CONTENT
}

# Run main with error handling
if ! main; then
    echo -e "${RED}Script failed${NC}"
    exit 1
fi

# Move this script to sys directory
mv scripts/template.sh scripts/sys/ 