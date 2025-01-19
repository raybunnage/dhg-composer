#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the backend directory
cd "$SCRIPT_DIR/.."

# Run the Python verification script
python scripts/verify_structure.py

# Get the exit code
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Backend structure verification passed"
else
    echo "❌ Backend structure verification failed"
fi

exit $EXIT_CODE 