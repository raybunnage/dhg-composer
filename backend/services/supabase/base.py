from typing import Optional
from supabase import create_client
from supabase.client import Client, ClientOptions
from .mixins import AuthenticationMixin, QueryMixin, StorageMixin, UtilityMixin
import logging

logger = logging.getLogger("supabase-service.base")


class SupabaseService(AuthenticationMixin, QueryMixin, StorageMixin, UtilityMixin):
    """Main Supabase service that combines all mixins."""

    def __init__(self, supabase_url: str, supabase_key: str):
        logger.info("Initializing SupabaseService")
        self.supabase: Optional[Client] = None
        self.supabase_url = supabase_url
        self.supabase_key = supabase_key

    async def initialize(self):
        """Initialize the Supabase client."""
        if not self.supabase:
            logger.info("Creating new Supabase client")
            options = ClientOptions(
                auto_refresh_token=True,
                persist_session=True,
            )
            self.supabase = create_client(
                self.supabase_url, self.supabase_key, options=options
            )
            logger.info("Supabase client created successfully")
