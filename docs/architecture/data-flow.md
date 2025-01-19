# Data Flow Architecture

## Request Flow

```mermaid
sequenceDiagram
    participant Client
    participant FastAPI
    participant Service
    participant Supabase
    
    Client->>FastAPI: HTTP Request
    FastAPI->>FastAPI: Validate Request
    FastAPI->>Service: Process Request
    Service->>Supabase: Database Query
    Supabase-->>Service: Query Result
    Service-->>FastAPI: Processed Result
    FastAPI-->>Client: HTTP Response
```

## Error Handling Flow

```mermaid
sequenceDiagram
    participant Client
    participant FastAPI
    participant ErrorHandler
    participant Service
    
    Client->>FastAPI: Invalid Request
    FastAPI->>ErrorHandler: Handle Error
    ErrorHandler->>Service: Log Error
    ErrorHandler-->>Client: Error Response
```

## Data Validation Flow

1. **Request Validation**
   - HTTP request validation
   - Schema validation
   - Type checking

2. **Business Validation**
   - Business rule checking
   - State validation
   - Permission checking

3. **Response Validation**
   - Output schema validation
   - Response formatting
   - Error wrapping 