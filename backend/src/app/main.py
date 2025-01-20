import os
from pathlib import Path
from dotenv import load_dotenv
from fastapi import FastAPI, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routes import api_router
from app.core.apps import AppRegistry, AppConfig
from app.middleware.app_context import AppContextMiddleware
from app.core.app_settings import APP_SETTINGS
import logging
from app.core.env_validator import validate_environment
import time
from app.domains.auth.routes import router as auth_router

# Load environment variables
ENV = os.getenv("ENV", "development")
env_file = f".env.{ENV}" if ENV != "development" else ".env"
load_dotenv(Path(__file__).parent.parent.parent / env_file)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def create_app() -> FastAPI:
    # Validate environment before creating app
    try:
        env_config = validate_environment()
        logger.info(f"Environment validated successfully: {env_config['ENV']}")
    except Exception as e:
        logger.error(f"Environment validation failed: {str(e)}")
        # Don't raise here, continue with defaults
        logger.warning("Continuing with default configuration")

    app = FastAPI(
        title=settings.PROJECT_NAME,
        description=settings.DESCRIPTION,
        version=settings.VERSION,
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

    # Mount routers directly without v1 prefix
    app.include_router(auth_router, prefix="/auth", tags=["auth"])
    app.include_router(api_router, prefix="/api")

    @app.middleware("http")
    async def log_requests(request: Request, call_next):
        start_time = time.time()
        path = request.url.path
        method = request.method

        # Add more detailed path logging with proper formatting
        logger.info(
            f"Request Details:\n"
            f"- Method: {method}\n"
            f"- Full Path: {path}\n"
            f"- API Prefix Check: {path.startswith('/api')}\n"
            f"- Expected Prefix: /api\n"
            f"- Headers: {dict(request.headers)}"
        )

        response = await call_next(request)

        process_time = time.time() - start_time
        logger.info(
            f"Request completed: {method} {path} - Status: {response.status_code} - Time: {process_time:.2f}s"
        )

        return response

    return app


app = create_app()


@app.get("/")
async def read_root():
    return {"message": "Hello World"}
