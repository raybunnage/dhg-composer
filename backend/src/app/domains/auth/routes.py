from fastapi import APIRouter, Depends, HTTPException
from app.core.apps import AppFeature
from app.core.deps import get_current_app, require_feature
from app.services.auth.service import AuthService
from app.services.auth.schemas import SignUpRequest, SignInRequest

router = APIRouter()


@router.post("/signup")
async def signup(
    request: SignUpRequest,
    app=Depends(get_current_app),
    _=Depends(require_feature(AppFeature.AUTH)),
):
    """User signup endpoint"""
    try:
        auth_service = AuthService()
        user = await auth_service.signup_user(request)
        return {"status": "success", "message": "Signup successful!", "data": user}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/login")
async def login(
    request: SignInRequest,
    app=Depends(get_current_app),
    _=Depends(require_feature(AppFeature.AUTH)),
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
        raise HTTPException(status_code=401, detail=str(e))
