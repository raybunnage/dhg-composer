from typing import Any, Dict, List, Optional
from datetime import datetime
from app.core.cache import RedisCache
from app.core.logging import logger


class CacheMixin:
    """Mixin for adding caching capabilities to services"""

    _cache = RedisCache()

    async def get_cached(self, key: str) -> Optional[Any]:
        return await self._cache.get(key)

    async def set_cached(self, key: str, value: Any, expire: int = 3600) -> None:
        await self._cache.set(key, value, expire)

    async def clear_cached(self, key: str) -> None:
        await self._cache.delete(key)


class AuditMixin:
    """Mixin for adding audit logging to services"""

    def __init__(self):
        self.audit_logger = logger.get_audit_logger()

    async def log_action(
        self, action: str, user_id: str, details: Dict[str, Any], app_id: str
    ) -> None:
        await self.audit_logger.info(
            action,
            extra={
                "user_id": user_id,
                "app_id": app_id,
                "timestamp": datetime.utcnow(),
                "details": details,
            },
        )


class ValidationMixin:
    """Mixin for adding validation capabilities"""

    async def validate_entity(self, data: Dict[str, Any], schema: Any) -> None:
        try:
            schema(**data)
        except Exception as e:
            raise ValueError(f"Validation failed: {str(e)}")

    async def validate_permissions(
        self, user_id: str, action: str, resource: str, app_id: str
    ) -> bool:
        # Implement permission validation logic
        pass


class VersioningMixin:
    """Mixin for handling entity versioning"""

    async def create_version(
        self,
        entity_type: str,
        entity_id: str,
        data: Dict[str, Any],
        user_id: str,
        app_id: str,
    ) -> None:
        version = {
            "entity_type": entity_type,
            "entity_id": entity_id,
            "data": data,
            "created_by": user_id,
            "app_id": app_id,
            "created_at": datetime.utcnow(),
        }
        # Store version in database
        await self.versions_repository.create(version)
