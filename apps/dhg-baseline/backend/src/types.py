from pydantic import BaseModel, EmailStr
from typing import Optional


class User(BaseModel):
    id: str
    email: str
    aud: str
    role: Optional[str] = None
    email_confirmed_at: Optional[str] = None
    phone: Optional[str] = None
    last_sign_in_at: Optional[str] = None
    created_at: str
    updated_at: str


class Profile(BaseModel):
    id: str
    user_id: str
    username: Optional[str] = None
    full_name: Optional[str] = None
    avatar_url: Optional[str] = None
    website: Optional[str] = None
    created_at: str
    updated_at: str
