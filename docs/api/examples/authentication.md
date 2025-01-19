# Authentication Examples

## User Login Flow

### 1. Login Request

```python
import requests

def login(email: str, password: str) -> dict:
    response = requests.post(
        "http://localhost:8000/api/v1/auth/login",
        json={
            "email": email,
            "password": password
        }
    )
    return response.json()

# Example usage
result = login("user@example.com", "password123")
token = result["data"]["access_token"]
```

### 2. Using the Token

```python
def get_user_profile(token: str) -> dict:
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(
        "http://localhost:8000/api/v1/users/me",
        headers=headers
    )
    return response.json()

# Example usage
profile = get_user_profile(token)
print(f"Welcome, {profile['data']['full_name']}!")
```

## Error Handling

```python
def safe_request(func):
    def wrapper(*args, **kwargs):
        try:
            response = func(*args, **kwargs)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 401:
                print("Authentication failed. Please log in again.")
            elif e.response.status_code == 429:
                print("Rate limit exceeded. Please wait before retrying.")
            else:
                print(f"Request failed: {e.response.json()['error']}")
            return None
    return wrapper

@safe_request
def get_protected_resource(token: str):
    headers = {"Authorization": f"Bearer {token}"}
    return requests.get(
        "http://localhost:8000/api/v1/protected-resource",
        headers=headers
    )
``` 