#!/bin/bash
# promote.sh - Promote changes between environments (dev -> staging -> prod)

FROM_ENV=$1
TO_ENV=$2

if [ -z "$FROM_ENV" ] || [ -z "$TO_ENV" ]; then
    echo "Usage: ./promote.sh <from-env> <to-env>"
    echo "Example: ./promote.sh dev staging"
    exit 1
fi

echo "Promoting from $FROM_ENV to $TO_ENV..."

# Ensure we have latest changes
git fetch origin

case "$FROM_ENV-$TO_ENV" in
    "dev-staging")
        git checkout staging
        git pull origin staging
        git merge development
        git push origin staging
        ;;
    "staging-prod")
        git checkout main
        git pull origin main
        git merge staging
        git push origin main
        ;;
    *)
        echo "Invalid promotion path. Valid paths are:"
        echo "dev-staging: Promote from development to staging"
        echo "staging-prod: Promote from staging to production"
        exit 1
        ;;
esac

# Deploy to appropriate environment
if [ "$TO_ENV" == "prod" ]; then
    vercel --prod
else
    vercel --name "$TO_ENV"
fi

echo "Promotion to $TO_ENV complete!" 