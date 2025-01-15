from datetime import datetime
from typing import Optional
import logging
from functools import wraps
import jwt
from ..exceptions import SupabaseAuthenticationError

logger = logging.getLogger("supabase-service.utility")


def log_method():
    """Decorator for logging method calls and errors."""

    def decorator(func):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            try:
                logger.debug(
                    f"Calling {func.__name__} with args: {args}, kwargs: {kwargs}"
                )
                result = await func(*args, **kwargs)
                logger.debug(f"{func.__name__} completed successfully")
                return result
            except Exception as e:
                logger.error(f"Error in {func.__name__}: {str(e)}", exc_info=True)
                raise

        return wrapper

    return decorator


class UtilityMixin:
    """Utility methods."""

    @log_method()
    async def get_token_expiry(self, token: str) -> datetime:
        """Get token expiration timestamp."""
        try:
            decoded = jwt.decode(token, options={"verify_signature": False})
            return datetime.fromtimestamp(decoded["exp"])
        except Exception as e:
            raise SupabaseAuthenticationError(
                "Failed to decode token", original_error=e
            )

    @log_method()
    async def is_token_expiring_soon(
        self, token: str, threshold_minutes: int = 5
    ) -> bool:
        """Check if token is expiring soon."""
        try:
            expiry = await self.get_token_expiry(token)
            return (expiry - datetime.now()).total_seconds() < (threshold_minutes * 60)
        except Exception:
            return True

    @log_method()
    async def health_check(self) -> bool:
        """Check if Supabase connection is healthy."""
        try:
            await (
                self.supabase.from_("health_check")
                .select("count", count="exact")
                .execute()
            )
            return True
        except Exception:
            return False
