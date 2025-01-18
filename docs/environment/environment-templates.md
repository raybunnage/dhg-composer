# Understanding Environment Templates

## What Are Environment Templates?
Environment templates (like `.env.template` or `.env.example`) are blueprint files that show what environment variables your project needs, without containing actual sensitive values.

## Why Use Templates?

### 1. Onboarding Benefits
```bash
# New developer joins:
cp .env.template .env.development
# Now they know exactly what values they need to fill in
```

### 2. Security Benefits
```ini
# .env.template (safe to commit)
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
API_KEY=your-api-key-here

# .env (never commit this!)
DATABASE_URL=postgresql://admin:secretpass@prod-db:5432/myapp
API_KEY=actual-secret-key-123
```

## Template Structure

### Basic Template
```ini
# .env.template
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=your_database_name
DB_USER=your_username
DB_PASSWORD=your_password

# API Keys
SUPABASE_URL=your-project.supabase.co
SUPABASE_KEY=your-anon-key

# Feature Flags
DEBUG=true
ENABLE_LOGGING=true
```

### Environment-Specific Templates
```ini
# .env.development.template
API_URL=http://localhost:8000
DEBUG=true
LOG_LEVEL=debug

# .env.production.template
API_URL=https://api.yourapp.com
DEBUG=false
LOG_LEVEL=error
```

## Best Practices

### 1. Template Maintenance
```bash
# When adding new environment variables:
1. Add to .env.template first
2. Update documentation
3. Notify team

# When removing variables:
1. Remove from .env.template
2. Update documentation
3. Clean up old .env files
```

### 2. Variable Documentation
```ini
# .env.template
# Required: URL for database connection
# Format: postgresql://user:pass@host:port/db
DATABASE_URL=

# Optional: Set to 'true' to enable debug mode
# Default: false
DEBUG=false

# Required: Supabase anon key
# Get this from: Supabase Dashboard > Settings > API
SUPABASE_KEY=
```

### 3. Validation System
```python
# validate_env.py
required_vars = [
    'DATABASE_URL',
    'SUPABASE_KEY',
    'API_URL'
]

optional_vars = [
    'DEBUG',
    'LOG_LEVEL'
]

def validate_env():
    missing = []
    for var in required_vars:
        if var not in os.environ:
            missing.append(var)
    
    if missing:
        raise Exception(f"Missing required env vars: {', '.join(missing)}")
```

## Common Issues and Solutions

### 1. Missing Variables
```bash
# Problem: New variable added but not in .env
ERROR: Missing required environment variable: API_KEY

# Solution: Use template to update
diff .env.template .env
# Add missing variables
```

### 2. Invalid Values
```bash
# Problem: Wrong format or invalid value
ERROR: Invalid DATABASE_URL format

# Solution: Check template documentation
cat .env.template  # Read format requirements
```

### 3. Environment Mismatch
```bash
# Problem: Using wrong environment values
ERROR: Cannot connect to database

# Solution: Verify environment
echo $NODE_ENV  # Check current environment
cp .env.development.template .env.development  # Reset to template
```

## Template Management Script

```bash
#!/bin/bash
# manage_env.sh

function create_env() {
    local env_type=$1
    if [[ ! -f ".env.${env_type}.template" ]]; then
        echo "No template found for ${env_type}"
        exit 1
    }
    
    cp ".env.${env_type}.template" ".env.${env_type}"
    echo "Created .env.${env_type} from template"
}

function verify_env() {
    local env_type=$1
    local template=".env.${env_type}.template"
    local env_file=".env.${env_type}"
    
    # Check for missing variables
    while IFS= read -r line; do
        if [[ $line =~ ^[A-Z_]+=.* ]]; then
            var_name=${line%%=*}
            if ! grep -q "^${var_name}=" "$env_file"; then
                echo "Missing variable: ${var_name}"
            fi
        fi
    done < "$template"
}
```

## Safety Features

### 1. Git Protection
```gitignore
# .gitignore
.env*
!.env*.template
!.env.example
```

### 2. Backup System
```bash
# Backup before changes
cp .env .env.backup-$(date +%Y%m%d)

# Restore if needed
cp .env.backup-20240315 .env
```

### 3. Template Verification
```bash
# Verify template matches current needs
./scripts/verify-template.sh

# Update template if needed
./scripts/update-template.sh
```

## Remember:
1. Never commit actual `.env` files
2. Keep templates updated
3. Document all variables
4. Use different templates for different environments
5. Validate environment setup regularly
6. Maintain backup copies of working configurations
7. Use scripts to manage environment setup 