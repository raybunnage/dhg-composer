from supabase import create_client, Client
from app.core.config import settings
import logging

logger = logging.getLogger(__name__)

try:
    # Simple initialization like in the working version
    supabase: Client = create_client(
        supabase_url=settings.SUPABASE_URL,
        supabase_key=settings.SUPABASE_KEY,
    )  # No options parameter at all
    logger.info("Supabase client initialized successfully")
except Exception as e:
    logger.error(f"Failed to initialize Supabase client: {str(e)}")
    raise
