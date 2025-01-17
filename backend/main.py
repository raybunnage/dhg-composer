from fastapi import FastAPI, HTTPException, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from src.services.supabase.client import SupabaseClient
from src.services.anthropic.client import AnthropicClient
from src.config.settings import get_settings
from pydantic import BaseModel
import logging
import io
from src.mixins.pdf_processor import PDFProcessorMixin
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError

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


# Add PDFProcessorMixin to your FastAPI class
class CustomFastAPI(FastAPI, PDFProcessorMixin):
    pass


# Update app initialization
app = CustomFastAPI()

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


# Add these new endpoints
@app.post("/process-pdf")
async def process_pdf(file: UploadFile = File(...)):
    """Process uploaded PDF file"""
    try:
        # Read the uploaded file
        contents = await file.read()
        pdf_file = io.BytesIO(contents)

        # Extract text
        text = await app.extract_text(pdf_file)

        # Analyze content
        analysis = await app.analyze_content(text)

        # Get AI insights if needed
        ai_analysis = await app.state.anthropic.analyze_text(
            text[:1000]
        )  # First 1000 chars for demo

        return {"status": "success", "analysis": analysis, "ai_insights": ai_analysis}
    except Exception as e:
        logger.error(f"PDF processing failed: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request, exc):
    return JSONResponse(
        status_code=422,
        content={"status": "error", "message": "Validation error", "details": str(exc)},
    )


@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    return JSONResponse(
        status_code=500,
        content={
            "status": "error",
            "message": "Internal server error",
            "details": str(exc),
        },
    )
