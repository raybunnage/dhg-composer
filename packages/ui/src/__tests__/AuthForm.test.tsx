import { render, screen, fireEvent } from '@testing-library/react'
import { AuthForm } from '../components/AuthForm'

describe('AuthForm', () => {
  const mockSubmit = jest.fn()

  beforeEach(() => {
    mockSubmit.mockClear()
  })

  it('renders login form correctly', () => {
    render(<AuthForm type="login" onSubmit={mockSubmit} />)
    
    expect(screen.getByPlaceholderText('Email')).toBeInTheDocument()
    expect(screen.getByPlaceholderText('Password')).toBeInTheDocument()
    expect(screen.getByRole('button')).toHaveTextContent('Sign In')
  })

  it('handles form submission', async () => {
    render(<AuthForm type="login" onSubmit={mockSubmit} />)
    
    const email = 'test@example.com'
    const password = 'password123'

    fireEvent.change(screen.getByPlaceholderText('Email'), {
      target: { value: email },
    })
    fireEvent.change(screen.getByPlaceholderText('Password'), {
      target: { value: password },
    })
    fireEvent.click(screen.getByRole('button'))

    expect(mockSubmit).toHaveBeenCalledWith({ email, password })
  })

  it('shows loading state', () => {
    render(<AuthForm type="login" onSubmit={mockSubmit} loading={true} />)
    expect(screen.getByRole('button')).toHaveTextContent('Loading...')
  })
}) 