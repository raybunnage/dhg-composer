import { useEffect } from 'react'

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