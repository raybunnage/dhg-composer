#!/bin/bash

# verify-branch.sh
# Validates branch structure and configuration

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BRANCH_NAME=${1:-$(git branch --show-current)}

# Function to log with timestamp
log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check branch naming convention
verify_branch_name() {
    local branch=$1
    local valid_prefixes=("feature/" "hotfix/" "release/" "main" "development" "staging")
    local valid=false
    
    for prefix in "${valid_prefixes[@]}"; do
        if [[ $branch == $prefix* ]] || [[ $branch == "$prefix" ]]; then
            valid=true
            break
        fi
    done
    
    if ! $valid; then
        log "${RED}Error: Invalid branch name format${NC}"
        log "Valid formats: feature/*, hotfix/*, release/*, main, development, staging"
        return 1
    fi
    
    log "${GREEN}Branch name format is valid${NC}"
    return 0
}

# Function to verify environment configuration
verify_environment() {
    local branch=$1
    local env_file=".env"
    
    # Check if environment file exists
    if [[ ! -f $env_file ]]; then
        log "${RED}Error: Environment file not found${NC}"
        return 1
    }
    
    # Verify required variables
    local required_vars=("DATABASE_URL" "API_KEY" "NODE_ENV")
    local missing_vars=()
    
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}=" "$env_file"; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        log "${RED}Error: Missing required environment variables: ${missing_vars[*]}${NC}"
        return 1
    fi
    
    log "${GREEN}Environment configuration is valid${NC}"
    return 0
}

# Function to run appropriate tests
run_branch_tests() {
    local branch=$1
    
    # Determine test type based on branch
    if [[ $branch == "main" ]] || [[ $branch == "staging" ]]; then
        log "Running full test suite..."
        ./scripts/run-tests.sh full
    elif [[ $branch == feature/* ]]; then
        log "Running feature tests..."
        ./scripts/run-tests.sh feature
    elif [[ $branch == hotfix/* ]]; then
        log "Running critical tests..."
        ./scripts/run-tests.sh critical
    else
        log "Running standard tests..."
        ./scripts/run-tests.sh
    fi
}

# Main verification process
log "Starting branch verification for: $BRANCH_NAME"

# Step 1: Verify branch name
verify_branch_name "$BRANCH_NAME" || exit 1

# Step 2: Verify environment
verify_environment "$BRANCH_NAME" || exit 1

# Step 3: Run tests
run_branch_tests "$BRANCH_NAME" || exit 1

log "${GREEN}All verifications passed successfully${NC}" 