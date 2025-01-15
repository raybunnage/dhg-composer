from typing import Optional
from supabase import AsyncClient
from .mixins import (
    AuthenticationMixin,
    QueryMixin,
    StorageMixin,
    UtilityMixin
)
import logging

logger = logging.getLogger("supabase-service.base")

class SupabaseService(
    AuthenticationMixin,
    QueryMixin,
    StorageMixin,
    UtilityMixin
):
    """Main Supabase service that combines all mixins."""
    
    def __init__(self, supabase_url: str, supabase_key: str):
        logger.info("Initializing SupabaseService")
        self.supabase: Optional[AsyncClient] = None
        self.supabase_url = supabase_url
        self.supabase_key = supabase_key
        
    async def initialize(self):
        """Initialize the Supabase client."""
        if not self.supabase:
            logger.info("Creating new Supabase client")
            self.supabase = AsyncClient(
                supabase_url=self.supabase_url,
                supabase_key=self.supabase_key,
            )
            logger.info("Supabase client created successfully") 