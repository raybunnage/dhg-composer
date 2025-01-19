from typing import Dict
from pydantic import BaseModel
from .apps import AppFeature


class AppSettings(BaseModel):
    """App-specific settings"""

    theme: Dict[str, str]
    features: Dict[AppFeature, bool]
    api_version: str
    max_users: int
    storage_limit: int


APP_SETTINGS: Dict[str, AppSettings] = {
    "app1": AppSettings(
        theme={"primary": "#007bff", "secondary": "#6c757d"},
        features={
            AppFeature.AUTH: True,
            AppFeature.PAYMENTS: True,
            AppFeature.MARKETPLACE: False,
        },
        api_version="v1",
        max_users=1000,
        storage_limit=5_000_000,
    ),
    "app2": AppSettings(
        theme={"primary": "#28a745", "secondary": "#ffc107"},
        features={
            AppFeature.AUTH: True,
            AppFeature.SCHEDULING: True,
            AppFeature.VIDEOCONFERENCE: True,
        },
        api_version="v1",
        max_users=500,
        storage_limit=1_000_000,
    ),
}
