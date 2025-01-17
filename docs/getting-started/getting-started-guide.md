[← Back to Documentation Home](../README.md)

# Getting Started with FastAPI, Supabase, and Vite React

## Table of Contents
1. [Introduction](#introduction)
2. [Backend Setup with FastAPI](#backend-setup)
3. [Understanding Async Programming](#understanding-async-programming)
4. [Supabase Integration](#supabase-integration)
5. [Frontend Development with Vite React](#frontend-development)
6. [Full Stack Integration](#full-stack-integration)
7. [Day-to-Day Commands](#day-to-day-commands)

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

### Using npm in the Frontend Directory

Yes, you should run `npm` commands within the `frontend` directory of your project. This is because the `frontend` directory typically contains the `package.json` file, which defines the project's dependencies and scripts for the frontend part of your application.

Here's a quick guide on what you might typically do with `npm` in the `frontend` directory:

1. **Install Dependencies:**

   To install all the dependencies listed in your `package.json` file, navigate to the `frontend` directory and run:

   ```bash
   npm install
   ```

   This command will create a `node_modules` directory and install all the necessary packages.

2. **Run Development Server:**

   To start the development server, which allows you to see changes in real-time as you develop your React application, use:

   ```bash
   npm run dev
   ```

   This command typically starts a local server (often on `http://localhost:3000` or another port) where you can view your application.

3. **Build for Production:**

   When you're ready to deploy your application, you can build it for production:

   ```bash
   npm run build
   ```

   This command compiles your application into static files for production, usually placing them in a `dist` or `build` directory.

4. **Run Tests:**

   If you have tests set up, you can run them using:

   ```bash
   npm test
   ```

5. **Add or Update Packages:**

   To add a new package, use:

   ```bash
   npm install <package-name>
   ```

   To update an existing package, you can use:

   ```bash
   npm update <package-name>
   ```

By running these commands in the `frontend` directory, you ensure that all operations are performed in the context of your frontend project, using the correct configuration and dependencies. If you have any specific questions about using `npm` in your project, feel free to ask!

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

## Tree Command 

```bash
tree -I 'node_modules|dist|build|.git|.venv|__pycache__'
```

