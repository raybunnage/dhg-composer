from typing import Optional
import os
from supabase import create_client, Client
from .types import User, Profile


class SupabaseClient:
    def __init__(self, url: str, key: str):
        self.client: Client = create_client(url, key)

    async def get_user(self, jwt: str) -> Optional[User]:
        try:
            response = await self.client.auth.get_user(jwt)
            return response.user if response else None
        except Exception as e:
            print(f"Error getting user: {e}")
            return None

    async def get_profile(self, user_id: str) -> Optional[Profile]:
        try:
            response = (
                await self.client.from_("profiles")
                .select("*")
                .eq("id", user_id)
                .single()
                .execute()
            )
            return response.data if response else None
        except Exception as e:
            print(f"Error getting profile: {e}")
            return None
