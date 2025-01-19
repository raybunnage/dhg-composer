from fastapi import APIRouter
from app.domains.auth.routes import router as auth_router
from app.domains.test.routes import router as test_router
from app.domains.app1.routes import router as app1_router
from app.domains.app2.routes import router as app2_router

api_router = APIRouter()

# Include auth routes (available to all apps)
api_router.include_router(auth_router, prefix="/auth", tags=["auth"])

# Include test routes
api_router.include_router(test_router, tags=["test"])

# Include app-specific routes
api_router.include_router(app1_router, tags=["app1"])
api_router.include_router(app2_router, tags=["app2"])
