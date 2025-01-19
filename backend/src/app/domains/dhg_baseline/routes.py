from fastapi import APIRouter, Depends, HTTPException
from app.core.dependencies import require_feature
from app.services.supabase.mixins import SupabaseDBMixin, SupabaseAuthMixin
from app.core.logger import get_logger

logger = get_logger(__name__)
router = APIRouter()


@router.get("/users/me")
async def get_current_user(
    feature_enabled: bool = Depends(require_feature("baseline")),
    db: SupabaseDBMixin = Depends(SupabaseDBMixin),
    auth: SupabaseAuthMixin = Depends(SupabaseAuthMixin),
):
    """Get current user profile with a basic query example"""
    try:
        # Get current user from auth
        user = await auth.get_current_user()
        if not user:
            raise HTTPException(status_code=401, detail="Not authenticated")

        # Example query using DB mixin
        result = await db.execute_query(
            "select id, email, created_at from auth.users where id = $1", [user.id]
        )

        return {"status": "success", "data": {"user": result[0] if result else None}}
    except Exception as e:
        logger.error(f"Error getting user profile: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
