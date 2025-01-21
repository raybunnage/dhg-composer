import { describe, it, expect, vi, beforeEach } from 'vitest';
import { AuthService } from '../auth.service';

// Mock Supabase client
vi.mock('@supabase/supabase-js', () => ({
  createClient: () => ({
    auth: {
      signInWithPassword: vi.fn(),
      signUp: vi.fn(),
      signOut: vi.fn(),
      getUser: vi.fn(),
      getSession: vi.fn(),
      onAuthStateChange: vi.fn()
    }
  })
}));

describe('AuthService', () => {
  let authService: AuthService;

  beforeEach(() => {
    authService = new AuthService('fake-url', 'fake-key');
  });

  describe('signIn', () => {
    it('should sign in successfully', async () => {
      const mockResponse = { data: { user: { id: '123' } }, error: null };
      vi.mocked(authService['supabase'].auth.signInWithPassword).mockResolvedValue(mockResponse);

      const result = await authService.signIn('test@test.com', 'password');
      expect(result).toEqual(mockResponse.data);
    });

    it('should handle sign in error', async () => {
      const mockError = new Error('Invalid credentials');
      vi.mocked(authService['supabase'].auth.signInWithPassword).mockRejectedValue(mockError);

      await expect(authService.signIn('test@test.com', 'password'))
        .rejects.toThrow('Invalid credentials');
    });
  });

  describe('signUp', () => {
    it('should sign up successfully', async () => {
      const mockResponse = { data: { user: { id: '123' } }, error: null };
      vi.mocked(authService['supabase'].auth.signUp).mockResolvedValue(mockResponse);

      const result = await authService.signUp('test@test.com', 'password');
      expect(result).toEqual(mockResponse.data);
    });

    it('should handle sign up error', async () => {
      const mockError = new Error('Email already exists');
      vi.mocked(authService['supabase'].auth.signUp).mockRejectedValue(mockError);

      await expect(authService.signUp('test@test.com', 'password'))
        .rejects.toThrow('Email already exists');
    });
  });

  describe('getUser', () => {
    it('should get user successfully', async () => {
      const mockUser = { id: '123', email: 'test@test.com' };
      vi.mocked(authService['supabase'].auth.getUser).mockResolvedValue({ 
        data: { user: mockUser }, 
        error: null 
      });

      const user = await authService.getUser();
      expect(user).toEqual(mockUser);
    });
  });
}); 