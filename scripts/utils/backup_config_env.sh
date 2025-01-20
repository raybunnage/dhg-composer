#!/bin/bash

# Exit on any error
set -e

# Get current Git branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."
BACKUP_ROOT="$PROJECT_ROOT/.config_backups"

# Create backup directory structure
BACKUP_DIR="$BACKUP_ROOT/${BRANCH}/${TIMESTAMP}"
mkdir -p "$BACKUP_DIR"

# Function to backup a file with directory structure
backup_file() {
    local file=$1
    local base_dir=$2
    
    if [ -f "$base_dir/$file" ]; then
        # Create directory structure in backup
        mkdir -p "$BACKUP_DIR/$(dirname $file)"
        # Copy file with metadata
        cp -p "$base_dir/$file" "$BACKUP_DIR/$file"
        echo "✅ Backed up: $file"
    else
        echo "⚠️  Missing: $file"
    fi
}

# List of files to backup
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

echo "🔄 Starting configuration backup..."
echo "📁 Branch: $BRANCH"
echo "⏰ Timestamp: $TIMESTAMP"
echo "💾 Backup location: $BACKUP_DIR"
echo ""

# Backup all env files
echo "📝 Backing up environment files..."
for file in "${ENV_FILES[@]}"; do
    backup_file "$file" "$PROJECT_ROOT"
done

# Backup all config files
echo -e "\n📝 Backing up configuration files..."
for file in "${CONFIG_FILES[@]}"; do
    backup_file "$file" "$PROJECT_ROOT"
done

# Create metadata file
echo -e "\n📌 Creating backup metadata..."
cat > "$BACKUP_DIR/backup_metadata.json" << EOF
{
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "branch": "$BRANCH",
    "git_commit": "$(git rev-parse HEAD)",
    "environment": "$ENV",
    "user": "$(whoami)",
    "hostname": "$(hostname)"
}
EOF

# Create a latest symlink for this branch
LATEST_LINK="$BACKUP_ROOT/${BRANCH}/latest"
rm -f "$LATEST_LINK"
ln -s "$BACKUP_DIR" "$LATEST_LINK"

# Cleanup old backups (keep last 5 per branch)
echo -e "\n🧹 Cleaning up old backups..."
cd "$BACKUP_ROOT/$BRANCH"
ls -t | tail -n +6 | xargs rm -rf 2>/dev/null || true

# List available backups for this branch
echo -e "\n📚 Available backups for branch '$BRANCH':"
ls -lt "$BACKUP_ROOT/$BRANCH" | grep -v '^total' | head -n 5 | sed 's/^/  /'

echo -e "\n✨ Backup complete!"
echo "📂 Latest backup: $BACKUP_DIR"
echo "🔗 Latest symlink: $LATEST_LINK"

# Provide restore hint
echo -e "\n💡 To restore this backup, use:"
echo "  ./scripts/utils/restore_config_env.sh $BRANCH $TIMESTAMP" 