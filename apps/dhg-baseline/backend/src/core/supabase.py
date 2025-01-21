from typing import Optional
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from packages.supabase_py.src.supabase_client import SupabaseClient
from packages.supabase_py.src.types import User
import os

security = HTTPBearer()
supabase = SupabaseClient(url=os.getenv("SUPABASE_URL"), key=os.getenv("SUPABASE_KEY"))


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> User:
    user = await supabase.get_user(credentials.credentials)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user
