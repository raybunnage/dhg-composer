# Managing .gitignore in Multi-Environment Projects

## Overview
Proper .gitignore configuration is crucial for:
- Protecting sensitive environment data
- Preserving environment-specific configurations
- Maintaining backup files safely
- Preventing accidental commits of local files

## Recommended Structure

### Root .gitignore
```gitignore
# Environment Files
.env
.env.*
!.env.*.template
!.env.example

# Environment Backups
!.backup/
!config_backups/
*.backup
*.bak

# IDE and System Files
.vscode/
.idea/
*.swp
.DS_Store
._.DS_Store
**/.DS_Store
**/._.DS_Store

# Python
__pycache__/
*.py[cod]
*.so
.Python
venv/
.env/
*.egg-info/
dist/
build/

# Node
node_modules/
npm-debug.log
yarn-debug.log
yarn-error.log
.next/
.nuxt/
dist/

# Local Development
*.local
local_*
```

### Backend-specific .gitignore
```gitignore:backend/.gitignore
# Environment Files
.env
.env.*
!.env.*.template
!.env.example

# Local Development
local_settings.py
*.sqlite3

# Preserve Environment Templates
!templates/
!templates/*.env
```

### Frontend-specific .gitignore
```gitignore:frontend/.gitignore
# Environment Files
.env
.env.*
!.env.*.template
!.env.example

# Build Files
.cache/
dist/
build/
```

## Environment File Management

### Protected Files (Never Ignore)
```bash
# Environment Templates
.env.development.template
.env.staging.template
.env.production.template
.env.example

# Backup Configurations
config_backups/*/
.backup/*/
```

### Always Ignored Files
```bash
# Active Environment Files
.env
.env.development
.env.staging
.env.production

# Temporary Files
*.tmp
*.temp
```

## Best Practices

### 1. Template Management
```bash
# Create environment template
cp .env.example .env.development.template

# Update template (safe to commit)
git add .env.development.template
git commit -m "Update development environment template"
```

### 2. Backup Protection
```bash
# Create backup directory (not ignored)
mkdir -p config_backups/branch-name

# Backup configurations
./scripts/backup-config.sh

# Safe to commit backup templates
git add config_backups/*/templates/
```

### 3. Environment File Creation
```bash
# Create from template (will be ignored)
cp .env.development.template .env.development

# Verify gitignore is working
git status  # Should not show .env.development
```

## Common Issues and Solutions

### 1. Accidentally Committed Environment File
```bash
# Remove from git but keep locally
git rm --cached .env.development
echo ".env.development" >> .gitignore
git commit -m "Remove development environment file"
```

### 2. Ignored Files Not Working
```bash
# Reset git cache
git rm -r --cached .
git add .
git commit -m "Reset git cache and apply gitignore rules"
```

### 3. Need to Share Specific Config
```bash
# Create shareable template
cp .env.development .env.development.template
# Remove sensitive data from template
vim .env.development.template
git add .env.development.template
```

## Environment-Specific Guidelines

### Development
```gitignore
# Allow development tools
!.vscode/launch.json
!.vscode/settings.json
```

### Staging
```gitignore
# Strict environment file rules
.env.staging*
!.env.staging.template
```

### Production
```gitignore
# Maximum security
.env.prod*
!.env.production.template
*.key
*.pem
```

## Verification Steps

### 1. Check Gitignore Configuration
```bash
# Verify gitignore patterns
git check-ignore -v path/to/file

# List all ignored files
git status --ignored
```

### 2. Verify Environment Security
```bash
# Check for sensitive files
./scripts/verify-branch.sh main strict

# Ensure templates are tracked
git ls-files | grep .env
```

### 3. Test Backup System
```bash
# Create test backup
./scripts/backup-config.sh test

# Verify backup is tracked correctly
git status
```

## Maintenance Tasks

### Regular Cleanup
```bash
# Remove untracked files (dry run)
git clean -n

# Remove ignored files
git clean -fdX

# Remove all untracked files
git clean -fd
```

### Update Templates
```bash
# Update all environment templates
./scripts/update-templates.sh

# Verify no sensitive data
./scripts/verify-templates.sh
```

Remember:
1. Always use templates for sharing configurations
2. Regularly verify gitignore patterns
3. Keep backup directories tracked but ignore their contents
4. Use environment-specific rules when needed
5. Document any special exceptions 