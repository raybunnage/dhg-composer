from app.services.supabase.mixins import SupabaseQueryMixin
from app.core.base.service import BaseService


class TestService(BaseService, SupabaseQueryMixin):
    """Test service for Supabase connection testing"""

    async def test_db_connection(self):
        result = await self.test_connection()
        return {
            "status": "success",
            "message": "Connected to Supabase successfully!",
            "data": result,
        }

    async def add_sample_data(self):
        data = {
            "last_name": "Test",
            "first_name": "User",
            "username": "testuser",
            "user_initials": "TY",
        }
        result = await self.add_test_data(data)
        return {
            "status": "success",
            "message": "Test data added successfully!",
            "data": result,
        }
