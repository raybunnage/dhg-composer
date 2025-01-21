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

## Documentation Structure
- `docs/` - Project documentation root
  - `ai-processing/` - AI integration guides
    - `cursor-rules.md` - Guidelines for implementing AI cursor rules and patterns
    - `evaluating-cursor-rules.md` - How to test and validate cursor rule effectiveness
    - `using_cursor_composer.md` - Guide for using the Cursor AI composition tools
    - `using_cursor_to_setup.md` - Initial setup instructions for Cursor AI integration

  - `api/` - API documentation
    - `endpoints/`
      - `auth.md` - Authentication endpoint specifications and usage
      - `users.md` - User management API endpoints and examples
    - `examples/`
      - `authentication.md` - Real-world examples of API authentication flows
    - `models/` - API data model documentation

  - `architecture/` - System design documentation
    - `branches/`
      - `branch_reset.md` - How to safely reset and clean up branches
      - `dhg-baseline.md` - Understanding the baseline branch structure
      - `golden_branch_setup.md` - Setting up and maintaining the golden branch
      - `managing_branches.md` - Branch management strategies and workflows
      - `vercel.md` - Vercel deployment branch configuration
    - `components/`
      - `auth-flow.md` - Authentication flow architecture and implementation
      - `data-access.md` - Data access patterns and best practices
    - `data-flow.md` - System-wide data flow patterns
    - `deployment.md` - Deployment architecture and strategies
    - `domains.md` - Domain-driven design implementation
    - `overview.md` - High-level system architecture overview
    - `project-structure.md` - Detailed project organization guide
    - `requirements.md` - System requirements and dependencies

  - `backend/` - Backend development guides
    - `authentication/`
      - `supabase-auth-guide.md` - Implementing Supabase authentication
    - `db-migrations/`
      - `db-migrate-guide.md` - Database migration procedures
      - `migrations.md` - Migration patterns and best practices

  - `deployment/` - Deployment guides
    - `baseline-setup.md` - Initial deployment setup instructions
    - `environments.md` - Environment configuration guide
    - `promote-guide.md` - Code promotion between environments
    - `staging_implementation_guide.md` - Staging environment setup

  - `development/`
    - `shell/`
      - `shell-scripting-guide.md` - Writing and maintaining shell scripts

  - `environment/` - Environment management
    - `backup_management.md` - Environment backup procedures
    - `environment-setup.md` - Initial environment configuration
    - `gitignore_management.md` - Managing Git ignore patterns
    - `manage-env-guide.md` - Day-to-day environment management

  - `frontend/` - Frontend development
    - `typescript/`
      - `tsx-guide.md` - TypeScript with React implementation guide
      - `typescript-guide.md` - TypeScript best practices and patterns

  - `getting-started/` - Onboarding documentation
    - `best-practices.md` - Project-wide best practices
    - `getting-started-guide.md` - New developer onboarding guide
    - `git-commands.md` - Essential Git commands and workflows
    - `scripts.md` - Available utility scripts and their usage

  - `reference/` - Reference documentation
    - `git-glossary.md` - Git terminology and concepts
    - `glossary.md` - Project-wide terminology
    - `merge-guide.md` - Git merge procedures and conflict resolution
    - `scripts-index.md` - Complete index of available scripts

  - `security/` - Security documentation
    - `authentication.md` - Authentication implementation details
    - `authorization.md` - Authorization patterns and roles
    - `data-protection.md` - Data security measures
    - `secret-keys.md` - Secret key management procedures
    - `signed-commits-guide.md` - Setting up and using signed commits

  - `services/` - External service integration
    - `anthropic/` - Anthropic AI integration guides
    - `pdfs/` - PDF processing service documentation
    - `supabase/` - Supabase service integration guides

  - `testing/` - Testing documentation
    - `README.md` - Testing overview and strategy
    - `using-run-tests.md` - Guide to running and maintaining tests

Each documentation file is designed to be:
- Self-contained with clear examples
- Beginner-friendly with step-by-step instructions
- Cross-referenced with related documentation
- Regularly updated with current best practices

## Documentation Emojis
Common emojis used throughout the documentation:

### Quick Access
- 🚀 - Getting started, launches
- 📚 - Documentation, guides
- 🔧 - Tools, utilities, configuration
- 🏗️ - Architecture, structure
- 🔒 - Security, authentication
- 🧪 - Testing
- 🔌 - Integrations, plugins
- 📝 - Notes, documentation
- ⚠️ - Warnings, important notes
- 💡 - Tips, ideas

### How to Use Emojis
1. **System Shortcuts**:
   - Windows: `Windows key + .` (period)
   - Mac: `Command + Control + Space`
   - Linux: Varies by distribution, often `Ctrl + .` or `Super + .`

2. **Direct Copy/Paste**:
   - Copy from this reference
   - Use system emoji picker
   - Copy from emoji websites

3. **Markdown Emoji Codes** (platform dependent):
   ```markdown
   :rocket: = 🚀
   :books: = 📚
   :wrench: = 🔧
   :lock: = 🔒
   ```

### Best Practices
- Use emojis consistently across documentation
- Don't overuse - one emoji per heading is sufficient
- Ensure emojis add meaning rather than decoration
- Consider accessibility - always pair emojis with clear text