#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create backend directory structure
mkdir -p backend/{services/supabase/mixins,src/{api,core,models,utils},tests/{integration,unit}}

# Move requirements to a dedicated folder
mkdir -p backend/requirements
mv backend/requirements*.txt backend/requirements/ 2>/dev/null

# Create basic files if they don't exist
touch backend/src/api/__init__.py
touch backend/src/core/__init__.py
touch backend/src/models/__init__.py
touch backend/src/utils/__init__.py

# Create main.py if it doesn't exist
if [ ! -f backend/main.py ]; then
    cat > backend/main.py << EOL
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "API is running"}
EOL
fi

echo -e "${GREEN}Backend structure created successfully${NC}" 