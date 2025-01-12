import { useState, useEffect } from 'react'
import './App.css'

function App() {
  const [backendMessage, setBackendMessage] = useState<string>('')
  const [error, setError] = useState<string>('')

  useEffect(() => {
    // Test backend connection
    console.log('Attempting to connect to backend...')
    fetch('http://localhost:8001/test-supabase', {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
      },
    })
      .then(response => {
        console.log('Response received:', response)
        return response.json()
      })
      .then(data => {
        console.log('Backend response:', data)
        setBackendMessage(JSON.stringify(data, null, 2))
      })
      .catch(err => {
        console.error('Error connecting to backend:', err)
        setError(`${err.message} - Make sure backend is running on port 8001`)
      })
  }, [])

  return (
    <div className="App">
      <h1>Frontend + Backend Test</h1>
      
      {error && (
        <div style={{ color: 'red', margin: '20px' }}>
          Error connecting to backend: {error}
        </div>
      )}
      
      {backendMessage && (
        <div style={{ margin: '20px' }}>
          <h2>Backend Response:</h2>
          <pre>{backendMessage}</pre>
        </div>
      )}
    </div>
  )
}

export default App
