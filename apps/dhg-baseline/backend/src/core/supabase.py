from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer
from supabase import create_client, Client
from src.core.config import settings

# Initialize Supabase client
supabase: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)

security = HTTPBearer()


async def get_current_user(token: str = Depends(security)):
    try:
        # Verify the JWT token
        user = supabase.auth.get_user(token.credentials)
        return user
    except Exception as e:
        raise HTTPException(
            status_code=401,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
