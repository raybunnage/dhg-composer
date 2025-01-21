# Project Structure

## Overview
```
.
├── backend/           # FastAPI backend application
├── frontend/         # React/Vite frontend application
├── docs/            # Project documentation
├── scripts/         # Project management scripts
├── examples/        # Code examples and templates
├── backups/         # Project backups
└── file_types/      # File type definitions
```

## Backend Structure
```
backend/
├── core/
│   └── logging.py                    # Configures application logging
├── migrations/                       # Database schema changes
│   ├── 000001_initial_schema.down.sql    # Reverses initial database setup
│   ├── 000001_initial_schema.up.sql      # Sets up initial database structure
│   ├── 001_create_users_table.py         # Creates the users table
│   └── README.md                         # Migration documentation
├── requirements/                     # Python package dependencies
│   ├── requirements.base.txt             # Core dependencies for all environments
│   ├── requirements.development.light.txt # Minimal development setup
│   ├── requirements.development.txt       # Full development environment
│   ├── requirements.production.txt        # Production-only dependencies
│   └── requirements.staging.txt          # Staging environment needs
├── src/                             # Main source code directory
│   ├── app/
│   │   └── main.py                      # Application entry point
│   ├── core/
│   │   └── __init__.py                  # Core functionality initialization
│   ├── middleware/
│   │   └── rate_limiter.py              # Controls API request rates
│   ├── __init__.py                      # Makes directory a Python package
│   └── run.py                           # Starts the application
├── tests/                           # Test files directory
│   ├── api/
│   │   └── test_contracts.py            # Tests API contracts
│   ├── e2e/
│   │   └── conftest.py                  # End-to-end test configuration
│   ├── factories/
│   │   ├── base.py                      # Base factory for test data
│   │   └── user.py                      # Creates test user data
│   ├── fixtures/
│   │   └── data.py                      # Reusable test data
│   ├── integration/
│   │   └── test_api.py                  # Tests API functionality
│   ├── load/
│   │   └── k6-script.js                 # Load testing script
│   ├── performance/
│   │   └── locustfile.py                # Performance test configuration
│   ├── unit/
│   │   └── test_main.py                 # Tests individual components
│   ├── utils/
│   │   └── generators.py                # Creates test data
│   └── conftest.py                      # Global test configuration
└── pyproject.toml                   # Python project configuration
```

## Frontend Structure
```
frontend/
├── public/                          # Publicly accessible files
│   └── vite.svg                         # Vite logo
├── src/                             # Source code directory
│   ├── assets/                          # Static files like images
│   │   └── react.svg                        # React logo
│   ├── components/                      # Reusable UI components
│   │   ├── DataFetch.tsx                   # Data fetching component
│   │   ├── Login.css                       # Login styling
│   │   ├── Login.tsx                       # Login component
│   │   └── PrimaryButton.jsx               # Main button component
│   ├── config/                          # Application configuration
│   │   ├── features.ts                     # Feature flags
│   │   └── supabase.ts                     # Supabase configuration
│   ├── hooks/                           # Custom React hooks
│   │   └── useAuth.ts                      # Authentication hook
│   ├── layouts/                         # Page layouts
│   │   └── MainLayout.tsx                  # Main application layout
│   ├── lib/                             # Shared libraries
│   │   └── supabaseClient.ts               # Supabase client setup
│   ├── pages/                           # Page components
│   │   └── Home.tsx                        # Homepage component
│   ├── routes/                          # Navigation setup
│   │   └── index.ts                        # Route definitions
│   ├── services/                        # API services
│   │   └── api.ts                          # API client setup
│   ├── types/                           # TypeScript definitions
│   │   └── index.ts                        # Common types
│   ├── utils/                           # Helper functions
│   │   └── helpers.ts                      # Utility functions
│   ├── App.css                          # Main app styling
│   ├── App.tsx                          # Main app component
│   ├── index.css                        # Global styles
│   ├── main.tsx                         # Application entry point
│   └── vite-env.d.ts                    # Vite type definitions
├── tests/                           # Test directory
│   ├── e2e/
│   │   └── cypress.config.ts             # Cypress test configuration
│   └── jest.setup.ts                    # Jest test setup
├── README.md                       # Project documentation
├── eslint.config.js                # Code style rules
├── index.html                      # Entry HTML file
├── package.json                    # NPM dependencies
├── tsconfig.app.json               # TypeScript app config
├── tsconfig.json                   # Main TypeScript config
├── tsconfig.node.json              # Node-specific TS config
└── vite.config.ts                  # Vite bundler config
```

## Scripts Structure
```
scripts/
├── backend/                        # Backend-specific scripts
│   └── verify_backend.sh              # Checks backend setup
├── backup/                        # Backup management
│   ├── backup-full-project.sh         # Creates complete project backup
│   └── restore-full-project.sh        # Restores from backup
├── db/                            # Database management
│   └── db-migrate.sh                  # Runs database migrations
├── deploy/                        # Deployment scripts
│   ├── deploy-production.sh           # Deploys to production
│   └── deploy-staging.sh              # Deploys to staging
├── dev/                           # Development tools
│   ├── deploy-branch.sh               # Deploys feature branch
│   ├── deploy-prod.sh                 # Deploys to production
│   ├── manage-backend.sh              # Manages backend services
│   ├── promote.sh                     # Promotes to production
│   ├── run-tests.sh                   # Runs test suite
│   ├── start-dev-light.sh             # Starts minimal dev environment
│   └── start-dev.sh                   # Starts full dev environment
├── docs/                          # Documentation tools
│   ├── setup-api-docs.sh              # Sets up API documentation
│   ├── setup-test-docs.sh             # Sets up test documentation
│   ├── tree-backend.sh                # Shows backend structure
│   └── tree-project.sh                # Shows project structure
├── env/                           # Environment management
│   └── start-venv.sh                  # Starts virtual environment
├── git/                           # Git workflow scripts
│   ├── backup-branches.sh             # Backs up git branches
│   ├── compare-branches.sh            # Compares branches
│   ├── git-commit.sh                  # Assists with commits
│   ├── merge-branch.sh                # Merges branches
│   ├── new-feature.sh                 # Creates feature branch
│   └── verify-branch.sh               # Checks branch status
├── monitoring/                    # System monitoring
│   └── monitor-services.sh            # Monitors running services
├── performance/                   # Performance testing
│   └── run-performance-tests.sh       # Runs performance tests
├── security/                      # Security tools
│   ├── secret_key_manager.py          # Manages secret keys
│   └── security-audit.sh              # Runs security checks
├── setup/                         # Setup scripts
│   └── setup_environments.sh          # Sets up environments
├── sys/                           # System maintenance
│   ├── backup-config.sh               # Backs up system config
│   ├── cleanup_backend.sh             # Cleans backend files
│   ├── enhance-project-structure.sh   # Improves project structure
│   ├── evaluate-cursor-rules.sh       # Checks cursor rules
│   ├── evaluate_cursor_rules.py       # Python cursor rule checker
│   ├── make-scripts-executable.sh     # Makes scripts runnable
│   ├── rebuild_project.sh             # Rebuilds project
│   ├── reorganize-project.sh          # Reorganizes files
│   ├── restore-config.sh              # Restores system config
│   ├── setup-new-scripts.sh           # Sets up new scripts
│   ├── setup-testing.sh               # Sets up testing
│   ├── verify-scripts.sh              # Verifies scripts
│   └── verify_structure.py            # Checks project structure
└── utils/                         # Utility scripts
    ├── backup-config-env.sh           # Backs up environment config
    └── restore-config-env.sh          # Restores environment config
```

## Key Components

### Domains
Each domain represents a distinct business capability and contains:
- Models: Database models
- Schemas: API schemas
- Services: Business logic
- Repositories: Data access
- Routes: API endpoints

### Configuration
- Environment-based configuration
- Validation using Pydantic
- Secure secret management

### Testing
- Factory-based test data generation
- API contract testing
- Domain-specific test suites 