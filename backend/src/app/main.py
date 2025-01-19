import os
from pathlib import Path
from dotenv import load_dotenv
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routes import api_router
from app.core.apps import AppRegistry, AppConfig
from app.middleware.app_context import AppContextMiddleware
from app.core.app_settings import APP_SETTINGS
import logging
from app.core.env_validator import validate_environment

# Load environment variables
ENV = os.getenv("ENV", "development")
env_file = f".env.{ENV}" if ENV != "development" else ".env"
load_dotenv(Path(__file__).parent.parent.parent / env_file)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Add after environment loading
try:
    env_config = validate_environment()
    logger.info(f"Environment validated successfully: {env_config['ENV']}")
except Exception as e:
    logger.error(f"Environment validation failed: {str(e)}")
    raise


def create_app() -> FastAPI:
    app = FastAPI(
        title=settings.PROJECT_NAME,
        version=settings.VERSION,
        description=settings.DESCRIPTION,
        openapi_url=f"{settings.API_V1_STR}/openapi.json",
    )

    # Register apps
    for app_id, app_settings in APP_SETTINGS.items():
        AppRegistry.register_app(
            AppConfig(
                id=app_id,
                name=f"Application {app_id}",
                features=list(app_settings.features.keys()),
                database_schema=app_id,
                api_prefix=f"/api/{app_settings.api_version}",
                cors_origins=[f"https://{app_id}.yourdomain.com"],
            )
        )

    # Configure CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=[str(origin) for origin in settings.BACKEND_CORS_ORIGINS],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Add middleware
    app.add_middleware(AppContextMiddleware)

    # Include routers
    app.include_router(api_router)

    return app


app = create_app()


@app.get("/")
async def read_root():
    return {"message": "Hello World"}
