import { useState, useEffect } from 'react'
import { Login } from './components/Login'
import { DataFetch } from './components/DataFetch'
import './App.css'

function App() {
  const [session, setSession] = useState<any>(null)
  const [error, setError] = useState<string>('')

  // Debug logging
  useEffect(() => {
    console.log('App mounted')
    console.log('Current session state:', session)
  }, [])

  try {
    if (!session) {
      console.log('No session, showing login component')
      return <Login onSuccess={(sessionData) => {
        console.log('Login callback received:', sessionData)
        setSession(sessionData)
      }} />
    }

    return (
      <div className="App">
        <h1>Welcome!</h1>
        <button 
          onClick={() => {
            console.log('Logging out, clearing session')
            setSession(null)
          }}
          style={{ maxWidth: '200px', margin: '20px' }}
        >
          Logout
        </button>
        <DataFetch />
      </div>
    )
  } catch (err) {
    console.error('Rendering error:', err)
    return <div>Error loading application. Check console for details.</div>
  }
}

export default App
