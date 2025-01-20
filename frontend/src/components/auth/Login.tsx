import { useState } from 'react'
import { supabase } from '@/lib/supabaseClient'

export default function Login() {
  const [loading, setLoading] = useState(false)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [isSignUp, setIsSignUp] = useState(false)  // Toggle between signin/signup

  async function handleAuth(e: React.FormEvent) {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      const endpoint = isSignUp ? 'signup' : 'signin'
      const apiUrl = `${import.meta.env.VITE_API_URL}/api/v1/auth/${endpoint}`  // Correct prefix for both
      
      console.log('Auth Request:', {
        url: apiUrl,
        method: 'POST',
        action: isSignUp ? 'signup' : 'signin',
        body: { email, password }
      })

      // Call appropriate Supabase method
      const { data, error } = isSignUp 
        ? await supabase.auth.signUp({ email, password })
        : await supabase.auth.signInWithPassword({ email, password })
      
      console.log('Supabase Auth Response:', { data, error })

      if (error) throw error
      
      // Sync with backend
      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',  // Add explicit Accept header
        },
        body: JSON.stringify({ email, password }),
      })
      
      // Log the full response details
      console.log('Response status:', response.status);
      console.log('Response headers:', Object.fromEntries(response.headers));

      const responseData = await response.json().catch(() => ({}))
      console.log('Backend Response:', {
        status: response.status,
        ok: response.ok,
        data: responseData
      })

      if (!response.ok) {
        throw new Error(responseData.detail || 'Failed to sync with backend')
      }

    } catch (error) {
      console.error('Auth error:', error)
      setError(error instanceof Error ? error.message : 'An error occurred')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="flex flex-col items-center justify-center min-h-screen p-4">
      <form onSubmit={handleAuth} className="w-full max-w-sm space-y-4">
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-gray-700">
            Email
          </label>
          <input
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          />
        </div>

        <div>
          <label htmlFor="password" className="block text-sm font-medium text-gray-700">
            Password
          </label>
          <input
            id="password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
          />
        </div>

        {error && (
          <div className="text-red-500 text-sm">{error}</div>
        )}

        <button
          type="submit"
          disabled={loading}
          className="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50"
        >
          {loading ? 'Loading...' : (isSignUp ? 'Sign Up' : 'Sign In')}
        </button>

        <button
          type="button"
          onClick={() => setIsSignUp(!isSignUp)}
          className="w-full text-sm text-gray-600 hover:text-gray-900"
        >
          {isSignUp ? 'Already have an account? Sign In' : 'Need an account? Sign Up'}
        </button>
      </form>
    </div>
  )
} 