from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPBearer
from src.core.supabase import get_current_user
from src.types import User, Profile

router = APIRouter(prefix="/auth", tags=["auth"])
security = HTTPBearer()


@router.get("/me")
async def get_me(current_user: User = Depends(get_current_user)) -> User:
    return current_user


@router.get("/profile")
async def get_profile(current_user: User = Depends(get_current_user)) -> Profile:
    profile = await supabase.get_profile(current_user.id)
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    return profile
