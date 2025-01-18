#!/bin/bash
# db-migrate.sh - Handle database migrations across environments

ENV=$1

if [ -z "$ENV" ]; then
    echo "Usage: ./db-migrate.sh <environment>"
    echo "Example: ./db-migrate.sh staging"
    exit 1
fi

# Load appropriate environment variables
source "backend/.env.$ENV"

echo "Running migrations for $ENV environment..."

# Run migrations using Supabase CLI
supabase db push --db-url "$DATABASE_URL"

echo "Migrations complete for $ENV environment" 