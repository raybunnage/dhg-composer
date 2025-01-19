from typing import TypeVar, Type, Any

T = TypeVar("T")


class MixinMeta(type):
    """Metaclass for handling mixin composition"""

    def __new__(mcs, name: str, bases: tuple, namespace: dict) -> Type:
        # Collect all mixin methods and properties
        for base in bases:
            for key, value in base.__dict__.items():
                if not key.startswith("__"):
                    if key not in namespace:
                        namespace[key] = value
        return super().__new__(mcs, name, bases, namespace)


class BaseMixin:
    """Base class for all mixins"""

    __metaclass__ = MixinMeta
