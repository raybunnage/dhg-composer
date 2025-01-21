# Python Requirements Management

This document describes our current Python dependencies and future plans.

## Current Dependencies

### FastAPI and Core Dependencies
- `fastapi==0.95.2`
  - Deliberately downgraded for compatibility with pydantic v1
  - Required for Supabase 1.0.3 compatibility
  
- `pydantic==1.10.12`
  - Downgraded version required by postgrest 0.10.6
  - Used for data validation and serialization
  
- `email-validator==2.1.1`
  - Required for pydantic email validation
  - Provides robust email format checking

- `python-dotenv==1.0.0`
  - Environment management
  - Loads environment variables from .env files

### API and HTTP Dependencies
All specifically downgraded for Supabase 1.0.3 compatibility:

- `httpx==0.23.3`
  - Downgraded for Supabase 1.0.3
  - Modern HTTP client with async support

- `httpcore==0.16.3`
  - Compatible with httpx 0.23.3
  - Low-level HTTP transport library

- `aiohttp==3.7.4`
  - Known to work on M1/M2 Macs
  - Async HTTP client/server framework

- `uvicorn==0.23.2`
  - ASGI server implementation
  - Handles async web traffic

### Supabase and Related Dependencies
Current working versions tested for compatibility:

- `supabase==1.0.3`
  - Base version known to work
  - Python client for Supabase

- `postgrest==0.10.6`
  - Compatible with supabase 1.0.3
  - RESTful API for PostgreSQL

- `gotrue==1.0.1`
  - Compatible with supabase 1.0.3
  - Authentication client

### Authentication
- `python-jose[cryptography]==3.3.0`
  - JWT handling capabilities
  - Includes cryptography extensions

- `passlib[bcrypt]==1.7.4`
  - Password hashing functionality
  - Includes bcrypt algorithm support

- `python-multipart==0.0.20`
  - Form data parsing
  - Required for file uploads

### Utilities
- `orjson==3.10.15`
  - Fast JSON parsing
  - High-performance JSON operations

- `tenacity==8.2.3`
  - Retry logic for API calls
  - Handles transient failures

- `structlog==23.2.0`
  - Structured logging
  - Enhanced log formatting

## Version Compatibility Notes
- The Supabase ecosystem requires specific version alignment:
  - FastAPI must be 0.95.2 or lower due to pydantic v1 requirement
  - Pydantic must be v1 series (1.10.12) for postgrest compatibility
  - HTTP clients must be aligned with Supabase 1.0.3 requirements

## Future State Dependencies
These are planned additions not yet implemented:

### Production Server
- Gunicorn with uvicorn workers
- Performance monitoring tools
- Enhanced error tracking

### Development Tools
- Additional testing frameworks
- Linting and formatting tools
- Documentation generators

### Monitoring and Logging
- Advanced monitoring tools
- Production-grade logging
- APM solutions

## Best Practices

### Version Management
```bash
# Check for outdated packages
pip list --outdated

# Security audit
pip-audit
```

### Virtual Environments
```bash
# Create new environment
python -m venv venv

# Activate environment
source venv/bin/activate  # Unix
venv\Scripts\activate     # Windows
```

### Installation
```bash
# Install current dependencies
pip install -r requirements/requirements.base.txt
```

## Troubleshooting Common Issues
1. **Supabase Version Conflicts**
   - Ensure FastAPI and pydantic versions match requirements
   - Check HTTP client compatibility
   - Verify postgrest version alignment

2. **M1/M2 Mac Compatibility**
   - Use specified aiohttp version
   - Test in local environment first
   - Monitor for ARM-specific issues 