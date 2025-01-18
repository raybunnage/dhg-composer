from functools import wraps
from typing import Callable, Optional, Any, Union


def docs(description: Optional[str] = None) -> Callable:
    """
    A decorator that adds documentation to functions, methods, and classes.

    Args:
        description (str, optional): Documentation text for the decorated object

    Returns:
        Callable: The decorated function/class with added documentation

    Examples:
        # Function documentation
        @docs("Adds two numbers and returns their sum")
        def add(a: int, b: int) -> int:
            return a + b

        # Class documentation
        @docs("A user class to store user information")
        class User:
            def __init__(self, name: str):
                self.name = name

        # Method documentation
        class Calculator:
            @docs("Multiplies two numbers")
            def multiply(self, x: int, y: int) -> int:
                return x * y
    """

    def decorator(obj: Union[Callable, type]) -> Union[Callable, type]:
        # Add documentation
        if description:
            obj.__doc__ = description

        # Only wrap if it's a function/method, not a class
        if isinstance(obj, type):
            return obj

        @wraps(obj)
        def wrapper(*args, **kwargs):
            return obj(*args, **kwargs)

        return wrapper

    return decorator
