#!/bin/bash

# manage-env.sh
# Manages environment configurations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to create environment file from template
create_env() {
    local env_type=$1
    local template=".env.${env_type}.template"
    local env_file=".env.${env_type}"
    
    if [[ ! -f $template ]]; then
        echo -e "${RED}Error: Template $template not found${NC}"
        exit 1
    }
    
    cp "$template" "$env_file"
    echo -e "${GREEN}Created $env_file from template${NC}"
}

# Function to verify environment file
verify_env() {
    local env_type=$1
    local env_file="backend/.env.${env_type}"
    
    # Required variables for all environments
    local required_vars=(
        "SUPABASE_URL"
        "SUPABASE_KEY"
        "DATABASE_URL"
        "ENVIRONMENT"
        "PORT"
        "DEBUG"
        "LOG_LEVEL"
        "CORS_ORIGINS"
    )
    
    if [[ ! -f $env_file ]]; then
        echo -e "${RED}Error: $env_file not found${NC}"
        echo "Run: $0 create $env_type"
        exit 1
    fi
    
    # Check required variables
    local missing=0
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}=" "$env_file" || grep -q "^${var}=$" "$env_file"; then
            echo -e "${YELLOW}Warning: Missing or empty value for ${var} in $env_file${NC}"
            missing=1
        fi
    done
    
    if [[ $missing -eq 1 ]]; then
        echo -e "${RED}Please fill in all required values in $env_file${NC}"
        exit 1
    fi
    
    # Environment-specific checks
    case $env_type in
        development)
            if ! grep -q "^DEBUG=true" "$env_file"; then
                echo -e "${YELLOW}Warning: DEBUG should be true in development${NC}"
            fi
            ;;
        production)
            if grep -q "^DEBUG=true" "$env_file"; then
                echo -e "${RED}Error: DEBUG should be false in production${NC}"
                exit 1
            fi
            ;;
    esac
    
    echo -e "${GREEN}Environment file $env_file is valid${NC}"
}

# Function to backup environment file
backup_env() {
    local env_type=$1
    local env_file=".env.${env_type}"
    local backup_file=".env.${env_type}.backup-$(date +%Y%m%d_%H%M%S)"
    
    if [[ -f $env_file ]]; then
        cp "$env_file" "$backup_file"
        echo -e "${GREEN}Created backup: $backup_file${NC}"
    else
        echo -e "${RED}Error: $env_file not found${NC}"
        exit 1
    fi
}

# Main script
case $1 in
    create)
        create_env "$2"
        ;;
    verify)
        verify_env "$2"
        ;;
    backup)
        backup_env "$2"
        ;;
    *)
        echo "Usage: $0 {create|verify|backup} {development|staging|production}"
        exit 1
        ;;
esac 