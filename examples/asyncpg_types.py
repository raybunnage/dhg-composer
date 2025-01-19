# Automatic handling of PostgreSQL types
async def save_json(data: dict):
    # Automatically converts Python dict to JSONB
    await conn.execute(
        "INSERT INTO data (payload) VALUES ($1)",
        data,  # No manual JSON serialization needed
    )


# Handles complex types like arrays, JSON, UUID
async def get_tags():
    # Automatically converts PostgreSQL array to Python list
    return await conn.fetch("SELECT tags FROM posts WHERE id = $1", post_id)
