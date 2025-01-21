# Backend Setup Guide for Monorepo Pattern

This guide outlines the step-by-step process of setting up a FastAPI backend service within a monorepo structure, using DHG Baseline as a reference implementation.

## 1. Initial Directory Structure

bash
mkdir -p apps/dhg-baseline/backend/{src,tests,requirements}
cd apps/dhg-baseline/backend
Create core directories
mkdir -p src/{api,core,services}
mkdir -p tests/{api,services}
```

## 2. Set Up Python Environment

1. Create virtual environment:

```bash
python -m venv .venv
source .venv/bin/activate  # Unix
# or
.venv\Scripts\activate     # Windows
```

2. Create requirements files:

```text:requirements/requirements.base.txt
fastapi==0.104.1
uvicorn==0.24.0
python-dotenv==1.0.0
pydantic==2.4.2
sqlalchemy==2.0.23
alembic==1.12.1
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
```

```text:requirements/requirements.development.light.txt
-r requirements.base.txt
pytest==7.4.3
pytest-asyncio==0.21.1
httpx==0.25.1
black==23.11.0
isort==5.12.0
flake8==6.1.0
```

```text:requirements/requirements.production.txt
-r requirements.base.txt
gunicorn==21.2.0
uvicorn[standard]==0.24.0
```

## 3. Core Application Setup

1. Create main application file:

```python:src/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .core.config import settings
from .api import auth, users, health

app = FastAPI(title="DHG Baseline API")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router)
app.include_router(users.router)
app.include_router(health.router)
```

2. Create configuration:

```python:src/core/config.py
from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    PROJECT_NAME: str = "DHG Baseline API"
    VERSION: str = "0.1.0"
    API_V1_STR: str = "/api/v1"
    
    # Security
    SECRET_KEY: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # CORS
    CORS_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://localhost:5173",
    ]
    
    # Supabase
    SUPABASE_URL: str
    SUPABASE_KEY: str
    
    class Config:
        env_file = ".env"

settings = Settings()
```

## 4. API Structure

1. Create API routers:

```python:src/api/auth.py
from fastapi import APIRouter, Depends, HTTPException
from ..core.supabase import get_current_user
from ..services.auth import AuthService

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/login")
async def login(email: str, password: str):
    return await AuthService.login(email, password)

@router.get("/me")
async def get_current_user_info(user = Depends(get_current_user)):
    return user
```

```python:src/api/health.py
from fastapi import APIRouter

router = APIRouter(tags=["health"])

@router.get("/health")
async def health_check():
    return {"status": "healthy"}
```

## 5. Service Layer

1. Create service classes:

```python:src/services/auth.py
from typing import Optional
from ..core.supabase import supabase
from ..core.exceptions import AuthenticationError

class AuthService:
    @staticmethod
    async def login(email: str, password: str):
        try:
            response = await supabase.auth.sign_in_with_password({
                "email": email,
                "password": password
            })
            return response.data
        except Exception as e:
            raise AuthenticationError(str(e))
```

## 6. Testing Setup

1. Create test configuration:

```python:tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from src.main import app

@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def mock_supabase_client(mocker):
    return mocker.patch("src.core.supabase.supabase")
```

2. Create API tests:

```python:tests/api/test_auth.py
import pytest
from fastapi.testclient import TestClient
from unittest.mock import patch
from src.main import app

def test_login(client: TestClient, mock_supabase_client):
    mock_supabase_client.auth.sign_in_with_password.return_value = {
        "data": {"user": {"id": "123", "email": "test@example.com"}}
    }
    
    response = client.post("/auth/login", json={
        "email": "test@example.com",
        "password": "password123"
    })
    
    assert response.status_code == 200
    assert response.json()["user"]["id"] == "123"
```

## 7. Environment Setup

1. Create .env file:

```env:.env
SECRET_KEY=your-secret-key
SUPABASE_URL=your-supabase-url
SUPABASE_KEY=your-supabase-key
ENVIRONMENT=development
```

2. Create .env.example:

```env:.env.example
SECRET_KEY=
SUPABASE_URL=
SUPABASE_KEY=
ENVIRONMENT=development
```

## 8. Development Scripts

1. Create start script:

```bash:start.sh
#!/bin/bash
export PYTHONPATH=$PYTHONPATH:$(pwd)
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

2. Make it executable:
```bash
chmod +x start.sh
```

## 9. Docker Setup (Optional)

```dockerfile:Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements/requirements.production.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

## Best Practices

1. **Project Structure**
   - Keep related files together
   - Use clear naming conventions
   - Maintain separation of concerns

2. **Code Organization**
   - Router for routing logic
   - Services for business logic
   - Models for data structures
   - Core for shared functionality

3. **Testing**
   - Write tests for all endpoints
   - Mock external services
   - Use fixtures for common setup

4. **Security**
   - Use environment variables
   - Implement proper authentication
   - Validate all inputs

5. **Documentation**
   - Document all endpoints
   - Include setup instructions
   - Maintain API documentation

## Common Issues and Solutions

1. **Import Issues**
   - Set PYTHONPATH correctly
   - Use relative imports properly
   - Check module structure

2. **Environment Issues**
   - Verify .env file exists
   - Check variable names
   - Validate values

3. **Testing Problems**
   - Mock external services
   - Use proper fixtures
   - Handle async operations correctly