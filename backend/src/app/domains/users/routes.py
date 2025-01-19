from fastapi import APIRouter, Depends
from app.core.apps import AppFeature
from app.core.deps import get_current_app, require_feature

router = APIRouter()


@router.get("/users/")
async def list_users(
    app: AppConfig = Depends(get_current_app),
    _=Depends(require_feature(AppFeature.AUTH)),
):
    """List users for current app"""
    # Use app.database_schema for app-specific data
    return {"app": app.id, "users": []}


@router.post("/payments/")
async def create_payment(
    app: AppConfig = Depends(get_current_app),
    _=Depends(require_feature(AppFeature.PAYMENTS)),
):
    """Create payment (only available in apps with payment feature)"""
    return {"status": "payment processed"}
