from typing import Optional
from pydantic import BaseModel
from datetime import datetime


class User(BaseModel):
    id: str
    email: str
    created_at: datetime
    updated_at: datetime


class Profile(BaseModel):
    id: str
    created_at: datetime
    updated_at: datetime
    email: str
    full_name: Optional[str] = None
    avatar_url: Optional[str] = None


class AuthResponse(BaseModel):
    user: Optional[User] = None
    error: Optional[str] = None
