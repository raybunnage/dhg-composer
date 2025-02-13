from fastapi import APIRouter
from app.domains.auth.routes import router as auth_router
from app.domains.dhg_baseline.routes import router as baseline_router

api_router = APIRouter()

# This will make routes available at /api/v1/auth/signin
api_router.include_router(auth_router, prefix="/auth", tags=["auth"])
api_router.include_router(baseline_router, prefix="/baseline", tags=["baseline"])
