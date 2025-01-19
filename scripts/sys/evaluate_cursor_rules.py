# Add to CURSOR_RULES dictionary

CURSOR_RULES = {
    "python_package_management": {
        "priority": "high",
        "patterns": [
            r"pip install",
            r"pip uninstall",
            r"python -m pip",
            r"pip sync",
            r"pip freeze",  # Added to catch more pip commands
        ],
        "suggestions": [
            {
                "preferred": "uv pip install",
                "instead_of": "pip install",
                "reason": "uv is faster and more reliable than pip for Python package management",
            },
            {
                "preferred": "uv pip uninstall",
                "instead_of": "pip uninstall",
                "reason": "Use uv for consistent package management",
            },
            {
                "preferred": "uv pip sync requirements/requirements.development.txt",
                "instead_of": "pip install -r requirements/requirements.development.txt",
                "reason": "uv sync ensures exact dependency matching and is faster",
            },
            {
                "preferred": "uv pip freeze",
                "instead_of": "pip freeze",
                "reason": "uv provides more accurate dependency tracking",
            },
        ],
        "documentation": """
        Use uv instead of pip for Python package management:
        - Faster installation and dependency resolution
        - Better caching and reproducibility
        - Improved security with lockfile support
        
        Examples:
        ✅ uv pip install package-name
        ✅ uv pip sync requirements.txt
        ✅ uv pip freeze > requirements.txt
        ❌ pip install package-name
        ❌ pip install -r requirements.txt
        ❌ pip freeze > requirements.txt
        """,
    },
    "python_dependency_management": {
        "priority": "high",
        "patterns": [
            r"requirements\.txt",
            r"pip list",
            r"pip check",
            r"pip show",
            r"pip-compile",
            r"pip-sync",
        ],
        "suggestions": [
            {
                "preferred": "uv pip compile requirements/requirements.in -o requirements/requirements.txt",
                "instead_of": "pip-compile requirements.in",
                "reason": "uv compile is faster and provides better dependency resolution",
            },
            {
                "preferred": "uv pip sync requirements/requirements.txt",
                "instead_of": "pip-sync requirements.txt",
                "reason": "uv sync ensures exact dependency matching and is faster",
            },
            {
                "preferred": "uv pip list --outdated",
                "instead_of": "pip list --outdated",
                "reason": "uv provides more accurate outdated package detection",
            },
            {
                "preferred": "uv pip show package-name",
                "instead_of": "pip show package-name",
                "reason": "uv provides more detailed package information",
            },
        ],
        "documentation": """
        Best practices for Python dependency management with uv:
        
        1. Use requirements.in files for direct dependencies:
        ✅ List only direct dependencies in requirements.in
        ✅ Use uv pip compile to generate requirements.txt
        
        2. Lock file workflow:
        ✅ uv pip compile requirements.in -o requirements.txt
        ✅ uv pip sync requirements.txt
        
        3. Dependency updates:
        ✅ uv pip list --outdated
        ✅ Update version in requirements.in
        ✅ Recompile requirements.txt
        
        4. Environment consistency:
        ✅ Always use uv pip sync after requirements.txt changes
        ✅ Use uv pip freeze to capture current state
        
        ❌ Avoid manual editing of requirements.txt
        ❌ Avoid pip install without sync
        ❌ Avoid mixing pip and uv in same project
        """,
    },
    "venv_management": {
        "priority": "high",
        "patterns": [
            r"python -m venv",
            r"virtualenv",
            r"source.*activate",
        ],
        "suggestions": [
            {
                "preferred": "uv venv",
                "instead_of": "python -m venv",
                "reason": "uv venv creates optimized virtual environments",
            },
            {
                "preferred": "source .venv/bin/activate && uv pip sync requirements.txt",
                "instead_of": "source venv/bin/activate && pip install -r requirements.txt",
                "reason": "Use uv for consistent environment setup",
            },
        ],
        "documentation": """
        Virtual environment best practices with uv:
        
        1. Creation:
        ✅ uv venv .venv
        ✅ source .venv/bin/activate
        
        2. Initial setup:
        ✅ uv pip sync requirements/requirements.development.txt
        
        3. Maintenance:
        ✅ uv pip sync after any requirements changes
        ✅ uv pip freeze to capture environment state
        
        ❌ Avoid mixing different venv tools
        ❌ Avoid manual pip installs in venv
        """,
    },
}
