import pytest
from typing import Generator, Dict, Any
from app.core.config import settings
from app.db.base import SupabaseDB


@pytest.fixture
def supabase_client():
    """Get Supabase client for testing"""
    return SupabaseDB.get_client()


@pytest.fixture
def test_data() -> Dict[str, Any]:
    """Sample test data"""
    return {
        "user": {
            "email": "test@example.com",
            "full_name": "Test User",
            "password": "testpassword123",
        }
    }
