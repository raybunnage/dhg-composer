# Understanding and Using run-tests.sh

## What is run-tests.sh?
The `run-tests.sh` script is your helper for running tests in the project. Think of it like a checklist that makes sure everything is working correctly before you share your code.

## Basic Usage

### 1. Running All Tests
```bash
# Run all tests
./scripts/run-tests.sh

# What this does:
# 1. Checks if your environment is set up
# 2. Runs backend tests (Python/FastAPI)
# 3. Runs frontend tests (React)
# 4. Shows you the results
```

### 2. Running Specific Tests
```bash
# Test just the backend
./scripts/run-tests.sh backend

# Test just the frontend
./scripts/run-tests.sh frontend

# Test a specific feature
./scripts/run-tests.sh backend auth
```

## Understanding Test Output

### Success Example
```bash
Running tests...
✓ Backend tests passed (15 tests)
✓ Frontend tests passed (10 tests)
All tests completed successfully!
```

### Failure Example
```bash
Running tests...
✓ Backend tests passed (15 tests)
✗ Frontend tests failed
  Error in src/components/Login.test.tsx
  Expected: user to be logged in
  Received: user is null

# Don't panic! This tells you:
# 1. Where the problem is (Login.test.tsx)
# 2. What went wrong (user should be logged in but isn't)
```

## Common Scenarios

### 1. Before Pushing Code
```bash
# Good practice before git push
git add .
./scripts/run-tests.sh  # Run all tests
git commit -m "feat: add login page"  # Only if tests pass
```

### 2. After Pulling Updates
```bash
git pull origin main
./scripts/run-tests.sh  # Make sure nothing broke
```

### 3. During Development
```bash
# While working on auth feature
./scripts/run-tests.sh backend auth  # Test just auth
```

## Troubleshooting Common Issues

### 1. Permission Denied
```bash
# If you see: Permission denied
chmod +x scripts/run-tests.sh  # Make script executable
```

### 2. Environment Issues
```bash
# If tests fail with environment errors:
# 1. Check your .env file exists
cp .env.example .env

# 2. Verify environment
./scripts/manage-env.sh verify dev
```

### 3. Test Database Issues
```bash
# If database tests fail:
# 1. Check database is running
docker ps  # Should see your database container

# 2. Reset test database
./scripts/run-tests.sh reset-db
```

## Test Types Explained

### 1. Unit Tests
```bash
# Tests individual components
./scripts/run-tests.sh unit

# Example output:
Testing Login component...
✓ Renders login form
✓ Handles invalid input
✓ Submits form data
```

### 2. Integration Tests
```bash
# Tests components working together
./scripts/run-tests.sh integration

# Example output:
Testing authentication flow...
✓ User can login
✓ User can access protected routes
```

### 3. API Tests
```bash
# Tests backend endpoints
./scripts/run-tests.sh api

# Example output:
Testing /api/auth...
✓ POST /login validates input
✓ GET /user returns user data
```

## Best Practices

### 1. Run Tests Frequently
```bash
# Good times to run tests:
# - Before committing
# - After pulling changes
# - When changing important code
# - Before deploying
```

### 2. Fix Failures Immediately
```bash
# When a test fails:
1. Read the error message carefully
2. Check the failing test file
3. Make fixes
4. Run tests again
```

### 3. Keep Tests Updated
```bash
# When you add new features:
1. Add new tests
2. Update existing tests if needed
3. Run full test suite
```

## Safety Tips

1. **Always Run Tests Before Pushing**
   ```bash
   ./scripts/run-tests.sh
   # Only push if tests pass
   ```

2. **Keep Test Database Separate**
   ```bash
   # Tests should use:
   TEST_DB_NAME=test_database
   # Never use production database for tests!
   ```

3. **Handle Test Data Carefully**
   ```bash
   # Before tests:
   ./scripts/run-tests.sh setup  # Prepare test data
   
   # After tests:
   ./scripts/run-tests.sh cleanup  # Clean test data
   ```

## Remember:
1. Run tests before sharing code
2. Read error messages carefully
3. Keep test database separate
4. Update tests with new features
5. Don't ignore failing tests
6. Use appropriate test type for each case
7. Clean up test data when done 