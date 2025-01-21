#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Monorepo Structure:${NC}"

# Use tree command with specific exclusions
tree -L 5 -I 'node_modules|venv|dist|.git|.next|.vercel|__pycache__|*.pyc|.DS_Store|.env*|coverage|build|*.log|*.lock|*.sum|*.map|.pytest_cache|.coverage|htmlcov|.mypy_cache|.tox|.nox|.hypothesis|.dmypy.json|.pyre|.pytype|.idea|.vscode|*.swp|*.swo|tmp|logs|backups|.backup|.config_backups' \
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
        local max_level=5

        # Skip excluded directories and files
        local exclude_pattern="node_modules|venv|dist|.git|.next|.vercel|__pycache__|.DS_Store|.env|coverage|build|.pytest_cache|.coverage|htmlcov|.mypy_cache|.tox|.nox|.hypothesis|.dmypy.json|.pyre|.pytype|.idea|.vscode|tmp|logs|backups|.backup|.config_backups"
        
        if [[ "$dir" =~ $exclude_pattern ]]; then
            return
        fi

        # List directories first
        for d in "$dir"/*/; do
            if [ -d "$d" ] && [ $level -lt $max_level ] && [[ ! "$(basename "$d")" =~ $exclude_pattern ]]; then
                echo "${prefix}├── $(basename "$d")"
                list_dirs "$prefix│   " "$d" $((level + 1))
            fi
        done

        # Then list important files
        for f in "$dir"/*; do
            if [ -f "$f" ] && [[ ! "$(basename "$f")" =~ $exclude_pattern ]] && \
               [[ "$(basename "$f")" != "." ]] && \
               [[ "$f" != *".pyc" ]] && \
               [[ "$f" != *".log" ]] && \
               [[ "$f" != *".lock" ]] && \
               [[ "$f" != *".sum" ]] && \
               [[ "$f" != *".map" ]] && \
               [[ "$f" != *".swp" ]] && \
               [[ "$f" != *".swo" ]]; then
                echo "${prefix}├── $(basename "$f")"
            fi
        done
    }

    # Start listing from current directory
    echo "."
    list_dirs "" "." 1
fi

echo -e "\n${GREEN}Key Directories:${NC}"
echo "apps/          - Application packages"
echo "  ├── web/     - Main web application (React/Vite)"
echo "  ├── api/     - Main API service (FastAPI)"
echo "  └── admin/   - Admin dashboard"
echo "packages/      - Shared packages"
echo "  ├── ui/      - Shared UI components"
echo "  ├── utils/   - Shared utilities"
echo "  ├── types/   - Shared TypeScript types"
echo "  └── config/  - Shared configurations"
echo "scripts/       - Project management scripts"
echo "  ├── env/     - Environment management"
echo "  ├── dev/     - Development utilities"
echo "  ├── git/     - Git workflows"
echo "  ├── db/      - Database management"
echo "  ├── docs/    - Documentation generators"
echo "  └── sys/     - System utilities"
echo "docs/          - Project documentation"
echo "  ├── api/     - API documentation"
echo "  ├── guides/  - Development guides"
echo "  └── arch/    - Architecture decisions"
echo "tests/         - Project-wide tests"
echo "  ├── e2e/     - End-to-end tests"
echo "  └── integration/ - Integration tests" 