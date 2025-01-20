from fastapi import APIRouter, Depends, HTTPException, Request
from app.core.apps import AppFeature
from app.core.deps import get_current_app
from app.services.auth.service import AuthService
from app.services.auth.schemas import SignUpRequest, SignInRequest
from app.core.logger import get_logger
from app.core.dependencies import require_feature
from app.core.route_validator import validate_api_prefix
from pydantic import BaseModel
from app.core.supabase import supabase  # Assuming you have this set up

logger = get_logger(__name__)

router = APIRouter()


class SignUpRequest(BaseModel):
    email: str
    password: str


class SignInRequest(BaseModel):
    email: str
    password: str


@router.post("/signup")
async def signup(
    request: Request,
    signup_request: SignUpRequest,
    app=Depends(get_current_app),
    feature_enabled: bool = Depends(require_feature("auth")),
):
    """User signup endpoint"""
    try:
        # Validate API prefix
        if not validate_api_prefix(request):
            logger.error(f"Invalid route prefix for signup: {request.url.path}")
            raise HTTPException(status_code=404, detail="Invalid route")

        logger.info(f"Signup attempt with request: {signup_request}")
        auth_service = AuthService()
        user = await auth_service.signup_user(signup_request)
        response_data = {
            "status": "success",
            "message": "Signup successful!",
            "data": user,
        }
        logger.info(f"Signup successful, returning: {response_data}")
        return response_data
    except Exception as e:
        logger.error(f"Signup failed: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/signin")
async def sign_in(request: SignInRequest):
    logger.info(f"Login attempt for email: {request.email}")
    try:
        result = supabase.auth.sign_in_with_password(
            {"email": request.email, "password": request.password}
        )
        logger.info(f"Login successful for email: {request.email}")
        return {
            "status": "success",
            "message": "Login successful!",
            "data": result.user,
            "session": result.session,
        }
    except Exception as e:
        logger.error(f"Login failed for email {request.email}: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))
