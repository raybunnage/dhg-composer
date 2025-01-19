from typing import Dict, Any, List, Optional
import os
from pathlib import Path
import logging
import re
from pydantic import BaseModel, validator, AnyHttpUrl, SecretStr
from urllib.parse import urlparse

logger = logging.getLogger(__name__)


class EnvironmentValidator(BaseModel):
    """Validates environment configuration"""

    # Required variables
    SUPABASE_URL: AnyHttpUrl
    SUPABASE_KEY: SecretStr
    ENV: str
    SECRET_KEY: Optional[SecretStr] = None  # Make it optional for now

    # Optional variables with defaults
    DEBUG: bool = False
    PORT: int = 8000
    LOG_LEVEL: str = "info"
    BACKEND_CORS_ORIGINS: List[str] = ["http://localhost:3000"]
    DATABASE_URL: Optional[str] = None

    @validator("SUPABASE_URL")
    def validate_supabase_url(cls, v: str) -> str:
        parsed = urlparse(str(v))
        if not parsed.scheme in ["http", "https"]:
            raise ValueError("SUPABASE_URL must use http(s) protocol")
        if not "supabase.co" in parsed.netloc:
            raise ValueError("SUPABASE_URL must be a Supabase URL")
        return str(v)

    @validator("SUPABASE_KEY")
    def validate_supabase_key(cls, v: SecretStr) -> SecretStr:
        key = v.get_secret_value()
        if len(key) < 20:
            raise ValueError("SUPABASE_KEY is too short")
        if not re.match(r"^[a-zA-Z0-9._-]+$", key):
            raise ValueError("SUPABASE_KEY contains invalid characters")
        return v

    @validator("ENV")
    def validate_env(cls, v: str) -> str:
        valid_envs = ["development", "staging", "production"]
        if v.lower() not in valid_envs:
            raise ValueError(f"ENV must be one of: {', '.join(valid_envs)}")
        return v.lower()

    @validator("SECRET_KEY")
    def validate_secret_key(cls, v: Optional[SecretStr]) -> Optional[SecretStr]:
        if v is None:
            return v
        key = v.get_secret_value()
        if len(key) < 32:
            raise ValueError("SECRET_KEY must be at least 32 characters")
        if not any(c.isupper() for c in key):
            raise ValueError("SECRET_KEY must contain at least one uppercase letter")
        return v

    @validator("PORT")
    def validate_port(cls, v: int) -> int:
        if not 1024 <= v <= 65535:
            raise ValueError("PORT must be between 1024 and 65535")
        return v

    @validator("LOG_LEVEL")
    def validate_log_level(cls, v: str) -> str:
        valid_levels = ["debug", "info", "warning", "error", "critical"]
        if v.lower() not in valid_levels:
            raise ValueError(f"LOG_LEVEL must be one of: {', '.join(valid_levels)}")
        return v.lower()

    @validator("BACKEND_CORS_ORIGINS")
    def validate_cors_origins(cls, v: List[str]) -> List[str]:
        validated = []
        for origin in v:
            try:
                parsed = urlparse(origin)
                if not parsed.scheme or not parsed.netloc:
                    raise ValueError
                validated.append(origin)
            except ValueError:
                raise ValueError(f"Invalid CORS origin: {origin}")
        return validated

    @validator("DATABASE_URL")
    def validate_database_url(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return v
        if not v.startswith("postgresql://"):
            raise ValueError("DATABASE_URL must be a PostgreSQL connection string")
        return v


def validate_environment() -> Dict[str, Any]:
    """Validates the current environment configuration"""
    try:
        # Load all environment variables
        env_vars = {
            "SUPABASE_URL": os.getenv("SUPABASE_URL"),
            "SUPABASE_KEY": os.getenv("SUPABASE_KEY"),
            "ENV": os.getenv("ENV", "development"),
            "SECRET_KEY": os.getenv("SECRET_KEY"),
            "DEBUG": os.getenv("DEBUG", "false").lower() == "true",
            "PORT": int(os.getenv("PORT", "8000")),
            "LOG_LEVEL": os.getenv("LOG_LEVEL", "info"),
            "BACKEND_CORS_ORIGINS": os.getenv(
                "BACKEND_CORS_ORIGINS", "http://localhost:3000"
            ).split(","),
            "DATABASE_URL": os.getenv("DATABASE_URL"),
        }

        # Validate environment
        validator = EnvironmentValidator(**env_vars)
        config = validator.dict()

        # Log validation success (excluding sensitive data)
        safe_config = {
            k: v for k, v in config.items() if k not in ["SUPABASE_KEY", "SECRET_KEY"]
        }
        logger.info(f"Environment validated successfully: {safe_config}")

        return config
    except Exception as e:
        logger.error(f"Environment validation failed: {str(e)}")
        raise
