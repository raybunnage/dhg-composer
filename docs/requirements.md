# Project Dependencies Documentation

## Backend Dependencies

### FastAPI (fastapi==0.109.1)
- **Purpose**: Modern, fast web framework for building APIs with Python
- **Features**:
  - Automatic API documentation
  - Type checking with Pydantic
  - Async support
  - High performance
- **Usage**: Used as our main backend framework for creating API endpoints

### Uvicorn (uvicorn==0.27.0)
- **Purpose**: Lightweight ASGI server implementation
- **Features**:
  - Supports async Python
  - Hot reloading for development
  - High performance
- **Usage**: Runs our FastAPI application

### Python-dotenv (python-dotenv==1.0.0)
- **Purpose**: Loads environment variables from .env files
- **Features**:
  - Secure configuration management
  - Environment-specific settings
- **Usage**: Manages our Supabase credentials and other sensitive data

### Supabase (supabase==2.3.1)
- **Purpose**: Python client for Supabase
- **Features**:
  - Database operations
  - Authentication
  - Real-time subscriptions
- **Usage**: Connects our backend to Supabase database

### Pydantic (pydantic==2.6.1)
- **Purpose**: Data validation using Python type annotations
- **Features**:
  - Type checking
  - Data serialization
  - Configuration management
- **Usage**: Validates data structures in FastAPI

### HTTPX (httpx==0.24.1)
- **Purpose**: HTTP client for Python
- **Features**:
  - Async support
  - Modern Python features
  - Similar to requests library
- **Usage**: Used by Supabase client for HTTP communications

## Frontend Dependencies

### React + Vite
- **Purpose**: Frontend framework and build tool
- **Features**:
  - Component-based UI
  - Fast refresh
  - TypeScript support
- **Usage**: Main frontend framework

### Supabase JS Client (@supabase/supabase-js)
- **Purpose**: JavaScript client for Supabase
- **Features**:
  - Database operations
  - Real-time subscriptions
  - Authentication
- **Usage**: Frontend connection to Supabase

### TypeScript
- **Purpose**: Typed JavaScript
- **Features**:
  - Static typing
  - Better IDE support
  - Catch errors early
- **Usage**: Main programming language for frontend 