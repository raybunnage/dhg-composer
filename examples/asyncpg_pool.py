# Efficient connection management
pool = await asyncpg.create_pool(
    user="postgres",
    password="secret",
    database="app",
    host="localhost",
    min_size=5,  # Keep 5 connections ready
    max_size=20,  # Scale up to 20 when needed
)
