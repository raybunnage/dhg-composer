# Branch Management Guide

## Branch Structure
```
project/
├── main (production)
├── staging
├── development
├── feature/
│   ├── auth-system
│   ├── user-dashboard
│   └── payment-integration
├── hotfix/
│   └── security-patch-123
└── release/
    └── v1.2.0
```

## Branch Types

### Main Branches

#### 1. Main (Production)
- **Purpose**: Production-ready code
- **Protected**: Yes
- **Naming**: `main` or `master`
- **Rules**:
  - No direct commits
  - Requires signed commits
  - Must pass all tests
  - Requires PR approvals

#### 2. Staging
- **Purpose**: Pre-production testing
- **Protected**: Yes
- **Naming**: `staging`
- **Rules**:
  - Must pass all tests
  - Requires PR approvals
  - Integration testing environment

#### 3. Development
- **Purpose**: Integration of features
- **Protected**: Yes
- **Naming**: `development` or `dev`
- **Rules**:
  - Feature branches merge here first
  - Must pass basic tests
  - Code review required

### Temporary Branches

#### 1. Feature Branches
- **Pattern**: `feature/description`
- **Examples**:
  ```bash
  feature/user-authentication
  feature/payment-system
  feature/email-templates
  ```
- **Rules**:
  - Branch from: `development`
  - Merge to: `development`
  - Delete after merge

#### 2. Hotfix Branches
- **Pattern**: `hotfix/issue-description`
- **Examples**:
  ```bash
  hotfix/login-bug
  hotfix/security-patch
  hotfix/database-connection
  ```
- **Rules**:
  - Branch from: `main`
  - Merge to: `main` and `development`
  - Requires urgent review

#### 3. Release Branches
- **Pattern**: `release/version`
- **Examples**:
  ```bash
  release/v1.0.0
  release/v1.1.0-beta
  ```
- **Rules**:
  - Branch from: `development`
  - Merge to: `main` and `development`
  - Tag after merge

## Branch Workflows

### 1. Feature Development
```bash
# Start new feature
git checkout development
git pull origin development
git checkout -b feature/new-feature

# Regular updates
git fetch origin
git rebase origin/development

# Complete feature
git push origin feature/new-feature
# Create PR to development
```

### 2. Hotfix Process
```bash
# Create hotfix
git checkout main
git checkout -b hotfix/critical-fix

# After fix
git push origin hotfix/critical-fix
# Create PR to main AND development
```

### 3. Release Process
```bash
# Create release branch
git checkout development
git checkout -b release/v1.0.0

# Stabilize and test
git push origin release/v1.0.0
# Create PR to main
```

## Protection Rules

### Main Branch
```yaml
Protection rules:
- Require pull request reviews
- Require signed commits
- Require status checks to pass
- No direct pushes
- No force pushes
```

### Staging Branch
```yaml
Protection rules:
- Require pull request reviews
- Require status checks to pass
- No direct pushes
```

### Development Branch
```yaml
Protection rules:
- Require basic status checks
- Allow team leads to push
```

## Environment Mapping

### Branch to Environment Mapping
```yaml
main:
  url: https://app.example.com
  env: production
  database: prod_db

staging:
  url: https://staging.example.com
  env: staging
  database: staging_db

development:
  url: https://dev.example.com
  env: development
  database: dev_db
```

## Best Practices

### 1. Branch Naming
```bash
# Good examples
feature/add-user-authentication
hotfix/fix-login-timeout
release/v1.2.0

# Bad examples
new-stuff
quick-fix
john-branch
```

### 2. Commit Messages
```bash
# Good examples
feat: add user authentication system
fix: resolve login timeout issue
docs: update API documentation

# Bad examples
fix stuff
update code
wip
```

### 3. Branch Maintenance
```bash
# Regular cleanup
git fetch --prune
git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d

# Update local branches
git fetch --all
git pull --rebase origin development
```

## Common Commands

### Branch Management
```bash
# List branches
git branch -a

# Create branch
git checkout -b feature/new-feature

# Delete branch
git branch -d feature/old-feature

# Force delete
git branch -D feature/abandoned
```

### Syncing
```bash
# Update branch
git fetch origin
git rebase origin/development

# Force push (if needed)
git push --force-with-lease origin feature/name
```

## Remember
1. Always branch from the correct source
2. Keep branches focused and short-lived
3. Use meaningful branch names
4. Regular rebase with source branch
5. Delete branches after merging
6. Follow naming conventions
7. Keep documentation updated 