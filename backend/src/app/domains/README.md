# Domain-Driven Design Structure

Each domain folder contains:
- models.py: Domain models and entities
- schemas.py: Pydantic schemas for API
- service.py: Business logic
- repository.py: Data access layer
- exceptions.py: Domain-specific exceptions
- routes.py: API endpoints

Example domains:
- user
- auth
- product
- order 