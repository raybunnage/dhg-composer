from fastapi import Depends, HTTPException
from app.core.apps import AppRegistry, AppConfig


async def get_current_app() -> AppConfig:
    app = AppRegistry.get_current_app()
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")
    return app


async def require_feature(feature: str, app: AppConfig = Depends(get_current_app)):
    if not AppRegistry.has_feature(feature):
        raise HTTPException(
            status_code=403,
            detail=f"Feature {feature} not available in this application",
        )
