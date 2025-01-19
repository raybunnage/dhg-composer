import { useEffect, useState } from 'react'
import { supabase } from '@/lib/supabaseClient'

export default function AuthTest() {
  const [user, setUser] = useState<any>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Check for user on mount
    checkUser()
    // Listen for auth changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
      setLoading(false)
    })

    return () => subscription.unsubscribe()
  }, [])

  async function checkUser() {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      setUser(user)
    } catch (error) {
      console.error('Error checking user:', error)
    } finally {
      setLoading(false)
    }
  }

  async function signInWithEmail() {
    try {
      const { error } = await supabase.auth.signInWithPassword({
        email: 'test@example.com',
        password: 'test123',
      })
      if (error) throw error
    } catch (error) {
      console.error('Error signing in:', error)
    }
  }

  if (loading) return <div>Loading...</div>

  return (
    <div className="p-4">
      {user ? (
        <div>
          <p>Logged in as: {user.email}</p>
          <button 
            onClick={() => supabase.auth.signOut()}
            className="bg-red-500 text-white px-4 py-2 rounded"
          >
            Sign Out
          </button>
        </div>
      ) : (
        <button 
          onClick={signInWithEmail}
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          Sign In
        </button>
      )}
    </div>
  )
} 