#!/bin/bash
# Backup script for .vercel and .env files
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BACKUP_DIR=".backup/${BRANCH}"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup backend .env if it exists
if [ -f backend/.env ]; then
    cp backend/.env "$BACKUP_DIR/backend.env"
    echo "Backed up backend/.env"
fi

# Backup frontend .env if it exists
if [ -f frontend/.env ]; then
    cp frontend/.env "$BACKUP_DIR/frontend.env"
    echo "Backed up frontend/.env"
else
    echo "No frontend/.env found - skipping"
fi

# Backup .vercel directory if it exists
if [ -d .vercel ]; then
    cp -r .vercel "$BACKUP_DIR/vercel"
    echo "Backed up .vercel directory"
fi

echo "Backed up configuration for branch: $BRANCH" 