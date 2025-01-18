#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create testing documentation structure
mkdir -p docs/testing/{backend,frontend,e2e,performance}

# Create main testing documentation
cat > docs/testing/README.md << 'EOL'
# Testing Guide

## Overview
This guide covers all testing aspects of our application, including unit tests, integration tests, end-to-end tests, and performance testing.

## Quick Links
- [Backend Testing](backend/README.md)
- [Frontend Testing](frontend/README.md)
- [End-to-End Testing](e2e/README.md)
- [Performance Testing](performance/README.md)

## Testing Philosophy
- Write tests first (TDD when possible)
- Keep tests simple and focused
- Test behavior, not implementation
- Maintain test independence
- Use meaningful test names

## Running Tests
```bash
# Run all tests
./scripts/run-tests.sh

# Run specific test suites
./scripts/run-tests.sh backend
./scripts/run-tests.sh frontend
./scripts/run-tests.sh e2e
```
EOL

# Create backend testing documentation
cat > docs/testing/backend/README.md << 'EOL'
# Backend Testing Guide

## Test Structure
```
backend/
├── tests/
│   ├── unit/           # Unit tests
│   ├── integration/    # Integration tests
│   └── fixtures/       # Test fixtures
```

## Running Backend Tests
```bash
# Run all backend tests
pytest backend/tests

# Run with coverage
pytest --cov=backend backend/tests

# Run specific test file
pytest backend/tests/test_auth.py
```

## Writing Tests

### Unit Test Example
```python
from fastapi.testclient import TestClient
from backend.main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "API is running"}

def test_create_item():
    response = client.post(
        "/items/",
        json={"title": "Test Item", "description": "Test Description"},
    )
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == "Test Item"
```

### Integration Test Example
```python
import pytest
from httpx import AsyncClient
from backend.main import app

@pytest.mark.asyncio
async def test_create_user_flow():
    async with AsyncClient(app=app, base_url="http://test") as ac:
        # Create user
        response = await ac.post("/users/", json={
            "email": "test@example.com",
            "password": "password123"
        })
        assert response.status_code == 201
        user_id = response.json()["id"]
        
        # Verify user exists
        response = await ac.get(f"/users/{user_id}")
        assert response.status_code == 200
```

## Test Configuration
```python
# conftest.py
import pytest
from backend.database import Base, engine
from backend.main import app

@pytest.fixture(autouse=True)
async def setup_db():
    # Setup
    Base.metadata.create_all(bind=engine)
    yield
    # Cleanup
    Base.metadata.drop_all(bind=engine)

@pytest.fixture
def test_app():
    return app
```

## Mocking Examples
```python
from unittest.mock import patch

def test_external_service():
    with patch('backend.services.external.make_request') as mock_request:
        mock_request.return_value = {"data": "mocked"}
        # Test code here
```
EOL

# Create frontend testing documentation
cat > docs/testing/frontend/README.md << 'EOL'
# Frontend Testing Guide

## Test Structure
```
frontend/
├── src/
│   └── __tests__/      # Test files next to components
└── tests/
    ├── unit/           # Unit tests
    ├── integration/    # Integration tests
    └── fixtures/       # Test fixtures
```

## Running Frontend Tests
```bash
# Run all frontend tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test file
npm test -- src/components/Login.test.tsx
```

## Writing Tests

### Component Test Example
```typescript
import { render, screen, fireEvent } from '@testing-library/react'
import { Login } from '../components/Login'

describe('Login Component', () => {
    it('should render login form', () => {
        render(<Login />)
        expect(screen.getByLabelText(/email/i)).toBeInTheDocument()
        expect(screen.getByLabelText(/password/i)).toBeInTheDocument()
    })

    it('should handle login submission', async () => {
        const mockLogin = jest.fn()
        render(<Login onLogin={mockLogin} />)
        
        fireEvent.change(screen.getByLabelText(/email/i), {
            target: { value: 'test@example.com' },
        })
        fireEvent.change(screen.getByLabelText(/password/i), {
            target: { value: 'password123' },
        })
        fireEvent.click(screen.getByRole('button', { name: /login/i }))
        
        expect(mockLogin).toHaveBeenCalledWith({
            email: 'test@example.com',
            password: 'password123',
        })
    })
})
```

### Hook Test Example
```typescript
import { renderHook, act } from '@testing-library/react-hooks'
import useCounter from '../hooks/useCounter'

describe('useCounter', () => {
    it('should increment counter', () => {
        const { result } = renderHook(() => useCounter())
        
        act(() => {
            result.current.increment()
        })
        
        expect(result.current.count).toBe(1)
    })
})
```

## Mocking Examples
```typescript
// Mock API calls
jest.mock('../api', () => ({
    login: jest.fn().mockResolvedValue({ token: 'fake-token' }),
}))

// Mock hooks
jest.mock('react-query', () => ({
    useQuery: jest.fn().mockReturnValue({
        data: mockData,
        isLoading: false,
        error: null,
    }),
}))
```
EOL

# Create E2E testing documentation
cat > docs/testing/e2e/README.md << 'EOL'
# End-to-End Testing Guide

## Overview
E2E tests verify the entire application stack works together correctly.

## Running E2E Tests
```bash
# Start application in test mode
./scripts/start-test-env.sh

# Run E2E tests
npm run test:e2e
```

## Writing Tests

### Cypress Example
```typescript
describe('Authentication Flow', () => {
    it('should allow user to login', () => {
        cy.visit('/')
        cy.get('[data-testid=email]').type('user@example.com')
        cy.get('[data-testid=password]').type('password123')
        cy.get('[data-testid=login-button]').click()
        cy.url().should('include', '/dashboard')
    })
})
```

### API Flow Test Example
```typescript
describe('Item Management', () => {
    beforeEach(() => {
        cy.login()
    })

    it('should create and delete item', () => {
        // Create item
        cy.get('[data-testid=new-item]').click()
        cy.get('[data-testid=item-title]').type('Test Item')
        cy.get('[data-testid=save-item]').click()
        
        // Verify item exists
        cy.contains('Test Item').should('be.visible')
        
        // Delete item
        cy.get('[data-testid=delete-item]').click()
        cy.contains('Test Item').should('not.exist')
    })
})
```
EOL

# Create performance testing documentation
cat > docs/testing/performance/README.md << 'EOL'
# Performance Testing Guide

## Overview
Performance testing ensures our application meets performance requirements under various conditions.

## Tools
- k6 for load testing
- Lighthouse for frontend performance
- PostgreSQL EXPLAIN for query optimization

## Running Performance Tests
```bash
# Run k6 load test
k6 run tests/performance/load-test.js

# Run Lighthouse audit
npm run lighthouse

# Run database query analysis
npm run analyze-queries
```

## Writing Tests

### k6 Load Test Example
```javascript
import http from 'k6/http'
import { check, sleep } from 'k6'

export const options = {
    vus: 10,
    duration: '30s',
}

export default function () {
    const res = http.get('http://localhost:8000/api/items')
    check(res, {
        'status is 200': (r) => r.status === 200,
        'response time < 200ms': (r) => r.timings.duration < 200,
    })
    sleep(1)
}
```

## Performance Metrics
- Page Load Time: < 3s
- Time to Interactive: < 5s
- API Response Time: < 200ms
- Database Query Time: < 100ms

## Monitoring
```bash
# Monitor API performance
./scripts/monitor-api.sh

# Monitor database performance
./scripts/monitor-db.sh
```
EOL

echo -e "${GREEN}Testing documentation structure created successfully!${NC}"
echo -e "\nCreated:"
echo "- docs/testing/README.md (Testing overview)"
echo "- docs/testing/backend/ (Backend testing)"
echo "- docs/testing/frontend/ (Frontend testing)"
echo "- docs/testing/e2e/ (End-to-end testing)"
echo "- docs/testing/performance/ (Performance testing)"
echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Customize test examples for your application"
echo "2. Add specific test cases"
echo "3. Update performance metrics"
echo "4. Add more testing scenarios" 