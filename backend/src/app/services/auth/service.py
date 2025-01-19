from app.services.supabase.mixins import SupabaseAuthMixin
from app.services.auth.schemas import SignUpRequest, SignInRequest
from app.core.logger import get_logger

logger = get_logger(__name__)


class AuthService(SupabaseAuthMixin):
    """Authentication service using Supabase"""

    async def signup_user(self, request: SignUpRequest):
        """Handle user signup"""
        try:
            return await self.sign_up(request.email, request.password)
        except Exception as e:
            logger.error(f"Signup failed: {str(e)}")
            raise

    async def login_user(self, request: SignInRequest):
        """Handle user login"""
        try:
            return await self.sign_in(request.email, request.password)
        except Exception as e:
            logger.error(f"Login failed: {str(e)}")
            raise
