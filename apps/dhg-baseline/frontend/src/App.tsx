import { useState, useEffect } from 'react'
import { createClient } from '@supabase/supabase-js'
import './App.css'

// Initialize Supabase client
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY
const supabase = createClient(supabaseUrl, supabaseKey)

function App() {
  const [count, setCount] = useState(0)
  const [user, setUser] = useState(null)

  useEffect(() => {
    // Check active sessions and sets the user
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null)
    })

    // Listen for changes on auth state (signed in, signed out, etc.)
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
    })

    return () => subscription.unsubscribe()
  }, [])

  return (
    <>
      <h1>DHG Baseline</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <div>
        {user ? (
          <button onClick={() => supabase.auth.signOut()}>Sign Out</button>
        ) : (
          <button onClick={() => supabase.auth.signInWithOAuth({
            provider: 'github'
          })}>Sign In with GitHub</button>
        )}
      </div>
    </>
  )
}

export default App 