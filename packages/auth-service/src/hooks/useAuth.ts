import { useState, useEffect } from 'react';
import { User } from '@supabase/supabase-js';
import { AuthService } from '../auth.service';

export const useAuth = (authService: AuthService) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    // Get initial user
    authService.getUser()
      .then(setUser)
      .catch(setError)
      .finally(() => setLoading(false));

    // Listen for auth changes
    const { data: { subscription } } = authService.onAuthStateChange(setUser);

    return () => {
      subscription.unsubscribe();
    };
  }, [authService]);

  const signIn = async (email: string, password: string) => {
    try {
      const data = await authService.signIn(email, password);
      return data;
    } catch (err) {
      setError(err as Error);
      throw err;
    }
  };

  const signUp = async (email: string, password: string) => {
    try {
      const data = await authService.signUp(email, password);
      return data;
    } catch (err) {
      setError(err as Error);
      throw err;
    }
  };

  const signOut = async () => {
    try {
      await authService.signOut();
    } catch (err) {
      setError(err as Error);
      throw err;
    }
  };

  return {
    user,
    loading,
    error,
    signIn,
    signUp,
    signOut,
  };
}; 