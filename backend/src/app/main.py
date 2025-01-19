from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routes import api_router
from app.core.apps import AppRegistry, AppConfig
from app.middleware.app_context import AppContextMiddleware
from app.core.app_settings import APP_SETTINGS


def create_app() -> FastAPI:
    app = FastAPI(
        title=settings.PROJECT_NAME,
        version=settings.VERSION,
        description=settings.DESCRIPTION,
        openapi_url=f"{settings.API_V1_STR}/openapi.json",
    )

    # Register apps
    for app_id, settings in APP_SETTINGS.items():
        AppRegistry.register_app(
            AppConfig(
                id=app_id,
                name=f"Application {app_id}",
                features=list(settings.features.keys()),
                database_schema=app_id,
                api_prefix=f"/api/{settings.api_version}",
                cors_origins=[f"https://{app_id}.yourdomain.com"],
            )
        )

    # Configure CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.ALLOWED_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # Add middleware
    app.add_middleware(AppContextMiddleware)

    # Include routers with app context
    app.include_router(
        api_router, prefix="/{app_id}/api/v1", dependencies=[Depends(get_current_app)]
    )

    return app


app = create_app()
