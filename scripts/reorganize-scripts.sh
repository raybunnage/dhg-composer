#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create script directories
mkdir -p scripts/{env,git,dev,db,docs,sys}

# Environment management scripts
mv scripts/manage-env.sh scripts/env/
mv scripts/setup-env.sh scripts/env/
mv scripts/setup-venv.sh scripts/env/
mv scripts/manage-requirements.sh scripts/env/

# Git and branch management
mv scripts/git-commit.sh scripts/git/
mv scripts/merge-branch.sh scripts/git/
mv scripts/verify-branch.sh scripts/git/
mv scripts/new-feature.sh scripts/git/
mv scripts/backup-branches.sh scripts/git/
mv scripts/compare-branches.sh scripts/git/

# Development and deployment
mv scripts/start-dev.sh scripts/dev/
mv scripts/deploy-branch.sh scripts/dev/
mv scripts/deploy-prod.sh scripts/dev/
mv scripts/promote.sh scripts/dev/
mv scripts/run-tests.sh scripts/dev/
mv scripts/manage-backend.sh scripts/dev/

# Database management
mv scripts/db-migrate.sh scripts/db/

# Documentation
mv scripts/setup-api-docs.sh scripts/docs/
mv scripts/setup-test-docs.sh scripts/docs/
mv scripts/tree-project.sh scripts/docs/
mv scripts/tree-backend.sh scripts/docs/

# System and utilities
mv scripts/make-executable.sh scripts/sys/
mv scripts/make-scripts-executable.sh scripts/sys/
mv scripts/verify-scripts.sh scripts/sys/
mv scripts/rebuild_project.sh scripts/sys/
mv scripts/backup-config.sh scripts/sys/
mv scripts/restore-config.sh scripts/sys/

# Move this script itself
mv scripts/reorganize-scripts.sh scripts/sys/

# Update README
cat > scripts/README.md << 'END_README'
# Project Scripts

## Directory Structure

- `env/` - Environment and requirements management
  - `manage-env.sh` - Manage environment configurations
  - `setup-env.sh` - Initial environment setup
  - `setup-venv.sh` - Python virtual environment setup
  - `manage-requirements.sh` - Handle Python requirements

- `git/` - Git and branch management
  - `git-commit.sh` - Standardized commit process
  - `merge-branch.sh` - Branch merging utilities
  - `verify-branch.sh` - Branch verification
  - `new-feature.sh` - New feature branch creation
  - `backup-branches.sh` - Branch backup
  - `compare-branches.sh` - Branch comparison

- `dev/` - Development and deployment
  - `start-dev.sh` - Start development servers
  - `deploy-branch.sh` - Branch deployment
  - `deploy-prod.sh` - Production deployment
  - `promote.sh` - Promotion between environments
  - `run-tests.sh` - Test execution
  - `manage-backend.sh` - Backend management

- `db/` - Database management
  - `db-migrate.sh` - Database migrations

- `docs/` - Documentation
  - `setup-api-docs.sh` - API documentation setup
  - `setup-test-docs.sh` - Test documentation setup
  - `tree-project.sh` - Project structure documentation
  - `tree-backend.sh` - Backend structure documentation

- `sys/` - System and utilities
  - `make-executable.sh` - Make scripts executable
  - `verify-scripts.sh` - Script verification
  - `rebuild_project.sh` - Project rebuild
  - `backup-config.sh` - Configuration backup
  - `restore-config.sh` - Configuration restore

## Usage

Scripts can be run using their path:
```bash
# Environment scripts
./scripts/env/setup-env.sh

# Git scripts
./scripts/git/new-feature.sh

# Development scripts
./scripts/dev/start-dev.sh
```

## Adding New Scripts

1. Place new scripts in appropriate directory
2. Make executable: `chmod +x scripts/category/script.sh`
3. Update this README
4. Test the script
END_README

echo -e "${GREEN}Scripts reorganized successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Update any scripts that reference other scripts to use new paths"
echo "2. Update documentation to reflect new script locations"
echo "3. Test all scripts to ensure they work with new paths"
echo "4. Consider adding shell aliases for frequently used scripts" 