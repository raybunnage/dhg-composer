from datetime import datetime
from pydantic import BaseModel, Field
from typing import List


class Course(BaseModel):
    id: int
    title: str
    description: str
    instructor_id: int
    schedule: List[datetime]
    created_at: datetime = Field(default_factory=datetime.utcnow)
    updated_at: datetime = Field(default_factory=datetime.utcnow)
