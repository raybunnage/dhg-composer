"""
Utility functions for script operations.
"""

import os
from pathlib import Path


def get_project_root():
    """Get the project root directory."""
    return Path(__file__).parent.parent


def get_scripts_dir():
    """Get the scripts directory."""
    return Path(__file__).parent


def ensure_directory(path):
    """Ensure a directory exists."""
    os.makedirs(path, exist_ok=True)
    return path
