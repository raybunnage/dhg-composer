#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Error handling
set -e
trap 'echo -e "${RED}Error on line $LINENO${NC}"; exit 1' ERR

# Check if feature name was provided
if [ -z "$1" ]; then
    echo "Error: Please provide a feature name"
    echo "Usage: ./new-feature.sh <feature-name>"
    echo "Example: ./new-feature.sh add-user-auth"
    exit 1
fi

FEATURE_NAME=$1
BRANCH_NAME="feature/$FEATURE_NAME"

# Ensure we're on development and it's up to date
git checkout development
git pull origin development

# Create new feature branch
git checkout -b "$BRANCH_NAME"

echo "Created new feature branch: $BRANCH_NAME"
echo "Make your changes and then use merge-branch.sh to merge back to development"

# Create feature branch
create_feature_branch() {
    local feature_name="$1"
    local base_branch="${2:-main}"
    local branch_name="feature/${feature_name// /-}"
    
    echo -e "${YELLOW}Creating feature branch: ${branch_name}${NC}"
    
    # Ensure base branch is up to date
    git fetch origin
    git checkout "$base_branch"
    git pull origin "$base_branch"
    
    # Create and switch to feature branch
    git checkout -b "$branch_name"
    
    # Create directory structure
    mkdir -p {implementation,tests,docs}
    
    # Create documentation template
    cat > docs/README.md << 'END_DOC'
# Feature: ${feature_name}

## Overview
Brief description of the feature.

## Implementation Details
- Key components
- Technical decisions
- Dependencies

## Testing Strategy
- Unit tests
- Integration tests
- Test cases
END_DOC

    # Initial commit
    git add .
    git commit -m "feat: Initialize ${feature_name} feature structure"
    
    echo -e "${GREEN}Feature branch created successfully!${NC}"
    echo "Next steps:"
    echo "1. Update docs/README.md with feature details"
    echo "2. Implement feature in implementation/"
    echo "3. Add tests in tests/"
}

# Main function
main() {
    if [ -z "$1" ]; then
        echo -e "${RED}Error: Feature name required${NC}"
        show_help
        exit 1
    fi
    
    create_feature_branch "$@"
}

# Run main function
main "$@" 