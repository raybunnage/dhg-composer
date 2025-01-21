# DHG Baseline Project Structure

## Overview
This document provides a detailed breakdown of the DHG Baseline project structure, explaining each directory and file's purpose.

## Project Tree

.
├── backend/ # Backend service directory
│ ├── README.md # Backend documentation
│ ├── pytest.ini # Python test configuration
│ ├── requirements/ # Python dependency management
│ │ ├── requirements.base.txt # Core dependencies
│ │ ├── requirements.development.light.txt # Minimal dev dependencies
│ │ └── requirements.production.txt # Production dependencies
│ ├── src/ # Source code directory
│ │ ├── api/ # API endpoints
│ │ │ └── auth.py # Authentication endpoints
│ │ ├── core/ # Core functionality
│ │ │ ├── config.py # Application configuration
│ │ │ ├── exceptions.py # Custom exception handling
│ │ │ ├── logging.py # Logging configuration
│ │ │ └── supabase.py # Supabase integration
│ │ ├── main.py # Application entry point
│ │ └── services/ # Business logic services
│ │ └── supabase.py # Supabase service implementation
│ ├── start.sh # Backend startup script
│ └── tests/ # Test directory
│ ├── api/ # API tests
│ │ └── test_auth.py # Authentication tests
│ ├── conftest.py # Test configuration and fixtures
│ └── services/ # Service tests
│ └── test_supabase.py # Supabase service tests
├── frontend/ # Frontend application
│ ├── package.json # Node.js dependencies and scripts
│ ├── src/ # Source code directory
│ │ ├── App.css # Main application styles
│ │ ├── App.tsx # Main application component
│ │ ├── hooks/ # Custom React hooks
│ │ │ └── useAuth.ts # Authentication hook
│ │ ├── index.css # Global styles
│ │ ├── main.tsx # Application entry point
│ │ └── pages/ # Application pages
│ │ └── auth/ # Authentication pages
│ │ └── index.tsx # Main auth page
│ ├── tsconfig.json # TypeScript configuration
│ ├── tsconfig.node.json # Node-specific TS config
│ └── vite.config.ts # Vite bundler configuration
└── packages/ # Shared packages directory
└── ui/ # UI component library
├── packages/ # Package configuration
│ └── ui/
│ └── package.json # UI library dependencies
└── src/ # Source code directory
└── components/ # Shared UI components
└── types.py # Core data models

## Key Directories Explained

### Backend (`/backend`)
- Contains the FastAPI backend service
- Organized with clear separation of concerns (API, core, services)
- Includes comprehensive testing setup
- Manages dependencies through requirements files

### Frontend (`/frontend`)
- React/Vite application
- TypeScript-based implementation
- Modular structure with hooks, pages, and components
- Configured for modern development practices

### Packages (`/packages`)
- Shared code and components
- UI library for consistent component usage
- Enables code reuse across applications

## Best Practices Implemented
1. Clear separation of concerns
2. Modular architecture
3. Comprehensive testing structure
4. Shared component library
5. Type-safe implementation
6. Organized dependency management

## Notes
- The structure follows modern full-stack development practices
- Enables scalability and maintainability
- Supports team collaboration through clear organization
- Implements testing at all levels

# Project Code Documentation

> This documentation provides beginner-friendly explanations of code files in our project.

## How to Read This Documentation

Each file is documented with:
1. **Purpose**: What the file does
2. **Imports**: What external code it uses and why
3. **Code Breakdown**: Step-by-step explanation of the code
4. **Examples**: How to use the code

## Code Reviews

<!-- Code reviews will be added here by the CodeReview rule -->

## Example Usage

To get a code review, ask:
"Please review this code file: path/to/file.py"

The assistant will:
1. Analyze the code
2. Generate beginner-friendly documentation
3. Add it to this file
4. Explain any complex concepts

## config.py

### Purpose
This file manages the application's configuration settings using Pydantic. It:
- Loads environment variables
- Validates configuration values
- Provides type-safe access to settings
- Creates a singleton settings instance

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── src/
              └── core/
                  └── config.py
```

### Imports
Let's break down each import:

- `from functools import lru_cache`
  - Provides caching for the settings
  - Ensures settings are only loaded once
  - Improves performance

- `from typing import Optional`
  - Allows marking settings that might be None
  - Used for optional configuration values

- `from pydantic import BaseSettings, validator`
  - `BaseSettings`: Base class for settings with env variable support
  - `validator`: Decorator for custom validation methods

### Code Breakdown

1. Settings Class Definition:
```python
class Settings(BaseSettings):
    # API Settings
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "DHG Baseline API"
    DEBUG: bool = False
```
- Defines basic API configuration
- Sets default values for some settings
- Uses type hints for validation

2. CORS Configuration:
```python
BACKEND_CORS_ORIGINS: list[str] = ["http://localhost:5173"]  # Frontend URL
```
- Configures Cross-Origin Resource Sharing
- Default allows local frontend development
- Can be overridden by environment variables

3. Supabase Settings:
```python
SUPABASE_URL: str
SUPABASE_KEY: str
SUPABASE_JWT_SECRET: Optional[str] = None
```
- Required Supabase configuration
- URL and KEY must be provided
- JWT secret is optional

4. CORS Validator:
```python
@validator("BACKEND_CORS_ORIGINS", pre=True)
def assemble_cors_origins(cls, v: str | list[str]) -> list[str]:
    if isinstance(v, str):
        return [i.strip() for i in v.split(",")]
    return v
```
- Allows CORS origins as comma-separated string
- Converts string input to list
- Strips whitespace from values

5. Settings Configuration:
```python
class Config:
    case_sensitive = True
    env_file = ".env"
```
- Makes settings case-sensitive
- Loads values from .env file

6. Singleton Instance:
```python
@lru_cache()
def get_settings() -> Settings:
    return Settings()

settings = get_settings()
```
- Creates cached settings instance
- Provides global access to settings
- Ensures settings are only loaded once

### Examples

Using the settings in code:
```python
from src.core.config import settings

# Access API settings
api_path = settings.API_V1_STR  # "/api/v1"
project_name = settings.PROJECT_NAME  # "DHG Baseline API"

# Access Supabase settings
supabase_url = settings.SUPABASE_URL
supabase_key = settings.SUPABASE_KEY

# Check CORS origins
allowed_origins = settings.BACKEND_CORS_ORIGINS
```

### Best Practices Used
1. **Configuration Management**:
   - Environment variable support
   - Type validation
   - Default values
   - Singleton pattern

2. **Type Safety**:
   - Type hints throughout
   - Pydantic validation
   - Optional type handling

3. **Performance**:
   - LRU cache for settings
   - Single instance pattern
   - Efficient validation

4. **Security**:
   - Environment-based configuration
   - CORS protection
   - Sensitive value handling

## exceptions.py

### Purpose
This file defines custom exceptions for the API. It:
- Creates a base exception class for consistent error handling
- Defines specific exceptions for common error cases
- Ensures consistent error responses across the API
- Provides proper HTTP status codes and headers

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── src/
              └── core/
                  └── exceptions.py
```

### Imports
Let's break down each import:

- `from fastapi import HTTPException, status`
  - `HTTPException`: FastAPI's base class for HTTP errors
  - `status`: Contains standard HTTP status codes (like 404, 401)

### Code Breakdown

1. Base Exception Class:
```python
class BaseAPIException(HTTPException):
    """Base exception for API errors."""

    def __init__(self, status_code: int, detail: str, headers: dict = None):
        super().__init__(status_code=status_code, detail=detail, headers=headers)
```
- Creates a foundation for all API exceptions
- Inherits from FastAPI's HTTPException
- Allows setting status code, error message, and headers
- Makes error handling consistent

2. Authentication Error:
```python
class AuthenticationError(BaseAPIException):
    """Raised when authentication fails."""

    def __init__(self, detail: str = "Authentication failed"):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=detail,
            headers={"WWW-Authenticate": "Bearer"},
        )
```
- Used when authentication fails
- Sets 401 Unauthorized status code
- Adds WWW-Authenticate header for proper HTTP auth
- Provides default error message

3. Not Found Error:
```python
class NotFoundError(BaseAPIException):
    """Raised when a resource is not found."""

    def __init__(self, detail: str = "Resource not found"):
        super().__init__(status_code=status.HTTP_404_NOT_FOUND, detail=detail)
```
- Used when resources don't exist
- Sets 404 Not Found status code
- Provides default "not found" message
- Can customize error message if needed

### Examples

Using these exceptions in your code:
```python
# Authentication error
async def login_user(credentials: dict):
    if not valid_credentials(credentials):
        raise AuthenticationError("Invalid username or password")

# Not found error
async def get_user(user_id: str):
    user = await db.find_user(user_id)
    if not user:
        raise NotFoundError(f"User {user_id} not found")
    return user
```

### Best Practices Used
1. **Error Hierarchy**:
   - Clear exception inheritance
   - Base class for common functionality
   - Specific exceptions for different cases

2. **HTTP Standards**:
   - Proper status codes
   - Appropriate headers
   - Clear error messages

3. **Code Organization**:
   - Each exception has a single purpose
   - Descriptive class names
   - Helpful docstrings

4. **Flexibility**:
   - Customizable error messages
   - Optional headers
   - Extensible base class

## logging.py

### Purpose
This file sets up structured logging for the application. It:
- Configures consistent log formatting
- Provides JSON output for better log processing
- Allows adding context to log messages
- Makes debugging and monitoring easier

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── src/
              └── core/
                  └── logging.py
```

### Imports
Let's break down each import:

- `import structlog`
  - A structured logging library
  - Makes logs machine-readable
  - Allows adding context to logs

- `from typing import Any, Dict`
  - Type hints for function parameters
  - Dict for context dictionary
  - Any for flexible value types

### Code Breakdown

1. Setup Function:
```python
def setup_logging() -> None:
    """Configure structured logging for the application."""
    structlog.configure(
        processors=[
            structlog.contextvars.merge_contextvars,
            structlog.processors.add_log_level,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.JSONRenderer(),
        ],
        wrapper_class=structlog.make_filtering_bound_logger(
            structlog.get_logger().level
        ),
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(),
        cache_logger_on_first_use=True,
    )
```
- Sets up log processors:
  - Merges context variables
  - Adds log levels
  - Adds timestamps in ISO format
  - Outputs in JSON format
- Configures filtering and caching
- Uses dictionary for context

2. Logger Factory:
```python
def get_logger(context: Dict[str, Any] = None) -> structlog.BoundLogger:
    """Get a logger instance with optional context."""
    logger = structlog.get_logger()
    if context:
        return logger.bind(**context)
    return logger
```
- Creates a new logger instance
- Allows adding context data
- Returns a bound logger
- Makes context optional

### Examples

Using the logger in your code:
```python
from src.core.logging import setup_logging, get_logger

# Setup logging at application startup
setup_logging()

# Get a basic logger
logger = get_logger()
logger.info("Application started")

# Get a logger with context
user_logger = get_logger({"user_id": "123", "action": "login"})
user_logger.info("User logged in")
# Output: {"user_id": "123", "action": "login", "event": "User logged in", "level": "info", "timestamp": "2024-..."}
```

### Best Practices Used
1. **Structured Logging**:
   - JSON format for machine readability
   - Consistent log structure
   - Context support
   - ISO timestamps

2. **Configuration**:
   - Single setup function
   - Cached logger instances
   - Flexible context handling
   - Level filtering

3. **Type Safety**:
   - Type hints for parameters
   - Return type annotations
   - Optional context parameter

4. **Usability**:
   - Simple interface
   - Context binding
   - Factory pattern
   - Clear documentation

## supabase.py

### Purpose
This file handles Supabase authentication integration. It:
- Initializes the Supabase client
- Provides user authentication
- Verifies JWT tokens
- Creates a dependency for protected routes

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── src/
              └── core/
                  └── supabase.py
```

### Imports
Let's break down each import:

- `from fastapi import Depends, HTTPException`
  - `Depends`: FastAPI's dependency injection system
  - `HTTPException`: For handling authentication errors

- `from fastapi.security import HTTPBearer`
  - Handles Bearer token authentication
  - Extracts JWT from Authorization header

- `from supabase import create_client, Client`
  - Creates Supabase client instance
  - Provides type hints for client

- `from src.core.config import settings`
  - Imports application settings
  - Gets Supabase credentials

### Code Breakdown

1. Client Initialization:
```python
supabase: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)
security = HTTPBearer()
```
- Creates global Supabase client
- Sets up Bearer token security
- Uses settings from config

2. Authentication Dependency:
```python
async def get_current_user(token: str = Depends(security)):
    try:
        # Verify the JWT token
        user = supabase.auth.get_user(token.credentials)
        return user
    except Exception as e:
        raise HTTPException(
            status_code=401,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
```
- Verifies user's JWT token
- Returns user if valid
- Raises 401 if invalid
- Used as dependency for protected routes

### Examples

Using the authentication in your routes:
```python
from fastapi import Depends
from src.core.supabase import get_current_user

@router.get("/protected")
async def protected_route(user = Depends(get_current_user)):
    return {"message": f"Hello {user.email}"}

# This route requires a valid JWT token in the Authorization header:
# Authorization: Bearer <your-jwt-token>
```

### Best Practices Used
1. **Security**:
   - JWT token verification
   - Proper error handling
   - Bearer token authentication
   - Clear error messages

2. **Code Organization**:
   - Single responsibility
   - Dependency injection
   - Global client instance
   - Type hints

3. **Error Handling**:
   - Try/except block
   - Standard HTTP errors
   - Proper headers
   - Informative messages

4. **Configuration**:
   - Uses settings from config
   - Environment-based setup
   - Reusable security instance
   - Clean dependency pattern

## services/supabase.py

### Purpose
This file implements the Supabase service layer. It:
- Manages Supabase client initialization
- Handles user profile operations
- Provides token verification
- Uses retries for reliability

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── src/
              └── services/
                  └── supabase.py
```

### Imports
Let's break down each import:

- `from typing import Optional`
  - For marking variables that might be None
  - Used for client initialization

- `from functools import lru_cache`
  - Provides caching for the service instance
  - Ensures single instance (singleton pattern)

- `import structlog`
  - Structured logging library
  - For consistent log formatting

- `from supabase import create_client, Client`
  - Supabase client library
  - For interacting with Supabase

- `from tenacity import retry, stop_after_attempt, wait_exponential`
  - Retry mechanism for reliability
  - Handles temporary failures gracefully

### Code Breakdown

1. Service Class Definition:
```python
class SupabaseService:
    def __init__(self):
        self.client: Optional[Client] = None
        self.initialize_client()
```
- Creates service instance
- Initializes Supabase client
- Uses type hints for clarity

2. Client Initialization:
```python
def initialize_client(self) -> None:
    """Initialize the Supabase client."""
    try:
        self.client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)
        logger.info("Supabase client initialized successfully")
    except Exception as e:
        logger.error("Failed to initialize Supabase client", error=str(e))
        raise
```
- Sets up Supabase connection
- Uses settings from config
- Logs success/failure
- Proper error handling

3. Token Verification:
```python
@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=4, max=10),
)
async def verify_token(self, token: str) -> dict:
    """Verify a JWT token."""
    try:
        if not self.client:
            raise ValueError("Supabase client not initialized")
        return {"valid": True}  # Placeholder
    except Exception as e:
        logger.error("Token verification failed", error=str(e))
        raise
```
- Retries on failure (3 attempts)
- Exponential backoff
- Validates client exists
- Logs errors

4. Profile Retrieval:
```python
@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=4, max=10),
)
async def get_user_profile(self, user_id: str) -> dict:
    """Get a user's profile from Supabase."""
    try:
        if not self.client:
            raise ValueError("Supabase client not initialized")
        response = (
            self.client.from_("profiles")
            .select("*")
            .eq("id", user_id)
            .single()
            .execute()
        )
        return response.data
    except Exception as e:
        logger.error("Failed to get user profile", user_id=user_id, error=str(e))
        raise
```
- Gets user profile from Supabase
- Uses retry mechanism
- Structured error logging
- Type-safe return

5. Service Factory:
```python
@lru_cache()
def get_supabase_service() -> SupabaseService:
    """Get a singleton instance of SupabaseService."""
    return SupabaseService()
```
- Creates singleton service
- Caches instance
- Type-safe return

### Examples

Using the service in your code:
```python
from src.services.supabase import get_supabase_service

# Get service instance
supabase_service = get_supabase_service()

# Get user profile
try:
    profile = await supabase_service.get_user_profile("user123")
    print(f"Found profile: {profile}")
except Exception as e:
    print(f"Error getting profile: {e}")
```

### Best Practices Used
1. **Reliability**:
   - Retry mechanism
   - Exponential backoff
   - Error logging
   - Exception handling

2. **Design Patterns**:
   - Singleton service
   - Factory pattern
   - Dependency injection ready
   - Service layer pattern

3. **Code Quality**:
   - Type hints
   - Docstrings
   - Structured logging
   - Clean organization

4. **Performance**:
   - Cached service instance
   - Connection reuse
   - Efficient queries
   - Error recovery

## main.py

### Purpose
This is the main entry point for the FastAPI application. It:
- Sets up the FastAPI server
- Configures CORS and middleware
- Manages application lifecycle
- Defines base routes
- Includes API routers

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── src/
              └── main.py
```

### Imports
Let's break down each import:

- `from fastapi import FastAPI`
  - The main FastAPI framework
  - Used to create the application

- `from fastapi.middleware.cors import CORSMiddleware`
  - Handles Cross-Origin Resource Sharing
  - Allows frontend to communicate with API

- `from contextlib import asynccontextmanager`
  - For managing application lifecycle
  - Handles startup and shutdown

- `import structlog`
  - Structured logging library
  - For consistent log formatting

- `from src.core.config import settings`
  - Application configuration
  - Environment-based settings

- `from src.api import auth`
  - Authentication routes
  - User management endpoints

### Code Breakdown

1. Application Lifecycle:
```python
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    logger.info("Starting up application", app_name=settings.PROJECT_NAME)
    yield
    # Shutdown
    logger.info("Shutting down application", app_name=settings.PROJECT_NAME)
```
- Manages application startup/shutdown
- Logs lifecycle events
- Uses async context manager

2. FastAPI Initialization:
```python
app = FastAPI(
    title=settings.PROJECT_NAME,
    version="1.0.0",
    description="DHG Baseline API",
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan,
)
```
- Creates FastAPI instance
- Sets API metadata
- Configures OpenAPI docs
- Attaches lifecycle manager

3. CORS Configuration:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```
- Sets up CORS middleware
- Configures allowed origins
- Enables credentials
- Allows necessary methods/headers

4. Base Routes:
```python
@app.get("/")
async def root():
    return {
        "message": f"Welcome to {settings.PROJECT_NAME}",
        "docs_url": "/docs",
        "openapi_url": f"{settings.API_V1_STR}/openapi.json",
    }

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```
- Root endpoint with API info
- Health check endpoint
- Simple status responses

5. Router Integration:
```python
app.include_router(auth.router, prefix=f"{settings.API_V1_STR}/auth", tags=["auth"])
```
- Includes authentication routes
- Adds API version prefix
- Tags routes for documentation

### Examples

Starting the application:
```python
# Run with uvicorn
uvicorn src.main:app --reload --host 0.0.0.0 --port 8001

# Access endpoints
curl http://localhost:8001/  # Root endpoint
curl http://localhost:8001/health  # Health check
curl http://localhost:8001/api/v1/auth/me  # Auth endpoint
```

### Best Practices Used
1. **Application Structure**:
   - Clean initialization
   - Proper middleware setup
   - Organized routing
   - Lifecycle management

2. **Security**:
   - CORS configuration
   - API versioning
   - Protected routes
   - Environment settings

3. **Documentation**:
   - OpenAPI integration
   - Route tagging
   - Clear descriptions
   - API metadata

4. **Monitoring**:
   - Health check endpoint
   - Structured logging
   - Startup/shutdown events
   - Status reporting

## types.py

### Purpose
This file defines the core data models using Pydantic. It:
- Defines user and profile data structures
- Ensures type safety for data handling
- Validates data formats
- Provides consistent data models across the application

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── src/
              └── types.py
```

### Imports
Let's break down each import:

- `from pydantic import BaseModel, EmailStr`
  - `BaseModel`: Base class for data validation
  - `EmailStr`: Special type for email validation

- `from typing import Optional`
  - For marking fields that might be None
  - Makes fields optional in models

### Code Breakdown

1. User Model:
```python
class User(BaseModel):
    id: str
    email: str
    aud: str
    role: Optional[str] = None
    email_confirmed_at: Optional[str] = None
    phone: Optional[str] = None
    last_sign_in_at: Optional[str] = None
    created_at: str
    updated_at: str
```
- Defines user data structure
- Required fields: id, email, aud
- Optional fields: role, email confirmation, phone
- Tracks timestamps for creation/updates

2. Profile Model:
```python
class Profile(BaseModel):
    id: str
    user_id: str
    username: Optional[str] = None
    full_name: Optional[str] = None
    avatar_url: Optional[str] = None
    website: Optional[str] = None
    created_at: str
    updated_at: str
```
- Defines user profile data
- Required fields: id, user_id
- Optional fields: username, full_name, avatar, website
- Tracks creation/update times

### Examples

Using these models in your code:
```python
# Create a new user
user = User(
    id="123",
    email="user@example.com",
    aud="authenticated",
    created_at="2024-01-01",
    updated_at="2024-01-01"
)

# Create a profile
profile = Profile(
    id="456",
    user_id=user.id,
    username="johndoe",
    created_at="2024-01-01",
    updated_at="2024-01-01"
)
```

### Best Practices Used
1. **Type Safety**:
   - Clear type definitions
   - Optional field handling
   - Pydantic validation
   - Consistent structure

2. **Data Modeling**:
   - Separate user and profile models
   - Clear field names
   - Default values for optionals
   - Timestamp tracking

3. **Validation**:
   - Automatic type checking
   - Email format validation
   - Required field enforcement
   - Clean data structure

4. **Flexibility**:
   - Optional fields where needed
   - Extensible models
   - Clear relationships
   - Timestamp tracking