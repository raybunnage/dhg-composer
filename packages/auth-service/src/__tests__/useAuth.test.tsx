import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderHook, act } from '@testing-library/react-hooks';
import { useAuth } from '../hooks/useAuth';
import { AuthService } from '../auth.service';

describe('useAuth', () => {
  let mockAuthService: AuthService;

  beforeEach(() => {
    // Create a fresh mock for each test
    mockAuthService = {
      getUser: vi.fn().mockResolvedValue(null),
      signIn: vi.fn(),
      signUp: vi.fn(),
      signOut: vi.fn(),
      onAuthStateChange: vi.fn().mockReturnValue({
        data: {
          subscription: {
            unsubscribe: vi.fn()
          }
        }
      })
    } as unknown as AuthService;
  });

  it('should initialize with loading state', async () => {
    const { result, waitForNextUpdate } = renderHook(() => useAuth(mockAuthService));
    
    expect(result.current.loading).toBe(true);
    await waitForNextUpdate();
    expect(result.current.loading).toBe(false);
  });

  it('should handle successful sign in', async () => {
    const mockUser = { id: '123', email: 'test@test.com' };
    const mockResponse = { user: mockUser, session: {} };
    
    vi.mocked(mockAuthService.signIn).mockResolvedValueOnce(mockResponse);

    const { result } = renderHook(() => useAuth(mockAuthService));

    await act(async () => {
      const response = await result.current.signIn('test@test.com', 'password');
      expect(response).toEqual(mockResponse);
    });

    expect(mockAuthService.signIn).toHaveBeenCalledWith('test@test.com', 'password');
  });

  it('should handle sign in error', async () => {
    const mockError = new Error('Invalid credentials');
    vi.mocked(mockAuthService.signIn).mockRejectedValueOnce(mockError);

    const { result } = renderHook(() => useAuth(mockAuthService));

    await act(async () => {
      try {
        await result.current.signIn('test@test.com', 'password');
        // Should not reach here
        expect(false).toBe(true);
      } catch (error) {
        expect(error).toBe(mockError);
      }
    });

    expect(result.current.error).toBe(mockError);
  });
}); 