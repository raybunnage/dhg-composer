from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from supabase import create_client
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
    allow_origins=["http://localhost:5173"],
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

if not url or not key:
    raise ValueError("SUPABASE_URL and SUPABASE_KEY must be set in .env file")

# Initialize Supabase client
supabase = create_client(url, key)


@app.get("/")
async def read_root():
    return {"message": "Hello World"}


@app.get("/api/data")
async def get_data():
    try:
        response = supabase.table("your_table").select("*").execute()
        return response.data
    except Exception as e:
        return {"error": str(e)}


# if __name__ == "__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8000)
