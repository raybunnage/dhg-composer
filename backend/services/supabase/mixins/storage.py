from typing import Optional, BinaryIO, List
from ..exceptions import SupabaseStorageError
from .utility import log_method
import logging

logger = logging.getLogger("supabase-service.storage")


class StorageMixin:
    """Storage related methods."""

    @log_method()
    async def upload_file(self, bucket: str, path: str, file: BinaryIO) -> str:
        """Upload a file to Supabase storage."""
        try:
            result = await self.supabase.storage.from_(bucket).upload(path, file)
            return result.get("Key")
        except Exception as e:
            raise SupabaseStorageError("Failed to upload file", original_error=e)

    @log_method()
    async def get_public_url(self, bucket: str, path: str) -> str:
        """Get public URL for a file."""
        try:
            return await self.supabase.storage.from_(bucket).get_public_url(path)
        except Exception as e:
            raise SupabaseStorageError("Failed to get public URL", original_error=e)

    @log_method()
    async def delete_file(self, bucket: str, path: str) -> bool:
        """Delete a file from storage."""
        try:
            await self.supabase.storage.from_(bucket).remove([path])
            return True
        except Exception as e:
            raise SupabaseStorageError("Failed to delete file", original_error=e)

    @log_method()
    async def list_files(self, bucket: str, path: str = "") -> List[str]:
        """List files in a bucket/path."""
        try:
            result = await self.supabase.storage.from_(bucket).list(path)
            return [item["name"] for item in result]
        except Exception as e:
            raise SupabaseStorageError("Failed to list files", original_error=e)
