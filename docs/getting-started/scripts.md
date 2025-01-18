[← Back to Documentation Home](../README.md)

# Development Workflow Scripts Guide

This guide explains how to use our development scripts in the correct order. These scripts help manage our development, staging, and production environments.

## Initial Setup

First, make all scripts executable:
```bash
# Make all scripts executable
chmod +x scripts/*.sh
```

## Daily Development Workflow

### 1. Starting Your Day
```bash
# Start the development environment
./scripts/start-dev.sh dev
```

### 2. Creating a New Feature
```bash
# Create a new feature branch
./scripts/new-feature.sh my-feature-name

# Start development environment in your new branch
./scripts/start-dev.sh dev
```

### 3. Database Changes
If your feature requires database changes:
```bash
# Run migrations in development environment
./scripts/db-migrate.sh dev

# Test your changes thoroughly
```

## Promoting Changes

### 1. Development to Staging
After your feature is complete and tested in development:
```bash
# Promote from development to staging
./scripts/promote.sh dev staging

# Start staging environment to test
./scripts/start-dev.sh staging

# Run migrations in staging if needed
./scripts/db-migrate.sh staging
```

### 2. Staging to Production
After thorough testing in staging:
```bash
# Promote from staging to production
./scripts/promote.sh staging prod

# Run migrations in production if needed
./scripts/db-migrate.sh prod
```

## Common Scenarios

### Backing Up Configuration
Before making major changes:
```bash
# Backup current branch's configuration
./scripts/backup-config.sh
```

### Restoring Configuration
If you need to restore previous configuration:
```bash
# Restore configuration for current branch
./scripts/restore-config.sh
```

### Running Tests
Before promoting to staging or production:
```bash
# Run all tests
./scripts/run-tests.sh
```

### Viewing Project Structure
To understand the codebase:
```bash
# View backend structure
./scripts/tree-backend.sh
```

## Complete Feature Development Example

Here's a complete workflow example:

```bash
# 1. Create new feature branch
./scripts/new-feature.sh user-authentication

# 2. Start development environment
./scripts/start-dev.sh dev

# 3. Make your changes...

# 4. If you have database changes
./scripts/db-migrate.sh dev

# 5. Run tests
./scripts/run-tests.sh

# 6. Promote to staging
./scripts/promote.sh dev staging

# 7. Test in staging
./scripts/start-dev.sh staging
./scripts/db-migrate.sh staging
./scripts/run-tests.sh

# 8. If all tests pass, promote to production
./scripts/promote.sh staging prod
./scripts/db-migrate.sh prod
```

## Environment Variables

Each environment has its own `.env` file:
- `backend/.env.development`
- `backend/.env.staging`
- `backend/.env.production`

The `start-dev.sh` script automatically uses the correct environment file based on the environment parameter.

## Troubleshooting

### Port Already in Use
The `start-dev.sh` script automatically handles port conflicts, but if you need to manually kill processes:
```bash
# Kill process on backend port (8001)
kill -9 $(lsof -t -i:8001)

# Kill process on frontend port (5173)
kill -9 $(lsof -t -i:5173)
```

### Wrong Branch
If you accidentally worked on the wrong branch:
```bash
# Create new branch with your changes
git checkout -b feature/correct-branch-name

# Return to development branch
git checkout development
```

## Best Practices

1. **Always** create a new feature branch for changes
2. **Always** test in development first
3. **Always** run tests before promoting
4. **Always** backup configurations before major changes
5. Keep database migrations organized and well-tested
6. Document all significant changes

## Need Help?

If you encounter issues:
1. Check the logs in your terminal
2. Review the relevant environment's `.env` file
3. Ensure all dependencies are installed
4. Make sure you're on the correct branch
