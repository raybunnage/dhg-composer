from fastapi import APIRouter, Depends, HTTPException
from app.core.dependencies import require_feature
from app.services.supabase.mixins import SupabaseQueryMixin, SupabaseAuthMixin
from app.core.logger import get_logger

logger = get_logger(__name__)
router = APIRouter()


@router.get("/users/me")
async def get_current_user(
    feature_enabled: bool = Depends(require_feature("baseline")),
    db: SupabaseQueryMixin = Depends(SupabaseQueryMixin),
    auth: SupabaseAuthMixin = Depends(SupabaseAuthMixin),
):
    """Get current user profile with a basic query example"""
    try:
        # Get current user from auth
        user = await auth.get_current_user()
        if not user:
            raise HTTPException(status_code=401, detail="Not authenticated")

        # Example query using Query mixin
        result = await db.test_connection()

        return {"status": "success", "data": {"user": user, "test_data": result}}
    except Exception as e:
        logger.error(f"Error getting user profile: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
