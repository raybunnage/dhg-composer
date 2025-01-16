# DHG Composer Server Management

## to kill
lsof -i :8001
kill -9 $(lsof -t -i:8001)

lsof -i :5173
kill -9 $(lsof -t -i:5173)

## to start

cd backend
venv\Scripts\activate
source venv/bin/activate
python --version
uvicorn main:app --reload --port 8001


## in a new terminal

cd frontend
npm install
npm run dev

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
