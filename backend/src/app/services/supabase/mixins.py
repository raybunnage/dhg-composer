from typing import Dict, Any, Optional
from app.core.mixins.base import BaseMixin
from app.core.config import settings
from app.core.logger import get_logger
from supabase import create_client, Client
import asyncpg

logger = get_logger(__name__)


class SupabaseClientMixin(BaseMixin):
    """Base mixin for Supabase client functionality"""

    _client = None

    @property
    def client(self):
        if self._client is None:
            self._client = create_client(
                supabase_url=settings.SUPABASE_URL,
                supabase_key=settings.SUPABASE_KEY,
            )
        return self._client


class SupabaseAuthMixin:
    def __init__(self):
        self.supabase: Client = create_client(
            settings.SUPABASE_URL, settings.SUPABASE_KEY
        )

    async def get_current_user(self):
        """Get current authenticated user"""
        try:
            return self.supabase.auth.get_user()
        except Exception as e:
            return None


class SupabaseDBMixin:
    def __init__(self):
        self.supabase: Client = create_client(
            settings.SUPABASE_URL, settings.SUPABASE_KEY
        )

    async def execute_query(self, query: str, values: list = None):
        """Execute a raw SQL query"""
        try:
            result = self.supabase.table("users").select("*").execute()
            return result.data
        except Exception as e:
            raise Exception(f"Database query failed: {str(e)}")


class SupabaseAuthMixin(SupabaseClientMixin):
    """Mixin for Supabase authentication operations"""

    async def sign_up(self, email: str, password: str) -> Dict[str, Any]:
        logger.info(f"Signup attempt for email: {email}")
        try:
            result = self.client.auth.sign_up({"email": email, "password": password})
            logger.info(f"Signup successful for email: {email}")
            return result.user
        except Exception as e:
            logger.error(f"Signup failed for email {email}: {str(e)}")
            raise

    async def sign_in(self, email: str, password: str) -> Dict[str, Any]:
        logger.info(f"Login attempt for email: {email}")
        try:
            result = self.client.auth.sign_in_with_password(
                {"email": email, "password": password}
            )
            logger.info(f"Login successful for email: {email}")
            return {"user": result.user, "session": result.session}
        except Exception as e:
            logger.error(f"Login failed for email {email}: {str(e)}")
            raise


class SupabaseQueryMixin(SupabaseClientMixin):
    """Mixin for Supabase database operations"""

    async def test_connection(self) -> Dict[str, Any]:
        try:
            result = self.client.from_("test").select("*").limit(1).execute()
            return result.data
        except Exception as e:
            raise

    async def add_test_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        try:
            result = self.client.table("test").insert(data).execute()
            return result.data
        except Exception as e:
            raise
