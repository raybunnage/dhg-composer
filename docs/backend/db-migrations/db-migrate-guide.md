# Database Migration Guide

## Overview
The `db-migrate.sh` script manages database migrations using Alembic with FastAPI and PostgreSQL.

## Usage
```bash
# Run all pending migrations
./scripts/db/db-migrate.sh up

# Rollback last migration
./scripts/db/db-migrate.sh down

# Create new migration
./scripts/db/db-migrate.sh create "description_of_change"
```

## Options
- `up`: Apply pending migrations
- `down`: Rollback last migration
- `create`: Create new migration file
- `status`: Show migration status
- `history`: Show migration history

## Examples
```bash
# Create new migration for user table
./scripts/db/db-migrate.sh create "add_user_table"

# Apply all pending migrations
./scripts/db/db-migrate.sh up

# Rollback specific migration
./scripts/db/db-migrate.sh down 20240118_add_user_table
```

## Migration Files
Located in `backend/migrations/`:
- `xxxxx_migration_name.up.sql`: Forward migration
- `xxxxx_migration_name.down.sql`: Rollback migration 