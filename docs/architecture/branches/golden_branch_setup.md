# Setting Up Golden Branch Configuration

## Overview
This guide explains how to properly distribute the golden branch configuration across environments while maintaining security and proper separation of concerns.

## 1. Environment Configuration

### Create Environment Templates
First, create template files for each environment:


bash:scripts/setup-env-templates.sh
Create development template
cp backend/.env backend/.env.development.template
Create staging template
cp backend/.env backend/.env.staging.template
Create production template
cp backend/.env backend/.env.production.template
```

### Update .gitignore
Add environment-specific patterns:
```text:.gitignore
# Existing code...

# Environment Files
.env
.env.*
!.env.*.template

text:.gitignore
Existing code...
Environment Files
.env
.env.
!.env..template
```

## 2. Requirements Management

Create environment-specific requirements files:
```bash:scripts/setup-requirements.sh
# Base requirements (common across all environments)
cp requirements.txt requirements.base.txt

# Create environment-specific requirements
cp requirements.txt requirements.development.txt
cp requirements.txt requirements.staging.txt
cp requirements.txt requirements.production.txt
```

## 3. Implementation Steps

1. **Backup Current Golden Configuration**
```bash
# Create backup script
./scripts/backup-config.sh golden-backup
```

2. **Create Branch Structure**
```bash
# Create environment branches
git checkout -b config/golden-standard
git checkout -b config/development
git checkout -b config/staging
git checkout -b config/production
```

3. **Setup Environment Files**
```bash
# For each environment:
./scripts/setup-env.sh <environment>
```

4. **Documentation Updates**
Add environment-specific documentation in `docs/environments/`:
- `development.md`
- `staging.md`
- `production.md`

## 4. Maintenance Scripts

### Environment Setup Script
```python:scripts/setup-env.sh
#!/bin/bash
ENV_TYPE=$1

# Validate input
if [[ ! $ENV_TYPE =~ ^(development|staging|production)$ ]]; then
    echo "Invalid environment type. Use: development, staging, or production"
    exit 1
fi

# Copy appropriate template
cp backend/.env.$ENV_TYPE.template backend/.env

# Install appropriate requirements
pip install -r requirements.$ENV_TYPE.txt

echo "Environment $ENV_TYPE setup complete"
```

### Configuration Backup Script
```python:scripts/backup-config.sh
#!/bin/bash
BACKUP_NAME=$1

# Create backup directory
BACKUP_DIR="config_backups/$BACKUP_NAME"
mkdir -p $BACKUP_DIR

# Backup environment files
cp backend/.env $BACKUP_DIR/
cp backend/.env.*.template $BACKUP_DIR/

# Backup requirements
cp requirements*.txt $BACKUP_DIR/

# Backup documentation
cp -r docs/ $BACKUP_DIR/

echo "Configuration backed up to $BACKUP_DIR"
```

## 5. Best Practices

1. **Environment Variables**
   - Keep sensitive data out of templates
   - Use placeholder values in templates
   - Document required variables

2. **Version Control**
   - Never commit actual .env files
   - Commit only templates
   - Use vault/secret management for production

3. **Documentation**
   - Keep setup instructions updated
   - Document environment differences
   - Include troubleshooting guides

4. **Security**
   - Different credentials per environment
   - Restricted access to production configs
   - Regular secret rotation

## 6. Deployment Process

1. **Development**
```bash
git checkout config/development
./scripts/setup-env.sh development
```

2. **Staging**
```bash
git checkout config/staging
./scripts/setup-env.sh staging
```

3. **Production**
```bash
git checkout config/production
./scripts/setup-env.sh production
```

## 7. Recovery Process

If needed, restore from golden backup:

```bash
./scripts/restore-config.sh golden-backup
```

Remember to regularly validate and update the golden configuration to ensure it remains the source of truth for your project setup.