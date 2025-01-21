from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
import structlog

from .core.config import settings
from .api import auth

# Configure structured logging
logger = structlog.get_logger()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    logger.info("Starting up application", app_name=settings.PROJECT_NAME)
    yield
    # Shutdown
    logger.info("Shutting down application", app_name=settings.PROJECT_NAME)


# Initialize FastAPI
app = FastAPI(
    title="DHG Baseline API",
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan,
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    return {
        "message": f"Welcome to {settings.PROJECT_NAME}",
        "docs_url": "/docs",
        "openapi_url": f"{settings.API_V1_STR}/openapi.json",
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy"}


# Include routers
app.include_router(auth.router, prefix=f"{settings.API_V1_STR}/auth", tags=["auth"])
