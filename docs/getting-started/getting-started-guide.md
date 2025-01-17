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




## Getting Started Guide Overview

This guide will help you set up a modern full-stack application using:
- FastAPI for the backend
- Supabase as the database
- Vite React for the frontend

### Prerequisites
- Python 3.7+
- Node.js 14+
- Basic understanding of Python and JavaScript/React
- A Supabase account

## Backend Setup

### Setting up FastAPI

```bash
# Create a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: .\venv\Scripts\activate

# Install required packages
pip install fastapi uvicorn python-dotenv supabase
```

Create a basic FastAPI application (`main.py`):

```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173"],  # Vite's default port
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Hello World"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

## Understanding Async Programming

FastAPI is built on top of Starlette and leverages Python's async capabilities. Here's how to work with async functions:

### Basic Async Concepts

```python
from fastapi import FastAPI
import asyncio

app = FastAPI()

# Async endpoint example
@app.get("/async-example")
async def async_endpoint():
    # Simulate async operation
    await asyncio.sleep(1)
    return {"message": "Async operation completed"}

# Multiple async operations
@app.get("/parallel-tasks")
async def parallel_tasks():
    # Run multiple tasks concurrently
    task1 = asyncio.create_task(async_operation_1())
    task2 = asyncio.create_task(async_operation_2())
    
    results = await asyncio.gather(task1, task2)
    return {"results": results}

async def async_operation_1():
    await asyncio.sleep(1)
    return "Operation 1 complete"

async def async_operation_2():
    await asyncio.sleep(1)
    return "Operation 2 complete"
```

### Best Practices for Async Programming
1. Use `async/await` consistently
2. Avoid blocking operations in async functions
3. Use appropriate async libraries for database operations
4. Handle exceptions properly in async context

## Supabase Integration

### Setting up Supabase

1. Create a `.env` file:
```plaintext
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
```

2. Create a Supabase client (`database.py`):
```python
from supabase import create_client
import os
from dotenv import load_dotenv

load_dotenv()

supabase = create_client(
    os.getenv("SUPABASE_URL"),
    os.getenv("SUPABASE_KEY")
)

# Example function to fetch data
async def get_items():
    try:
        response = supabase.table('items').select("*").execute()
        return response.data
    except Exception as e:
        print(f"Error: {e}")
        return []
```

### Integrating Supabase with FastAPI

```python
from fastapi import FastAPI, HTTPException
from .database import supabase

app = FastAPI()

@app.get("/items")
async def read_items():
    try:
        items = await get_items()
        return items
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/items")
async def create_item(item: Item):
    try:
        response = supabase.table('items').insert(item.dict()).execute()
        return response.data[0]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

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

### Creating Supabase Client (frontend)

```javascript
// src/lib/supabase.js
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_KEY

export const supabase = createClient(supabaseUrl, supabaseKey)
```

### Example React Component with API Integration

```jsx
// src/components/ItemsList.jsx
import { useState, useEffect } from 'react'
import axios from 'axios'

const ItemsList = () => {
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const fetchItems = async () => {
      try {
        const response = await axios.get('http://localhost:8000/items')
        setItems(response.data)
      } catch (error) {
        console.error('Error fetching items:', error)
      } finally {
        setLoading(false)
      }
    }

    fetchItems()
  }, [])

  if (loading) return <div>Loading...</div>

  return (
    <div>
      <h2>Items List</h2>
      <ul>
        {items.map(item => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul>
    </div>
  )
}

export default ItemsList
```

## Full Stack Integration

### Project Structure
```
your-project/
├── backend/
│   ├── venv/
│   ├── main.py
│   ├── database.py
│   └── requirements.txt
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── lib/
│   │   └── App.jsx
│   ├── package.json
│   └── vite.config.js
└── README.md
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