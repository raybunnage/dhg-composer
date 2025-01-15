import logging
import sys
from typing import Optional
from pathlib import Path


def setup_logging(
    log_level: str = "INFO",
    log_file: Optional[Path] = None,
    service_name: str = "supabase-service",
) -> None:
    """Configure logging for the application."""

    # Create formatter
    formatter = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )

    # Configure root logger
    root_logger = logging.getLogger()
    root_logger.setLevel(log_level)

    # Console handler
    console_handler = logging.StreamHandler(sys.stdout)
    console_handler.setFormatter(formatter)
    root_logger.addHandler(console_handler)

    # File handler if log_file is specified
    if log_file:
        file_handler = logging.FileHandler(log_file)
        file_handler.setFormatter(formatter)
        root_logger.addHandler(file_handler)

    # Create service logger
    service_logger = logging.getLogger(service_name)
    service_logger.setLevel(log_level)

    return service_logger
