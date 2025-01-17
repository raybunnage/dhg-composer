# Best Practices for Full-Stack Development

## Project Structure
- Organize your project into clear directories for frontend, backend, and documentation.
- Use a `scripts` directory for utility scripts.

## Documentation
- Maintain a comprehensive README file.
- Use inline comments and docstrings to explain code.

## Environment Configuration
- Use `.env` files for sensitive information and environment-specific settings.
- Include an example `.env` file for reference.

## Dependency Management
- Keep your `requirements.txt` and `package.json` files up to date.
- Use lock files to ensure consistent dependency versions.

## Security Best Practices
- Implement authentication and authorization.
- Validate and sanitize user inputs.

## Error Handling
- Implement comprehensive error handling in both frontend and backend.
- Log errors for debugging purposes.

## Testing
- Write unit tests for critical components.
- Use a testing framework for automated testing.

## Version Control
- Use meaningful commit messages.
- Regularly update branches to incorporate changes.

## Deployment
- Provide clear instructions for deploying the application.
- Consider using CI/CD pipelines for automated deployment.


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


