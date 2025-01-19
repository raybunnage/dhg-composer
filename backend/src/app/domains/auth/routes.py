from fastapi import APIRouter, Depends, HTTPException
from app.core.apps import AppFeature
from app.core.deps import get_current_app
from app.services.supabase.auth import SupabaseAuth

router = APIRouter()

@router.post("/signup")
async def signup(
    email: str,
    password: str,
    app = Depends(get_current_app),
    _=Depends(require_feature(AppFeature.AUTH))
):
    """User signup endpoint"""
    try:
        user = await SupabaseAuth.sign_up(email, password)
        return {"user": user, "message": "Signup successful"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/login")
async def login(
    email: str,
    password: str,
    app = Depends(get_current_app),
    _=Depends(require_feature(AppFeature.AUTH))
):
    """User login endpoint"""
    try:
        session = await SupabaseAuth.sign_in(email, password)
        return {"session": session, "message": "Login successful"}
    except Exception as e:
        raise HTTPException(status_code=401, detail=str(e)) 