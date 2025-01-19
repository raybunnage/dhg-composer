import os
from pathlib import Path
import logging
from typing import List, Dict

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

REQUIRED_STRUCTURE = {
    "src/app": {
        "dirs": [
            "core",
            "domains",
            "services",
            "middleware",
            "api",
        ],
        "files": [
            "main.py",
            "__init__.py",
        ],
    },
    "src/app/core": {
        "files": [
            "__init__.py",
            "config.py",
            "logger.py",
            "deps.py",
            "apps.py",
            "env_validator.py",
        ]
    },
    "src/app/domains": {
        "dirs": [
            "auth",
            "test",
        ],
        "files": [
            "__init__.py",
        ],
    },
    "src/app/domains/auth": {
        "files": [
            "__init__.py",
            "routes.py",
        ]
    },
    "src/app/services": {
        "dirs": [
            "auth",
            "supabase",
        ],
        "files": [
            "__init__.py",
        ],
    },
    "src/app/services/auth": {
        "files": [
            "__init__.py",
            "service.py",
            "schemas.py",
        ]
    },
    "src/app/services/supabase": {
        "files": [
            "__init__.py",
            "auth.py",
            "client.py",
            "mixins.py",
        ]
    },
    "src": {
        "files": [
            "run.py",
            "__init__.py",
        ]
    },
}


def verify_path(base_path: Path, structure: Dict) -> List[str]:
    """Verify directory structure and return missing items"""
    missing = []

    # Check required directories
    if "dirs" in structure:
        for dir_name in structure["dirs"]:
            dir_path = base_path / dir_name
            if not dir_path.exists():
                missing.append(f"Directory missing: {dir_path}")

    # Check required files
    if "files" in structure:
        for file_name in structure["files"]:
            file_path = base_path / file_name
            if not file_path.exists():
                missing.append(f"File missing: {file_path}")

    return missing


def verify_imports(file_path: Path) -> List[str]:
    """Verify imports in a Python file use absolute paths"""
    issues = []

    if not file_path.exists() or not file_path.suffix == ".py":
        return issues

    with open(file_path, "r") as f:
        lines = f.readlines()

    for i, line in enumerate(lines, 1):
        if line.strip().startswith("from .") or line.strip().startswith("import ."):
            issues.append(f"{file_path}:{i} - Relative import found: {line.strip()}")
        elif line.strip().startswith("from") and not line.strip().startswith(
            "from app."
        ):
            # Exclude standard library imports
            if not any(
                line.strip().startswith(f"from {lib}")
                for lib in ["typing", "datetime", "pathlib", "logging", "os", "re"]
            ):
                issues.append(
                    f"{file_path}:{i} - Non-absolute import found: {line.strip()}"
                )

    return issues


def main():
    # Get backend directory
    backend_dir = Path(__file__).parent.parent

    # Track all issues
    all_issues = []

    # Verify directory structure
    logger.info("Verifying directory structure...")
    for rel_path, requirements in REQUIRED_STRUCTURE.items():
        path = backend_dir / rel_path
        issues = verify_path(path, requirements)
        all_issues.extend(issues)

    # Verify imports in Python files
    logger.info("Verifying imports...")
    for root, _, files in os.walk(backend_dir / "src"):
        for file in files:
            if file.endswith(".py"):
                file_path = Path(root) / file
                import_issues = verify_imports(file_path)
                all_issues.extend(import_issues)

    # Report results
    if all_issues:
        logger.error("Structure verification failed!")
        for issue in all_issues:
            logger.error(issue)
        return 1
    else:
        logger.info("Structure verification passed!")
        return 0


if __name__ == "__main__":
    exit(main())
