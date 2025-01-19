from fastapi import HTTPException, Depends
from app.core.config import settings
from typing import Callable


def require_feature(feature_name: str) -> Callable:
    """
    Creates a synchronous dependency that checks if a feature is enabled
    """

    def check_feature() -> bool:
        enabled = settings.APPS_ENABLED.get(feature_name, False)
        if not enabled:
            raise HTTPException(
                status_code=404, detail=f"Feature {feature_name} is not enabled"
            )
        return True

    return check_feature


# Usage in routes:
# @router.get("/endpoint")
# async def endpoint(
#     feature_enabled: bool = Depends(require_feature("feature_name"))
# ):
#     pass
