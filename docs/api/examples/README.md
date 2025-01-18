# API Usage Examples

## Authentication Examples

### Login
```python
# Python example
import requests

response = requests.post(
    "http://api.example.com/auth/login",
    json={
        "email": "user@example.com",
        "password": "secretpassword"
    }
)
token = response.json()["access_token"]
```

```typescript
// TypeScript example
const login = async (email: string, password: string) => {
  const response = await fetch('http://api.example.com/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ email, password }),
  });
  const data = await response.json();
  return data.access_token;
};
```

## User Management Examples

### Get Current User
```python
# Python example
import requests

headers = {"Authorization": f"Bearer {token}"}
response = requests.get(
    "http://api.example.com/users/me",
    headers=headers
)
user = response.json()
```

```typescript
// TypeScript example
const getCurrentUser = async (token: string) => {
  const response = await fetch('http://api.example.com/users/me', {
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  });
  return await response.json();
};
```

## Error Handling Examples

### Handle API Errors
```typescript
// TypeScript example
const handleAPIRequest = async (url: string, options: RequestInit) => {
  try {
    const response = await fetch(url, options);
    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.detail);
    }
    return await response.json();
  } catch (error) {
    console.error('API Error:', error);
    throw error;
  }
};
```

### Validation Error Handling
```python
# Python example
from fastapi import HTTPException

try:
    response = requests.post(url, json=data)
    response.raise_for_status()
except requests.exceptions.HTTPError as e:
    if e.response.status_code == 422:
        validation_errors = e.response.json()
        print("Validation errors:", validation_errors)
    raise
``` 