import { useState } from 'react'
import './Login.css'

interface LoginProps {
  onSuccess: (session: any) => void
}

export function Login({ onSuccess }: LoginProps) {
  const [isLogin, setIsLogin] = useState(true)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    console.log('Form submitted:', { isLogin, email })
    setError('')
    setMessage('')

    try {
      const endpoint = isLogin ? '/auth/signin' : '/auth/signup'
      console.log('Making request to:', `http://localhost:8001${endpoint}`)
      
      const response = await fetch(`http://localhost:8001${endpoint}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      })

      console.log('Response status:', response.status)
      const data = await response.json()
      console.log('Response data:', data)

      if (data.status === 'success') {
        console.log('Operation successful')
        setMessage(data.message)
        if (isLogin && data.session) {
          console.log('Login successful, setting session')
          onSuccess(data.session)
        }
      } else {
        console.error('Operation failed:', data.detail || 'An error occurred')
        setError(data.detail || 'An error occurred')
      }
    } catch (err) {
      console.error('Request failed:', err)
      setError('Failed to connect to server')
    }
  }

  return (
    <div className="login-container">
      <h2>{isLogin ? 'Login' : 'Sign Up'}</h2>
      
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="email">Email:</label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>

        <div className="form-group">
          <label htmlFor="password">Password:</label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>

        {error && <div className="error">{error}</div>}
        {message && <div className="success">{message}</div>}

        <button type="submit">
          {isLogin ? 'Login' : 'Sign Up'}
        </button>
      </form>

      <p>
        {isLogin ? "Don't have an account? " : "Already have an account? "}
        <button 
          className="link-button"
          onClick={() => {
            console.log('Switching mode to:', !isLogin ? 'login' : 'signup')
            setIsLogin(!isLogin)
          }}
        >
          {isLogin ? 'Sign Up' : 'Login'}
        </button>
      </p>
    </div>
  )
} 