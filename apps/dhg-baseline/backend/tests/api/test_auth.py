import pytest
from fastapi import HTTPException

from src.api.auth import router


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
