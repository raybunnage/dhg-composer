# Multi-App Architecture Guide

## What is Multi-App Architecture?

A multi-app architecture allows you to run multiple applications or features as separate components within a single backend system. Think of it like having multiple small apps inside one big app - similar to how your phone can run different apps that work together.

## Why Use Multi-App Architecture?

1. **Separation of Concerns**
   - Each app handles specific features
   - Easier to maintain and update
   - Reduces complexity in each component

2. **Scalability**
   - Scale different features independently
   - Add new features without affecting others
   - Remove features without breaking the system

3. **Team Organization**
   - Different teams can work on different apps
   - Clear boundaries between features
   - Independent development cycles

## How It Works

### 1. Basic Structure
```
backend/
├── src/
│   ├── app/
│   │   ├── main.py          # Main FastAPI application
│   │   ├── core/            # Shared core functionality
│   │   └── domains/         # Different app domains
│   │       ├── app1/        # First application
│   │       │   ├── routes.py
│   │       │   ├── models.py
│   │       │   └── services.py
│   │       └── app2/        # Second application
│   │           ├── routes.py
│   │           ├── models.py
│   │           └── services.py
```

### 2. Configuration
```python
# In core/config.py
class Settings(BaseSettings):
    APPS_ENABLED: Dict[str, bool] = {
        "app1": True,
        "app2": True
    }
```

### 3. App Registration
```python
# In main.py
from fastapi import FastAPI
from app.core.config import settings

app = FastAPI()

# Dynamically load enabled apps
if settings.APPS_ENABLED.get("app1"):
    from app.domains.app1.routes import router as app1_router
    app.include_router(app1_router, prefix="/api/v1/app1")

if settings.APPS_ENABLED.get("app2"):
    from app.domains.app2.routes import router as app2_router
    app.include_router(app2_router, prefix="/api/v1/app2")
```

## Real-World Example

Let's say you're building a system with authentication and a blog:

```python
# domains/auth/routes.py
from fastapi import APIRouter

router = APIRouter()

@router.post("/login")
async def login():
    # Handle login logic
    pass

# domains/blog/routes.py
from fastapi import APIRouter

router = APIRouter()

@router.get("/posts")
async def get_posts():
    # Get blog posts
    pass
```

## When to Use Multi-App Architecture

Use this approach when:
1. Your project has distinct features that could work independently
2. Different teams need to work on different parts
3. You want to enable/disable features easily
4. You plan to scale different features differently

## Best Practices

1. **Keep Apps Independent**
   - Each app should work without knowing about others
   - Share code through core utilities
   - Use events for cross-app communication

2. **Consistent Structure**
   ```
   app_name/
   ├── routes.py      # API endpoints
   ├── models.py      # Database models
   ├── schemas.py     # Pydantic models
   ├── services.py    # Business logic
   └── tests/         # App-specific tests
   ```

3. **Configuration Management**
   - Use environment variables for app settings
   - Enable/disable apps through configuration
   - Keep app-specific settings separate

4. **API Versioning**
   - Use prefixes for each app: `/api/v1/app1`
   - Version APIs independently
   - Document API changes

## Common Patterns

1. **Shared Authentication**
```python
# core/auth.py
from fastapi import Depends

async def get_current_user():
    # Shared authentication logic
    pass

# Use in any app
@router.get("/protected")
async def protected_route(user = Depends(get_current_user)):
    return {"message": f"Hello {user.name}"}
```

2. **Cross-App Communication**
```python
# Using events
from app.core.events import EventBus

@router.post("/new-post")
async def create_post():
    # Create post
    EventBus.emit("post_created", post_data)
```

## Getting Started

1. **Create a New App**
```bash
# Create app structure
mkdir -p src/app/domains/new_app
touch src/app/domains/new_app/{__init__,routes,models,services}.py

# Enable in config
APPS_ENABLED='{"new_app": true}'
```

2. **Add Routes**
```python
# domains/new_app/routes.py
from fastapi import APIRouter

router = APIRouter(prefix="/new-app", tags=["new_app"])

@router.get("/")
async def root():
    return {"message": "New app is working!"}
```

3. **Register in Main**
```python
# main.py
if settings.APPS_ENABLED.get("new_app"):
    from app.domains.new_app.routes import router as new_app_router
    app.include_router(new_app_router, prefix="/api/v1")
```

## Troubleshooting

1. **App Not Loading**
   - Check APPS_ENABLED configuration
   - Verify import paths
   - Check for circular imports

2. **Cross-App Issues**
   - Use core services for shared functionality
   - Implement proper error handling
   - Use dependency injection

## Next Steps

1. Start with a simple app structure
2. Add more apps as needed
3. Implement shared services in core
4. Add cross-app communication if required
5. Scale individual apps based on needs 