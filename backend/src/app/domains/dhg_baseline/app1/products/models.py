from datetime import datetime
from pydantic import BaseModel, Field


class Product(BaseModel):
    id: int
    name: str
    price: float
    description: str
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
