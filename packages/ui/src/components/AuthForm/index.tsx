import React from 'react'
import { Button } from '../Button'
import { Input } from '../Input'
import { Card } from '../Card'

export interface AuthFormProps {
  onSubmit: (data: { email: string; password: string }) => void
  type: 'login' | 'register'
  loading?: boolean
}

export function AuthForm({ onSubmit, type, loading = false }: AuthFormProps) {
  const [email, setEmail] = React.useState('')
  const [password, setPassword] = React.useState('')

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    onSubmit({ email, password })
  }

  return (
    <Card className="w-[350px] p-6">
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="space-y-2">
          <Input
            type="email"
            placeholder="Email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div className="space-y-2">
          <Input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <Button
          type="submit"
          className="w-full"
          disabled={loading}
        >
          {loading ? 'Loading...' : type === 'login' ? 'Sign In' : 'Sign Up'}
        </Button>
      </form>
    </Card>
  )
} 