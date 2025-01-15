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


def test_read_root():
    """Test the root endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}


@patch("main.supabase")
def test_test_supabase(mock_supabase):
    """Test the Supabase connection endpoint."""
    # Create mock response
    mock_result = MagicMock()
    mock_result.data = [{"test": "data"}]

    # Create a simpler mock chain
    mock_execute = AsyncMock(return_value=mock_result)
    mock_query = MagicMock()
    mock_query.execute = mock_execute

    # Set up the chain
    mock_from = MagicMock()
    mock_from.select = MagicMock(return_value=mock_query)
    mock_from.select().limit = MagicMock(return_value=mock_query)

    mock_supabase.from_ = MagicMock(return_value=mock_from)

    response = client.get("/test-supabase")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "success"
    assert "message" in data
    assert "data" in data


@pytest.mark.parametrize(
    "email,password,expected_status",
    [
        ("test@example.com", "password123", 200),  # Valid credentials
        ("invalid@email", "short", 400),  # Invalid email
        ("", "", 400),  # Empty credentials
    ],
)
@patch("main.supabase")
def test_signup_validation(mock_supabase, email, password, expected_status):
    """Test signup endpoint with various inputs."""
    if expected_status == 200:
        # Mock successful signup
        mock_result = AsyncMock()
        mock_result.user = {"id": "123", "email": email}
        mock_supabase.auth.sign_up = AsyncMock(return_value=mock_result)
    else:
        # Mock failed signup
        mock_supabase.auth.sign_up = AsyncMock(
            side_effect=Exception("Invalid credentials")
        )

    response = client.post(
        "/auth/signup",
        json={"email": email, "password": password},
    )
    assert response.status_code == expected_status


@pytest.mark.parametrize(
    "email,password,expected_status",
    [
        ("test@example.com", "password123", 200),  # Valid credentials
        ("invalid@email", "short", 400),  # Invalid credentials
        ("", "", 400),  # Empty credentials
    ],
)
@patch("main.supabase")
def test_signin_validation(mock_supabase, email, password, expected_status):
    """Test signin endpoint with various inputs."""
    if expected_status == 200:
        # Mock successful login
        mock_result = AsyncMock()
        mock_result.user = {"id": "123", "email": email}
        mock_result.session = {"access_token": "test_token"}
        mock_supabase.auth.sign_in_with_password = AsyncMock(return_value=mock_result)
    else:
        # Mock failed login
        mock_supabase.auth.sign_in_with_password = AsyncMock(
            side_effect=Exception("Invalid credentials")
        )

    response = client.post(
        "/auth/signin",
        json={"email": email, "password": password},
    )
    assert response.status_code == expected_status
