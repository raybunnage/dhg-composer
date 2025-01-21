# Starting DHG Baseline Backend

## Development Server

Navigate to the backend directory:
```bash
cd apps/dhg-baseline/backend
```

Create and activate a virtual environment (first time only):
```bash
# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Unix/macOS:
source venv/bin/activate
# On Windows:
.\venv\Scripts\activate
```

Install dependencies (first time only):
```bash
# For development
pip install -r requirements/requirements.development.light.txt

# For production
pip install -r requirements/requirements.production.txt
```

Start the development server:
```bash
# Using the start script
./start.sh development

# Or directly with uvicorn
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

The server will start on `http://localhost:8000` by default.

## Alternative Commands

From the root directory:
```bash
# Using yarn workspace (if configured)
yarn baseline:backend dev

# Or using the direct path
cd apps/dhg-baseline/backend && ./start.sh development
```

## Environment Setup

Create and configure your environment variables:
```bash
cp .env.example .env
```

Required variables in `.env`:
```
SUPABASE_URL=your-supabase-url
SUPABASE_KEY=your-service-role-key
SUPABASE_JWT_SECRET=your-jwt-secret
DEBUG=True  # Set to False in production
```

## API Documentation

Once the server is running, you can access:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Health Check

Verify the server is running:
```bash
curl http://localhost:8000/health
```

## Common Issues

1. Port 8000 already in use:
   ```bash
   # Start on a different port
   uvicorn src.main:app --reload --port 8001
   ```

2. Dependencies issues:
   ```bash
   # Clean and reinstall
   rm -rf venv
   python -m venv venv
   source venv/bin/activate  # or .\venv\Scripts\activate on Windows
   pip install -r requirements/requirements.development.light.txt
   ```

3. Environment variables not loading:
   - Ensure `.env` file is in the correct location
   - Check file permissions
   - Verify no spaces around `=` in `.env` file

4. Database connection issues:
   - Verify Supabase credentials
   - Check network connectivity
   - Ensure proper permissions in Supabase

## Development Tools

Run tests:
```bash
pytest
```

Generate coverage report:
```bash
pytest --cov=src --cov-report=html
```

Format code:
```bash
black src tests
```

Lint code:
```bash
ruff src tests
```

## Production Deployment

For production deployment:
```bash
./start.sh production
```

This will:
- Install production dependencies
- Run with production settings
- Disable debug mode
- Use multiple workers
