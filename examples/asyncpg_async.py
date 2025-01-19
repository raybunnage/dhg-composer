# Clean async/await syntax
async def get_user(email: str):
    async with pool.acquire() as conn:
        return await conn.fetchrow("SELECT * FROM users WHERE email = $1", email)


# Can be used with FastAPI's async features
@app.get("/users/{email}")
async def read_user(email: str):
    user = await get_user(email)
    return user
