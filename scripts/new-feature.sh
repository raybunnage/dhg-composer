#!/bin/bash
# new-feature.sh - Create a new feature branch from development

if [ -z "$1" ]; then
    echo "Usage: ./new-feature.sh <feature-name>"
    echo "Example: ./new-feature.sh user-auth"
    exit 1
fi

FEATURE_NAME=$1

# Ensure we're up to date
git fetch origin
git checkout development
git pull origin development

# Create new feature branch
git checkout -b "feature/$FEATURE_NAME"

echo "Created new feature branch: feature/$FEATURE_NAME"
echo "Branch is based on latest development branch" 