class SupabaseError(Exception):
    """Base Supabase error."""
    def __init__(self, message: str, original_error: Exception = None):
        self.message = message
        self.original_error = original_error
        super().__init__(self.message)

class SupabaseAuthenticationError(SupabaseError):
    """Authentication related errors."""
    pass

class SupabaseQueryError(SupabaseError):
    """Query related errors."""
    pass

class SupabaseStorageError(SupabaseError):
    """Storage related errors."""
    pass 