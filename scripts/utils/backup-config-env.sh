#!/bin/bash

# Exit on any error
set -e

# Get script directory and project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."
BACKUP_ROOT="$PROJECT_ROOT/.config_backups"

# Get current Git branch and timestamp
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Determine environment based on branch
if [[ "$BRANCH" == "main" ]]; then
    ENV="production"
elif [[ "$BRANCH" == "development" ]]; then
    ENV="development"
else
    ENV="preview"
fi

# Create backup directory structure
BACKUP_DIR="$BACKUP_ROOT/${BRANCH}/${TIMESTAMP}"
mkdir -p "$BACKUP_DIR"

# Function to backup a file with directory structure
backup_file() {
    local file=$1
    local base_dir=$2
    
    if [ -f "$base_dir/$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname $file)"
        cp -p "$base_dir/$file" "$BACKUP_DIR/$file"
        echo "✅ Backed up: $file"
    else
        echo "⚠️  Missing: $file"
    fi
}

# Define monorepo apps
APPS=(
    "dhg-baseline"
    # Add other apps here as needed
)

# Define files to backup for each app
backup_app_files() {
    local app=$1
    local env=$2
    
    # App-specific environment files
    ENV_FILES=(
        "apps/${app}/frontend/.env"
        "apps/${app}/frontend/.env.${env}"
        "apps/${app}/frontend/.env.local"
        "apps/${app}/frontend/.env.production"
        "apps/${app}/frontend/.env.development"
        "apps/${app}/backend/.env"
        "apps/${app}/backend/.env.${env}"
        "apps/${app}/backend/.env.production"
        "apps/${app}/backend/.env.development"
    )

    # App-specific config files
    CONFIG_FILES=(
        "apps/${app}/frontend/vite.config.ts"
        "apps/${app}/frontend/tsconfig.json"
        "apps/${app}/frontend/package.json"
        "apps/${app}/backend/src/core/config.py"
        "apps/${app}/backend/src/core/settings.py"
        "apps/${app}/frontend/.env.example"
        "apps/${app}/backend/.env.example"
    )

    # Backup app files
    echo "📝 Backing up ${app} environment files..."
    for file in "${ENV_FILES[@]}"; do
        backup_file "$file" "$PROJECT_ROOT"
    done

    echo "📝 Backing up ${app} configuration files..."
    for file in "${CONFIG_FILES[@]}"; do
        backup_file "$file" "$PROJECT_ROOT"
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

echo "🔄 Starting configuration backup..."
echo "📁 Branch: $BRANCH"
echo "🌍 Environment: $ENV"
echo "⏰ Timestamp: $TIMESTAMP"
echo "💾 Backup location: $BACKUP_DIR"
echo ""

# Backup root level files
echo "📝 Backing up root configuration files..."
for file in "${ROOT_CONFIG_FILES[@]}"; do
    backup_file "$file" "$PROJECT_ROOT"
done

# Backup each app's files
for app in "${APPS[@]}"; do
    echo -e "\n🔹 Processing ${app}..."
    backup_app_files "$app" "$ENV"
done

# Create metadata file
echo -e "\n📌 Creating backup metadata..."
cat > "$BACKUP_DIR/backup_metadata.json" << EOF
{
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "branch": "$BRANCH",
    "environment": "$ENV",
    "git_commit": "$(git rev-parse HEAD)",
    "user": "$(whoami)",
    "hostname": "$(hostname)",
    "apps": [
        $(printf '"%s",' "${APPS[@]}" | sed 's/,$//')
    ]
}
EOF

# Create/update latest symlink
LATEST_LINK="$BACKUP_ROOT/${BRANCH}/latest"
rm -f "$LATEST_LINK"
ln -s "$BACKUP_DIR" "$LATEST_LINK"

# Cleanup old backups (keep last 5)
echo -e "\n🧹 Cleaning up old backups..."
cd "$BACKUP_ROOT/$BRANCH"
ls -t | grep -v "latest" | tail -n +6 | xargs rm -rf 2>/dev/null || true

# Show available backups
echo -e "\n📚 Available backups for branch '$BRANCH':"
ls -lt "$BACKUP_ROOT/$BRANCH" | grep -v '^total' | head -n 5 | sed 's/^/  /'

echo -e "\n✨ Backup complete!"
echo "📂 Latest backup: $BACKUP_DIR"
echo "🔗 Latest symlink: $LATEST_LINK"
echo "🌍 Environment: $ENV"

# Show restore command
echo -e "\n💡 To restore this backup, use:"
echo "  ./scripts/utils/restore-config-env.sh $BRANCH $TIMESTAMP"
echo "  or"
echo "  ./scripts/utils/restore-config-env.sh $BRANCH latest" 