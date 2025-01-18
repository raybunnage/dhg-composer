# Project Scripts Documentation

This guide explains how to use the project's utility scripts for managing environments, deployments, and development workflows.

## Core Environment Scripts

### 1. start-dev.sh
**Purpose**: Starts the development environment with both frontend and backend servers.

**Usage**:
```bash
./scripts/start-dev.sh [dev|staging|prod]  # defaults to dev
```

**What it does**:
- Creates environment file if missing
- Kills any existing processes on ports 8001 and 5173
- Starts the FastAPI backend server
- Starts the Vite frontend development server
- Sets up environment variables

**When to use**: 
- When starting local development
- After pulling new changes
- When switching between environments

### 2. manage-env.sh
**Purpose**: Manages environment configuration files.

**Usage**:
```bash
./scripts/manage-env.sh [create|update|verify] [dev|staging|prod]
```

**Common workflows**:
```bash
# First time setup
./scripts/manage-env.sh create dev    # Create dev environment
./scripts/manage-env.sh update dev    # Edit variables

# Before deployment
./scripts/manage-env.sh verify prod   # Check production config
```

### 3. backup-config.sh & restore-config.sh
**Purpose**: Backup and restore environment configurations.

**Usage**:
```bash
# Create backup
./scripts/backup-config.sh

# Restore from backup
./scripts/restore-config.sh
```

**What they backup**:
- Backend environment files (.env.*)
- Frontend environment files
- Vercel configuration
- Branch-specific configurations

## Deployment Scripts

### 1. deploy-branch.sh
**Purpose**: Deploys current branch to Vercel preview environment.

**Usage**:
```bash
./scripts/deploy-branch.sh
```

### 2. deploy-prod.sh
**Purpose**: Deploys to production environment.

**Usage**:
```bash
./scripts/deploy-prod.sh
```

**Important**: Only run this from the main branch after thorough testing!

## Git Workflow Scripts

### 1. git-commit.sh
**Purpose**: Streamlines git commit process.

**Usage**:
```bash
./scripts/git-commit.sh "Your commit message"
```

### 2. merge-branch.sh
**Purpose**: Safely merges a branch into main.

**Usage**:
```bash
./scripts/merge-branch.sh feature-branch-name
```

### 3. new-feature.sh
**Purpose**: Creates a new feature branch (when implemented).

**Usage**:
```bash
./scripts/new-feature.sh feature-name
```

## Maintenance Scripts

### 1. rebuild_project.sh
**Purpose**: Complete project rebuild from scratch.

**Usage**:
```bash
./scripts/rebuild_project.sh
```

**What it does**:
- Kills existing processes
- Removes and recreates virtual environment
- Reinstalls backend dependencies
- Reinstalls frontend dependencies
- Updates requirements.txt

**When to use**:
- After major dependency changes
- When environment is corrupted
- Fresh project setup

### 2. run-tests.sh
**Purpose**: Runs all project tests.

**Usage**:
```bash
./scripts/run-tests.sh
```

### 3. tree-backend.sh
**Purpose**: Displays backend directory structure.

**Usage**:
```bash
./scripts/tree-backend.sh
```

## Common Workflows

### Initial Project Setup
```bash
# 1. Set up environment
./scripts/manage-env.sh create dev
./scripts/manage-env.sh update dev

# 2. Rebuild project
./scripts/rebuild_project.sh

# 3. Start development servers
./scripts/start-dev.sh
```

### Daily Development
```bash
# 1. Start development environment
./scripts/start-dev.sh

# 2. Make changes and commit
./scripts/git-commit.sh "Your changes"

# 3. Run tests before push
./scripts/run-tests.sh
```

### Deployment Process
```bash
# 1. Verify environment
./scripts/manage-env.sh verify prod

# 2. Backup configuration
./scripts/backup-config.sh

# 3. Deploy
./scripts/deploy-prod.sh
```

## Script Dependencies
- Bash shell
- Python 3.x and venv
- Node.js and npm
- Git
- Vercel CLI (for deployments)

## Troubleshooting

### Common Issues

1. **Permission Denied**
   ```bash
   chmod +x scripts/*.sh  # Make scripts executable
   ```

2. **Environment Not Found**
   ```bash
   # Create missing environment file
   ./scripts/manage-env.sh create dev
   ```

3. **Port Already in Use**
   ```bash
   # Manually kill processes
   kill -9 $(lsof -t -i:8001)
   kill -9 $(lsof -t -i:5173)
   ```

Remember to make all scripts executable before first use:
```bash
chmod +x scripts/*.sh
``` 