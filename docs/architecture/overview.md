# Project Architecture Overview

> **Note**: This project uses a monorepo pattern for code organization. Previous documentation referring to a multi-app approach has been archived and is no longer relevant.

## Monorepo Structure

Our monorepo organizes code into:

- `apps/` - Individual applications
- `packages/` - Shared code and utilities
- `scripts/` - Development and deployment tools
- `docs/` - Project documentation

This structure allows us to:
- Share code efficiently between applications
- Maintain consistent tooling and configurations
- Simplify dependency management
- Coordinate changes across multiple packages

## System Architecture

```mermaid
graph TB
    Client[Client Applications] --> API[FastAPI Backend]
    API --> Supabase[(Supabase)]
    API --> Cache[(Redis Cache)]
    
    subgraph Backend Services
        API --> UserService[User Service]
        API --> AuthService[Auth Service]
        UserService --> Supabase
        AuthService --> Supabase
    end
```

## Key Components

### 1. Frontend (React + Vite)
- Single Page Application (SPA)
- TypeScript for type safety
- Component-based architecture
- State management with Zustand
- API integration with React Query

### 2. Backend (FastAPI)
- Domain-driven design
- Async request handling
- Middleware for authentication and rate limiting
- Comprehensive error handling
- API documentation with OpenAPI

### 3. Database (Supabase)
- PostgreSQL database
- Row Level Security (RLS)
- Real-time subscriptions
- Built-in authentication
- Automated backups

## Security Architecture

- JWT-based authentication
- Role-based access control (RBAC)
- Rate limiting per endpoint
- Input validation at all layers
- Secure password hashing
- HTTPS enforcement 