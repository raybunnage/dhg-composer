# Project Structure

[← Back to Main Documentation](./README.MD)

## Root Directory
- `docs/` - Documentation
  - `getting-started/` - Getting started guides
  - `deployment/` - Deployment guides
  - `environment/` - Environment setup guides
  - `reference/` - Reference documentation
  - `security/` - Security documentation
  - `supabase/` - Supabase integration guides

## Backend
- `backend/`
  - `core/` - Core functionality
    - `logging.py`
  - `migrations/` - Database migrations
    - `000001_initial_schema.down.sql`
    - `000001_initial_schema.up.sql`
    - `001_create_users_table.py`
  - `requirements/` - Dependency management
    - `requirements.base.txt` - Core dependencies
    - `requirements.development.light.txt` - Lightweight dev dependencies
    - `requirements.development.txt` - Full dev dependencies
    - `requirements.production.txt` - Production dependencies
    - `requirements.staging.txt` - Staging dependencies
  - `src/` - Source code
    - `app/` - Main application
      - `api/` - API endpoints
      - `core/` - Core application code
      - `db/` - Database operations
      - `domains/` - Domain logic
      - `middleware/` - Request/Response middleware
      - `models/` - Data models
      - `routes/` - Route definitions
      - `services/` - Business logic services
      - `utils/` - Utility functions
      - `main.py` - Application entry point
    - `middleware/` - Global middleware
      - `rate_limiter.py` - Rate limiting implementation
    - `schemas/` - Data schemas
    - `run.py` - Server runner
  - `tests/` - Test suite
    - `api/` - API tests
    - `e2e/` - End-to-end tests
    - `factories/` - Test data factories
    - `fixtures/` - Test fixtures
    - `integration/` - Integration tests
    - `load/` - Load testing (k6)
    - `performance/` - Performance testing (locust)
    - `unit/` - Unit tests
    - `utils/` - Test utilities
    - `conftest.py` - Test configuration

## Scripts
- `scripts/` - Utility scripts
  - `backend/` - Backend-specific utilities
    - `verify_backend.sh` - Checks backend setup and dependencies are correctly configured.
  - `backup/` - Backup utilities
    - `backup-project.sh` - Creates a complete backup of your project's current state.
  - `db/` - Database utilities
    - `db-migrate.sh` - Runs database migrations and verifies their success.
  - `deploy/` - Deployment scripts
    - `deploy-production.sh` - Deploys your application to production with safety checks.
    - `deploy-staging.sh` - Deploys your application to staging for testing.
  - `dev/` - Development utilities
    - `deploy-branch.sh` - Deploys your current branch to a development environment.
    - `deploy-prod.sh` - Safely deploys to production with pre-flight checks.
    - `manage-backend.sh` - Handles common backend tasks like restart and logs.
    - `promote.sh` - Promotes code between environments (e.g., staging to production).
    - `run-tests.sh` - Executes the test suite with proper configuration.
    - `start-dev-light.sh` - Starts a minimal development environment for quick testing.
    - `start-dev.sh` - Launches full development environment with all services.
  - `docs/` - Documentation utilities
    - `setup-api-docs.sh` - Generates and serves API documentation.
    - `setup-test-docs.sh` - Creates test coverage and results documentation.
    - `tree-backend.sh` - Generates a visual tree of backend structure.
    - `tree-project.sh` - Creates a complete project structure visualization.
  - `env/` - Environment management
    - `manage-env.sh` - Helps switch between different environment configurations.
    - `setup-venv.sh` - Creates and configures Python virtual environment.
  - `git/` - Git workflow utilities
    - `backup-branches.sh` - Creates backups of important git branches.
    - `compare-branches.sh` - Shows differences between branches for review.
    - `git-commit.sh` - Helps create properly formatted commit messages.
    - `merge-branch.sh` - Safely merges branches with conflict checking.
    - `new-feature.sh` - Creates a new feature branch with proper naming.
    - `verify-branch.sh` - Checks branch is ready for merge or deployment.
  - `monitoring/` - Monitoring utilities
    - `monitor-services.sh` - Watches service health and sends alerts.
  - `performance/` - Performance testing
    - `run-performance-tests.sh` - Executes load and performance test suites.
  - `security/` - Security utilities
    - `security-audit.sh` - Runs security checks on code and dependencies.
  - `sys/` - System utilities
    - `backup-config.sh` - Backs up system and application configurations.
    - `cleanup_backend.sh` - Removes temporary files and cleans up backend.
    - `make-scripts-executable.sh` - Sets correct permissions on script files.
    - `verify-scripts.sh` - Validates all scripts are properly formatted.
  - `utils/` - General utilities
    - `backup_config_env.sh` - Saves environment configurations by branch.
    - `restore_config_env.sh` - Restores environment configurations from backup.

Key aspects of the scripts organization:
1. Modular structure with clear separation of concerns
2. Dedicated folders for different types of operations
3. Automation tools for common development tasks
4. Comprehensive testing and deployment utilities
5. Environment and configuration management tools
6. Documentation and project structure generators

Each script is designed to be:
- Self-documenting with help options
- Safe to run with confirmation prompts
- Consistent in style and usage
- Helpful for both beginners and experienced developers