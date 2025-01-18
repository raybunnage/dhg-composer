# Environment Setup Guide

## Overview
This project uses different environment configurations for development, staging, and production. Each environment has its own specific settings defined in environment files.

## Environment Files

### Templates
- `.env.development.template` - Development environment template
- `.env.staging.template` - Staging environment template
- `.env.production.template` - Production environment template

### Working Files
- `.env.development` - Your local development settings
- `.env.staging` - Staging environment settings
- `.env.production` - Production environment settings

## Setting Up Your Development Environment

1. **Initial Setup**
   ```bash
   # Run setup script
   ./scripts/setup-env.sh
   ```

2. **Update Environment Variables**
   Edit `backend/.env.development` with your local values:
   - `SUPABASE_URL` - Your Supabase project URL
   - `SUPABASE_KEY` - Your Supabase anon key
   - `DATABASE_URL` - Your local database URL

3. **Verify Setup**
   ```bash
   # Verify environment
   ./scripts/manage-env.sh verify development
   ```

## Environment Management

### Creating New Environment
```bash
# Create environment from template
./scripts/manage-env.sh create development
```

### Verifying Environment
```bash
# Verify environment configuration
./scripts/manage-env.sh verify development
```

### Backing Up Environment
```bash
# Create backup of environment file
./scripts/manage-env.sh backup development
```

## Security Notes

1. Never commit actual environment files
2. Keep your keys and secrets secure
3. Use different values for each environment
4. Regularly rotate production secrets
5. Backup environment files securely 