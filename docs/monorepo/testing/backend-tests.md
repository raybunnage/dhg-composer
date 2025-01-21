## test_auth.py

### Purpose
This test file verifies the authentication endpoints in the API. It tests:
- Token verification
- User profile retrieval
- Current user endpoint
- Error handling for invalid tokens and missing profiles

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── tests/
              └── api/
                  └── test_auth.py
```

### Imports
Let's break down each import:

- `import pytest`
  - Testing framework
  - Provides test runner and assertions

- `from fastapi import HTTPException`
  - Used for testing error cases
  - Simulates API exceptions

- `from fastapi.testclient import TestClient`
  - FastAPI's test client
  - Simulates HTTP requests

- `from unittest.mock import patch`
  - For mocking dependencies
  - Isolates tests from external services

- `from src.main import app`
  - The FastAPI application
  - Used to create test client

- `from packages.supabase_py.src.types import User, Profile`
  - Data models for testing
  - Provides type-safe test data

### Test Cases

1. `test_verify_token_success`:
   - What: Tests successful token verification
   - How: Sends GET request with valid token
   - Asserts: 200 status code and valid=True response
   ```python
   def test_verify_token_success(client, mock_supabase_service):
       response = client.get("/api/v1/auth/verify", 
           headers={"Authorization": "Bearer test-token"})
       assert response.status_code == 200
       assert response.json()["valid"] is True
   ```

2. `test_verify_token_failure`:
   - What: Tests invalid token handling
   - How: Mocks service to raise HTTPException
   - Asserts: 401 status code for invalid token
   ```python
   def test_verify_token_failure(client, mock_supabase_service):
       mock_supabase_service.verify_token.side_effect = HTTPException(
           status_code=401, detail="Invalid token")
       response = client.get("/api/v1/auth/verify", 
           headers={"Authorization": "Bearer invalid-token"})
       assert response.status_code == 401
   ```

3. `test_get_profile_success`:
   - What: Tests profile retrieval
   - How: Sends GET request for user profile
   - Asserts: 200 status code and correct profile data
   ```python
   def test_get_profile_success(client, mock_supabase_service):
       response = client.get("/api/v1/auth/profile/test-user-id",
           headers={"Authorization": "Bearer test-token"})
       assert response.status_code == 200
       assert response.json()["email"] == "test@example.com"
   ```

4. `test_get_profile_not_found`:
   - What: Tests missing profile handling
   - How: Mocks service to return 404
   - Asserts: 404 status code for non-existent profile

5. `test_get_me`:
   - What: Tests current user endpoint
   - How: Mocks current user and verifies response
   - Asserts: User data matches mock data

6. `test_get_profile`:
   - What: Tests full profile endpoint
   - How: Mocks both user and profile data
   - Asserts: Profile data matches mock data

### Fixtures and Mocks

1. `client`:
   - TestClient instance
   - Used for making HTTP requests
   - Provided by FastAPI

2. `mock_supabase_service`:
   - Mocks Supabase service
   - Isolates tests from real Supabase
   - Controls response data

### Examples

Running the tests:
```bash
# Run all auth tests
pytest tests/api/test_auth.py -v

# Run specific test
pytest tests/api/test_auth.py::test_verify_token_success -v

# Run with coverage
pytest tests/api/test_auth.py --cov=src/api/auth
```

### Best Practices Used
1. **Test Organization**:
   - Clear test names
   - Focused test cases
   - Proper mocking
   - Isolated tests

2. **Assertions**:
   - Status code checks
   - Response data validation
   - Error case handling
   - Clear failure messages

3. **Mocking**:
   - External service isolation
   - Controlled test data
   - Error simulation
   - Context managers

4. **Code Quality**:
   - Descriptive docstrings
   - Consistent structure
   - Error case coverage
   - Clean setup/teardown

## test_supabase.py

### Purpose
This test file verifies the Supabase service functionality. It tests:
- Service initialization
- Token verification
- User profile retrieval
- Integration with Supabase client

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── tests/
              └── services/
                  └── test_supabase.py
```

### Imports
Let's break down each import:

- `import pytest`
  - Testing framework
  - Provides test runner and assertions
  - Includes async test support

- `from src.services.supabase import SupabaseService`
  - Service being tested
  - Handles Supabase operations

### Test Cases

1. `test_supabase_service_initialization`:
   ```python
   @pytest.mark.asyncio
   async def test_supabase_service_initialization(test_settings):
       """Test Supabase service initialization."""
       service = SupabaseService()
       assert service.client is not None
   ```
   - What: Tests service initialization
   - How: Creates service instance with test settings
   - Asserts: Client is properly initialized
   - Uses: `test_settings` fixture for configuration

2. `test_verify_token`:
   ```python
   @pytest.mark.asyncio
   async def test_verify_token(mock_supabase_service):
       """Test token verification."""
       result = await mock_supabase_service.verify_token("test-token")
       assert result["valid"] is True
   ```
   - What: Tests token verification
   - How: Calls verify_token with test token
   - Asserts: Token is validated successfully
   - Uses: `mock_supabase_service` fixture

3. `test_get_user_profile`:
   ```python
   @pytest.mark.asyncio
   async def test_get_user_profile(mock_supabase_service):
       """Test user profile retrieval."""
       profile = await mock_supabase_service.get_user_profile("test-user-id")
       assert profile["id"] == "test-user-id"
       assert profile["email"] == "test@example.com"
   ```
   - What: Tests profile retrieval
   - How: Fetches profile with test user ID
   - Asserts: Profile data matches expected values
   - Uses: `mock_supabase_service` fixture

### Fixtures Used

1. `test_settings`:
   - Provides test configuration
   - Sets up test environment
   - Manages test credentials

2. `mock_supabase_service`:
   - Mocks Supabase service
   - Provides test responses
   - Isolates tests from real Supabase

### Examples

Running the tests:
```bash
# Run all Supabase service tests
pytest tests/services/test_supabase.py -v

# Run specific test
pytest tests/services/test_supabase.py::test_verify_token -v

# Run with coverage
pytest tests/services/test_supabase.py --cov=src/services/supabase
```

### Best Practices Used
1. **Async Testing**:
   - Uses pytest.mark.asyncio
   - Proper async/await usage
   - Handles async operations

2. **Test Structure**:
   - Clear test functions
   - Descriptive docstrings
   - Focused assertions
   - Isolated tests

3. **Mocking**:
   - Service mocking
   - Environment isolation
   - Controlled test data
   - Clean setup

4. **Code Quality**:
   - Type hints
   - Error handling
   - Clear assertions
   - Proper fixtures

## conftest.py

### Purpose
This is the main pytest configuration file. It provides:
- Shared test fixtures
- Test settings overrides
- Mock services
- Logger configuration
- FastAPI test client setup

### Location
```
apps/
  └── dhg-baseline/
      └── backend/
          └── tests/
              └── conftest.py
```

### Imports
Let's break down each import:

- `import pytest`
  - Testing framework
  - Fixture management
  - Test configuration

- `from fastapi.testclient import TestClient`
  - FastAPI test client
  - HTTP request simulation

- `import structlog`
  - Structured logging
  - Test logging configuration

- `from src.main import app`
  - Main FastAPI application
  - Used for test client

- `from src.core.config import Settings, get_settings`
  - Application settings
  - Settings override for tests

- `from src.services.supabase import SupabaseService`
  - Supabase service for mocking
  - Service interface definition

### Test Configuration

1. Logger Setup:
```python
structlog.configure(
    processors=[
        structlog.processors.JSONRenderer(),
    ]
)
```
- Configures JSON logging
- Simplifies test output
- Consistent log format

2. Test Settings:
```python
def get_settings_override():
    return Settings(
        DEBUG=True,
        SUPABASE_URL="https://test-supabase-url.com",
        SUPABASE_KEY="test-key",
        SUPABASE_JWT_SECRET="test-secret",
    )
```
- Provides test configuration
- Uses test credentials
- Enables debug mode

### Fixtures

1. `test_settings`:
```python
@pytest.fixture
def test_settings():
    return get_settings_override()
```
- Provides test configuration
- Used across test files
- Consistent test environment

2. `client`:
```python
@pytest.fixture
def client(test_settings):
    app.dependency_overrides[get_settings] = get_settings_override
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()
```
- Creates FastAPI test client
- Overrides settings for tests
- Cleans up after tests
- Context manager pattern

3. `mock_supabase_service`:
```python
@pytest.fixture
def mock_supabase_service(mocker):
    mock_service = mocker.Mock(spec=SupabaseService)
    mock_service.verify_token.return_value = {"valid": True}
    mock_service.get_user_profile.return_value = {
        "id": "test-user-id",
        "email": "test@example.com",
    }
    return mock_service
```
- Mocks Supabase service
- Provides test responses
- Consistent test data
- Isolates from real service

### Examples

Using fixtures in tests:
```python
def test_example(client, test_settings, mock_supabase_service):
    # Test with FastAPI client
    response = client.get("/api/test")
    assert response.status_code == 200

    # Test with mock service
    result = mock_supabase_service.verify_token("test")
    assert result["valid"] is True
```

### Best Practices Used
1. **Fixture Design**:
   - Reusable fixtures
   - Proper cleanup
   - Dependency injection
   - Scope management

2. **Test Isolation**:
   - Environment overrides
   - Service mocking
   - Clean state between tests
   - Controlled dependencies

3. **Configuration**:
   - Structured logging
   - Test settings
   - Clear overrides
   - Environment separation

4. **Code Organization**:
   - Central fixture location
   - Clear documentation
   - Consistent patterns
   - Maintainable structure
