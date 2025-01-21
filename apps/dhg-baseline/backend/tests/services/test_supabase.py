import pytest
from src.services.supabase import SupabaseService


@pytest.mark.asyncio
async def test_supabase_service_initialization(test_settings):
    """Test Supabase service initialization."""
    service = SupabaseService()
    assert service.client is not None


@pytest.mark.asyncio
async def test_verify_token(mock_supabase_service):
    """Test token verification."""
    result = await mock_supabase_service.verify_token("test-token")
    assert result["valid"] is True


@pytest.mark.asyncio
async def test_get_user_profile(mock_supabase_service):
    """Test user profile retrieval."""
    profile = await mock_supabase_service.get_user_profile("test-user-id")
    assert profile["id"] == "test-user-id"
    assert profile["email"] == "test@example.com"
