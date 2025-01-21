import React from 'react'
// Remove these imports for now as we haven't set up these packages yet
// import { AuthForm } from '@dhg/ui'
// import { createSupabaseClient, signIn } from '@dhg/supabase-client'
// import type { AuthResponse } from '@dhg/types'

export const AuthPage: React.FC = () => {
  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="w-full max-w-md">
        <h1 className="text-2xl font-bold mb-4">Sign In</h1>
        {/* We'll add the actual auth form later */}
        <div>Authentication form will go here</div>
      </div>
    </div>
  )
} 