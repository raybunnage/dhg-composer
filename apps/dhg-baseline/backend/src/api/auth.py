from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import structlog

from ..services.supabase import get_supabase_service, SupabaseService

logger = structlog.get_logger()
router = APIRouter()
security = HTTPBearer()


@router.get("/verify")
async def verify_token(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    supabase_service: SupabaseService = Depends(get_supabase_service),
):
    """Verify a JWT token."""
    try:
        token = credentials.credentials
        result = await supabase_service.verify_token(token)
        return {"valid": True, "details": result}
    except Exception as e:
        logger.error("Token verification failed", error=str(e))
        raise HTTPException(
            status_code=401, detail="Invalid authentication credentials"
        )


@router.get("/profile/{user_id}")
async def get_profile(
    user_id: str,
    credentials: HTTPAuthorizationCredentials = Depends(security),
    supabase_service: SupabaseService = Depends(get_supabase_service),
):
    """Get a user's profile."""
    try:
        # First verify the token
        token = credentials.credentials
        await supabase_service.verify_token(token)

        # Then get the profile
        profile = await supabase_service.get_user_profile(user_id)
        return profile
    except Exception as e:
        logger.error("Failed to get profile", user_id=user_id, error=str(e))
        raise HTTPException(
            status_code=404, detail=f"Profile not found for user: {user_id}"
        )
