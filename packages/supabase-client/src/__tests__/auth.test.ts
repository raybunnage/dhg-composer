import { createClient } from '@supabase/supabase-js'
import { signIn, getUser } from '../auth'

jest.mock('@supabase/supabase-js')

describe('Supabase Auth', () => {
  const mockClient = {
    auth: {
      signInWithPassword: jest.fn(),
      getUser: jest.fn(),
    },
  }

  beforeEach(() => {
    jest.clearAllMocks()
    ;(createClient as jest.Mock).mockReturnValue(mockClient)
  })

  describe('signIn', () => {
    it('signs in user successfully', async () => {
      const mockUser = { id: '123', email: 'test@example.com' }
      mockClient.auth.signInWithPassword.mockResolvedValue({
        data: { user: mockUser },
        error: null,
      })

      const result = await signIn(
        mockClient as any,
        'test@example.com',
        'password123'
      )

      expect(result.user).toEqual(mockUser)
      expect(mockClient.auth.signInWithPassword).toHaveBeenCalledWith({
        email: 'test@example.com',
        password: 'password123',
      })
    })

    it('handles sign in error', async () => {
      mockClient.auth.signInWithPassword.mockResolvedValue({
        data: { user: null },
        error: new Error('Invalid credentials'),
      })

      await expect(
        signIn(mockClient as any, 'test@example.com', 'wrong-password')
      ).rejects.toThrow('Invalid credentials')
    })
  })
}) 