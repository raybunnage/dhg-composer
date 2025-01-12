import { useState, useEffect } from 'react'
import './App.css'

interface TestUser {
  user_id: string
  created_at: string
  last_name: string | null
  first_name: string | null
  username: string | null
  user_initials: string | null
}

interface ApiResponse {
  status: string
  message: string
  data: TestUser[]
}

function App() {
  const [users, setUsers] = useState<TestUser[]>([])
  const [error, setError] = useState<string>('')
  const [successMessage, setSuccessMessage] = useState<string>('')

  const fetchData = () => {
    fetch('http://localhost:8001/test-supabase')
      .then(response => response.json())
      .then((data: ApiResponse) => {
        console.log('Backend response:', data)
        if (data.status === 'success') {
          setUsers(data.data)
          setError('')
        } else {
          setError(data.message)
        }
      })
      .catch(err => {
        console.error('Error connecting to backend:', err)
        setError(`${err.message} - Make sure backend is running on port 8001`)
      })
  }

  const addTestData = () => {
    fetch('http://localhost:8001/test-supabase/add', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    })
      .then(response => response.json())
      .then((data: ApiResponse) => {
        console.log('Data added:', data)
        if (data.status === 'success') {
          setSuccessMessage('User added successfully!')
          fetchData() // Refresh the data display
        } else {
          setError(data.message)
        }
      })
      .catch(err => {
        console.error('Error adding data:', err)
        setError(`${err.message} - Failed to add test data`)
      })
  }

  useEffect(() => {
    fetchData()
  }, [])

  return (
    <div className="App">
      <h1>Frontend + Backend Test</h1>
      
      <button onClick={addTestData} style={{ margin: '20px' }}>
        Add Test User
      </button>
      
      {error && (
        <div style={{ color: 'red', margin: '20px' }}>
          Error: {error}
        </div>
      )}

      {successMessage && (
        <div style={{ color: 'green', margin: '20px' }}>
          {successMessage}
        </div>
      )}
      
      <div style={{ margin: '20px' }}>
        <h2>Users:</h2>
        {users.length === 0 ? (
          <p>No users found</p>
        ) : (
          <table style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead>
              <tr>
                <th style={tableStyle}>Name</th>
                <th style={tableStyle}>Username</th>
                <th style={tableStyle}>Initials</th>
                <th style={tableStyle}>Created</th>
              </tr>
            </thead>
            <tbody>
              {users.map(user => (
                <tr key={user.user_id}>
                  <td style={tableStyle}>{`${user.first_name} ${user.last_name}`}</td>
                  <td style={tableStyle}>{user.username}</td>
                  <td style={tableStyle}>{user.user_initials}</td>
                  <td style={tableStyle}>{new Date(user.created_at).toLocaleString()}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}

const tableStyle = {
  border: '1px solid #ddd',
  padding: '8px',
  textAlign: 'left' as const
}

export default App
