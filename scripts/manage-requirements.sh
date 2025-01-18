#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Requirements file locations
REQ_DIR="requirements"
mkdir -p ${REQ_DIR}

# Create base requirements if it doesn't exist
if [ ! -f "${REQ_DIR}/requirements.txt" ]; then
    cat > "${REQ_DIR}/requirements.txt" << EOL
# Base requirements for all environments
fastapi>=0.68.0
pydantic>=1.8.0
sqlalchemy>=1.4.0
python-jose[cryptography]>=3.3.0
passlib[bcrypt]>=1.7.4
python-multipart>=0.0.5
uvicorn>=0.15.0
supabase>=0.7.1
python-dotenv>=0.19.0
EOL
fi

# Create development requirements
if [ ! -f "${REQ_DIR}/requirements.dev.txt" ]; then
    cat > "${REQ_DIR}/requirements.dev.txt" << EOL
# Development requirements
-r requirements.txt

# Testing
pytest>=7.0.0
pytest-cov>=3.0.0
pytest-asyncio>=0.18.0
httpx>=0.23.0

# Linting and formatting
black>=22.3.0
flake8>=4.0.0
isort>=5.10.0
mypy>=0.950

# Debugging
ipython>=8.0.0
debugpy>=1.6.0

# Documentation
mkdocs>=1.3.0
mkdocs-material>=8.2.0
EOL
fi

# Create staging requirements
if [ ! -f "${REQ_DIR}/requirements.staging.txt" ]; then
    cat > "${REQ_DIR}/requirements.staging.txt" << EOL
# Staging requirements
-r requirements.txt

# Monitoring and logging
sentry-sdk>=1.5.0
prometheus-client>=0.14.0
python-json-logger>=2.0.0

# Testing
pytest>=7.0.0
pytest-cov>=3.0.0
EOL
fi

# Create production requirements
if [ ! -f "${REQ_DIR}/requirements.prod.txt" ]; then
    cat > "${REQ_DIR}/requirements.prod.txt" << EOL
# Production requirements
-r requirements.txt

# Performance and monitoring
gunicorn>=20.1.0
uvicorn[standard]>=0.17.0
sentry-sdk>=1.5.0
prometheus-client>=0.14.0
python-json-logger>=2.0.0
EOL
fi

echo -e "${GREEN}Requirements files created in ${REQ_DIR}/${NC}" 