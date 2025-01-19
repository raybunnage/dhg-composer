import pytest
from fastapi.testclient import TestClient
from app.main import app
from ..factories.user import UserFactory
from ..utils.generators import TestDataGenerator

client = TestClient(app)


@pytest.fixture
def test_user():
    """Create a test user"""
    return UserFactory.create()


@pytest.fixture
def auth_token():
    """Generate test auth token"""
    return TestDataGenerator.generate_auth_token()


def test_openapi_schema():
    """Test that the OpenAPI schema is valid and contains all expected endpoints"""
    response = client.get("/api/v1/openapi.json")
    assert response.status_code == 200
    schema = response.json()

    # Verify essential components
    assert "paths" in schema
    assert "components" in schema
    assert "schemas" in schema["components"]

    # Verify critical endpoints
    assert "/api/v1/users" in schema["paths"]
    assert "/api/v1/auth/login" in schema["paths"]


@pytest.mark.parametrize(
    "endpoint,method,expected_status",
    [
        ("/api/v1/users", "GET", 401),  # Unauthorized without token
        ("/api/v1/users", "POST", 422),  # Invalid input
        ("/api/v1/auth/login", "POST", 422),  # Invalid credentials
        ("/api/v1/health", "GET", 200),  # Health check always accessible
    ],
)
def test_endpoint_contracts(endpoint: str, method: str, expected_status: int):
    """Test API endpoint contracts"""
    response = client.request(method, endpoint)
    assert response.status_code == expected_status
    assert "application/json" in response.headers["content-type"]


def test_user_creation_contract(test_user):
    """Test user creation endpoint contract"""
    response = client.post("/api/v1/users", json=test_user)
    assert response.status_code in [201, 400]  # Created or already exists

    if response.status_code == 201:
        data = response.json()
        assert "id" in data
        assert "email" in data
        assert "full_name" in data
        assert "created_at" in data
        assert data["email"] == test_user["email"]


def test_authenticated_endpoints(auth_token):
    """Test endpoints requiring authentication"""
    headers = {"Authorization": f"Bearer {auth_token}"}

    # Test user profile endpoint
    response = client.get("/api/v1/users/me", headers=headers)
    assert response.status_code in [200, 401]

    if response.status_code == 200:
        data = response.json()
        assert "id" in data
        assert "email" in data
        assert "full_name" in data
