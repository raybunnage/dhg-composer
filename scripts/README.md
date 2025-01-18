# Project Scripts

This directory contains all project management and automation scripts.

## Available Scripts

### Environment Management
- `manage-env.sh` - Manages environment configurations
- `setup-env.sh` - Sets up development environment
- `verify-env.sh` - Validates environment setup

### Development Tools
- `start-dev.sh` - Starts development server
- `run-tests.sh` - Runs project tests
- `rebuild_project.sh` - Rebuilds entire project

### Backup and Recovery
- `backup-config.sh` - Backs up configurations
- `restore-config.sh` - Restores configurations
- `backup-branches.sh` - Creates branch backups

### Verification
- `verify-scripts.sh` - Verifies script setup
- `verify-branch.sh` - Validates branch structure
- `compare-branches.sh` - Shows branch differences

## Usage

Make scripts executable:
```bash
chmod +x scripts/*.sh
```

Verify scripts setup:
```bash
./scripts/verify-scripts.sh
``` 