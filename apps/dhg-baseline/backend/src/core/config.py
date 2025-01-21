from functools import lru_cache
from typing import Optional

from pydantic import BaseSettings, validator


class Settings(BaseSettings):
    # API Settings
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "DHG Baseline API"
    DEBUG: bool = False

    # CORS Settings
    BACKEND_CORS_ORIGINS: list[str] = ["http://localhost:5173"]  # Frontend URL

    # Supabase Settings
    SUPABASE_URL: str
    SUPABASE_KEY: str
    SUPABASE_JWT_SECRET: Optional[str] = None

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: str | list[str]) -> list[str]:
        if isinstance(v, str):
            return [i.strip() for i in v.split(",")]
        return v

    class Config:
        case_sensitive = True
        env_file = ".env"


@lru_cache()
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
