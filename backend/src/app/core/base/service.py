from typing import Generic, TypeVar
from app.core.mixins.base import MixinMeta

T = TypeVar("T")


class BaseService(Generic[T], metaclass=MixinMeta):
    """Base service class that supports mixin composition"""

    def __init__(self, repository):
        self.repository = repository

    async def get(self, id: str) -> T:
        return await self.repository.get(id)

    async def list(self, filters: dict = None) -> list[T]:
        return await self.repository.list(filters)

    async def create(self, data: dict) -> T:
        return await self.repository.create(data)

    async def update(self, id: str, data: dict) -> T:
        return await self.repository.update(id, data)

    async def delete(self, id: str) -> None:
        await self.repository.delete(id)
