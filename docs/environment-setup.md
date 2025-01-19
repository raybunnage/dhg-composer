# Environment Setup Guide

## Overview
This document describes how to set up environment configurations for different deployment scenarios.

## Environment Files
The application uses different environment files for different deployment scenarios:

- `.env` - Local development (gitignored)
- `.env.development.template` - Template for development setup
- `.env.staging.template` - Template for staging setup
- `.env.production.template` - Template for production setup

## Required Environment Variables

### Core Variables
```env
# Required
SUPABASE_URL="your-supabase-url"
SUPABASE_KEY="your-supabase-key"
ENV="development|staging|production"
SECRET_KEY="min-32-char-secret"

# Optional (with defaults)
DEBUG=true|false  # defaults to false
PORT=8000         # defaults to 8000
```

### Variable Descriptions

- `SUPABASE_URL`: Your Supabase project URL
  - Format: `https://<project>.supabase.co`
  - Required for database and auth functionality
  
- `SUPABASE_KEY`: Your Supabase project API key
  - Must be at least 20 characters
  - Keep this secret!
  
- `ENV`: Deployment environment
  - Valid values: "development", "staging", "production"
  - Affects logging, debugging, and security settings
  
- `SECRET_KEY`: Application secret key
  - Must be at least 32 characters
  - Used for token signing and security
  
- `DEBUG`: Enable debug mode
  - Set to "true" for development
  - Always "false" in production
  
- `PORT`: Server port
  - Defaults to 8000
  - Can be changed for different environments

## Setup Instructions

### Local Development Setup

1. Copy the example environment file:
```bash
cp backend/.env.example backend/.env
```

2. Edit `.env` and add your credentials:
```env
SUPABASE_URL="https://your-project.supabase.co"
SUPABASE_KEY="your-actual-key"
ENV="development"
SECRET_KEY="your-secret-key-min-32-chars"
DEBUG=true
```

### Staging/Production Setup

1. Use the appropriate template:
```bash
# For staging
cp backend/.env.staging.template backend/.env.staging

# For production
cp backend/.env.production.template backend/.env.production
```

2. Update the environment variables according to your deployment.

## Environment Validation

The application validates environment variables on startup:

- Checks for required variables
- Validates URL formats
- Ensures minimum key lengths
- Verifies environment names

If validation fails, the application will log errors and refuse to start.

## Security Notes

1. Never commit `.env` files to version control
2. Keep production credentials secure
3. Rotate secrets regularly
4. Use different credentials for each environment
5. Monitor environment access

## Troubleshooting

### Common Issues

1. "SUPABASE_URL must be a valid URL"
   - Ensure URL starts with https://
   - Check for typos in the domain

2. "SUPABASE_KEY is too short"
   - Verify you're using the correct API key
   - Check for copying errors

3. "Environment validation failed"
   - Check the logs for specific validation errors
   - Verify all required variables are set
   - Check variable format and content

### Getting Help

- Check the error logs
- Review this documentation
- Contact the development team 