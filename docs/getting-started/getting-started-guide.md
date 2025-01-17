[← Back to Documentation Home](../README.md)

# Getting Started with FastAPI, Supabase, and Vite React

## Table of Contents
1. [Introduction](#introduction)
2. [Backend Setup with FastAPI](#backend-setup)
3. [Understanding Async Programming](#async-programming)
4. [Supabase Integration](#supabase-integration)
5. [Frontend Development with Vite React](#frontend-development)
6. [Full Stack Integration](#full-stack-integration)

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

### Vercel CLI Commands

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



## Frontend Development with Vite React

### Setting up Vite React

```bash
# Create a new Vite React project
npm create vite@latest frontend -- --template react
cd frontend
npm install
```

### Installing Required Dependencies

```bash
npm install @supabase/supabase-js axios @tanstack/react-query
```


### Development Workflow

1. Start the backend server:
```bash
cd backend
uvicorn main:app --reload
```

2. Start the frontend development server:
```bash
cd frontend
npm run dev
```

### Environment Variables

Backend (`.env`):
```plaintext
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
```

Frontend (`.env.local`):
```plaintext
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_KEY=your_supabase_anon_key
VITE_API_URL=http://localhost:8000
```

### Best Practices

1. **API Organization**
   - Use router modules in FastAPI
   - Implement proper error handling
   - Add request validation
   - Implement middleware for common operations

2. **Frontend Architecture**
   - Use proper state management
   - Implement error boundaries
   - Add loading states
   - Use proper TypeScript types

3. **Security**
   - Implement proper authentication
   - Use environment variables
   - Validate all inputs
   - Implement CORS properly

4. **Performance**
   - Use connection pooling for database
   - Implement caching where appropriate
   - Use proper indexing in Supabase
   - Optimize API responses

This guide covers the basics of setting up a full-stack application with FastAPI, Supabase, and Vite React. As you build your application, you'll want to dive deeper into each technology's documentation for more advanced features and best practices.



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

## Tree Command 

```bash
tree -I 'node_modules|dist|build|.git|.venv|__pycache__'
```

