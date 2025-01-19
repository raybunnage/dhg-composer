from faker import Faker
from .base import BaseFactory

fake = Faker()


class UserFactory(BaseFactory):
    """Factory for generating user test data"""

    @classmethod
    def create(cls, **kwargs):
        """Create a user with default test data"""
        data = {
            "email": kwargs.get("email", fake.email()),
            "full_name": kwargs.get("full_name", fake.name()),
            "password": kwargs.get("password", "Test123!"),  # For testing only
            "is_active": kwargs.get("is_active", True),
            "is_superuser": kwargs.get("is_superuser", False),
            "created_at": kwargs.get("created_at", fake.date_time_this_year()),
        }
        return {**data, **kwargs}  # Override defaults with any provided kwargs

    @classmethod
    def create_superuser(cls, **kwargs):
        """Create a superuser"""
        return cls.create(is_superuser=True, **kwargs)

    @classmethod
    def create_inactive_user(cls, **kwargs):
        """Create an inactive user"""
        return cls.create(is_active=False, **kwargs)
