class Queries:
    """Keep SQL queries organized and reusable"""

    # User queries
    GET_USER_BY_EMAIL = """
        SELECT id, email, full_name, created_at
        FROM users
        WHERE email = $1;
    """

    CREATE_USER = """
        INSERT INTO users (email, hashed_password, full_name)
        VALUES ($1, $2, $3)
        RETURNING id, email, full_name, created_at;
    """
