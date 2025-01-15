import pytest
from unittest.mock import AsyncMock, patch
from services.supabase import (
    SupabaseService,
    SupabaseAuthenticationError,
    SupabaseQueryError,
    SupabaseStorageError
)

@pytest.fixture
async def supabase_service():
    """Create a test instance of SupabaseService."""
    service = SupabaseService(
        supabase_url="test_url",
        supabase_key="test_key"
    )
    await service.initialize()
    return service

@pytest.mark.asyncio
async def test_login_success(supabase_service):
    """Test successful login."""
    mock_response = AsyncMock()
    mock_response.user = {"id": "123", "email": "test@example.com"}
    mock_response.session = {"access_token": "test_token"}
    
    with patch.object(supabase_service.supabase.auth, 'sign_in_with_password', 
                     return_value=mock_response):
        result = await supabase_service.login("test@example.com", "password")
        assert result["user"]["id"] == "123"
        assert result["session"]["access_token"] == "test_token"

@pytest.mark.asyncio
async def test_login_failure(supabase_service):
    """Test login failure."""
    with patch.object(supabase_service.supabase.auth, 'sign_in_with_password', 
                     side_effect=Exception("Login failed")):
        with pytest.raises(SupabaseAuthenticationError):
            await supabase_service.login("test@example.com", "password")

@pytest.mark.asyncio
async def test_fetch_data(supabase_service):
    """Test fetching data."""
    mock_data = [{"id": 1, "name": "Test"}]
    mock_response = AsyncMock()
    mock_response.data = mock_data
    
    with patch.object(supabase_service.supabase, 'from_') as mock_from:
        mock_from.return_value.select.return_value.match.return_value.execute.return_value = mock_response
        result = await supabase_service.fetch_data("test_table", {"id": 1})
        assert result == mock_data

@pytest.mark.asyncio
async def test_upload_file(supabase_service):
    """Test file upload."""
    mock_response = {"Key": "test_key"}
    
    with patch.object(supabase_service.supabase.storage, 'from_') as mock_from:
        mock_from.return_value.upload.return_value = mock_response
        result = await supabase_service.upload_file("bucket", "path", b"test_file")
        assert result == "test_key" 