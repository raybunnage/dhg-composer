#!/bin/bash

# Get the project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."
BACKEND_DIR="$PROJECT_ROOT/backend"

# Change to the backend directory
cd "$BACKEND_DIR"

# Run the Python verification script from sys directory
python "$PROJECT_ROOT/scripts/sys/verify_structure.py"

# Get the exit code
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Backend structure verification passed"
else
    echo "❌ Backend structure verification failed"
fi

exit $EXIT_CODE 