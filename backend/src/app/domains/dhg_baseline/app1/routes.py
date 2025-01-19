from fastapi import APIRouter, Depends
from app.core.apps import AppFeature
from app.core.deps import get_current_app, require_feature

router = APIRouter(prefix="/app1")


@router.get("/products")
async def list_products(
    app=Depends(get_current_app), _=Depends(require_feature(AppFeature.MARKETPLACE))
):
    """List products for app1"""
    return {"products": [], "app": "app1"}


@router.post("/checkout")
async def process_checkout(
    app=Depends(get_current_app), _=Depends(require_feature(AppFeature.PAYMENTS))
):
    """Process checkout for app1"""
    return {"status": "success", "app": "app1"}
