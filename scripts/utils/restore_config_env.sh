#!/bin/bash

# Exit on any error
set -e

# Get script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."
BACKUP_ROOT="$PROJECT_ROOT/.config_backups"

# Check arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <branch> [timestamp]"
    echo "If timestamp is omitted, restores from 'latest'"
    exit 1
fi

BRANCH=$1
TIMESTAMP=${2:-"latest"}

# Handle symlink resolution
if [ "$TIMESTAMP" = "latest" ]; then
    LATEST_LINK="$BACKUP_ROOT/$BRANCH/latest"
    if [ ! -L "$LATEST_LINK" ]; then
        echo "❌ Error: No 'latest' symlink found for branch $BRANCH"
        echo "Available backups for branch '$BRANCH':"
        ls -lt "$BACKUP_ROOT/$BRANCH" | grep -v '^total' | head -n 5 | sed 's/^/  /'
        exit 1
    fi
    BACKUP_DIR=$(readlink -f "$LATEST_LINK")
    echo "📍 Using latest backup via symlink"
else
    BACKUP_DIR="$BACKUP_ROOT/$BRANCH/$TIMESTAMP"
fi

# Function to restore a file
restore_file() {
    local file=$1
    local base_dir=$2
    
    if [ -f "$BACKUP_DIR/$file" ]; then
        mkdir -p "$base_dir/$(dirname $file)"
        cp -p "$BACKUP_DIR/$file" "$base_dir/$file"
        echo "✅ Restored: $file"
    else
        echo "⚠️  Missing in backup: $file"
    fi
}

# Define files to restore (same as backup)
ENV_FILES=(
    ".env"
    ".env.dev"
    ".env.prod"
    ".env.test"
    "backend/.env"
    "backend/.env.dev"
    "backend/.env.prod"
    "backend/.env.test"
)

CONFIG_FILES=(
    "backend/src/app/core/config.py"
    "backend/src/app/core/app_settings.py"
    "frontend/src/config/config.ts"
    "frontend/src/config/environment.ts"
)

echo "🔄 Starting configuration restore..."
echo "📁 Branch: $BRANCH"
echo "📂 Restore from: $BACKUP_DIR"
echo ""

# Verify backup metadata
if [ -f "$BACKUP_DIR/backup_metadata.json" ]; then
    echo "📋 Backup metadata:"
    cat "$BACKUP_DIR/backup_metadata.json"
    echo ""
else
    echo "⚠️  Warning: No backup metadata found"
fi

# Prompt for confirmation
read -p "⚠️  This will overwrite existing configuration files. Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restore cancelled"
    exit 1
fi

# Restore env files
echo "📝 Restoring environment files..."
for file in "${ENV_FILES[@]}"; do
    restore_file "$file" "$PROJECT_ROOT"
done

# Restore config files
echo -e "\n📝 Restoring configuration files..."
for file in "${CONFIG_FILES[@]}"; do
    restore_file "$file" "$PROJECT_ROOT"
done

# Restore specific environments
ENVIRONMENTS=("development" "production")
for ENV in "${ENVIRONMENTS[@]}"; do
    ENV_BACKUP_DIR="$BACKUP_DIR/$ENV"
    if [ -f "${ENV_BACKUP_DIR}/.env" ]; then
        mkdir -p "backend"
        cp -p "${ENV_BACKUP_DIR}/.env" "backend/.env.${ENV}"
        echo "✅ Restored ${ENV} environment"
    else
        echo "⚠️  Missing ${ENV} environment in backup"
    fi
done

# Show available backups
echo -e "\n📚 Available backups for branch '$BRANCH':"
ls -lt "$BACKUP_ROOT/$BRANCH" | grep -v '^total' | head -n 5 | sed 's/^/  /'

echo -e "\n✨ Restore complete!"

# Show backup command
echo -e "\n💡 To create a new backup, use:"
echo "  ./scripts/utils/backup_config_env.sh" 