from fastapi import APIRouter, Depends, HTTPException, Request
from app.core.apps import AppFeature
from app.core.deps import get_current_app
from app.services.auth.service import AuthService
from app.services.auth.schemas import SignUpRequest, SignInRequest
from app.core.logger import get_logger
from app.core.dependencies import require_feature
from app.core.route_validator import validate_api_prefix
from pydantic import BaseModel
from app.core.supabase import supabase
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


class SignUpRequest(BaseModel):
    email: str
    password: str


class SignInRequest(BaseModel):
    email: str
    password: str


@router.post("/signup")
async def sign_up(request: SignUpRequest):
    logger.info(f"Signup attempt for email: {request.email}")
    try:
        result = supabase.auth.sign_up(
            {"email": request.email, "password": request.password}
        )
        logger.info(f"Signup successful for email: {request.email}")
        return {
            "status": "success",
            "message": "Signup successful! Please check your email.",
            "data": result.user,
        }
    except Exception as e:
        logger.error(f"Signup failed for email {request.email}: {str(e)}")
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
