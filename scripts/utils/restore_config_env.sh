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
BACKUP_DIR="$BACKUP_ROOT/$BRANCH/$TIMESTAMP"

# Verify backup exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "❌ Error: Backup not found at $BACKUP_DIR"
    echo "Available backups for branch '$BRANCH':"
    ls -lt "$BACKUP_ROOT/$BRANCH" | grep -v '^total' | head -n 5 | sed 's/^/  /'
    exit 1
fi

echo "🔄 Starting configuration restore..."
echo "📁 Branch: $BRANCH"
echo "⏰ Timestamp: $TIMESTAMP"
echo "📂 Restore from: $BACKUP_DIR"
echo ""

# Function to restore a file
restore_file() {
    local file=$1
    local base_dir=$2
    
    if [ -f "$BACKUP_DIR/$file" ]; then
        # Create directory structure
        mkdir -p "$base_dir/$(dirname $file)"
        # Copy file with metadata
        cp -p "$BACKUP_DIR/$file" "$base_dir/$file"
        echo "✅ Restored: $file"
    else
        echo "⚠️  Missing in backup: $file"
    fi
}

# List of files to restore (same as backup script)
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

# Display metadata
echo -e "\n📌 Backup metadata:"
cat "$BACKUP_DIR/backup_metadata.json" | python3 -m json.tool

echo -e "\n✨ Restore complete!" 