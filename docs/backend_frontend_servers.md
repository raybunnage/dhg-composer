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

## Git Sync Commands

### Sync Main Branch
```bash
# First, make sure you're on main branch
git checkout main

# Pull any changes that might be on remote main
git pull origin main

# Push your merge changes to remote main
git push origin main
```

### Optional: Set Up Branch Tracking
```bash
# Set up tracking for main branch (only need to do once)
git branch --set-upstream-to=origin/main main

# After setting up tracking, you can simply use:
git pull
git push
```

## Git Merge Guide

### Basic Merge Process
```bash
# 1. Save your current work
./backup-config.sh
git add .
git commit -m "Save current changes"

# 2. Switch to main and update it
git checkout main
git pull origin main
./restore-config.sh

# 3. Merge your feature branch
git merge your-branch-name

# 4. If there are conflicts:
# Edit the conflicting files
git add .
git commit -m "Resolve merge conflicts"

# 5. Push the merged changes
git push origin main
```

### Types of Merges
1. **Fast-forward Merge** (Automatic)
   - Happens when main hasn't changed
   - Clean, linear history
   ```bash
   git merge feature-branch
   ```

2. **Merge Commit** (Common)
   - Creates a new commit combining changes
   - Preserves branch history
   ```bash
   git merge feature-branch
   ```

3. **Squash Merge** (Clean History)
   - Combines all branch commits into one
   ```bash
   git merge --squash feature-branch
   git commit -m "Add feature-branch changes"
   ```

### Handling Merge Conflicts
1. **When Conflicts Occur:**
   ```bash
   # 1. Check which files have conflicts
   git status

   # 2. Open each conflicting file and look for:
   <<<<<<< HEAD
   main branch version
   =======
   your branch version
   >>>>>>> your-branch

   # 3. Edit files to resolve conflicts
   # 4. Remove conflict markers
   # 5. Save files
   ```

2. **After Resolving:**
   ```bash
   # Stage resolved files
   git add .

   # Create merge commit
   git commit -m "Resolve merge conflicts"
   ```

3. **If Things Go Wrong:**
   ```bash
   # Abort the merge and start over
   git merge --abort
   ```

### Best Practices
1. **Before Merging:**
   - Backup your config files
   - Pull latest main changes
   - Test your branch thoroughly
   - Run build checks locally

2. **During Merge:**
   - Take time to resolve conflicts carefully
   - Test after resolving conflicts
   - Don't rush the process

3. **After Merging:**
   - Verify the merge worked
   - Test the application
   - Push changes promptly
   - Delete merged branch if no longer needed

### Common Issues
1. **Merge Conflicts in Config Files:**
   ```bash
   # 1. Backup both versions
   ./backup-config.sh
   
   # 2. Resolve conflict
   
   # 3. Test both configurations
   ```

2. **Multiple Conflicts:**
   - Handle one file at a time
   - Commit after resolving all conflicts
   - Don't mix conflict resolution with new changes

3. **Accidental Merge:**
   ```bash
   # Undo last merge (if not pushed)
   git reset --hard HEAD~1
   ```

