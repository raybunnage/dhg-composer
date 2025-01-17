from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from src.services.supabase.client import SupabaseClient
from src.services.anthropic.client import AnthropicClient
from src.config.settings import get_settings
from pydantic import BaseModel
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# Add these request models
class SignUpRequest(BaseModel):
    email: str
    password: str


class SignInRequest(BaseModel):
    email: str
    password: str


app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

settings = get_settings()


@app.on_event("startup")
async def startup():
    app.state.supabase = SupabaseClient()
    app.state.anthropic = AnthropicClient()


# Add these auth endpoints
@app.post("/auth/signup")
async def sign_up(request: SignUpRequest):
    logger.info(f"Signup attempt for email: {request.email}")
    return await app.state.supabase.sign_up(
        email=request.email, password=request.password
    )


@app.post("/auth/signin")
async def sign_in(request: SignInRequest):
    logger.info(f"Login attempt for email: {request.email}")
    return await app.state.supabase.sign_in(
        email=request.email, password=request.password
    )


@app.get("/test-supabase")
async def test_supabase():
    try:
        return await app.state.supabase.test_connection()
    except Exception as e:
        logger.error(f"Test endpoint failed: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/test-services")
async def test_services():
    return {"status": "Services initialized", "environment": settings.ENVIRONMENT}
