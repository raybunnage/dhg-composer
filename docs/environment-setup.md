# Environment Setup Guide

## Overview
This document provides comprehensive instructions for setting up and managing environment configurations across different deployment scenarios.

## Environment Files Structure

```
backend/
├── .env                    # Local development (gitignored)
├── .env.example           # Template for local setup
├── .env.development.template  # Development environment template
├── .env.staging.template     # Staging environment template
└── .env.production.template  # Production environment template
```

## Required Environment Variables

### Core Variables
```env
# Required
SUPABASE_URL="https://<project>.supabase.co"
SUPABASE_KEY="your-supabase-key"
ENV="development|staging|production"
SECRET_KEY="your-secure-secret-key"

# Optional with defaults
DEBUG=true|false           # Default: false
PORT=8000                 # Default: 8000
LOG_LEVEL=info           # Default: info
BACKEND_CORS_ORIGINS="http://localhost:3000,http://localhost:8000"
DATABASE_URL="postgresql://user:pass@host:5432/db"
```

### Validation Rules

#### SUPABASE_URL
- Must be a valid HTTPS URL
- Must contain "supabase.co" domain
- Must include project identifier

#### SUPABASE_KEY
- Minimum 20 characters
- Alphanumeric characters, dots, underscores, and hyphens only
- Keep this secret and secure

#### ENV
- Valid values: "development", "staging", "production"
- Affects:
  - Logging verbosity
  - Debug features
  - Security measures
  - Performance optimizations

#### SECRET_KEY
- Minimum 32 characters
- Must contain:
  - At least one uppercase letter
  - At least one lowercase letter
  - At least one number
- Used for:
  - Token signing
  - Cryptographic operations
  - Security features

#### PORT
- Valid range: 1024-65535
- Default: 8000
- Must be available on host system

#### LOG_LEVEL
- Valid values: "debug", "info", "warning", "error", "critical"
- Default: "info"
- Affects logging verbosity

#### BACKEND_CORS_ORIGINS
- Comma-separated list of valid URLs
- Must include protocol (http/https)
- Must include domain
- Default: "http://localhost:3000"

#### DATABASE_URL (Optional)
- Valid PostgreSQL connection string
- Format: "postgresql://user:pass@host:5432/db"
- Required for direct database access

## Environment-Specific Setup

### Development Setup
```bash
# 1. Create local environment file
cp backend/.env.example backend/.env

# 2. Edit .env with your development credentials
nano backend/.env

# 3. Verify environment
python -m app.core.env_validator
```

### Staging Setup
```bash
# 1. Create staging environment file
cp backend/.env.staging.template backend/.env.staging

# 2. Edit with staging credentials
nano backend/.env.staging

# 3. Set environment variable
export ENV=staging
```

### Production Setup
```bash
# 1. Create production environment file
cp backend/.env.production.template backend/.env.production

# 2. Edit with production credentials
nano backend/.env.production

# 3. Set environment variable
export ENV=production
```

## Security Best Practices

### Credential Management
1. Never commit credentials to version control
2. Use different credentials for each environment
3. Rotate secrets regularly
4. Use secure secret storage in production
5. Monitor access and usage

### Secret Generation
```bash
# Generate secure SECRET_KEY
openssl rand -base64 32

# Generate secure password
openssl rand -base64 24
```

### Access Control
1. Limit environment file access
2. Use role-based access control
3. Audit access regularly
4. Log configuration changes

## Troubleshooting

### Common Issues

1. "SUPABASE_URL validation failed"
   - Check URL format
   - Verify project identifier
   - Ensure HTTPS protocol

2. "SECRET_KEY requirements not met"
   - Check length (min 32 chars)
   - Verify character requirements
   - Use secure generation method

3. "Invalid CORS origin"
   - Check URL format
   - Include protocol (http/https)
   - Verify domain name

### Validation Errors

When you see validation errors:
1. Check the specific error message
2. Verify against validation rules
3. Use provided examples
4. Check for typos and formatting

### Getting Help

1. Check application logs
2. Review this documentation
3. Verify against templates
4. Contact DevOps team

## Monitoring and Maintenance

### Regular Tasks
1. Rotate secrets monthly
2. Review CORS origins
3. Update documentation
4. Audit environment access
5. Verify backup procedures

### Logging
- Monitor environment loading
- Track validation failures
- Audit configuration changes
- Review access patterns

## Additional Resources

- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Supabase Documentation](https://supabase.io/docs)
- [Python dotenv](https://github.com/theskumar/python-dotenv)
- [Pydantic Settings](https://pydantic-docs.helpmanual.io/) 