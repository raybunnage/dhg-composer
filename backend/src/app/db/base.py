from supabase import create_client, Client
from typing import Optional
from app.core.config import settings


class SupabaseDB:
    _instance: Optional[Client] = None

    @classmethod
    def get_client(cls) -> Client:
        if not cls._instance:
            cls._instance = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)
        return cls._instance
