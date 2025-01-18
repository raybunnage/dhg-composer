#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create API documentation structure
mkdir -p docs/api/{endpoints,models,examples}

# Create index file
cat > docs/api/README.md << 'EOL'
# API Documentation

## Overview
This API documentation provides comprehensive information about our FastAPI backend endpoints, data models, and usage examples.

## Structure
- `endpoints/` - Detailed documentation for each API endpoint
- `models/` - Data model specifications and schemas
- `examples/` - Usage examples and code snippets

## Quick Links
- [Endpoints Documentation](endpoints/README.md)
- [Data Models](models/README.md)
- [Usage Examples](examples/README.md)

## Authentication
All API endpoints require authentication using Supabase JWT tokens.
See [Authentication Guide](../backend/authentication/supabase-auth-guide.md) for details.

## Base URL
- Development: `http://localhost:8000`
- Staging: `https://api-staging.yourapp.com`
- Production: `https://api.yourapp.com`
EOL

# Create endpoints index
cat > docs/api/endpoints/README.md << 'EOL'
# API Endpoints

## Authentication Endpoints
- [Login](auth/login.md)
- [Logout](auth/logout.md)
- [Refresh Token](auth/refresh.md)

## User Endpoints
- [Get User Profile](users/get-profile.md)
- [Update User Profile](users/update-profile.md)

## Data Endpoints
- [List Items](data/list-items.md)
- [Get Item Details](data/get-item.md)
- [Create Item](data/create-item.md)
- [Update Item](data/update-item.md)
- [Delete Item](data/delete-item.md)

## Common Response Formats
All endpoints return responses in the following format:
```json
{
    "success": boolean,
    "data": any | null,
    "error": string | null,
    "metadata": {
        "timestamp": string,
        "version": string
    }
}
```
EOL

# Create endpoint template
cat > docs/api/endpoints/template.md << 'EOL'
# Endpoint Name

## Overview
Brief description of what this endpoint does.

## Request
- **Method:** GET/POST/PUT/DELETE
- **URL:** `/api/v1/endpoint-path`
- **Authentication:** Required/Optional

### Headers
```json
{
    "Authorization": "Bearer <jwt_token>",
    "Content-Type": "application/json"
}
```

### Parameters
| Name | Type | Required | Description |
|------|------|----------|-------------|
| param1 | string | Yes | Description of param1 |
| param2 | number | No | Description of param2 |

### Request Body
```json
{
    "field1": "string",
    "field2": 123
}
```

## Response

### Success Response
- **Code:** 200 OK
```json
{
    "success": true,
    "data": {
        "id": "123",
        "name": "Example"
    },
    "error": null,
    "metadata": {
        "timestamp": "2024-03-15T12:00:00Z",
        "version": "1.0.0"
    }
}
```

### Error Responses
- **Code:** 400 Bad Request
```json
{
    "success": false,
    "data": null,
    "error": "Invalid input parameters",
    "metadata": {
        "timestamp": "2024-03-15T12:00:00Z",
        "version": "1.0.0"
    }
}
```

## Examples

### cURL
```bash
curl -X POST \
  'http://localhost:8000/api/v1/endpoint' \
  -H 'Authorization: Bearer <token>' \
  -H 'Content-Type: application/json' \
  -d '{
    "field1": "value1",
    "field2": 123
  }'
```

### TypeScript/JavaScript
```typescript
const response = await fetch('http://localhost:8000/api/v1/endpoint', {
    method: 'POST',
    headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({
        field1: 'value1',
        field2: 123,
    }),
});
const data = await response.json();
```

### Python
```python
import requests

response = requests.post(
    'http://localhost:8000/api/v1/endpoint',
    headers={
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json',
    },
    json={
        'field1': 'value1',
        'field2': 123,
    },
)
data = response.json()
```
EOL

# Create models index
cat > docs/api/models/README.md << 'EOL'
# Data Models

## Overview
This section documents all data models used in the API.

## Models

### User
```typescript
interface User {
    id: string;
    email: string;
    name: string;
    created_at: string;
    updated_at: string;
}
```

### Item
```typescript
interface Item {
    id: string;
    title: string;
    description: string;
    user_id: string;
    created_at: string;
    updated_at: string;
}
```

## Common Types

### Pagination
```typescript
interface PaginationParams {
    page: number;
    limit: number;
}

interface PaginatedResponse<T> {
    items: T[];
    total: number;
    page: number;
    limit: number;
    pages: number;
}
```

### Error
```typescript
interface APIError {
    code: string;
    message: string;
    details?: Record<string, any>;
}
```
EOL

# Create examples index
cat > docs/api/examples/README.md << 'EOL'
# API Usage Examples

## Authentication Flow

### Login and Token Management
```typescript
// Login
const { data: authData } = await api.post('/auth/login', {
    email: 'user@example.com',
    password: 'password123'
});

// Store tokens
localStorage.setItem('access_token', authData.access_token);
localStorage.setItem('refresh_token', authData.refresh_token);

// Use token in requests
const api = axios.create({
    baseURL: 'http://localhost:8000',
    headers: {
        'Authorization': `Bearer ${localStorage.getItem('access_token')}`
    }
});

// Handle token refresh
api.interceptors.response.use(
    response => response,
    async error => {
        if (error.response.status === 401) {
            const { data } = await api.post('/auth/refresh', {
                refresh_token: localStorage.getItem('refresh_token')
            });
            localStorage.setItem('access_token', data.access_token);
            error.config.headers['Authorization'] = `Bearer ${data.access_token}`;
            return api(error.config);
        }
        return Promise.reject(error);
    }
);
```

## Common Operations

### CRUD Operations
```typescript
// List items with pagination
const getItems = async (page = 1, limit = 10) => {
    const { data } = await api.get('/items', {
        params: { page, limit }
    });
    return data;
};

// Get single item
const getItem = async (id: string) => {
    const { data } = await api.get(`/items/${id}`);
    return data;
};

// Create item
const createItem = async (item: CreateItemDTO) => {
    const { data } = await api.post('/items', item);
    return data;
};

// Update item
const updateItem = async (id: string, updates: UpdateItemDTO) => {
    const { data } = await api.put(`/items/${id}`, updates);
    return data;
};

// Delete item
const deleteItem = async (id: string) => {
    await api.delete(`/items/${id}`);
};
```

### Error Handling
```typescript
try {
    const data = await api.get('/items');
    // Handle success
} catch (error) {
    if (error.response) {
        // Handle API error
        console.error(error.response.data.error);
    } else if (error.request) {
        // Handle network error
        console.error('Network error');
    } else {
        // Handle other errors
        console.error('Error:', error.message);
    }
}
```
EOL

echo -e "${GREEN}API documentation structure created successfully!${NC}"
echo -e "\nCreated:"
echo "- docs/api/README.md (API overview)"
echo "- docs/api/endpoints/ (Endpoint documentation)"
echo "- docs/api/models/ (Data models)"
echo "- docs/api/examples/ (Usage examples)"
echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Customize the documentation templates"
echo "2. Add specific endpoint documentation"
echo "3. Update models to match your schema"
echo "4. Add more usage examples" 