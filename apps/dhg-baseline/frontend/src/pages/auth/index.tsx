import { useState } from 'react'
import { AuthForm } from '@dhg/ui'
import { createSupabaseClient, signIn } from '@dhg/supabase-client'
import type { AuthResponse } from '@dhg/types'

const supabase = createSupabaseClient(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY
)

export function AuthPage() {
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const handleSubmit = async ({ email, password }: { email: string; password: string }) => {
    try {
      setLoading(true)
      setError(null)
      const response = await signIn(supabase, email, password)
      console.log('Signed in:', response)
      // Redirect or update state based on successful sign-in
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center">
      {error && (
        <div className="text-red-500 mb-4">
          {error}
        </div>
      )}
      <AuthForm
        type="login"
        onSubmit={handleSubmit}
        loading={loading}
      />
    </div>
  )
} 