from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from supabase import create_client
from dotenv import load_dotenv
import os
from pathlib import Path
from pydantic import BaseModel
import logging

# Get the directory where main.py is located
BASE_DIR = Path(__file__).resolve().parent

# Load environment variables from .env file in the backend directory
load_dotenv(BASE_DIR / ".env")

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Get environment variables
url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_KEY")

print(f"Loading .env from: {BASE_DIR / '.env'}")
print(f"URL: {url}")
print(f"Key: {key}")

# Initialize Supabase client as async
supabase = create_client(
    supabase_url=url,
    supabase_key=key,
)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class SignUpRequest(BaseModel):
    email: str
    password: str


class SignInRequest(BaseModel):
    email: str
    password: str


@app.get("/")
async def read_root():
    return {"message": "Hello World"}


@app.get("/test-supabase")
async def test_supabase():
    try:
        result = supabase.from_("test").select("*").limit(1).execute()
        return {
            "status": "success",
            "message": "Connected to Supabase successfully!",
            "data": result.data,
        }
    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
            "details": "Connection test failed",
        }


@app.post("/test-supabase/add")
async def add_test_data():
    try:
        data = {
            "last_name": "Test",
            "first_name": "User",
            "username": "testuser",
            "user_initials": "TY",
        }
        result = supabase.table("test").insert(data).execute()
        return {
            "status": "success",
            "message": "Test data added successfully!",
            "data": result.data,
        }
    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
            "details": "Failed to add test data",
        }


@app.post("/auth/signup")
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


@app.post("/auth/signin")
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


# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)
