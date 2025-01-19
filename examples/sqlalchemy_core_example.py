from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String

metadata = MetaData()

# Define tables without ORM
users = Table(
    "users",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("email", String),
    Column("full_name", String),
)

# Use SQL Expression Language
query = users.select().where(users.c.email == "user@example.com")
