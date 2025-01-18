#!/bin/bash
# Enhanced backup script for environment files, configurations, and branch states

# Get current branch and timestamp
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_TYPE=${1:-full}  # full, config, or branch

# Create structured backup directory
BACKUP_DIR="backups/${TIMESTAMP}/${BRANCH}"
mkdir -p "$BACKUP_DIR"/{env,branch,code}

echo "Creating backup for branch: $BRANCH"
echo "Backup type: $BACKUP_TYPE"

# Function to backup environment files
backup_env_files() {
    echo "Backing up environment files..."
    
    # Backend environments
    if [ -d "backend" ]; then
        mkdir -p "$BACKUP_DIR/env/backend"
        # Backup all environment files and templates
        cp backend/.env* "$BACKUP_DIR/env/backend/" 2>/dev/null || true
        echo "✓ Backed up backend environments"
    fi

    # Frontend environments
    if [ -d "frontend" ]; then
        mkdir -p "$BACKUP_DIR/env/frontend"
        cp frontend/.env* "$BACKUP_DIR/env/frontend/" 2>/dev/null || true
        echo "✓ Backed up frontend environments"
    fi
}

# Function to backup branch state
backup_branch_state() {
    echo "Backing up branch state..."
    
    # Save branch information
    git branch -a > "$BACKUP_DIR/branch/branch-list.txt"
    git log -n 10 --pretty=format:"%h %s" > "$BACKUP_DIR/branch/recent-commits.txt"
    
    # Create branch snapshot
    git bundle create "$BACKUP_DIR/branch/branch-snapshot.bundle" HEAD
    
    echo "✓ Backed up branch state"
}

# Function to backup code snapshot
backup_code_snapshot() {
    echo "Backing up code snapshot..."
    
    # Create code archive
    git archive --format=tar HEAD | gzip > "$BACKUP_DIR/code/snapshot.tar.gz"
    
    # Backup specific configurations
    if [ -d "config" ]; then
        cp -r config "$BACKUP_DIR/code/"
    fi
    
    echo "✓ Backed up code snapshot"
}

# Perform backups based on type
case "$BACKUP_TYPE" in
    "full")
        backup_env_files
        backup_branch_state
        backup_code_snapshot
        ;;
    "config")
        backup_env_files
        ;;
    "branch")
        backup_branch_state
        ;;
    *)
        echo "Invalid backup type. Use: full, config, or branch"
        exit 1
        ;;
esac

# Create backup manifest
cat > "$BACKUP_DIR/manifest.txt" << EOL
Backup Information:
Date: $(date)
Branch: $BRANCH
Type: $BACKUP_TYPE
Git Commit: $(git rev-parse HEAD)
EOL

# Create compressed archive
cd backups
tar -czf "${TIMESTAMP}_${BRANCH}_${BACKUP_TYPE}.tar.gz" "${TIMESTAMP}"
rm -rf "${TIMESTAMP}"
cd ..

echo "Backup complete: backups/${TIMESTAMP}_${BRANCH}_${BACKUP_TYPE}.tar.gz" 