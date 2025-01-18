# Shell Scripting Guidelines

This guide provides comprehensive standards for shell scripting in our project.

## Table of Contents
1. [Script Template](#script-template)
2. [Script Organization](#script-organization)
3. [Heredoc Usage](#heredoc-usage)
4. [Error Handling](#error-handling)
5. [Common Patterns](#common-patterns)
6. [Testing](#testing)
7. [Documentation](#documentation)

## Script Template
```bash
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
    # Script logic here
}

# Run main with error handling
if ! main; then
    echo -e "${RED}Script failed${NC}"
    exit 1
fi
```

## Script Organization
```
scripts/
├── env/     - Environment management
├── git/     - Git operations
├── dev/     - Development tools
├── db/      - Database operations
├── docs/    - Documentation tools
└── sys/     - System utilities
```

## Heredoc Usage
```bash
# Use unique, descriptive markers
cat << 'END_CONFIG'    # Good - specific name
config content
END_CONFIG

# Prevent variable expansion
cat << 'END_TEMPLATE'  # Variables won't expand
$HOME will not expand
END_TEMPLATE

# Allow variable expansion
cat << END_TEMPLATE    # Variables will expand
$HOME will expand
END_TEMPLATE
```

## Error Handling
```bash
# At start of script
set -e                    # Exit on error
set -u                    # Exit on undefined variable
set -o pipefail          # Exit on pipe failure

# Error trap
trap 'echo "Error on line $LINENO"' ERR

# Cleanup trap
trap cleanup EXIT
```

## Common Patterns

### Variable Definition
```bash
# Constants in uppercase
readonly MAX_RETRIES=3

# Local variables in lowercase
local count=0
```

### Function Structure
```bash
function_name() {
    local param1=$1
    local param2=$2
    
    # Function logic
}
```

### Path Handling
```bash
# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Use full paths
readonly CONFIG_DIR="${SCRIPT_DIR}/../config"
```

## Testing
```bash
# Test script
shellcheck scripts/category/script.sh

# Run in debug mode
bash -x scripts/category/script.sh
```

## Documentation
Every script should include:
```bash
#!/bin/bash

# Script Name: script_name.sh
# Description: Brief description of what the script does
# Usage: ./script_name.sh [options]
# Options:
#   -h, --help     Show this help message
#   -v, --verbose  Enable verbose output

# Author: Your Name
# Date: YYYY-MM-DD
```

## Best Practices

1. **Always Use Error Handling**
   - Set error flags at start of script
   - Use proper error traps
   - Implement cleanup functions

2. **Use Descriptive Names**
   - Functions should be verb-based
   - Variables should be clear and specific
   - Use consistent naming conventions

3. **Keep Scripts Focused**
   - One main purpose per script
   - Break complex logic into functions
   - Use helper scripts for shared functionality

4. **Document Everything**
   - Header documentation
   - Function documentation
   - Complex logic explanation

5. **Test Thoroughly**
   - Use shellcheck
   - Test edge cases
   - Verify error handling 