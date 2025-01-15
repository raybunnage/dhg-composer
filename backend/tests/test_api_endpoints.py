import pytest
from fastapi.testclient import TestClient
import sys
from pathlib import Path
from unittest.mock import patch, MagicMock, AsyncMock

# Add the parent directory to the Python path
sys.path.append(str(Path(__file__).parent.parent))

# Mock supabase before importing app
mock_supabase = AsyncMock()
with patch("supabase.create_client", return_value=mock_supabase):
    from main import app

client = TestClient(app)


def test_api_health():
    """Test the API is healthy."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}


def test_login_flow():
    """Test the complete login flow."""
    test_email = "test@example.com"
    test_password = "password123"

    # First try signup
    with patch("main.supabase") as mock_supabase:
        # Mock successful signup
        mock_result = AsyncMock()
        mock_result.user = {"id": "123", "email": test_email}
        mock_supabase.auth.sign_up = AsyncMock(return_value=mock_result)

        response = client.post(
            "/auth/signup",
            json={"email": test_email, "password": test_password},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "success"
        assert data["message"] == "Signup successful! Please check your email."
        assert data["data"]["email"] == test_email

    # Then try login
    with patch("main.supabase") as mock_supabase:
        # Mock successful login
        mock_result = AsyncMock()
        mock_result.user = {"id": "123", "email": test_email}
        mock_result.session = {"access_token": "test_token"}
        mock_supabase.auth.sign_in_with_password = AsyncMock(return_value=mock_result)

        response = client.post(
            "/auth/signin",
            json={"email": test_email, "password": test_password},
        )
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "success"
        assert data["message"] == "Login successful!"
        assert data["data"]["email"] == test_email
        assert "session" in data
        assert data["session"]["access_token"] == "test_token"


def test_invalid_login():
    """Test login with invalid credentials."""
    with patch("main.supabase") as mock_supabase:
        # Mock failed login
        mock_supabase.auth.sign_in_with_password = AsyncMock(
            side_effect=Exception("Invalid credentials")
        )

        response = client.post(
            "/auth/signin",
            json={"email": "wrong@email.com", "password": "wrongpass"},
        )
        assert response.status_code == 400
        assert "Invalid credentials" in str(response.json()["detail"])


def test_data_operations():
    """Test basic data operations."""
    with patch("main.supabase") as mock_supabase:
        # Mock successful data fetch
        mock_result = AsyncMock()
        mock_result.data = [{"id": 1, "name": "Test"}]
        mock_execute = AsyncMock(return_value=mock_result)
        mock_query = MagicMock()
        mock_query.execute = mock_execute
        mock_from = MagicMock()
        mock_from.select = MagicMock(return_value=mock_query)
        mock_from.select().limit = MagicMock(return_value=mock_query)
        mock_supabase.from_ = MagicMock(return_value=mock_from)

        response = client.get("/test-supabase")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "success"
        assert "data" in data
