from sqlalchemy import select
from app.models import User


# Clean, type-safe queries
async def get_user(db, email: str):
    query = select(User).where(User.email == email)
    result = await db.execute(query)
    return result.scalar_one_or_none()


# Relationships are easy
class User(Base):
    posts = relationship("Post", back_populates="author")


# Access related data naturally
user.posts  # Gets all posts by user
