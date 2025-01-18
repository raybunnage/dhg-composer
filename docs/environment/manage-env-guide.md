# Understanding and Using manage-env.sh

## What is manage-env.sh?
The `manage-env.sh` script helps you manage different environment configurations (development, staging, production) for your project. Think of it like having different settings for different situations - just like how you might have different outfits for work, gym, and parties.

## Basic Usage

### 1. Creating a New Environment
```bash
# Create a development environment
./scripts/manage-env.sh create dev

# Create a staging environment
./scripts/manage-env.sh create staging

# Create a production environment
./scripts/manage-env.sh create prod
```

What this does:
- Creates a new `.env` file for the specified environment
- Copies template values from `.env.example`
- Sets environment-specific variables

### 2. Updating Environment Variables
```bash
# Update development environment
./scripts/manage-env.sh update dev

# Example interaction:
> Enter SUPABASE_URL: https://your-dev-project.supabase.co
> Enter SUPABASE_KEY: your-dev-key
> Enter API_URL: http://localhost:8000
```

### 3. Verifying Environment Setup
```bash
# Verify development environment
./scripts/manage-env.sh verify dev

# This checks:
- Required files exist
- All required variables are set
- Values are in correct format
```

## Common Scenarios

### 1. Starting a New Project
```bash
# 1. Create development environment
./scripts/manage-env.sh create dev

# 2. Update with your local values
./scripts/manage-env.sh update dev

# 3. Verify setup
./scripts/manage-env.sh verify dev
```

### 2. Setting Up Multiple Environments
```bash
# Development setup
./scripts/manage-env.sh create dev
./scripts/manage-env.sh update dev

# Staging setup
./scripts/manage-env.sh create staging
./scripts/manage-env.sh update staging

# Production setup
./scripts/manage-env.sh create prod
./scripts/manage-env.sh update prod
```

### 3. Updating After Environment Changes
```bash
# When you get new API keys:
./scripts/manage-env.sh update dev

# When moving to staging:
./scripts/manage-env.sh update staging
```

## Environment Types Explained

### Development (dev)
- Used for local development
- Points to local or development databases
- Debug mode enabled
- Example values:
  ```
  API_URL=http://localhost:8000
  DEBUG=true
  SUPABASE_URL=your-dev-project.supabase.co
  ```

### Staging
- Used for testing before production
- Points to staging databases
- Production-like settings
- Example values:
  ```
  API_URL=https://staging-api.your-app.com
  DEBUG=false
  SUPABASE_URL=your-staging-project.supabase.co
  ```

### Production (prod)
- Used for live application
- Points to production databases
- Debug mode disabled
- Example values:
  ```
  API_URL=https://api.your-app.com
  DEBUG=false
  SUPABASE_URL=your-prod-project.supabase.co
  ```

## Safety Features

1. **Backup Before Update**
   ```bash
   # Script automatically creates backup
   ./scripts/manage-env.sh update dev
   # Backup created at: .env.dev.backup
   ```

2. **Validation Checks**
   ```bash
   # Verify environment is valid
   ./scripts/manage-env.sh verify dev
   ```

3. **Template Protection**
   - Never modifies `.env.example`
   - Keeps template as reference

## Troubleshooting

### 1. Permission Denied
```bash
# Make script executable
chmod +x scripts/manage-env.sh
```

### 2. Missing Environment File
```bash
# Create from example
cp .env.example .env.dev
./scripts/manage-env.sh update dev
```

### 3. Invalid Values
```bash
# Verify and show issues
./scripts/manage-env.sh verify dev
# Fix issues
./scripts/manage-env.sh update dev
```

## Best Practices

1. **Always Verify After Updates**
   ```bash
   ./scripts/manage-env.sh update dev
   ./scripts/manage-env.sh verify dev
   ```

2. **Keep Backups**
   ```bash
   # Manual backup
   cp .env.dev .env.dev.backup
   ```

3. **Regular Verification**
   ```bash
   # Add to your daily routine
   ./scripts/manage-env.sh verify dev
   ```

Remember:
- Never commit actual `.env` files to git
- Keep `.env.example` updated with required variables
- Verify environment setup before starting work
- Use appropriate environment for each stage
- Backup before making changes 