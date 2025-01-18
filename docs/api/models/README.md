# API Models Documentation

## Overview
This document describes all data models used in the API.

## User Model

### Properties
```typescript
interface User {
  id: string;          // UUID
  email: string;       // Email address
  name: string;        // Full name
  created_at: string;  // ISO datetime
  updated_at: string;  // ISO datetime
  is_active: boolean;  // Account status
}
```

### Validation Rules
- email: Must be a valid email address
- name: 2-100 characters
- password: Minimum 8 characters, requires numbers and special characters

## Authentication Models

### LoginRequest
```typescript
interface LoginRequest {
  email: string;
  password: string;
}
```

### LoginResponse
```typescript
interface LoginResponse {
  access_token: string;
  token_type: string;
  expires_in: number;
}
```

## Error Models

### APIError
```typescript
interface APIError {
  detail: string;
  code?: string;
  field?: string;
}
```

### ValidationError
```typescript
interface ValidationError {
  detail: {
    loc: string[];
    msg: string;
    type: string;
  }[];
} 