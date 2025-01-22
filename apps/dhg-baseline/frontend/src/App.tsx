import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthService, useAuth } from '@dhg/auth-service';
import { LoginPage } from './pages/auth/login';
import { Dashboard } from './pages/dashboard/Dashboard';
import './App.css'

// Initialize auth service with debug
const authService = new AuthService(
  import.meta.env.VITE_SUPABASE_URL || 'missing-url',
  import.meta.env.VITE_SUPABASE_ANON_KEY || 'missing-key'
);

const App: React.FC = () => {
  console.log('App rendering');
  const { user, loading } = useAuth(authService);
  
  console.log('Auth state:', { user, loading });

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-gray-50">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <Router>
      <div>
        <Routes>
          {/* Debug route */}
          <Route 
            path="/debug" 
            element={<div>Debug page loaded</div>} 
          />

          {/* Login route - redirect to dashboard if already logged in */}
          <Route 
            path="/login" 
            element={user ? <Navigate to="/dashboard" replace /> : <LoginPage />} 
          />

          {/* Protected dashboard route */}
          <Route 
            path="/dashboard" 
            element={user ? <Dashboard /> : <Navigate to="/login" replace />} 
          />

          {/* Default route */}
          <Route 
            path="/" 
            element={<Navigate to={user ? "/dashboard" : "/login"} replace />} 
          />
        </Routes>
      </div>
    </Router>
  );
};

export default App; 