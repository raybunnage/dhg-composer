from supabase import create_client, Client
from src.config.settings import get_settings
from fastapi import HTTPException
import logging

logger = logging.getLogger(__name__)


class SupabaseClient:
    def __init__(self):
        settings = get_settings()
        try:
            self.client: Client = create_client(
                supabase_url=settings.SUPABASE_URL, supabase_key=settings.SUPABASE_KEY
            )
        except Exception as e:
            logger.error(f"Failed to initialize Supabase client: {str(e)}")
            raise HTTPException(status_code=500, detail="Failed to initialize Supabase")

    async def get_client(self) -> Client:
        return self.client

    async def test_connection(self):
        try:
            result = self.client.table("test").select("*").limit(1).execute()
            return {
                "status": "success",
                "message": "Connected to Supabase successfully!",
                "data": result.data,
            }
        except Exception as e:
            logger.error(f"Supabase connection test failed: {str(e)}")
            raise HTTPException(status_code=500, detail=str(e))

    async def sign_up(self, email: str, password: str):
        """Handle user signup"""
        try:
            result = self.client.auth.sign_up({"email": email, "password": password})
            logger.info(f"Signup successful for email: {email}")
            return {
                "status": "success",
                "message": "Signup successful! Please check your email.",
                "data": result.user,
            }
        except Exception as e:
            logger.error(f"Signup failed for email {email}: {str(e)}")
            raise HTTPException(status_code=400, detail=str(e))

    async def sign_in(self, email: str, password: str):
        """Handle user signin"""
        try:
            result = self.client.auth.sign_in_with_password(
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
            raise HTTPException(status_code=400, detail=str(e))
