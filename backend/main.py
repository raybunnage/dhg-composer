from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from supabase import create_client, AsyncClient
from dotenv import load_dotenv
import os
from pathlib import Path

# Get the directory where main.py is located
BASE_DIR = Path(__file__).resolve().parent

# Load environment variables from .env file in the backend directory
load_dotenv(BASE_DIR / ".env")

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Get environment variables
url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_KEY")

print(f"Loading .env from: {BASE_DIR / '.env'}")
print(f"URL: {url}")
print(f"Key: {key}")

# Initialize Supabase client as async
supabase = AsyncClient(
    supabase_url=url,
    supabase_key=key,
)


@app.get("/")
async def read_root():
    return {"message": "Hello World"}


@app.get("/test-supabase")
async def test_supabase():
    try:
        # Use await with async client
        result = await supabase.from_("test").select("*").limit(1).execute()
        return {
            "status": "success",
            "message": "Connected to Supabase successfully!",
            "data": result.data,
        }
    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
            "details": "Connection test failed",
        }


@app.post("/test-supabase/add")
async def add_test_data():
    try:
        data = {
            "last_name": "Test",
            "first_name": "User",
            "username": "testuser",
            "user_initials": "TY",
        }
        # Use await with async client
        result = await supabase.table("test").insert(data).execute()
        return {
            "status": "success",
            "message": "Test data added successfully!",
            "data": result.data,
        }
    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
            "details": "Failed to add test data",
        }


# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)
