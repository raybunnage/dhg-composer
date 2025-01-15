from typing import Optional, Dict, Any
from datetime import datetime
import jwt
import logging
from supabase.exceptions import AuthApiError
from ..exceptions import SupabaseAuthenticationError
from .utility import log_method

logger = logging.getLogger("supabase-service.auth")

class AuthenticationMixin:
    """Authentication related methods."""
    
    @log_method()
    async def login(self, email: str, password: str) -> Dict[str, Any]:
        """Login with email and password."""
        try:
            if not email or not password:
                raise SupabaseAuthenticationError("Email and password are required")

            response = await self.supabase.auth.sign_in_with_password(
                {"email": email, "password": password}
            )

            if not response.user:
                raise SupabaseAuthenticationError("Login failed - no user returned")

            return {
                "user": response.user,
                "session": response.session
            }
        except AuthApiError as e:
            raise self.map_auth_error(e)
        except Exception as e:
            raise SupabaseAuthenticationError("Login failed", original_error=e)

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
        try:
            if not email or not password:
                raise SupabaseAuthenticationError("Email and password are required")

            response = await self.supabase.auth.sign_up(
                {"email": email, "password": password}
            )

            if not response.user:
                raise SupabaseAuthenticationError("Signup failed - no user created")

            return {
                "user": response.user,
                "session": response.session
            }
        except AuthApiError as e:
            raise self.map_auth_error(e)
        except Exception as e:
            raise SupabaseAuthenticationError("Signup failed", original_error=e)

    def map_auth_error(self, error: AuthApiError) -> SupabaseAuthenticationError:
        """Map Supabase auth errors to custom exceptions."""
        error_map = {
            'auth/invalid-email': 'Invalid email format',
            'auth/user-not-found': 'User not found',
            'auth/wrong-password': 'Invalid password',
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
                raise SupabaseAuthenticationError("Session refresh failed - no session returned")
            return True
        except AuthApiError as e:
            raise self.map_auth_error(e)
        except Exception as e:
            raise SupabaseAuthenticationError("Failed to refresh session", original_error=e)

    # ... (rest of your authentication methods) 