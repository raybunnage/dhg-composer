from pydantic_settings import BaseSettings
from typing import List, Dict
import secrets


class Settings(BaseSettings):
    PROJECT_NAME: str = "Your Project Name"
    VERSION: str = "1.0.0"
    DESCRIPTION: str = "Your project description"
    API_V1_STR: str = "/api/v1"

    # Security
    SECRET_KEY: str = secrets.token_urlsafe(32)
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 days

    # Supabase
    SUPABASE_URL: str
    SUPABASE_KEY: str

    # CORS
    ALLOWED_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://localhost:8000",
    ]

    # App-specific settings
    APP_ID: str
    APP_FEATURES: Dict[str, bool]

    @property
    def is_app1(self) -> bool:
        return self.APP_ID == "app1"

    @property
    def is_app2(self) -> bool:
        return self.APP_ID == "app2"

    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
