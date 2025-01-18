#!/bin/bash
# Restore script for environment files and configurations

BRANCH=$(git rev-parse --abbrev-ref HEAD)
BACKUP_DIR=".backup/${BRANCH}"

# Check if backup exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "No backup found for branch: $BRANCH"
    exit 1
fi

# Restore backend environment files
if [ -f "$BACKUP_DIR/backend.env.dev" ]; then
    cp "$BACKUP_DIR/backend.env.dev" backend/.env.dev
    echo "Restored backend/.env.dev"
fi

if [ -f "$BACKUP_DIR/backend.env.staging" ]; then
    cp "$BACKUP_DIR/backend.env.staging" backend/.env.staging
    echo "Restored backend/.env.staging"
fi

if [ -f "$BACKUP_DIR/backend.env.prod" ]; then
    cp "$BACKUP_DIR/backend.env.prod" backend/.env.prod
    echo "Restored backend/.env.prod"
fi

# Restore frontend environment file
if [ -f "$BACKUP_DIR/frontend.env" ]; then
    cp "$BACKUP_DIR/frontend.env" frontend/.env
    echo "Restored frontend/.env"
fi

# Restore .vercel directory
if [ -d "$BACKUP_DIR/vercel" ]; then
    cp -r "$BACKUP_DIR/vercel" .vercel
    echo "Restored .vercel directory"
fi

echo "Restored configuration for branch: $BRANCH" 