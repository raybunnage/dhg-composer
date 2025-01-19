from asyncpg import UniqueViolationError, ForeignKeyViolationError


async def safe_fetch(conn, query, *args):
    try:
        return await conn.fetchrow(query, *args)
    except UniqueViolationError:
        raise HTTPException(status_code=409, detail="Resource already exists")
    except ForeignKeyViolationError:
        raise HTTPException(status_code=404, detail="Referenced resource not found")
