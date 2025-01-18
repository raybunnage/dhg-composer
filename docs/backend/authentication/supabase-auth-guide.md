[← Back to Documentation Home](../../../README.md)

# Comprehensive Guide to Supabase Authentication

## Table of Contents
1. [Backend Setup](#backend-setup)
2. [Frontend Implementation](#frontend-implementation)
3. [Authentication Flows](#authentication-flows)
4. [Testing Authentication](#testing-authentication)
5. [Security Best Practices](#security-best-practices)

## Backend Setup

### FastAPI Authentication Dependencies

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from supabase import create_client
import jwt
from typing import Optional

# Initialize security scheme
security = HTTPBearer()

# Initialize Supabase client
supabase = create_client(
    supabase_url=os.getenv("SUPABASE_URL"),
    supabase_key=os.getenv("SUPABASE_SERVICE_KEY")  # Use service key for backend
)

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
) -> Optional[dict]:
    """
    Dependency to verify JWT token and get current user
    """
    try:
        # Get the JWT token from the authorization header
        token = credentials.credentials
        
        # Verify the token using Supabase JWT secret
        payload = jwt.decode(
            token,
            os.getenv("SUPABASE_JWT_SECRET"),
            algorithms=["HS256"]
        )
        
        # Get user details from Supabase
        user = supabase.auth.admin.get_user(payload['sub'])
        
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials"
            )
            
        return user.dict()
        
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token has expired"
        )
    except jwt.JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials"
        )
```

### Protected Routes in FastAPI

```python
from fastapi import APIRouter, Depends
from .auth import get_current_user

router = APIRouter()

@router.get("/protected")
async def protected_route(current_user: dict = Depends(get_current_user)):
    """
    Example of a protected route that requires authentication
    """
    return {
        "message": "This is a protected route",
        "user_id": current_user['id'],
        "email": current_user['email']
    }

@router.get("/user/profile")
async def get_user_profile(current_user: dict = Depends(get_current_user)):
    """
    Get user profile information
    """
    try:
        # Query user profile from database
        profile = supabase.table('profiles')\
            .select("*")\
            .eq('id', current_user['id'])\
            .single()\
            .execute()
            
        return profile.data
        
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )
```

## Frontend Implementation

### Supabase Auth Context

```typescript
// src/contexts/AuthContext.tsx
import { createContext, useContext, useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import type { User, AuthError } from '@supabase/supabase-js'

interface AuthContextType {
  user: User | null
  loading: boolean
  signIn: (email: string, password: string) => Promise<{ error: AuthError | null }>
  signUp: (email: string, password: string) => Promise<{ error: AuthError | null }>
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Check for active session on mount
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (_event, session) => {
        setUser(session?.user ?? null)
        setLoading(false)
      }
    )

    return () => {
      subscription.unsubscribe()
    }
  }, [])

  const signIn = async (email: string, password: string) => {
    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    })
    return { error }
  }

  const signUp = async (email: string, password: string) => {
    const { error } = await supabase.auth.signUp({
      email,
      password,
    })
    return { error }
  }

  const signOut = async () => {
    await supabase.auth.signOut()
  }

  return (
    <AuthContext.Provider value={{ user, loading, signIn, signUp, signOut }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}
```

### Login Component

```tsx
// src/components/Login.tsx
import { useState } from 'react'
import { useAuth } from '../contexts/AuthContext'

export function Login() {
  const { signIn } = useAuth()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      const { error } = await signIn(email, password)
      if (error) throw error
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred')
    } finally {
      setLoading(false)
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {error && (
        <div className="text-red-500">{error}</div>
      )}
      <div>
        <label htmlFor="email" className="block text-sm font-medium">
          Email
        </label>
        <input
          id="email"
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
        />
      </div>
      <div>
        <label htmlFor="password" className="block text-sm font-medium">
          Password
        </label>
        <input
          id="password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
        />
      </div>
      <button
        type="submit"
        disabled={loading}
        className="w-full py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
      >
        {loading ? 'Loading...' : 'Sign In'}
      </button>
    </form>
  )
}
```

## Authentication Flows

### Email/Password Authentication Flow

1. **User Registration (Sign Up)**:
```typescript
const handleSignUp = async () => {
  const { data, error } = await supabase.auth.signUp({
    email: 'example@email.com',
    password: 'example-password',
    options: {
      data: {
        first_name: 'John',
        last_name: 'Doe'
      }
    }
  })

  if (error) {
    console.error('Error signing up:', error.message)
    return
  }

  // User needs to verify their email
  console.log('Please check your email for verification link')
}
```

2. **Email Verification**:
```typescript
// This URL handler should be set up in your app
const handleEmailVerification = async () => {
  const { data, error } = await supabase.auth.verifyOtp({
    token_hash: window.location.hash.substring(1),
    type: 'email'
  })

  if (error) {
    console.error('Error verifying email:', error.message)
    return
  }

  // Email verified successfully
  console.log('Email verified successfully')
}
```

3. **Password Reset**:
```typescript
// Request password reset
const handleResetRequest = async (email: string) => {
  const { data, error } = await supabase.auth.resetPasswordForEmail(email)

  if (error) {
    console.error('Error requesting password reset:', error.message)
    return
  }

  console.log('Password reset email sent')
}

// Handle password reset
const handlePasswordReset = async (new_password: string) => {
  const { data, error } = await supabase.auth.updateUser({
    password: new_password
  })

  if (error) {
    console.error('Error resetting password:', error.message)
    return
  }

  console.log('Password updated successfully')
}
```

### Social Authentication

```typescript
// Implement social login (example with GitHub)
const handleGitHubLogin = async () => {
  const { data, error } = await supabase.auth.signInWithOAuth({
    provider: 'github',
    options: {
      redirectTo: 'http://localhost:5173/auth/callback'
    }
  })

  if (error) {
    console.error('Error with GitHub login:', error.message)
    return
  }
}
```

## Testing Authentication

### Backend Tests (using pytest)

```python
import pytest
from fastapi.testclient import TestClient
from .main import app
from .auth import create_test_jwt

client = TestClient(app)

@pytest.fixture
def auth_header():
    """Fixture to create authentication headers with test JWT"""
    token = create_test_jwt()
    return {"Authorization": f"Bearer {token}"}

def test_protected_route_unauthorized():
    """Test accessing protected route without authentication"""
    response = client.get("/protected")
    assert response.status_code == 401

def test_protected_route_authorized(auth_header):
    """Test accessing protected route with valid authentication"""
    response = client.get("/protected", headers=auth_header)
    assert response.status_code == 200
    assert "user_id" in response.json()

def test_invalid_token():
    """Test accessing protected route with invalid token"""
    headers = {"Authorization": "Bearer invalid_token"}
    response = client.get("/protected", headers=headers)
    assert response.status_code == 401
```

### Frontend Tests (using Jest and React Testing Library)

```typescript
// src/__tests__/Login.test.tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { Login } from '../components/Login'
import { AuthProvider } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'

// Mock Supabase client
jest.mock('../lib/supabase', () => ({
  supabase: {
    auth: {
      signInWithPassword: jest.fn()
    }
  }
}))

describe('Login Component', () => {
  beforeEach(() => {
    render(
      <AuthProvider>
        <Login />
      </AuthProvider>
    )
  })

  it('renders login form', () => {
    expect(screen.getByLabelText(/email/i)).toBeInTheDocument()
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument()
    expect(screen.getByRole('button', { name: /sign in/i })).toBeInTheDocument()
  })

  it('handles successful login', async () => {
    // Mock successful login
    const mockSignIn = supabase.auth.signInWithPassword as jest.Mock
    mockSignIn.mockResolvedValueOnce({ data: { user: {} }, error: null })

    // Fill form
    fireEvent.change(screen.getByLabelText(/email/i), {
      target: { value: 'test@example.com' }
    })
    fireEvent.change(screen.getByLabelText(/password/i), {
      target: { value: 'password123' }
    })

    // Submit form
    fireEvent.click(screen.getByRole('button', { name: /sign in/i }))

    // Verify loading state
    expect(screen.getByRole('button', { name: /loading/i })).toBeInTheDocument()

    // Verify successful login
    await waitFor(() => {
      expect(mockSignIn).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123'
      })
    })
  })

  it('handles login error', async () => {
    // Mock failed login
    const mockSignIn = supabase.auth.signInWithPassword as jest.Mock
    mockSignIn.mockResolvedValueOnce({
      data: null,
      error: new Error('Invalid credentials')
    })

    // Fill and submit form
    fireEvent.change(screen.getByLabelText(/email/i), {
      target: { value: 'test@example.com' }
    })
    fireEvent.change(screen.getByLabelText(/password/i), {
      target: { value: 'wrong-password' }
    })
    fireEvent.click(screen.getByRole('button', { name: /sign in/i }))

    // Verify error message
    await waitFor(() => {
      expect(screen.getByText(/invalid credentials/i)).toBeInTheDocument()
    })
  })
})
```

## Security Best Practices

1. **Token Management**:
   - Store tokens securely (use HTTP-only cookies when possible)
   - Implement proper token refresh mechanisms
   - Clear tokens on logout

```typescript
// Secure token handling
const handleLogin = async () => {
  const { data: { session }, error } = await supabase.auth.signInWithPassword({
    email,
    password
  })

  if (error) throw error

  // Store session in secure HTTP-only cookie (server-side)
  await fetch('/api/auth/session', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ session }),
  })
}
```

2. **Request Validation**:
   - Validate all input data
   - Use proper password requirements
   - Implement rate limiting

```typescript
// Input validation example
const validatePassword = (password: string): boolean => {
  const minLength = 8
  const hasUpperCase = /[A-Z]/.test(password)
  const hasLowerCase = /[a-z]/.test(password)
  const hasNumbers = /\d/.test(password)
  const hasSpecialChar =
```

[← Back to Documentation Home](../../../README.md)