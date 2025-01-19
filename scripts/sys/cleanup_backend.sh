#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."
BACKEND_DIR="$PROJECT_ROOT/backend"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to handle errors
handle_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Function to log success
log_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Check if backend directory exists
[ -d "$BACKEND_DIR" ] || handle_error "Backend directory not found"

echo "Starting backend cleanup..."

# Clean up Supabase service
if [ -f "$BACKEND_DIR/src/app/services/supabase/auth.py" ]; then
    rm -f "$BACKEND_DIR/src/app/services/supabase/auth.py" && log_success "Removed empty auth.py"
fi

if [ -f "$BACKEND_DIR/src/app/services/supabase/client.py" ]; then
    rm -f "$BACKEND_DIR/src/app/services/supabase/client.py" && log_success "Removed empty client.py"
fi

if [ -d "$BACKEND_DIR/src/app/services/supabase/mixins" ]; then
    rm -rf "$BACKEND_DIR/src/app/services/supabase/mixins" && log_success "Removed mixins directory"
fi

# Clean up Core module
if [ -d "$BACKEND_DIR/src/app/core/apps" ]; then
    rm -rf "$BACKEND_DIR/src/app/core/apps" && log_success "Removed apps directory"
fi

# Move directories under app/
for dir in middleware models routes utils; do
    if [ -d "$BACKEND_DIR/src/$dir" ]; then
        mv "$BACKEND_DIR/src/$dir" "$BACKEND_DIR/src/app/" && log_success "Moved $dir to app/"
    fi
done

# Move test service
if [ -f "$BACKEND_DIR/src/services/test_service.py" ]; then
    mv "$BACKEND_DIR/src/services/test_service.py" "$BACKEND_DIR/src/app/services/" && \
    log_success "Moved test_service.py to app/services/"
fi

# Ensure run.py is in correct location
if [ -f "$BACKEND_DIR/src/app/run.py" ]; then
    mv "$BACKEND_DIR/src/app/run.py" "$BACKEND_DIR/src/" && log_success "Moved run.py to correct location"
fi

echo -e "${GREEN}Backend cleanup completed successfully!${NC}" 