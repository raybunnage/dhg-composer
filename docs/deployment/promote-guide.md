# Environment Promotion Guide

## Overview
The `promote.sh` script manages code promotion between environments (development → staging → production).

## Usage
```bash
./scripts/dev/promote.sh <source-env> <target-env> [options]
```

## Parameters
- `source-env`: Source environment (dev/staging)
- `target-env`: Target environment (staging/prod)
- `options`: Additional deployment options

## Features
- Automated environment promotion
- Pre-promotion checks
- Database migration handling
- Rollback capability
- Deployment verification

## Examples
```bash
# Promote from dev to staging
./scripts/dev/promote.sh dev staging

# Promote from staging to production
./scripts/dev/promote.sh staging prod

# Promote with specific options
./scripts/dev/promote.sh dev staging --skip-tests
```

## Promotion Flow
1. Pre-promotion checks
2. Database backup
3. Code deployment
4. Database migrations
5. Service restart
6. Health checks
7. Verification

## Rollback
```bash
# Rollback last promotion
./scripts/dev/promote.sh rollback <env>
``` 