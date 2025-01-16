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
