#!/bin/bash
# Backup script for environment files and configurations

BRANCH=$(git rev-parse --abbrev-ref HEAD)
BACKUP_DIR=".backup/${BRANCH}"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup backend environment files
if [ -f backend/.env.dev ]; then
    cp backend/.env.dev "$BACKUP_DIR/backend.env.dev"
    echo "Backed up backend/.env.dev"
fi

if [ -f backend/.env.staging ]; then
    cp backend/.env.staging "$BACKUP_DIR/backend.env.staging"
    echo "Backed up backend/.env.staging"
fi

if [ -f backend/.env.prod ]; then
    cp backend/.env.prod "$BACKUP_DIR/backend.env.prod"
    echo "Backed up backend/.env.prod"
fi

# Backup frontend environment files if they exist
if [ -f frontend/.env ]; then
    cp frontend/.env "$BACKUP_DIR/frontend.env"
    echo "Backed up frontend/.env"
fi

# Backup .vercel directory if it exists
if [ -d .vercel ]; then
    cp -r .vercel "$BACKUP_DIR/vercel"
    echo "Backed up .vercel directory"
fi

echo "Backed up configuration for branch: $BRANCH" 