# Backend Project Structure

## Overview
The backend follows a domain-driven design with clear separation of concerns. The structure is organized to support scalability, maintainability, and testability.

## Directory Organization
- `src/app/` - Main application code
  - `api/` - API routes and endpoints
    - Handles HTTP request/response
    - Route definitions and handlers
    - Input validation
  - `core/` - Core functionality and config
    - Application configuration
    - Logging setup
    - Environment validation
    - Base classes and mixins
  - `domains/` - Domain-specific logic
    - Business domain implementations
    - Feature-specific routes
    - Domain models and schemas
  - `middleware/` - Request/response middleware
    - Authentication
    - Rate limiting
    - Request logging
  - `models/` - Database models
    - SQLAlchemy models
    - Pydantic schemas
    - Type definitions
  - `services/` - Business logic services
    - External service integrations
    - Business logic implementation
    - Data processing
  - `utils/` - Shared utilities
    - Helper functions
    - Common utilities
    - Shared constants

## Key Files
- `src/run.py` - Application entry point
  - Server configuration
  - Environment loading
  - Application startup
- `src/app/main.py` - FastAPI app configuration
  - Middleware setup
  - Route registration
  - Exception handlers
- `src/app/core/config.py` - Environment configuration
  - Environment variables
  - Application settings
  - Feature flags

## Best Practices
1. Keep domains isolated and self-contained
2. Use dependency injection for services
3. Maintain clear separation of concerns
4. Follow consistent naming conventions
5. Document all public interfaces
6. Write tests for all components

## Development Guidelines
1. New features should be added in the appropriate domain
2. Core functionality belongs in core/
3. Shared code goes in utils/
4. Keep services focused and single-purpose
5. Use type hints consistently 