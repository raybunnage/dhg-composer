import { useState, useEffect } from 'react'

interface TestUser {
  user_id: string
  created_at: string
  last_name: string | null
  first_name: string | null
  username: string | null
  user_initials: string | null
}

export function DataFetch() {
  const [users, setUsers] = useState<TestUser[]>([])
  const [error, setError] = useState('')

  useEffect(() => {
    console.log('DataFetch component mounted')
  }, [])

  return (
    <div>
      <h2>User Data</h2>
      {error && <div style={{ color: 'red' }}>{error}</div>}
      <pre>Component loaded</pre>
    </div>
  )
} 