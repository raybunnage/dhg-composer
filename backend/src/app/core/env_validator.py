from typing import Dict, Any
import os
from pathlib import Path
import logging
from pydantic import BaseModel, validator

logger = logging.getLogger(__name__)


class EnvironmentValidator(BaseModel):
    """Validates environment configuration"""

    # Required variables
    SUPABASE_URL: str
    SUPABASE_KEY: str
    ENV: str
    SECRET_KEY: str

    # Optional variables with defaults
    DEBUG: bool = False
    PORT: int = 8000

    @validator("SUPABASE_URL")
    def validate_supabase_url(cls, v: str) -> str:
        if not v.startswith(("http://", "https://")):
            raise ValueError("SUPABASE_URL must be a valid URL")
        if "supabase.co" not in v:
            raise ValueError("SUPABASE_URL must be a Supabase URL")
        return v

    @validator("SUPABASE_KEY")
    def validate_supabase_key(cls, v: str) -> str:
        if len(v) < 20:
            raise ValueError("SUPABASE_KEY is too short")
        return v

    @validator("ENV")
    def validate_env(cls, v: str) -> str:
        valid_envs = ["development", "staging", "production"]
        if v.lower() not in valid_envs:
            raise ValueError(f"ENV must be one of: {', '.join(valid_envs)}")
        return v.lower()

    @validator("SECRET_KEY")
    def validate_secret_key(cls, v: str) -> str:
        if len(v) < 32:
            raise ValueError("SECRET_KEY must be at least 32 characters")
        return v


def validate_environment() -> Dict[str, Any]:
    """Validates the current environment configuration"""
    try:
        env_vars = {
            "SUPABASE_URL": os.getenv("SUPABASE_URL"),
            "SUPABASE_KEY": os.getenv("SUPABASE_KEY"),
            "ENV": os.getenv("ENV", "development"),
            "SECRET_KEY": os.getenv("SECRET_KEY"),
            "DEBUG": os.getenv("DEBUG", "false").lower() == "true",
            "PORT": int(os.getenv("PORT", "8000")),
        }

        validator = EnvironmentValidator(**env_vars)
        return validator.dict()
    except Exception as e:
        logger.error(f"Environment validation failed: {str(e)}")
        raise
