from fastapi import APIRouter, Depends, HTTPException, Request
from app.core.apps import AppFeature
from app.core.deps import get_current_app
from app.services.auth.service import AuthService
from app.services.auth.schemas import SignUpRequest, SignInRequest
from app.core.logger import get_logger
from app.core.dependencies import require_feature
from app.core.route_validator import validate_api_prefix

logger = get_logger(__name__)

router = APIRouter()


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
async def signin(
    request: Request,
    signin_request: SignInRequest,
    app=Depends(get_current_app),
    feature_enabled: bool = Depends(require_feature("auth")),
):
    """User signin endpoint"""
    try:
        # Validate API prefix
        if not validate_api_prefix(request):
            logger.error(f"Invalid route prefix for signin: {request.url.path}")
            raise HTTPException(status_code=404, detail="Invalid route")

        logger.info(f"Signin attempt with request: {signin_request}")
        auth_service = AuthService()
        result = await auth_service.login_user(signin_request)
        response_data = {
            "status": "success",
            "message": "Signin successful!",
            "data": result["user"],
            "session": result["session"],
        }
        logger.info(f"Signin successful, returning: {response_data}")
        return response_data
    except Exception as e:
        logger.error(f"Signin failed with error: {str(e)}")
        raise HTTPException(status_code=401, detail=str(e))
