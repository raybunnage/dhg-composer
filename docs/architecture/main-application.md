# Backend Core Architecture

## Overview
The FastAPI application is built with a modular, feature-based architecture that supports multiple applications within a single backend. This document explains the core components and their interactions.

## Core Components Hierarchy

### 1. Application Entry Point (`main.py`)
```python
# Environment Setup
ENV = os.getenv("ENV", "development")
env_file = f".env.{ENV}" if ENV != "development" else ".env"
load_dotenv(Path(__file__).parent.parent.parent / env_file)

# Application Creation
def create_app() -> FastAPI:
    app = FastAPI(
        title=settings.PROJECT_NAME,
        description=settings.DESCRIPTION,
        version=settings.VERSION,
    )
    # ... middleware and router setup
```
- Initializes environment
- Creates FastAPI application
- Sets up middleware and routers
- Configures CORS and logging

### 2. Configuration System

#### Settings Management (`core/config.py`)
```python
class Settings(BaseSettings):
    DATABASE_URL: Optional[str] = None
    PORT: int = 8001
    SUPABASE_URL: str
    SUPABASE_KEY: str
    # ... other settings

    @validator("SUPABASE_URL")
    def validate_supabase_url(cls, v: str) -> str:
        if not v.startswith(("http://", "https://")):
            raise ValueError("SUPABASE_URL must be a valid URL")
```
- Manages all application settings
- Validates environment variables
- Provides type-safe configuration access

#### Environment Validation (`core/env_validator.py`)
```python
class EnvironmentValidator(BaseModel):
    SUPABASE_URL: AnyHttpUrl
    SUPABASE_KEY: SecretStr
    ENV: str
```
- Validates environment configuration
- Ensures required variables exist
- Provides detailed error messages

### 3. Application Registry System

#### Feature Management (`core/apps.py`)
```python
class AppFeature(str, Enum):
    AUTH = "auth"
    PAYMENTS = "payments"
    SCHEDULING = "scheduling"
    MARKETPLACE = "marketplace"
    VIDEOCONFERENCE = "videoconference"

class AppConfig(BaseModel):
    id: str
    name: str
    features: List[AppFeature]
    database_schema: str
    api_prefix: str
    cors_origins: List[str]
```
- Defines available features
- Configures application-specific settings
- Manages feature flags

#### Application Settings (`core/app_settings.py`)
```python
class AppSettings(BaseModel):
    theme: Dict[str, str]
    features: Dict[AppFeature, bool]
    api_version: str
    max_users: int
    storage_limit: int

APP_SETTINGS: Dict[str, AppSettings] = {
    "app1": AppSettings(...),
    "app2": AppSettings(...)
}
```
- Stores app-specific configurations
- Manages feature toggles
- Defines app limitations

### 4. Service Layer Architecture

#### Base Mixin System (`core/mixins/base.py`)
```python
class MixinMeta(type):
    """Metaclass for handling mixin composition"""
    def __new__(mcs, name: str, bases: tuple, namespace: dict) -> Type:
        for base in bases:
            for key, value in base.__dict__.items():
                if not key.startswith("__"):
                    if key not in namespace:
                        namespace[key] = value
        return super().__new__(mcs, name, bases, namespace)

class BaseMixin:
    __metaclass__ = MixinMeta
```
- Provides mixin composition functionality
- Enables modular service features
- Manages method resolution

#### Service Mixins (`core/mixins/service_mixins.py`)
```python
class CacheMixin:
    _cache = RedisCache()
    
    async def get_cached(self, key: str) -> Optional[Any]:
        return await self._cache.get(key)

class AuditMixin:
    async def log_action(self, action: str, user_id: str, details: Dict[str, Any], app_id: str):
        await self.audit_logger.info(...)

class ValidationMixin:
    async def validate_entity(self, data: Dict[str, Any], schema: Any):
        schema(**data)

class VersioningMixin:
    async def create_version(self, entity_type: str, entity_id: str, data: Dict[str, Any]):
        version = {...}
        await self.versions_repository.create(version)
```
- Provides reusable service functionality
- Handles cross-cutting concerns
- Enables feature composition

### 5. Dependency Injection System

#### Core Dependencies (`core/deps.py`)
```python
async def get_current_app() -> AppConfig:
    app = AppRegistry.get_current_app()
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")
    return app

async def require_feature(feature: str, app: AppConfig = Depends(get_current_app)):
    if not AppRegistry.has_feature(feature):
        raise HTTPException(status_code=403)
```
- Provides dependency injection
- Manages application context
- Handles feature requirements

#### Feature Dependencies (`core/dependencies.py`)
```python
def require_feature(feature_name: str) -> Callable:
    def check_feature() -> bool:
        enabled = settings.APPS_ENABLED.get(feature_name, False)
        if not enabled:
            raise HTTPException(status_code=404)
        return True
    return check_feature
```
- Manages feature-based access control
- Provides feature toggle functionality
- Enables conditional routing

### 6. Authentication System (`core/auth.py`)
```python
async def get_current_user(token: str = Depends(security)):
    try:
        client = SupabaseDB.get_client()
        user = client.auth.get_user(token.credentials)
        return user
    except Exception:
        raise HTTPException(status_code=401)
```
- Handles user authentication
- Integrates with Supabase
- Provides user context

## Application Flow

1. **Startup Sequence**
   - Load environment variables
   - Validate environment configuration
   - Initialize FastAPI application
   - Register applications and features
   - Set up middleware chain
   - Mount routers

2. **Request Processing**
   - Validate request
   - Set application context
   - Check feature availability
   - Process through middleware
   - Handle authentication
   - Route to endpoint
   - Return response

3. **Feature Management**
   - Check feature flags
   - Validate permissions
   - Apply app-specific settings
   - Handle cross-cutting concerns

## Best Practices

1. **Adding New Features**
   - Add feature to AppFeature enum
   - Update app settings
   - Create necessary mixins
   - Implement feature routes
   - Add feature dependencies

2. **Service Implementation**
   - Use appropriate mixins
   - Implement validation
   - Add audit logging
   - Handle caching
   - Version important changes

3. **Security Considerations**
   - Validate all inputs
   - Check feature access
   - Verify authentication
   - Audit sensitive operations
   - Handle errors appropriately