from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from services.supabase import SupabaseService, SupabaseAuthenticationError
from services.supabase.utils.logging_config import setup_logging
from dotenv import load_dotenv
import os
from pydantic import BaseModel

# Load environment variables
load_dotenv()

# Set up logging
logger = setup_logging(
    log_level=os.getenv("LOG_LEVEL", "INFO"),
    log_file=os.getenv("LOG_FILE"),
    service_name="fastapi-main",
)

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

supabase_service = SupabaseService(
    supabase_url=os.getenv("SUPABASE_URL"), supabase_key=os.getenv("SUPABASE_KEY")
)


class SignUpRequest(BaseModel):
    email: str
    password: str


class SignInRequest(BaseModel):
    email: str
    password: str


@app.on_event("startup")
async def startup():
    await supabase_service.initialize()


@app.get("/")
async def read_root():
    """Basic health check endpoint."""
    logger.debug("Health check endpoint called")
    return {"message": "Hello World"}


@app.get("/test-supabase")
async def test_supabase():
    """Test Supabase connection by querying test table."""
    logger.info("Testing Supabase connection")
    try:
        result = await supabase_service.fetch_data("test", {})
        logger.info("Supabase connection test successful")
        return {
            "status": "success",
            "message": "Connected to Supabase successfully!",
            "data": result[:1],  # Return only first record for testing
        }
    except Exception as e:
        logger.error(f"Supabase connection test failed: {str(e)}")
        return {
            "status": "error",
            "message": str(e),
            "details": "Connection test failed",
        }


@app.post("/test-supabase/add")
async def add_test_data():
    """Add test data to Supabase test table."""
    logger.info("Adding test data to Supabase")
    try:
        data = {
            "last_name": "Test",
            "first_name": "User",
            "username": "testuser",
            "user_initials": "TY",
        }
        result = await supabase_service.insert_data("test", data)
        logger.info("Test data added successfully")
        return {
            "status": "success",
            "message": "Test data added successfully!",
            "data": result,
        }
    except Exception as e:
        logger.error(f"Failed to add test data: {str(e)}")
        return {
            "status": "error",
            "message": str(e),
            "details": "Failed to add test data",
        }


@app.post("/auth/signup")
async def sign_up(request: SignUpRequest):
    logger.info(f"Signup attempt for email: {request.email}")
    try:
        result = await supabase_service.signup(request.email, request.password)
        logger.info(f"Signup successful for email: {request.email}")
        return {
            "status": "success",
            "message": "Signup successful! Please check your email.",
            "data": result,
        }
    except Exception as e:
        logger.error(f"Signup failed for email {request.email}: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))


@app.post("/auth/signin")
async def sign_in(request: SignInRequest):
    logger.info(f"Login attempt for email: {request.email}")
    try:
        result = await supabase_service.login(request.email, request.password)
        logger.info(f"Login successful for email: {request.email}")
        return {"status": "success", "message": "Login successful!", "data": result}
    except Exception as e:
        logger.error(f"Login failed for email {request.email}: {str(e)}")
        raise HTTPException(status_code=400, detail=str(e))
