[← Back to Documentation Home](../README.md)

# Getting Started with FastAPI, Supabase, and Vite React

## Table of Contents
1. [Introduction](#introduction)
2. [Backend Setup with FastAPI](#backend-setup-with-fastapi)
3. [Understanding Async Programming](#understanding-async-programming)
4. [Supabase Integration](#supabase-integration)
5. [Frontend Development with Vite React](#frontend-development-with-vite-react)
6. [Full Stack Integration](#full-stack-integration)
7. [Using Scripts to Streamline Your Workflow](#using-scripts-to-streamline-your-workflow)
8. [Day-to-Day Commands](#day-to-day-commands)
    1. [Starting the Development Environment](#starting-the-development-environment)
    2. [Version Control Commands](#version-control-commands)
    3. [Deployment Commands](#deployment-commands)
    4. [Testing Commands](#testing-commands)
    5. [Merging to Production](#merging-to-production)
    6. [Tree Command](#tree-command)
9. [Tree Command](#tree-command)

## Quick Start Commands

### Kill Existing Server Processes
If ports are already in use:
```bash
# For backend (port 8001)
lsof -i :8001
kill -9 $(lsof -t -i:8001)

# For frontend (port 5173)
lsof -i :5173
kill -9 $(lsof -t -i:5173)
```

### Start Backend Server
```bash
cd backend

# Windows
venv\Scripts\activate

# Mac/Linux
source venv/bin/activate

# Start server
python --version  # Verify Python version
uvicorn main:app --reload --port 8001
```

### Start Frontend Server
In a new terminal:
```bash
cd frontend
npm install
npm run dev
```

### Verify Server Status
- Backend API: http://localhost:8001
- Frontend App: http://localhost:5173
- Test endpoint: http://localhost:8001/test-supabase

### Common Issues
- If ports are already in use, use the kill commands above
- Make sure `.env` file exists in backend directory
- Verify virtual environment is activated for backend

## Backup and Restore Configuration

### Backup Configuration
```bash
# Make scripts executable (first time only)
chmod +x scripts/backup-config.sh
chmod +x scripts/restore-config.sh

# Run backup for current branch
./scripts/backup-config.sh
```

### Restore Configuration
```bash
# Restore .env and .vercel files for current branch
./scripts/restore-config.sh
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
./scripts/backup-config.sh

# Switch to main branch
git checkout main

# Restore main branch configuration
./scripts/restore-config.sh
```

## Vercel CLI Commands

#### Installation and Login

To install the Vercel CLI globally and log in to your account, use:

```bash
# Install Vercel CLI
npm install -g vercel

# Log in to your Vercel account
vercel login
```

#### Primary Vercel Commands

1. **Deploying Your Application**

   Deploy your application to Vercel:

   ```bash
   vercel
   ```

   Deploy to production:

   ```bash
   vercel --prod
   ```

2. **Managing Environment Variables**

   Add or update environment variables:

   ```bash
   vercel env add VARIABLE_NAME
   ```

   List all environment variables:

   ```bash
   vercel env ls
   ```

3. **Linking Your Project**

   Link your local project directory to a Vercel project:

   ```bash
   vercel link
   ```

4. **Checking Deployment Status**

   View the status of your deployments:

   ```bash
   vercel status
   ```

5. **Rolling Back Deployments**

   Roll back to a previous deployment:

   ```bash
   vercel rollback
   ```

6. **Viewing Deployment Logs**

   View logs for a specific deployment:

   ```bash
   vercel logs <deployment-url>
   ```

7. **Removing a Deployment**

   Remove a specific deployment:

   ```bash
   vercel remove <deployment-url>
   ```

8. **Switching Teams**

   If you are part of multiple teams, switch between them:

   ```bash
   vercel switch
   ```

These commands will help you manage your Vercel deployments effectively, ensuring that you can deploy, manage environment variables, and monitor your application with ease. For more detailed information, refer to the [Vercel CLI documentation](https://vercel.com/docs/cli).

---

### Using Scripts to Streamline Your Workflow

Our project includes several scripts located in the `scripts/` directory to help automate routine tasks and streamline your workflow. Here's an overview of each script and when to use them:

#### 1. `start-dev.sh`

**Purpose**: Starts both the backend and frontend development servers simultaneously.

**When to Use**:
- When you want to start working on both the backend and frontend.
- To ensure both servers are running with a single command.

**Usage**:
```bash
./scripts/start-dev.sh
```

---

#### 2. `deploy.sh`

**Purpose**: Deploys the application to Vercel in production mode.

**When to Use**:
- When you're ready to deploy your latest changes to production.
- To automate the deployment process.

**Usage**:
```bash
./scripts/deploy.sh
```

---

#### 3. `git-commit.sh`

**Purpose**: Automates adding, committing, and pushing changes to the repository with a commit message.

**When to Use**:
- When you've completed a set of changes you want to commit.
- To streamline the git workflow by reducing the number of commands needed.

**Usage**:
```bash
./scripts/git-commit.sh "Your commit message"
```

---

#### 4. `run-tests.sh`

**Purpose**: Runs tests for both the frontend and backend.

**When to Use**:
- Before deploying to ensure your code passes all tests.
- To verify that recent changes haven't broken existing functionality.

**Usage**:
```bash
./scripts/run-tests.sh
```

---

#### 5. `backup-config.sh` and `restore-config.sh`

**Purpose**:
- `backup-config.sh`: Backs up essential configuration files for the current branch.
- `restore-config.sh`: Restores configuration files for the current branch from a backup.

**When to Use**:
- Before switching branches to prevent configuration conflicts.
- To maintain consistent environment settings across different development branches.

**Usage**:
```bash
./scripts/backup-config.sh
./scripts/restore-config.sh
```

## Deploying to Vercel with logs

```bash
./scripts/deploy.sh &> deploy.log
```

---

### Summary

By utilizing these scripts, you can automate and simplify your daily development tasks, ensuring consistency and efficiency in your workflow. Here's a quick recap of when to use each script:

- **Start Development Environment**: Use `start-dev.sh` to launch both backend and frontend servers.
- **Deploy Application**: Use `deploy.sh` to deploy your application to Vercel.
- **Commit Changes**: Use `git-commit.sh` to add, commit, and push changes with a single command.
- **Run Tests**: Use `run-tests.sh` to execute tests for both frontend and backend.
- **Backup/Restore Configuration**: Use `backup-config.sh` and `restore-config.sh` to manage configuration files when switching branches.

These scripts are designed to help you maintain a smooth and efficient development process. If you have any specific questions about using these scripts or need further customization, feel free to ask!

## Day-to-Day Commands

### Starting the Development Environment

```bash
# Start the backend server
cd backend
source venv/bin/activate  # Activate virtual environment
uvicorn main:app --reload --port 8001 &

# Start frontend
cd ../frontend
npm run dev
```

### Version Control Commands

```bash
# Check the status of your git repository
git status

# Add changes to staging
git add .

# Commit changes with a message
git commit -m "Your commit message"

# Checkout a branch
git checkout branch-name

# Merge a branch into the current branch
git merge branch-name

# Push changes to the remote repository
git push origin branch-name
```

### Deployment Commands

```bash
# Deploy to Vercel
vercel

# Deploy to production
vercel --prod
```

### Testing Commands

```bash
# Run tests (assuming you have a test setup)
npm test  # For frontend tests
pytest  # For backend tests
```

### Merging to Production

```bash
# Switch to the main branch
git checkout main

# Merge changes from your feature branch
git merge feature-branch

# Push changes to the remote main branch
git push origin main

# Deploy the main branch to Vercel
vercel --prod
```


## Rebuilding the project

```bash
# Rebuild the project
./scripts/rebuild.sh
```

## Updating requirements.txt

```bash
# Update a package
pip install <package-name> --upgrade

# Freeze the current environment
pip freeze > requirements.txt

# Install the requirements
uv pip install -r requirements.txt
```

## Tree Command 

```bash
tree -I 'node_modules|dist|build|.git|.venv|__pycache__'
```

