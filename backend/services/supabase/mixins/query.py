from typing import Any, List, Dict, Optional
from ..exceptions import SupabaseQueryError
from .utility import log_method
import logging

logger = logging.getLogger("supabase-service.query")


class QueryMixin:
    """Database query related methods."""

    @log_method()
    async def fetch_data(
        self, table: str, query: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """Fetch data from a table with query parameters."""
        try:
            result = await self.supabase.from_(table).select("*").match(query).execute()
            return result.data
        except Exception as e:
            raise SupabaseQueryError(
                f"Failed to fetch data from {table}", original_error=e
            )

    @log_method()
    async def insert_data(self, table: str, data: Dict[str, Any]) -> Dict[str, Any]:
        """Insert data into a table."""
        try:
            result = await self.supabase.from_(table).insert(data).execute()
            return result.data[0] if result.data else None
        except Exception as e:
            raise SupabaseQueryError(
                f"Failed to insert data into {table}", original_error=e
            )

    @log_method()
    async def update_data(
        self, table: str, match: Dict[str, Any], data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """Update data in a table."""
        try:
            result = (
                await self.supabase.from_(table).update(data).match(match).execute()
            )
            return result.data[0] if result.data else None
        except Exception as e:
            raise SupabaseQueryError(
                f"Failed to update data in {table}", original_error=e
            )

    @log_method()
    async def delete_data(self, table: str, match: Dict[str, Any]) -> bool:
        """Delete data from a table."""
        try:
            await self.supabase.from_(table).delete().match(match).execute()
            return True
        except Exception as e:
            raise SupabaseQueryError(
                f"Failed to delete data from {table}", original_error=e
            )
