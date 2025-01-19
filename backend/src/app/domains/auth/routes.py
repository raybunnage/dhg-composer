from fastapi import APIRouter, Depends, HTTPException
from app.core.apps import AppFeature
from app.core.deps import get_current_app
from app.services.auth.service import AuthService
from app.services.auth.schemas import SignUpRequest, SignInRequest
from app.core.logger import get_logger
from app.core.dependencies import require_feature

logger = get_logger(__name__)

router = APIRouter()


@router.post("/signup")
async def signup(
    request: SignUpRequest,
    app=Depends(get_current_app),
    feature_enabled: bool = Depends(require_feature("auth")),
):
    """User signup endpoint"""
    try:
        auth_service = AuthService()
        user = await auth_service.signup_user(request)
        return {"status": "success", "message": "Signup successful!", "data": user}
    except Exception as e:
        logger.error(f"Signup failed: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/login")
async def login(
    request: SignInRequest,
    app=Depends(get_current_app),
    feature_enabled: bool = Depends(require_feature("auth")),
):
    """User login endpoint"""
    try:
        auth_service = AuthService()
        result = await auth_service.login_user(request)
        return {
            "status": "success",
            "message": "Login successful!",
            "data": result["user"],
            "session": result["session"],
        }
    except Exception as e:
        logger.error(f"Login failed: {str(e)}")
        raise HTTPException(status_code=401, detail=str(e))
