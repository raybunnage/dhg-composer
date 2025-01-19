# User Endpoints

## Create User

Create a new user account.

```http
POST /api/v1/users
```

### Request Body

```json
{
    "email": "user@example.com",
    "full_name": "John Doe",
    "password": "securepassword123"
}
```

### Response

```json
{
    "data": {
        "id": 1,
        "email": "user@example.com",
        "full_name": "John Doe",
        "created_at": "2024-03-20T12:00:00Z"
    },
    "error": null,
    "status": 201
}
```

## Get User Profile

Get the current user's profile.

```http
GET /api/v1/users/me
```

### Headers
```http
Authorization: Bearer <token>
```

### Response

```json
{
    "data": {
        "id": 1,
        "email": "user@example.com",
        "full_name": "John Doe",
        "created_at": "2024-03-20T12:00:00Z"
    },
    "error": null,
    "status": 200
}
```

## List Users

Get a paginated list of users.

```http
GET /api/v1/users?skip=0&limit=10
```

### Query Parameters

- `skip` (optional): Number of records to skip (default: 0)
- `limit` (optional): Maximum number of records to return (default: 100)

### Headers
```http
Authorization: Bearer <token>
```

### Response

```json
{
    "data": [
        {
            "id": 1,
            "email": "user1@example.com",
            "full_name": "User One",
            "created_at": "2024-03-20T12:00:00Z"
        },
        {
            "id": 2,
            "email": "user2@example.com",
            "full_name": "User Two",
            "created_at": "2024-03-20T12:00:00Z"
        }
    ],
    "error": null,
    "status": 200
}
``` 