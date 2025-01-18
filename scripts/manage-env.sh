#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Environment template locations
TEMPLATE_DIR="config/templates"
ENV_DIR="."

# Function to print usage
print_usage() {
    echo "Usage: $0 <command> <environment>"
    echo "Commands:"
    echo "  create  <env>   - Create environment from template"
    echo "  verify  <env>   - Verify environment configuration"
    echo "  update  <env>   - Update environment from template"
    echo "Environments: development, staging, production"
}

# Function to create environment from template
create_env() {
    local env=$1
    local template="${TEMPLATE_DIR}/.env.${env}.template"
    local output="${ENV_DIR}/.env.${env}"
    
    if [ ! -f "$template" ]; then
        echo -e "${RED}Template not found: $template${NC}"
        exit 1
    fi
    
    if [ -f "$output" ]; then
        echo -e "${YELLOW}Environment file already exists: $output${NC}"
        echo -n "Do you want to overwrite it? [y/N] "
        read answer
        if [ "$answer" != "y" ]; then
            echo "Skipping creation."
            return
        fi
    fi
    
    cp "$template" "$output"
    echo -e "${GREEN}Created environment file: $output${NC}"
    echo -e "${YELLOW}Please update the file with your specific values${NC}"
}

# Function to verify environment
verify_env() {
    local env=$1
    local env_file="${ENV_DIR}/.env.${env}"
    
    if [ ! -f "$env_file" ]; then
        echo -e "${RED}Environment file not found: $env_file${NC}"
        exit 1
    fi
    
    # Check for empty required values
    local empty_vars=$(grep -E '^[A-Z_]+=\s*$' "$env_file" | cut -d= -f1)
    if [ ! -z "$empty_vars" ]; then
        echo -e "${RED}The following required variables are empty:${NC}"
        echo "$empty_vars"
        exit 1
    fi
    
    echo -e "${GREEN}Environment verification passed: $env_file${NC}"
}

# Create templates directory if it doesn't exist
mkdir -p ${TEMPLATE_DIR}

# Create development template if it doesn't exist
if [ ! -f "${TEMPLATE_DIR}/.env.development.template" ]; then
    cat > "${TEMPLATE_DIR}/.env.development.template" << EOL
# Development environment
NODE_ENV=development
PORT=3000

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp_dev
DB_USER=postgres
DB_PASSWORD=development

# Supabase
SUPABASE_URL=http://localhost:54321
SUPABASE_ANON_KEY=your-local-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-local-service-role-key

# API
API_URL=http://localhost:8000
EOL
fi

# Create staging template if it doesn't exist
if [ ! -f "${TEMPLATE_DIR}/.env.staging.template" ]; then
    cat > "${TEMPLATE_DIR}/.env.staging.template" << EOL
# Staging environment
NODE_ENV=staging
PORT=3000

# Database
DB_HOST=staging-db-host
DB_PORT=5432
DB_NAME=myapp_staging
DB_USER=app_user
DB_PASSWORD=

# Supabase
SUPABASE_URL=your-staging-project-url
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# API
API_URL=https://api-staging.yourapp.com
EOL
fi

# Create production template if it doesn't exist
if [ ! -f "${TEMPLATE_DIR}/.env.production.template" ]; then
    cat > "${TEMPLATE_DIR}/.env.production.template" << EOL
# Production environment
NODE_ENV=production
PORT=3000

# Database
DB_HOST=prod-db-host
DB_PORT=5432
DB_NAME=myapp_prod
DB_USER=app_user
DB_PASSWORD=

# Supabase
SUPABASE_URL=your-production-project-url
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# API
API_URL=https://api.yourapp.com
EOL
fi

# Main script logic
case "$1" in
    create)
        create_env "$2"
        ;;
    verify)
        verify_env "$2"
        ;;
    update)
        create_env "$2"
        ;;
    *)
        print_usage
        exit 1
        ;;
esac 