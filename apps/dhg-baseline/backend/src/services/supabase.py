from typing import Optional
from functools import lru_cache
import structlog
from supabase import create_client, Client
from tenacity import retry, stop_after_attempt, wait_exponential
from packages.supabase_client import BaseSupabaseClient

from ..core.config import settings

logger = structlog.get_logger()


class SupabaseService(BaseSupabaseClient):
    """DHG Baseline specific Supabase service implementation"""

    def __init__(self):
        super().__init__()
        # App-specific initialization

    def initialize_client(self) -> None:
        """Initialize the Supabase client."""
        try:
            self.client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)
            logger.info("Supabase client initialized successfully")
        except Exception as e:
            logger.error("Failed to initialize Supabase client", error=str(e))
            raise

    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=4, max=10),
    )
    async def verify_token(self, token: str) -> dict:
        """Verify a JWT token."""
        try:
            if not self.client:
                raise ValueError("Supabase client not initialized")

            # Use the client to verify the token
            # This is a placeholder - implement actual verification logic
            return {"valid": True}
        except Exception as e:
            logger.error("Token verification failed", error=str(e))
            raise

    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=4, max=10),
    )
    async def get_user_profile(self, user_id: str) -> dict:
        """Get a user's profile from Supabase."""
        try:
            if not self.client:
                raise ValueError("Supabase client not initialized")

            response = (
                self.client.from_("profiles")
                .select("*")
                .eq("id", user_id)
                .single()
                .execute()
            )
            return response.data
        except Exception as e:
            logger.error("Failed to get user profile", user_id=user_id, error=str(e))
            raise


@lru_cache()
def get_supabase_service() -> SupabaseService:
    """Get a singleton instance of SupabaseService."""
    return SupabaseService()
