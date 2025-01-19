from typing import List, Dict, Optional
from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import validator, AnyHttpUrl
import secrets


class Settings(BaseSettings):
    # API Settings
    PROJECT_NAME: str = "DHG Backend"
    VERSION: str = "1.0.0"
    DESCRIPTION: str = "Multi-app FastAPI backend with Supabase integration"
    API_V1_STR: str = "/api/v1"

    # Environment
    ENV: str = "development"
    DEBUG: bool = True

    # Supabase
    SUPABASE_URL: str
    SUPABASE_KEY: str

    @validator("SUPABASE_URL")
    def validate_supabase_url(cls, v: str) -> str:
        if not v.startswith(("http://", "https://")):
            raise ValueError("SUPABASE_URL must be a valid URL")
        return v

    @validator("SUPABASE_KEY")
    def validate_supabase_key(cls, v: str) -> str:
        if len(v) < 20:  # Arbitrary minimum length for a valid key
            raise ValueError("SUPABASE_KEY seems invalid")
        return v

    # CORS Settings
    BACKEND_CORS_ORIGINS: List[AnyHttpUrl] = [
        "http://localhost:3000",  # React default
        "http://localhost:8000",  # Backend default
    ]

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: str | List[str]) -> List[str] | str:
        if isinstance(v, str):
            return [i.strip() for i in v.split(",")]
        return v

    # App Settings
    APPS_ENABLED: Dict[str, bool] = {"app1": True, "app2": True}

    # Security
    SECRET_KEY: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 days

    @validator("SECRET_KEY")
    def validate_secret_key(cls, v: str) -> str:
        if len(v) < 32:
            raise ValueError("SECRET_KEY must be at least 32 characters long")
        return v

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
    )


settings = Settings()
