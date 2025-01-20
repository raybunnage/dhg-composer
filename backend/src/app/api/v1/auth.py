from fastapi import APIRouter

router = APIRouter(prefix="/auth")

@router.post("/signin")
async def sign_in(request: SignInRequest):
    # ... your existing sign_in code ... 