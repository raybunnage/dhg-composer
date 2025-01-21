import pytest
from unittest.mock import Mock, patch
from src.supabase_client import SupabaseClient
from src.types import User, Profile


@pytest.fixture
def supabase_client():
    return SupabaseClient("test-url", "test-key")


@pytest.mark.asyncio
async def test_get_user(supabase_client):
    mock_user = User(
        id="123",
        email="test@example.com",
        created_at="2023-01-01T00:00:00",
        updated_at="2023-01-01T00:00:00",
    )

    with patch.object(
        supabase_client.client.auth, "get_user", return_value=Mock(user=mock_user)
    ):
        user = await supabase_client.get_user("test-jwt")
        assert user == mock_user


@pytest.mark.asyncio
async def test_get_profile(supabase_client):
    mock_profile = Profile(
        id="123",
        email="test@example.com",
        created_at="2023-01-01T00:00:00",
        updated_at="2023-01-01T00:00:00",
        full_name="Test User",
    )

    with patch.object(
        supabase_client.client,
        "from_",
        return_value=Mock(
            select=Mock(
                return_value=Mock(
                    eq=Mock(
                        return_value=Mock(
                            single=Mock(
                                return_value=Mock(
                                    execute=Mock(return_value=Mock(data=mock_profile))
                                )
                            )
                        )
                    )
                )
            )
        ),
    ):
        profile = await supabase_client.get_profile("123")
        assert profile == mock_profile
