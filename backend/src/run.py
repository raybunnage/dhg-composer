import os
from pathlib import Path
from dotenv import load_dotenv
import uvicorn
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def load_environment():
    """Load environment variables from the appropriate .env file"""
    # Get the backend root directory (two levels up from this file)
    backend_dir = Path(__file__).parent.parent.parent

    # Determine which env file to use
    env = os.getenv("ENV", "development")
    env_file = ".env" if env == "development" else f".env.{env}"
    env_path = backend_dir / env_file

    # Load environment variables
    if env_path.exists():
        load_dotenv(env_path)
        logger.info(f"Loaded environment from: {env_path}")
    else:
        logger.warning(f"Environment file not found: {env_path}")
        logger.info("Using existing environment variables")


if __name__ == "__main__":
    # Load environment before importing the app
    load_environment()

    # Import app after environment is loaded
    from app.main import app

    # Run the server
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=int(os.getenv("PORT", "8000")),
        reload=True,
        log_level=os.getenv("LOG_LEVEL", "info"),
    )
