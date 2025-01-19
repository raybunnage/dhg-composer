# API Documentation

## Overview

This API provides endpoints for user management and authentication using FastAPI and Supabase.

## Base URL

```
Development: http://localhost:8000/api/v1
Production: https://your-domain.com/api/v1
```

## Authentication

All authenticated endpoints require a Bearer token:
```http
Authorization: Bearer <your_token>
```

## Response Format

All responses follow this structure:
```json
{
    "data": {
        // Response data here
    },
    "error": null,  // or error message if failed
    "status": 200   // HTTP status code
}
```

## Rate Limiting

- Default: 100 requests per minute
- Auth endpoints: 10 requests per minute
- Exceeded limits return 429 Too Many Requests

## Common Error Codes

- 400: Bad Request - Invalid input
- 401: Unauthorized - Missing or invalid token
- 403: Forbidden - Insufficient permissions
- 404: Not Found - Resource doesn't exist
- 422: Validation Error - Invalid data format
- 429: Too Many Requests - Rate limit exceeded
- 500: Internal Server Error - Server-side error
