from typing import Optional, Dict, Any
from datetime import datetime
import jwt
import logging
from gotrue.errors import AuthApiError
from ..exceptions import SupabaseAuthenticationError
from .utility import log_method

logger = logging.getLogger("supabase-service.auth")


class AuthenticationMixin:
    """Authentication related methods."""

    @log_method()
    async def login(self, email: str, password: str) -> Dict[str, Any]:
        """Login with email and password."""
        logger.info(f"Login attempt for email: {email}")
        try:
            result = await self.supabase.auth.sign_in_with_password(
                {"email": email, "password": password}
            )
            logger.info(f"Login successful for email: {email}")
            return {
                "status": "success",
                "message": "Login successful!",
                "data": result.user,
                "session": result.session,
            }
        except Exception as e:
            logger.error(f"Login failed for email {email}: {str(e)}")
            raise SupabaseAuthenticationError(str(e))

    @log_method()
    async def logout(self) -> bool:
        """Logout the current user."""
        try:
            await self.supabase.auth.sign_out()
            return True
        except AuthApiError as e:
            raise self.map_auth_error(e)
        except Exception as e:
            raise SupabaseAuthenticationError("Logout failed", original_error=e)

    @log_method()
    async def signup(self, email: str, password: str) -> Dict[str, Any]:
        """Sign up a new user."""
        logger.info(f"Signup attempt for email: {email}")
        try:
            result = await self.supabase.auth.sign_up(
                {"email": email, "password": password}
            )
            logger.info(f"Signup successful for email: {email}")
            return {
                "status": "success",
                "message": "Signup successful! Please check your email.",
                "data": result.user,
            }
        except Exception as e:
            logger.error(f"Signup failed for email {email}: {str(e)}")
            raise SupabaseAuthenticationError(str(e))

    def map_auth_error(self, error: AuthApiError) -> SupabaseAuthenticationError:
        """Map Supabase auth errors to custom exceptions."""
        error_map = {
            "auth/invalid-email": "Invalid email format",
            "auth/user-not-found": "User not found",
            "auth/wrong-password": "Invalid password",
            # Add more mappings as needed
        }

        message = error_map.get(str(error.code), str(error))
        return SupabaseAuthenticationError(message, original_error=error)

    @log_method()
    async def refresh_session(self) -> bool:
        """Refresh the current session."""
        try:
            response = await self.supabase.auth.refresh_session()
            if not response.session:
                raise SupabaseAuthenticationError(
                    "Session refresh failed - no session returned"
                )
            return True
        except AuthApiError as e:
            raise self.map_auth_error(e)
        except Exception as e:
            raise SupabaseAuthenticationError(
                "Failed to refresh session", original_error=e
            )

    # ... (rest of your authentication methods)
