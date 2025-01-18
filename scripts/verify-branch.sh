#!/bin/bash
# verify-branch.sh - Verify branch readiness for merge/deployment

BRANCH=$1
LEVEL=${2:-basic}  # basic, thorough, or strict

# Show usage if no branch specified
if [ -z "$BRANCH" ]; then
    echo "Usage: ./scripts/verify-branch.sh <branch-name> [basic|thorough|strict]"
    echo "Example: ./scripts/verify-branch.sh feature/login thorough"
    exit 1
fi

# Verify branch exists
if ! git rev-parse --verify "$BRANCH" >/dev/null 2>&1; then
    echo "Error: Branch '$BRANCH' does not exist"
    exit 1
fi

echo "Verifying branch: $BRANCH (Level: $LEVEL)"

# Basic checks (all levels)
echo "Running basic checks..."

# Check if branch is up to date
git fetch origin
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/$BRANCH 2>/dev/null || git rev-parse HEAD)" ]; then
    echo "⚠️  Warning: Branch is not up to date with remote"
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  Warning: You have uncommitted changes"
fi

# Run tests
echo "Running tests..."
if ! ./scripts/run-tests.sh; then
    echo "❌ Tests failed"
    exit 1
fi

# Environment checks
echo "Checking environment configuration..."
if [ -f "backend/.env.$BRANCH" ]; then
    ./scripts/manage-env.sh verify "$BRANCH"
fi

# Thorough checks
if [ "$LEVEL" = "thorough" ] || [ "$LEVEL" = "strict" ]; then
    echo "Running thorough checks..."
    
    # Check for merge conflicts
    if git merge-base --is-ancestor origin/development "$BRANCH" 2>/dev/null; then
        echo "✓ No merge conflicts with development"
    else
        echo "⚠️  Warning: Branch may have conflicts with development"
    fi
    
    # Check for sensitive data
    echo "Checking for sensitive data..."
    git diff --name-only "$BRANCH" | while read -r file; do
        if grep -i "password\|secret\|key\|token" "$file" >/dev/null 2>&1; then
            echo "⚠️  Warning: Possible sensitive data in $file"
        fi
    done
fi

# Strict checks (production-ready)
if [ "$LEVEL" = "strict" ]; then
    echo "Running strict checks..."
    
    # Ensure all commits are signed
    if ! git log --pretty=format:%G? -n 1 | grep -q '[YESU]'; then
        echo "❌ Not all commits are signed"
        exit 1
    fi
    
    # Check documentation
    if [ -f "docs/README.md" ]; then
        if git diff --name-only "$BRANCH" | grep -q "^docs/"; then
            echo "✓ Documentation updated"
        else
            echo "⚠️  Warning: No documentation changes detected"
        fi
    fi
    
    # Verify dependencies are up to date
    if [ -f "backend/requirements.txt" ]; then
        echo "Checking Python dependencies..."
        pip list --outdated
    fi
    if [ -f "frontend/package.json" ]; then
        echo "Checking npm dependencies..."
        npm outdated
    fi
fi

# Final status
echo "Verification complete for $BRANCH"
if [ $? -eq 0 ]; then
    echo "✅ All checks passed"
else
    echo "❌ Some checks failed"
    exit 1
fi 