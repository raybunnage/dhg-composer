# Project Structure

## Backend Structure
```
backend/
├── src/
│   ├── app/
│   │   ├── api/
│   │   │   ├── routes/
│   │   │   └── docs/
│   │   ├── core/
│   │   │   ├── config.py
│   │   │   └── security.py
│   │   ├── domains/
│   │   │   ├── user/
│   │   │   ├── auth/
│   │   │   └── product/
│   │   └── main.py
│   └── tests/
│       ├── factories/
│       ├── api/
│       └── domains/
```

## Key Components

### Domains
Each domain represents a distinct business capability and contains:
- Models: Database models
- Schemas: API schemas
- Services: Business logic
- Repositories: Data access
- Routes: API endpoints

### Configuration
- Environment-based configuration
- Validation using Pydantic
- Secure secret management

### Testing
- Factory-based test data generation
- API contract testing
- Domain-specific test suites 