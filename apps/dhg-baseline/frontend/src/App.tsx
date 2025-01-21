import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { AuthPage } from './pages/auth'
import './App.css'

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/auth" element={<AuthPage />} />
        {/* Add other routes as needed */}
      </Routes>
    </Router>
  )
}

export default App 