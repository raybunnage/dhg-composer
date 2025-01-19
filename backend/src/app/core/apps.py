from enum import Enum
from typing import Dict, List, Optional
from pydantic import BaseModel


class AppFeature(str, Enum):
    AUTH = "auth"
    PAYMENTS = "payments"
    SCHEDULING = "scheduling"
    MARKETPLACE = "marketplace"
    VIDEOCONFERENCE = "videoconference"


class AppConfig(BaseModel):
    id: str
    name: str
    features: List[AppFeature]
    database_schema: str
    api_prefix: str
    cors_origins: List[str]


class AppRegistry:
    """Registry for managing multiple applications"""

    _apps: Dict[str, AppConfig] = {}
    _current_app: Optional[AppConfig] = None

    @classmethod
    def register_app(cls, config: AppConfig) -> None:
        cls._apps[config.id] = config

    @classmethod
    def get_app(cls, app_id: str) -> Optional[AppConfig]:
        return cls._apps.get(app_id)

    @classmethod
    def set_current_app(cls, app_id: str) -> None:
        cls._current_app = cls.get_app(app_id)

    @classmethod
    def get_current_app(cls) -> Optional[AppConfig]:
        return cls._current_app

    @classmethod
    def has_feature(cls, feature: AppFeature) -> bool:
        if not cls._current_app:
            return False
        return feature in cls._current_app.features
