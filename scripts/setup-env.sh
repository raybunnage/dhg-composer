#!/bin/bash

# setup-env.sh
# Helper script to set up development environment

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Setting up development environment..."

# Check requirements
if ! command_exists psql; then
    echo -e "${RED}PostgreSQL client not found. Please install PostgreSQL.${NC}"
    exit 1
fi

# Create development environment from template
if [[ ! -f backend/.env.development ]]; then
    echo "Creating development environment..."
    cp backend/.env.development.template backend/.env.development
    echo -e "${GREEN}Created .env.development${NC}"
    echo -e "${YELLOW}Please update backend/.env.development with your local values${NC}"
else
    echo -e "${YELLOW}Development environment already exists${NC}"
fi

# Verify environment
./scripts/manage-env.sh verify development

echo -e "${GREEN}Environment setup complete!${NC}"
echo "Next steps:"
echo "1. Update backend/.env.development with your local values"
echo "2. Run './scripts/start-dev.sh' to start development server" 