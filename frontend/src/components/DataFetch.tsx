import { useEffect } from 'react'

export function DataFetch() {
  useEffect(() => {
    console.log('DataFetch component mounted')
  }, [])

  return (
    <div>
      <h2>User Data</h2>
      <pre>Component loaded</pre>
    </div>
  )
} 