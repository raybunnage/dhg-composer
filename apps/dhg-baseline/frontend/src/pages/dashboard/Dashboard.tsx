import React, { useEffect } from 'react';
import { AuthService, useAuth } from '@dhg/auth-service';

const authService = new AuthService(
  import.meta.env.VITE_SUPABASE_URL || 'missing-url',
  import.meta.env.VITE_SUPABASE_ANON_KEY || 'missing-key'
);

export const Dashboard: React.FC = () => {
  const { user, signOut, loading } = useAuth(authService);

  useEffect(() => {
    console.log('Dashboard mounted, user:', user);
  }, [user]);

  const handleSignOut = async () => {
    try {
      console.log('Signing out...');
      await signOut();
      console.log('Sign out successful');
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  if (!user) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="text-gray-600">No user data available</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center">
              <h1 className="text-xl font-semibold text-gray-800">Dashboard</h1>
            </div>
            <div className="flex items-center space-x-4">
              <div className="text-sm text-gray-600">
                Logged in as: {user.email}
              </div>
              <button
                onClick={handleSignOut}
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
              >
                Sign Out
              </button>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <div className="px-4 py-6 sm:px-0">
          <div className="bg-white shadow rounded-lg p-6">
            <h2 className="text-lg font-medium text-gray-900 mb-4">User Information</h2>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-600">Email</label>
                <div className="mt-1 text-sm text-gray-900">{user.email}</div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-600">User ID</label>
                <div className="mt-1 text-sm text-gray-900">{user.id}</div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-600">Role</label>
                <div className="mt-1 text-sm text-gray-900">{user.role}</div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-600">Email Confirmed</label>
                <div className="mt-1 text-sm text-gray-900">
                  {user.email_confirmed_at ? 'Yes' : 'No'}
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-600">Raw User Data</label>
                <pre className="mt-1 bg-gray-50 p-4 rounded-md overflow-auto text-xs">
                  {JSON.stringify(user, null, 2)}
                </pre>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}; 