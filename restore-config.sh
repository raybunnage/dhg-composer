#!/bin/bash
# Restore script for .vercel and .env files
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BACKUP_DIR=".backup/${BRANCH}"

# Check if backup exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "No backup found for branch: $BRANCH"
    exit 1
fi

# Restore .env files
cp "$BACKUP_DIR/backend.env" backend/.env
cp "$BACKUP_DIR/frontend.env" frontend/.env

# Restore .vercel directory
cp -r "$BACKUP_DIR/vercel" .vercel

echo "Restored configuration for branch: $BRANCH" 