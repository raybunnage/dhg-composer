from contextlib import asynccontextmanager


class PostgresDB:
    def __init__(self, dsn: str):
        self._pool = None
        self._dsn = dsn

    async def connect(self):
        if not self._pool:
            self._pool = await asyncpg.create_pool(
                self._dsn,
                min_size=2,
                max_size=10,
                command_timeout=60,
                statement_cache_size=100,
            )

    @asynccontextmanager
    async def transaction(self):
        async with self._pool.acquire() as conn:
            async with conn.transaction():
                yield conn
