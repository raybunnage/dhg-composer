from app.services.supabase.mixins import SupabaseAuthMixin
from app.core.base.service import BaseService
from app.core.logger import get_logger
from .schemas import SignUpRequest, SignInRequest

logger = get_logger(__name__)


class AuthService(BaseService, SupabaseAuthMixin):
    """Authentication service using Supabase"""

    async def signup_user(self, request: SignUpRequest):
        return await self.sign_up(request.email, request.password)

    async def login_user(self, request: SignInRequest):
        return await self.sign_in(request.email, request.password)
