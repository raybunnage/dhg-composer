from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer
from app.db.base import SupabaseDB

security = HTTPBearer()


async def get_current_user(token: str = Depends(security)):
    try:
        # Verify token with Supabase
        client = SupabaseDB.get_client()
        user = client.auth.get_user(token.credentials)
        return user
    except Exception:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
