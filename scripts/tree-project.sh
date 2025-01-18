#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Project Structure:${NC}"

# Use tree command with specific exclusions
tree -L 4 -I 'node_modules|venv|dist|.git|.next|.vercel|__pycache__|*.pyc|.DS_Store|.env*' \
    --dirsfirst \
    --charset=ascii \
    -C \
    --prune \
    .

# If tree command not found, use alternative
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Using alternative directory listing:${NC}"
    
    # Function to list directories with indentation
    function list_dirs() {
        local prefix="$1"
        local dir="$2"
        local level="$3"
        local max_level=4

        # Skip excluded directories
        if [[ "$dir" == *"node_modules"* ]] || [[ "$dir" == *"venv"* ]] || \
           [[ "$dir" == *"dist"* ]] || [[ "$dir" == *".git"* ]] || \
           [[ "$dir" == *".next"* ]] || [[ "$dir" == *".vercel"* ]] || \
           [[ "$dir" == *"__pycache__"* ]] || [[ "$dir" == *".DS_Store"* ]] || \
           [[ "$dir" == *".env"* ]]; then
            return
        fi

        # List directories first
        for d in "$dir"/*/; do
            if [ -d "$d" ] && [ $level -lt $max_level ]; then
                echo "${prefix}├── $(basename "$d")"
                list_dirs "$prefix│   " "$d" $((level + 1))
            fi
        done

        # Then list important files
        for f in "$dir"/*; do
            if [ -f "$f" ] && [[ "$f" != *".pyc" ]] && [[ "$f" != *".DS_Store" ]] && \
               [[ "$f" != *".env"* ]] && [[ "$(basename "$f")" != "." ]]; then
                echo "${prefix}├── $(basename "$f")"
            fi
        done
    }

    # Start listing from current directory
    echo "."
    list_dirs "" "." 1
fi

echo -e "\n${GREEN}Key Directories:${NC}"
echo "frontend/      - React/Vite frontend application"
echo "backend/       - FastAPI backend application"
echo "docs/          - Project documentation"
echo "scripts/       - Project management scripts"
echo "config/        - Configuration templates" 