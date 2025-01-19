from fastapi.openapi.utils import get_openapi
from app.core.config import settings


def custom_openapi(app):
    if app.openapi_schema:
        return app.openapi_schema

    openapi_schema = get_openapi(
        title=settings.PROJECT_NAME,
        version=settings.VERSION,
        description=settings.DESCRIPTION,
        routes=app.routes,
    )

    # Custom documentation settings
    openapi_schema["info"]["x-logo"] = {"url": "https://your-domain.com/logo.png"}

    app.openapi_schema = openapi_schema
    return app.openapi_schema
