#!/bin/bash
# Deploy current branch to Vercel

# Get current branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Deploying branch: $BRANCH to Vercel..."

# Deploy to Vercel with branch name as deployment name
vercel --name "$BRANCH"

echo "Deployment complete!"
