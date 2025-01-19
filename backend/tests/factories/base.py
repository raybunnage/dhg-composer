import factory
from typing import Any, Dict
from faker import Faker

fake = Faker()


class BaseFactory:
    """Base factory class with common functionality"""

    @classmethod
    def create(cls, **kwargs) -> Dict[str, Any]:
        """Create a dictionary of model data"""
        return factory.build(dict, FACTORY_CLASS=cls, **kwargs)

    @classmethod
    def create_batch(cls, size: int = 1, **kwargs) -> list[Dict[str, Any]]:
        """Create a batch of model data dictionaries"""
        return [cls.create(**kwargs) for _ in range(size)]
