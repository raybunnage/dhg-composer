import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient
from unittest.mock import patch
from src.main import app
from packages.supabase_py.src.types import User, Profile

from src.api.auth import router

client = TestClient(app)


def test_verify_token_success(client, mock_supabase_service):
    """Test successful token verification."""
    response = client.get(
        "/api/v1/auth/verify", headers={"Authorization": "Bearer test-token"}
    )
    assert response.status_code == 200
    assert response.json()["valid"] is True


def test_verify_token_failure(client, mock_supabase_service):
    """Test failed token verification."""
    mock_supabase_service.verify_token.side_effect = HTTPException(
        status_code=401, detail="Invalid token"
    )
    response = client.get(
        "/api/v1/auth/verify", headers={"Authorization": "Bearer invalid-token"}
    )
    assert response.status_code == 401


def test_get_profile_success(client, mock_supabase_service):
    """Test successful profile retrieval."""
    response = client.get(
        "/api/v1/auth/profile/test-user-id",
        headers={"Authorization": "Bearer test-token"},
    )
    assert response.status_code == 200
    assert response.json()["email"] == "test@example.com"


def test_get_profile_not_found(client, mock_supabase_service):
    """Test profile not found."""
    mock_supabase_service.get_user_profile.side_effect = HTTPException(
        status_code=404, detail="Profile not found"
    )
    response = client.get(
        "/api/v1/auth/profile/non-existent-id",
        headers={"Authorization": "Bearer test-token"},
    )
    assert response.status_code == 404


def test_get_me():
    mock_user = User(
        id="123",
        email="test@example.com",
        created_at="2023-01-01T00:00:00",
        updated_at="2023-01-01T00:00:00",
    )

    with patch("src.core.supabase.get_current_user", return_value=mock_user):
        response = client.get(
            "/auth/me", headers={"Authorization": "Bearer test-token"}
        )
        assert response.status_code == 200
        assert response.json()["id"] == mock_user.id
        assert response.json()["email"] == mock_user.email


def test_get_profile():
    mock_user = User(
        id="123",
        email="test@example.com",
        created_at="2023-01-01T00:00:00",
        updated_at="2023-01-01T00:00:00",
    )
    mock_profile = Profile(
        id="123",
        email="test@example.com",
        created_at="2023-01-01T00:00:00",
        updated_at="2023-01-01T00:00:00",
        full_name="Test User",
    )

    with (
        patch("src.core.supabase.get_current_user", return_value=mock_user),
        patch("src.core.supabase.supabase.get_profile", return_value=mock_profile),
    ):
        response = client.get(
            "/auth/profile", headers={"Authorization": "Bearer test-token"}
        )
        assert response.status_code == 200
        assert response.json()["id"] == mock_profile.id
        assert response.json()["full_name"] == mock_profile.full_name
