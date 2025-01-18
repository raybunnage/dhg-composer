# API Endpoints Documentation

## Overview
This document details all available API endpoints, their methods, parameters, and responses.

## Authentication Endpoints

### POST /auth/login
Authenticates a user and returns a JWT token.

**Request Body:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "access_token": "string",
  "token_type": "bearer"
}
```

### POST /auth/register
Registers a new user.

**Request Body:**
```json
{
  "email": "string",
  "password": "string",
  "name": "string"
}
```

## User Endpoints

### GET /users/me
Returns the current user's profile.

**Headers:**
- Authorization: Bearer {token}

**Response:**
```json
{
  "id": "string",
  "email": "string",
  "name": "string",
  "created_at": "datetime"
}
```

### PUT /users/me
Updates the current user's profile.

**Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "name": "string",
  "email": "string"
}
```

## Error Responses
All endpoints may return these error responses:

```json
{
  "detail": "Error message"
}
```

Status codes:
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 500: Internal Server Error 