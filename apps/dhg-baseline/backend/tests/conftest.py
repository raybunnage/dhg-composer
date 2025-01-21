import pytest
from fastapi.testclient import TestClient
import structlog

from src.main import app
from src.core.config import Settings, get_settings
from src.services.supabase import SupabaseService

# Configure test logger
structlog.configure(
    processors=[
        structlog.processors.JSONRenderer(),
    ]
)


def get_settings_override():
    return Settings(
        DEBUG=True,
        SUPABASE_URL="https://test-supabase-url.com",
        SUPABASE_KEY="test-key",
        SUPABASE_JWT_SECRET="test-secret",
    )


@pytest.fixture
def test_settings():
    return get_settings_override()


@pytest.fixture
def client(test_settings):
    app.dependency_overrides[get_settings] = get_settings_override
    with TestClient(app) as test_client:
        yield test_client
    app.dependency_overrides.clear()


@pytest.fixture
def mock_supabase_service(mocker):
    mock_service = mocker.Mock(spec=SupabaseService)
    mock_service.verify_token.return_value = {"valid": True}
    mock_service.get_user_profile.return_value = {
        "id": "test-user-id",
        "email": "test@example.com",
    }
    return mock_service
