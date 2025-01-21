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

# Load metadata to get environment and apps
if [ -f "$BACKUP_DIR/backup_metadata.json" ]; then
    ENV=$(jq -r '.environment' "$BACKUP_DIR/backup_metadata.json")
    APPS=($(jq -r '.apps[]' "$BACKUP_DIR/backup_metadata.json"))
else
    echo "❌ Error: No backup metadata found"
    exit 1
fi

# Define files to restore for each app
restore_app_files() {
    local app=$1
    local env=$2
    
    # App-specific environment files
    ENV_FILES=(
        "apps/${app}/frontend/.env"
        "apps/${app}/frontend/.env.${env}"
        "apps/${app}/frontend/.env.local"
        "apps/${app}/backend/.env"
        "apps/${app}/backend/.env.${env}"
    )

    # App-specific config files
    CONFIG_FILES=(
        "apps/${app}/frontend/vite.config.ts"
        "apps/${app}/frontend/tsconfig.json"
        "apps/${app}/frontend/package.json"
        "apps/${app}/backend/src/core/config.py"
        "apps/${app}/backend/src/core/settings.py"
    )

    # Restore app files
    echo "📝 Restoring ${app} environment files..."
    for file in "${ENV_FILES[@]}"; do
        restore_file "$file" "$PROJECT_ROOT"
    done

    echo "📝 Restoring ${app} configuration files..."
    for file in "${CONFIG_FILES[@]}"; do
        restore_file "$file" "$PROJECT_ROOT"
    done
}

# Root level configuration files
ROOT_CONFIG_FILES=(
    "vercel.json"
    ".npmrc"
    ".nvmrc"
    "package.json"
    "turbo.json"
    ".vercelignore"
)

echo "🔄 Starting configuration restore..."
echo "📁 Branch: $BRANCH"
echo "🌍 Environment: $ENV"
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

# Restore root level files
echo "📝 Restoring root configuration files..."
for file in "${ROOT_CONFIG_FILES[@]}"; do
    restore_file "$file" "$PROJECT_ROOT"
done

# Restore each app's files
for app in "${APPS[@]}"; do
    echo -e "\n🔹 Processing ${app}..."
    restore_app_files "$app" "$ENV"
done

# Show available backups
echo -e "\n📚 Available backups for branch '$BRANCH':"
ls -lt "$BACKUP_ROOT/$BRANCH" | grep -v '^total' | head -n 5 | sed 's/^/  /'

echo -e "\n✨ Restore complete!"
echo "🌍 Environment: $ENV"

# Show backup command
echo -e "\n💡 To create a new backup, use:"
echo "  ./scripts/utils/backup-config-env.sh" 