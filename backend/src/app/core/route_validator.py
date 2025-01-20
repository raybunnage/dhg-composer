from fastapi import Request
from app.core.config import settings
import logging

logger = logging.getLogger(__name__)


def validate_api_prefix(request: Request) -> bool:
    """Validate that the request path includes the correct API prefix"""
    path = request.url.path
    if not path.startswith(settings.API_V1_STR):
        logger.warning(
            f"Invalid API prefix: {path} - Expected prefix: {settings.API_V1_STR}"
        )
        return False
    return True
