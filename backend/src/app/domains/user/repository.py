from typing import Optional, List
from datetime import datetime
from app.db.base import SupabaseDB
from .schemas import UserCreate, UserUpdate


class UserRepository:
    def __init__(self):
        self.db = SupabaseDB.get_client()

    async def create(self, user_data: UserCreate) -> dict:
        response = (
            self.db.table("users")
            .insert(
                {
                    "email": user_data.email,
                    "full_name": user_data.full_name,
                    # Note: Password handling is managed by Supabase Auth
                }
            )
            .execute()
        )

        return response.data[0] if response.data else None

    async def get_by_email(self, email: str) -> Optional[dict]:
        response = (
            self.db.table("users")
            .select("id, email, full_name, created_at")
            .eq("email", email)
            .execute()
        )

        return response.data[0] if response.data else None

    async def list_users(self, skip: int = 0, limit: int = 100) -> List[dict]:
        response = (
            self.db.table("users")
            .select("id, email, full_name, created_at")
            .range(skip, skip + limit)
            .execute()
        )

        return response.data

    async def update(self, user_id: int, user_data: UserUpdate) -> Optional[dict]:
        response = (
            self.db.table("users")
            .update(
                {
                    "email": user_data.email,
                    "full_name": user_data.full_name,
                    "updated_at": datetime.utcnow().isoformat(),
                }
            )
            .eq("id", user_id)
            .execute()
        )

        return response.data[0] if response.data else None
