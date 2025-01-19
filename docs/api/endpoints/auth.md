# Authentication Endpoints

## Login

Authenticate a user and get an access token.

```http
POST /api/v1/auth/login
```

### Request Body

```json
{
    "email": "user@example.com",
    "password": "yourpassword"
}
```

### Response

```json
{
    "data": {
        "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
        "token_type": "bearer",
        "expires_in": 3600
    },
    "error": null,
    "status": 200
}
```

## Refresh Token

Get a new access token using a refresh token.

```http
POST /api/v1/auth/refresh
```

### Headers
```http
Authorization: Bearer <refresh_token>
```

### Response

```json
{
    "data": {
        "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
        "token_type": "bearer",
        "expires_in": 3600
    },
    "error": null,
    "status": 200
}
```

## Logout

Invalidate the current session.

```http
POST /api/v1/auth/logout
```

### Headers
```http
Authorization: Bearer <token>
```

### Response

```json
{
    "data": {
        "message": "Successfully logged out"
    },
    "error": null,
    "status": 200
}
``` 