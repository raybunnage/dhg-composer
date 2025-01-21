#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔄 Migrating .env files to new structure..."

# Create required directories
mkdir -p apps/dhg-baseline/frontend
mkdir -p apps/dhg-baseline/backend

# Function to migrate a file
migrate_file() {
    local src=$1
    local dest=$2
    if [ -f "$src" ]; then
        echo -e "${YELLOW}Moving $src to $dest${NC}"
        cp "$src" "$dest"
        echo -e "${GREEN}✓ Migrated: $dest${NC}"
    fi
}

# Backup current state
echo "📦 Creating backup before migration..."
./scripts/utils/backup-config-env.sh

# Migrate root level files
migrate_file ".env.production" "apps/dhg-baseline/frontend/.env.production"
migrate_file ".env.development" "apps/dhg-baseline/frontend/.env.development"
migrate_file ".env.staging" "apps/dhg-baseline/frontend/.env.staging"

# Clean up old files
echo -e "\n🧹 Cleaning up old files..."
./scripts/utils/cleanup-env-files.sh

echo -e "\n✨ Migration complete!"
echo "Please verify the new structure and update your .env.example files" 