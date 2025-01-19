from datetime import datetime, timedelta
from typing import Any, Dict, List
import random
from faker import Faker

fake = Faker()


class TestDataGenerator:
    """Utility class for generating test data"""

    @staticmethod
    def generate_date_range(
        start_date: datetime = None, end_date: datetime = None
    ) -> tuple[datetime, datetime]:
        """Generate a random date range"""
        if not start_date:
            start_date = datetime.now() - timedelta(days=365)
        if not end_date:
            end_date = datetime.now()

        return (
            fake.date_time_between(start_date=start_date, end_date=end_date),
            fake.date_time_between(start_date=start_date, end_date=end_date),
        )

    @staticmethod
    def generate_user_data(count: int = 1) -> List[Dict[str, Any]]:
        """Generate a list of user data"""
        from ..factories.user import UserFactory

        return UserFactory.create_batch(size=count)

    @staticmethod
    def generate_auth_token() -> str:
        """Generate a fake auth token for testing"""
        return f"test_token_{fake.uuid4()}"
