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
  const [_users, _setUsers] = useState<TestUser[]>([])
  const [_error, _setError] = useState('')

  useEffect(() => {
    console.log('DataFetch component mounted')
  }, [])

  return (
    <div>
      <h2>User Data</h2>
      {_error && <div style={{ color: 'red' }}>{_error}</div>}
      <pre>Component loaded</pre>
    </div>
  )
} 