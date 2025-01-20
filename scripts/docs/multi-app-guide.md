# Multi-App Architecture Guide

## Overview
This guide explains our multi-app architecture approach for beginners. The system is designed to handle multiple applications within a single codebase while maintaining separation of concerns.

## Structure 

```bash
project/
├── backend/
│ ├── src/
│ │ ├── app/
│ │ │ ├── domains/ # Feature domains (auth, users, etc.)
│ │ │ ├── core/ # Core functionality
│ │ │ │ ├── apps.py # App registry and configuration
│ │ │ │ └── config.py # Global settings
│ │ │ └── middleware/ # Custom middleware
│ │ └── apps/ # Individual apps
│ │ ├── app1/
│ │ └── app2/
│ └── requirements/
├── frontend/
│ ├── src/
│ │ ├── apps/ # Frontend app components
│ │ └── shared/ # Shared components
│ └── package.json
└── scripts/
├── dev/ # Development utilities
├── docs/ # Documentation
└── utils/ # Utility scripts
```

## Key Concepts

### 1. App Registry
Each app is registered with core settings and configurations:

```python
AppConfig(
    id="app1",
    name="Application 1",
    features=["feature1", "feature2"],
    database_schema="app1",
    api_prefix="/api/v1",
    cors_origins=["https://app1.yourdomain.com"]
)
```

### 2. Feature Isolation
- Each app has its own database schema
- Separate API routes and prefixes
- Isolated frontend components
- App-specific configurations

### 3. Shared Resources
- Common authentication system
- Shared middleware
- Core utilities
- Base components

## Getting Started

### 1. Create a New App

```bash
# Create app structure
mkdir -p backend/src/apps/newapp
mkdir -p frontend/src/apps/newapp

# Register the app in backend/src/app/core/app_settings.py
```

### 2. Configure App Settings

```python
# backend/src/app/core/app_settings.py
APP_SETTINGS = {
    "newapp": AppSettings(
        features={
            "feature1": FeatureConfig(enabled=True),
            "feature2": FeatureConfig(enabled=False),
        },
        api_version="v1",
        database_schema="newapp"
    )
}
```

### 3. Add Routes

```python
# backend/src/apps/newapp/routes.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def read_root():
    return {"app": "newapp"}
```

### 4. Register Routes

```python
# backend/src/app/main.py
from apps.newapp.routes import router as newapp_router

app.include_router(
    newapp_router,
    prefix="/api/newapp",
    tags=["newapp"]
)
```

## Development Workflow

### 1. Environment Setup
```bash
# Create and activate virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
cd backend
uv pip install -r requirements/requirements.development.light.txt
```

### 2. Configuration Management
```bash
# Backup configuration
./scripts/utils/backup_config_env.sh

# Restore configuration
./scripts/utils/restore_config_env.sh <branch> [timestamp]
```

### 3. Start Development
```bash
# Start development servers
./scripts/dev/start-dev-light.sh
```

## Best Practices

### 1. Code Organization
- Keep app-specific code within its domain
- Use shared components for common functionality
- Follow consistent naming conventions
- Document all public interfaces

### 2. Configuration Management
- Use environment variables for app settings
- Keep sensitive data in `.env` files
- Regular configuration backups
- Version control for non-sensitive configs

### 3. Testing
- Write tests for all new features
- Maintain separate test suites per app
- Use fixtures for common test data
- Regular integration testing

### 4. Security
- Proper authentication/authorization
- Environment-specific settings
- Secure configuration management
- Regular security audits

## Troubleshooting

### Common Issues

1. **Missing Dependencies**
   ```bash
   # Reinstall dependencies
   rm -rf venv
   python -m venv venv
   source venv/bin/activate
   uv pip install -r requirements/requirements.development.light.txt
   ```

2. **Configuration Issues**
   ```bash
   # Restore last working configuration
   ./scripts/utils/restore_config_env.sh <branch> latest
   ```

3. **Database Problems**
   - Check schema prefix matches app name
   - Verify database migrations
   - Check connection settings

## Maintenance

### 1. Regular Backups
```bash
# Backup configurations before major changes
./scripts/utils/backup_config_env.sh
```

### 2. Version Control
- Keep .env.example up to date
- Document configuration changes
- Regular dependency updates

### 3. Documentation
- Update this guide for major changes
- Maintain API documentation
- Document configuration options

## Support

For additional help:
1. Check the `docs/` directory
2. Review test cases
3. Contact the development team

## Related Documentation
- [API Documentation](../docs/api/README.md)
- [Deployment Guide](../docs/deployment/README.md)
- [Testing Guide](../docs/testing/README.md)


