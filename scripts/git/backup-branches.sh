#!/bin/bash

# backup-branches.sh
# Creates timestamped backups of important branches

# Configuration
BACKUP_FILE="docs/branch-backups/backup-list-$(date +%Y%m%d).md"
IMPORTANT_BRANCHES=("main" "staging" "development")
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Ensure backup directory exists
mkdir -p docs/branch-backups

# Create backup header
echo "# Branch Backup List - $(date +%Y-%m-%d)" > "$BACKUP_FILE"
echo "Generated automatically by backup-branches.sh" >> "$BACKUP_FILE"
echo "" >> "$BACKUP_FILE"

# Function to backup a branch
backup_branch() {
    local branch=$1
    local backup_name="${branch}-backup-${TIMESTAMP}"
    
    echo "Backing up $branch to $backup_name"
    
    # Create backup branch
    git checkout "$branch" &>/dev/null
    git pull origin "$branch" &>/dev/null
    git checkout -b "$backup_name"
    
    # Document the backup
    echo "## $branch" >> "$BACKUP_FILE"
    echo "- Backup branch: \`$backup_name\`" >> "$BACKUP_FILE"
    echo "- Last commit: $(git log -1 --format='%h - %s')" >> "$BACKUP_FILE"
    echo "- Timestamp: $(date)" >> "$BACKUP_FILE"
    echo "" >> "$BACKUP_FILE"
    
    # Return to original branch
    git checkout "$branch" &>/dev/null
}

# Main backup process
echo "Starting branch backup process..."

# Store current branch
CURRENT_BRANCH=$(git branch --show-current)

# Backup each important branch
for branch in "${IMPORTANT_BRANCHES[@]}"; do
    if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        backup_branch "$branch"
    else
        echo "Warning: Branch $branch not found"
        echo "## $branch" >> "$BACKUP_FILE"
        echo "- WARNING: Branch not found" >> "$BACKUP_FILE"
        echo "" >> "$BACKUP_FILE"
    fi
done

# Return to original branch
git checkout "$CURRENT_BRANCH" &>/dev/null

echo "Backup complete. Documentation saved to $BACKUP_FILE" 