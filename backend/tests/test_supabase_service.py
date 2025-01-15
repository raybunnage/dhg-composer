import pytest
from unittest.mock import AsyncMock, patch, MagicMock
from services.supabase import (
    SupabaseService,
    SupabaseAuthenticationError,
    SupabaseQueryError,
    SupabaseStorageError,
)


@pytest.fixture
async def supabase_service():
    """Create a test instance of SupabaseService."""
    with (
        patch("supabase.create_client") as mock_create_client,
        patch("gotrue._sync.gotrue_base_api.SyncClient") as mock_sync_client,
    ):
        # Create mock client with all required methods
        mock_client = MagicMock()

        # Setup auth mocks
        auth_mock = MagicMock()
        auth_mock.sign_in_with_password = AsyncMock()
        auth_mock.sign_up = AsyncMock()
        auth_mock.sign_out = AsyncMock()
        auth_mock.refresh_session = AsyncMock()
        mock_client.auth = auth_mock

        # Setup storage mocks
        storage_mock = MagicMock()
        mock_bucket = MagicMock()
        mock_bucket.upload = AsyncMock()
        storage_mock.from_ = MagicMock(return_value=mock_bucket)
        mock_client.storage = storage_mock

        # Setup database query mocks
        mock_from = MagicMock()
        mock_select = MagicMock()
        mock_match = MagicMock()
        mock_execute = AsyncMock()

        mock_from.select = MagicMock(return_value=mock_select)
        mock_select.match = MagicMock(return_value=mock_match)
        mock_match.execute = mock_execute

        mock_client.from_ = MagicMock(return_value=mock_from)

        mock_create_client.return_value = mock_client

        service = SupabaseService(
            supabase_url="https://test.supabase.co",
            supabase_key="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U",
        )
        await service.initialize()
        return service


@pytest.mark.asyncio
async def test_login_success(supabase_service):
    """Test successful login."""
    # Create mock response
    mock_response = MagicMock()
    mock_response.user = {"id": "123", "email": "test@example.com"}
    mock_response.session = {"access_token": "test_token"}

    # Setup mock
    supabase_service.supabase.auth.sign_in_with_password = AsyncMock(
        return_value=mock_response
    )

    # Test
    result = await supabase_service.login("test@example.com", "password")
    assert result["status"] == "success"
    assert result["message"] == "Login successful!"
    assert result["data"] == mock_response.user
    assert result["session"] == mock_response.session


@pytest.mark.asyncio
async def test_login_failure(supabase_service):
    """Test login failure."""
    # Setup mock to raise exception
    supabase_service.supabase.auth.sign_in_with_password = AsyncMock(
        side_effect=Exception("Invalid credentials")
    )

    with pytest.raises(SupabaseAuthenticationError) as exc_info:
        await supabase_service.login("test@example.com", "wrong_password")
    assert "Invalid credentials" in str(exc_info.value)


@pytest.mark.asyncio
async def test_signup_success(supabase_service):
    """Test successful signup."""
    mock_response = MagicMock()
    mock_response.user = {"id": "123", "email": "new@example.com"}
    mock_response.session = {"access_token": "new_token"}

    supabase_service.supabase.auth.sign_up = AsyncMock(return_value=mock_response)

    result = await supabase_service.signup("new@example.com", "password")
    assert result["status"] == "success"
    assert result["message"] == "Signup successful! Please check your email."
    assert result["data"] == mock_response.user


@pytest.mark.asyncio
async def test_signup_failure(supabase_service):
    """Test signup failure."""
    with patch.object(
        supabase_service.supabase.auth,
        "sign_up",
        side_effect=Exception("Email already registered"),
    ):
        with pytest.raises(SupabaseAuthenticationError) as exc_info:
            await supabase_service.signup("existing@example.com", "password")
        assert "Email already registered" in str(exc_info.value)


@pytest.mark.asyncio
async def test_logout_success(supabase_service):
    """Test successful logout."""
    supabase_service.supabase.auth.sign_out = AsyncMock(return_value=None)
    result = await supabase_service.logout()
    assert result is True


@pytest.mark.asyncio
async def test_refresh_session_success(supabase_service):
    """Test successful session refresh."""
    mock_response = MagicMock()
    mock_response.session = {"access_token": "new_token"}

    supabase_service.supabase.auth.refresh_session = AsyncMock(
        return_value=mock_response
    )

    result = await supabase_service.refresh_session()
    assert result is True


@pytest.mark.asyncio
async def test_refresh_session_failure(supabase_service):
    """Test session refresh failure."""
    mock_response = MagicMock()
    mock_response.session = None

    supabase_service.supabase.auth.refresh_session = AsyncMock(
        return_value=mock_response
    )

    with pytest.raises(SupabaseAuthenticationError) as exc_info:
        await supabase_service.refresh_session()
    assert "Failed to refresh session" in str(exc_info.value)


@pytest.mark.asyncio
async def test_fetch_data(supabase_service):
    """Test fetching data."""
    mock_data = [{"id": 1, "name": "Test"}]
    mock_response = MagicMock()
    mock_response.data = mock_data

    # Setup the chain of mocks
    mock_execute = AsyncMock(return_value=mock_response)
    mock_match = MagicMock()
    mock_match.execute = mock_execute
    mock_select = MagicMock()
    mock_select.match = MagicMock(return_value=mock_match)
    mock_from = MagicMock()
    mock_from.select = MagicMock(return_value=mock_select)

    supabase_service.supabase.from_ = MagicMock(return_value=mock_from)

    result = await supabase_service.fetch_data("test_table", {"id": 1})
    assert result == mock_data


@pytest.mark.asyncio
async def test_upload_file(supabase_service):
    """Test file upload."""
    mock_response = {"Key": "test_key"}

    # Setup storage mock chain
    mock_upload = AsyncMock(return_value=mock_response)
    mock_bucket = MagicMock()
    mock_bucket.upload = mock_upload
    mock_from = MagicMock(return_value=mock_bucket)

    supabase_service.supabase.storage.from_ = mock_from

    result = await supabase_service.upload_file("bucket", "path", b"test_file")
    assert result == "test_key"
