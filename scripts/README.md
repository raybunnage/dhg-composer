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
  - `reorganize-scripts.sh` - Script organization utility

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
