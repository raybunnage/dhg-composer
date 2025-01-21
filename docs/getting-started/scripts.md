# Project Scripts Guide

## Quick Access Index
- [Development Scripts](#development-scripts)
  - [Start Development](#start-development)
  - [Deploy & Promote](#deploy--promote)
  - [Testing](#testing)
- [Backend Scripts](#backend-scripts)
  - [Verification](#verification)
  - [Database](#database)
- [Configuration Scripts](#configuration-scripts)
  - [Environment Backup](#environment-backup)
  - [System Configuration](#system-configuration)
- [Documentation Scripts](#documentation-scripts)
  - [Project Structure](#project-structure)
  - [API Documentation](#api-documentation)
- [Git Management Scripts](#git-management-scripts)
  - [Branch Operations](#branch-operations)
  - [Feature Management](#feature-management)
- [System Maintenance](#system-maintenance)
  - [Project Structure](#project-structure)
  - [Script Management](#script-management)
- [Security Scripts](#security-scripts)
  - [Auditing](#auditing)
  - [Key Management](#key-management)

## Development Scripts

### Start Development
```bash
# Full development environment
./scripts/dev/start-dev.sh

# Lightweight development environment
./scripts/dev/start-dev-light.sh

# Manage backend specifically
./scripts/dev/manage-backend.sh
```

### Deploy & Promote
```bash
# Deploy to branch
./scripts/dev/deploy-branch.sh

# Deploy to production
./scripts/dev/deploy-prod.sh

# Promote changes
./scripts/dev/promote.sh

# Deploy to staging
./scripts/deploy/deploy-staging.sh

# Deploy to production
./scripts/deploy/deploy-production.sh
```

### Testing
```bash
# Run test suite
./scripts/dev/run-tests.sh

# Run performance tests
./scripts/performance/run-performance-tests.sh
```

## Backend Scripts

### Verification
```bash
# Verify backend setup
./scripts/backend/verify_backend.sh
```

### Database
```bash
# Run database migrations
./scripts/db/db-migrate.sh
```

## Configuration Scripts

### Environment Backup
```bash
# Backup environment configuration
./scripts/config/backup-config-env.py backup

# Restore environment configuration
./scripts/config/backup-config-env.py restore

# List backups
./scripts/config/backup-config-env.py list
```

### System Configuration
```bash
# Backup system configuration
./scripts/sys/backup-config.sh

# Restore system configuration
./scripts/sys/restore-config.sh
```

## Documentation Scripts

### Project Structure
```bash
# Generate backend structure tree
./scripts/docs/tree-backend.sh

# Generate full project structure tree
./scripts/docs/tree-project.sh
```

### API Documentation
```bash
# Setup API documentation
./scripts/docs/setup-api-docs.sh

# Setup test documentation
./scripts/docs/setup-test-docs.sh
```

## Git Management Scripts

### Branch Operations
```bash
# Backup branches
./scripts/git/backup-branches.sh

# Compare branches
./scripts/git/compare-branches.sh

# Merge branches
./scripts/git/merge-branch.sh

# Verify branch
./scripts/git/verify-branch.sh
```

### Feature Management
```bash
# Create new feature branch
./scripts/git/new-feature.sh feature_name

# Commit changes
./scripts/git/git-commit.sh
```

## System Maintenance

### Project Structure
```bash
# Enhance project structure
./scripts/sys/enhance-project-structure.sh

# Reorganize project
./scripts/sys/reorganize-project.sh

# Verify project structure
./scripts/sys/verify_structure.py

# Clean up backend
./scripts/sys/cleanup_backend.sh
```

### Script Management
```bash
# Make scripts executable
./scripts/sys/make-scripts-executable.sh

# Setup new scripts
./scripts/sys/setup-new-scripts.sh

# Verify scripts
./scripts/sys/verify-scripts.sh
```

## Security Scripts

### Auditing
```bash
# Run security audit
./scripts/security/security-audit.sh
```

### Key Management
```bash
# Manage secret keys
./scripts/security/secret_key_manager.py
```

## Additional Resources
- For monitoring: `./scripts/monitoring/monitor-services.sh`
- For environment setup: `./scripts/setup/setup_environments.sh`
- For project backup: `./scripts/backup/backup-project.sh`

## Notes
- All scripts should be run from the project root directory
- Make sure scripts are executable (`chmod +x script_name.sh`)
- Some scripts may require additional parameters
- Check individual script documentation for detailed usage 