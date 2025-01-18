#!/bin/bash
# merge-branch.sh
# Merge specified branch into main branch

# Check if branch name was provided
if [ -z "$1" ]; then
    echo "Error: Please provide a branch name to merge"
    echo "Usage: ./merge-branch.sh <branch-name>"
    exit 1
fi

BRANCH=$1

# Switch to main branch
echo "Switching to main branch..."
git checkout main

# Pull latest changes from main
echo "Pulling latest changes from main..."
git pull origin main

# Merge specified branch
echo "Merging branch '$BRANCH' into main..."
git merge "$BRANCH"

# Push changes to remote
echo "Pushing changes to remote main branch..."
git push origin main

echo "Merge complete!"
