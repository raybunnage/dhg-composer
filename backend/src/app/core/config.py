from typing import List, Dict, Optional, Union
from pydantic import BaseSettings, validator, AnyHttpUrl, HttpUrl, Field
import secrets
import json
import os
from pathlib import Path

# At the top of the file
current_dir = Path(__file__).parent
env_file = current_dir.parent.parent.parent / ".env.dev"
print(f"Looking for env file at: {env_file}")
print(f"File exists: {env_file.exists()}")

if env_file.exists():
    print("Environment variables in file:")
    with open(env_file) as f:
        for line in f:
            if line.strip() and not line.startswith("#"):
                print(f"  {line.strip()}")


class Settings(BaseSettings):
    # Database Settings
    DATABASE_URL: Optional[str] = None  # Make it optional

    # Server Settings
    PORT: int = 8001
    ENVIRONMENT: str = "development"

    # API Settings
    PROJECT_NAME: str = "DHG Composer"
    VERSION: str = "0.1.0"
    DESCRIPTION: str = "Multi-app FastAPI backend with Supabase integration"

    # Environment
    ENV: str = "development"
    DEBUG: bool = True

    # Supabase - with better error messages
    SUPABASE_URL: str
    SUPABASE_KEY: str

    @validator("SUPABASE_URL")
    def validate_supabase_url(cls, v: str) -> str:
        if not v.startswith(("http://", "https://")):
            raise ValueError("SUPABASE_URL must be a valid URL")
        if not "supabase.co" in v:
            raise ValueError("SUPABASE_URL must be a Supabase URL")
        return v

    @validator("SUPABASE_KEY")
    def validate_supabase_key(cls, v: str) -> str:
        if len(v) < 20:  # Arbitrary minimum length for a valid key
            raise ValueError("SUPABASE_KEY seems invalid")
        return v

    # CORS Settings - Temporarily disable validation
    BACKEND_CORS_ORIGINS: List[str] = [
        "*"
    ]  # Changed from List[AnyHttpUrl] to List[str]

    @validator("BACKEND_CORS_ORIGINS", pre=True)
    def assemble_cors_origins(cls, v: Union[str, List[str]]) -> List[str]:
        # Temporarily bypass validation
        return ["*"]

    # App Settings
    APPS_ENABLED: Dict[str, bool] = {"app1": True, "app2": True}

    # Security
    SECRET_KEY: Optional[str] = None
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 8  # 8 days

    @validator("SECRET_KEY")
    def validate_secret_key(cls, v: Optional[str]) -> Optional[str]:
        if v is None:  # Handle None case first
            return v
        if len(v) < 32:
            raise ValueError("SECRET_KEY must be at least 32 characters long")
        return v

    class Config:
        env_file = ".env.dev"
        case_sensitive = True


settings = Settings()
