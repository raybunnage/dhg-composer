# DHG Composer Server Management

## to kill
lsof -i :8001
kill -9 $(lsof -t -i:8001)

lsof -i :5173
kill -9 $(lsof -t -i:5173)

## To Start backend

```
cd backend
venv\Scripts\activate

source venv/bin/activate

python --version
uvicorn main:app --reload --port 8001
```

## Start Frontend in a new terminal

```
cd frontend
npm install
npm run dev
```


## Verify Servers
- Backend API: http://localhost:8001
- Frontend App: http://localhost:5173
- Test endpoint: http://localhost:8001/test-supabase

## Common Issues
- If ports are already in use, use the kill commands above
- Make sure `.env` file exists in backend directory
- Verify virtual environment is activated for backend

## Backup and Restore Configuration

### Backup Configuration
```bash
# Make scripts executable (first time only)
chmod +x backup-config.sh
chmod +x restore-config.sh

# Run backup for current branch
./backup-config.sh
```

### Restore Configuration
```bash
# Restore .env and .vercel files for current branch
./restore-config.sh
```

### What Gets Backed Up
- Backend `.env` file
- Frontend `.env` file (if exists)
- `.vercel` directory

### Backup Location
- Files are stored in `.backup/<branch-name>/`
- Not tracked by git (in .gitignore)

## Branch Management

### Switch to Main Branch
```bash
# Backup current branch configuration
./backup-config.sh

# Switch to main branch
git checkout main

# Restore main branch configuration
./restore-config.sh
```

## Troubleshooting Vercel Deployments

### TypeScript Build Errors
If you see errors like "variable is declared but never read", you need to either:
1. Use the variables
2. Remove unused variables
3. Prefix with underscore to ignore

Example fixes:
```tsx
// Before (causes error):
const [error, setError] = useState<string>("");
const [users, setUsers] = useState<User[]>([]);

// Fix 1: Remove if not needed:
// Delete the unused lines

// Fix 2: Prefix with underscore if required for future use:
const [_error, _setError] = useState<string>("");
const [_users, _setUsers] = useState<User[]>([]);

// Fix 3: Use ESLint disable comment (not recommended but quick fix):
// @ts-ignore
const [error, setError] = useState<string>("");
```

### Common Build Errors
1. **"Command 'npm run build' exited with 2"**
   - Usually means TypeScript errors need fixing
   - Check the error log for specific file locations
   - Fix all TypeScript warnings before deploying

2. **Quick Fixes for Development:**
   ```bash
   # In your frontend directory:
   
   # 1. Run TypeScript check locally first
   npm run build
   
   # 2. Fix any errors it shows
   
   # 3. Commit and push changes
   git add .
   git commit -m "Fix TypeScript errors"
   git push
   ```

### Best Practices to Avoid Build Errors
1. Always run `npm run build` locally before pushing
2. Set up ESLint and TypeScript in your IDE
3. Fix warnings before they become deployment errors
4. Use proper TypeScript types for all variables

# Baseline Configuration

## DHG Baseline Branch

This branch (`dhg-baseline`) represents our stable foundation with core functionality.
It includes:

- Basic authentication
- Core data models
- Essential API endpoints

### Deployment URLs
- Production: https://your-app.vercel.app
- Baseline: https://dhg-baseline-your-app.vercel.app
- Development: https://development-your-app.vercel.app

### Working with the Baseline

1. To start a new feature:
   ```bash
   git checkout dhg-baseline
   git checkout -b feature/your-feature
   ```

2. To update baseline:
   - Create PR against dhg-baseline
   - Ensure all tests pass
   - Get required reviews
   - Merge only stable, tested features

3. Recovery process:
   If a feature branch becomes unstable:
   ```bash
   git checkout dhg-baseline
   git checkout -b feature/new-attempt
   ```

## Branch Structure

### Production Branch
- Name: `production`
- URLs:
  - Frontend: https://www.dhg-hub.org
  - API: https://api.dhg-hub.org
- Structure:
  ```text
  production/
  ├── frontend/    # React/TypeScript app
  └── backend/     # FastAPI server
  ```

### Baseline Branch
- Name: `dhg-baseline`
- URLs:
  - Frontend: https://baseline.dhg-hub.org
  - API: https://baseline-api.dhg-hub.org
- Structure:
  ```text
  dhg-baseline/
  ├── frontend/    # Stable frontend foundation
  └── backend/     # Stable backend foundation
  ```

### Staging Branch
- Name: `staging`
- URLs:
  - Frontend: https://staging.dhg-hub.org
  - API: https://staging-api.dhg-hub.org
- Structure:
  ```text
  staging/
  ├── frontend/    # Pre-release testing
  └── backend/     # Pre-release API testing
  ```

### Development Branch
- Name: `development`
- URLs:
  - Frontend: https://dev.dhg-hub.org
  - API: https://dev-api.dhg-hub.org
- Structure:
  ```text
  development/
  ├── frontend/    # Active frontend development
  └── backend/     # Active backend development
  ```

### Feature Branches
```text
feature/auth/
├── frontend/    # Auth-related frontend changes
└── backend/     # Auth-related backend changes

feature/data-model/
├── frontend/    # Data model frontend implementation
└── backend/     # Data model backend implementation
```

# Backend and Frontend Server Setup

## Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Activate virtual environment:
- Windows:
```bash
venv\Scripts\activate
```
- Mac/Linux:
```bash
source venv/bin/activate
```

3. Verify Python version:
```bash
python --version
```

4. Start the backend server:
```bash
uvicorn main:app --reload --port 8001
```

## Frontend Setup

1. In a new terminal, navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
npm install
```

3. Start the development server:
```bash
npm run dev
```
