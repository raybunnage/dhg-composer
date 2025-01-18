# Environment Configuration Guide

## Required Files Structure
```
project_root/
├── backend/
│   ├── .env                     # Active environment file (gitignored)
│   ├── .env.development.template
│   ├── .env.staging.template
│   └── .env.production.template
├── scripts/
│   ├── start-dev.sh
│   ├── backup-config.sh
│   ├── restore-config.sh
│   └── run-tests.sh
└── .gitignore
```

## Environment Templates

### Create Environment Templates
```bash:scripts/setup-env-templates.sh
#!/bin/bash

# Create template for development
cat > backend/.env.development.template << EOL
# Development Environment Configuration
DATABASE_URL=postgresql://user:password@localhost:5432/dev_db
ENVIRONMENT=development
DEBUG=true
LOG_LEVEL=debug
CORS_ORIGINS=http://localhost:3000
# Add other development-specific variables
EOL

# Create template for staging
cat > backend/.env.staging.template << EOL
# Staging Environment Configuration
DATABASE_URL=postgresql://user:password@staging-db:5432/staging_db
ENVIRONMENT=staging
DEBUG=false
LOG_LEVEL=info
CORS_ORIGINS=https://staging.yourdomain.com
# Add other staging-specific variables
EOL

# Create template for production
cat > backend/.env.production.template << EOL
# Production Environment Configuration
DATABASE_URL=postgresql://user:password@production-db:5432/prod_db
ENVIRONMENT=production
DEBUG=false
LOG_LEVEL=warning
CORS_ORIGINS=https://yourdomain.com
# Add other production-specific variables
EOL
```

## Required .gitignore Updates
```text:.gitignore
# Environment files
.env
.env.*
!.env.*.template

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/

# Logs
*.log
logs/
```

## Environment Setup Script
```bash:scripts/setup-env.sh
#!/bin/bash

ENV_TYPE=$1

if [[ ! $ENV_TYPE =~ ^(development|staging|production)$ ]]; then
    echo "Usage: $0 <development|staging|production>"
    exit 1
fi

# Copy appropriate template
cp backend/.env.$ENV_TYPE.template backend/.env

# Load environment-specific requirements
if [ -f requirements.$ENV_TYPE.txt ]; then
    pip install -r requirements.$ENV_TYPE.txt
else
    pip install -r requirements.txt
fi

echo "Environment $ENV_TYPE setup complete"
```

## Environment Backup Script
```bash:scripts/backup-config.sh
#!/bin/bash

BACKUP_DIR="config_backups/$(date +%Y%m%d_%H%M%S)"
mkdir -p $BACKUP_DIR

# Backup environment files
cp backend/.env $BACKUP_DIR/ 2>/dev/null || true
cp backend/.env.*.template $BACKUP_DIR/

# Backup requirements
cp requirements*.txt $BACKUP_DIR/

# Backup scripts
cp -r scripts/ $BACKUP_DIR/

echo "Configuration backed up to $BACKUP_DIR"
```

## Environment Restore Script
```bash:scripts/restore-config.sh
#!/bin/bash

BACKUP_DIR=$1

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory not found: $BACKUP_DIR"
    exit 1
fi

# Restore environment files
cp $BACKUP_DIR/.env* backend/

# Restore requirements
cp $BACKUP_DIR/requirements*.txt ./

echo "Configuration restored from $BACKUP_DIR"
``` 