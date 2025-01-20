#!/bin/bash

# compare-branches.sh
# Shows differences between branches with focus on critical files

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help message
show_help() {
    echo "Usage: $0 [source-branch] [target-branch]"
    echo "Default: Compares development with main"
    echo
    echo "Examples:"
    echo "  $0                     # Compare development with main"
    echo "  $0 feature/auth main   # Compare feature/auth with main"
    echo "  $0 development main    # Compare development with main"
}

# Default branches to compare
SOURCE_BRANCH=${1:-"development"}
TARGET_BRANCH=${2:-"main"}

echo -e "${YELLOW}Comparing $SOURCE_BRANCH with $TARGET_BRANCH...${NC}"

# Function to check if branch exists
check_branch() {
    if ! git rev-parse --verify "$1" >/dev/null 2>&1; then
        echo -e "${RED}Error: Branch $1 does not exist${NC}"
        exit 1
    fi
}

# Check both branches exist
check_branch "$SOURCE_BRANCH"
check_branch "$TARGET_BRANCH"

# Compare environment files
echo -e "\n${YELLOW}Environment File Differences:${NC}"
if git diff "$SOURCE_BRANCH..$TARGET_BRANCH" -- "*.env*" >/dev/null 2>&1; then
    git diff "$SOURCE_BRANCH..$TARGET_BRANCH" -- "*.env*" | grep "^[+-][^+-]"
else
    echo "No environment file differences found"
fi

# Check for missing commits
echo -e "\n${YELLOW}Commit Differences:${NC}"
echo "Commits in $TARGET_BRANCH but not in $SOURCE_BRANCH:"
git log "$SOURCE_BRANCH..$TARGET_BRANCH" --oneline

echo -e "\nCommits in $SOURCE_BRANCH but not in $TARGET_BRANCH:"
git log "$TARGET_BRANCH..$SOURCE_BRANCH" --oneline

# Show diff summary
echo -e "\n${YELLOW}Overall Diff Summary:${NC}"
git diff --stat "$SOURCE_BRANCH..$TARGET_BRANCH"

# Check for merge conflicts
echo -e "\n${YELLOW}Potential Merge Conflicts:${NC}"
git merge-tree $(git merge-base "$SOURCE_BRANCH" "$TARGET_BRANCH") "$SOURCE_BRANCH" "$TARGET_BRANCH" | grep -A3 "changed in both"

# Show recommendation
echo -e "\n${GREEN}Recommendation:${NC}"
if [ "$TARGET_BRANCH" = "main" ]; then
    echo "Remember to merge into development first and ensure all tests pass"
    echo "Use: ./scripts/dev/run-tests.sh"
fi 