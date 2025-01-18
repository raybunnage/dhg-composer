"""
Scripts module for project automation and management.
This makes the scripts directory a proper Python package.
"""

from pathlib import Path

SCRIPTS_DIR = Path(__file__).parent
PROJECT_ROOT = SCRIPTS_DIR.parent
