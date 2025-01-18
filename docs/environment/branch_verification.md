# Branch Verification Guide

## Overview
The `verify-branch.sh` script performs comprehensive checks on branches before merging or deployment. It supports three verification levels: basic, thorough, and strict.

## Usage
```bash
./scripts/verify-branch.sh <branch-name> [basic|thorough|strict]

# Examples
./scripts/verify-branch.sh feature/login basic
./scripts/verify-branch.sh staging thorough
./scripts/verify-branch.sh main strict
```

## Verification Levels

### 1. Basic Verification
Default level for feature branches.
```bash
./scripts/verify-branch.sh feature/login
```

**Checks**:
- Branch existence
- Up-to-date status with remote
- Uncommitted changes
- Basic tests
- Environment configuration

### 2. Thorough Verification
Recommended for staging and integration.
```bash
./scripts/verify-branch.sh staging thorough
```

**Additional Checks**:
- Potential merge conflicts
- Sensitive data scanning
- Integration tests
- Environment consistency

### 3. Strict Verification
Required for production branches.
```bash
./scripts/verify-branch.sh main strict
```

**Additional Checks**:
- Signed commits
- Documentation updates
- Dependency status
- Security scans

## Common Scenarios

### 1. Feature Branch Verification
```bash
# Before creating PR
./scripts/verify-branch.sh feature/user-auth basic

# Check output for warnings
# Address any issues before PR
```

### 2. Staging Deployment
```bash
# Before merging to staging
./scripts/verify-branch.sh development thorough

# Verify staging after merge
./scripts/verify-branch.sh staging thorough
```

### 3. Production Release
```bash
# Final checks before release
./scripts/verify-branch.sh main strict

# Must pass all checks before deployment
```

## Understanding Verification Output

### Warning Levels
```bash
✓ Check passed
⚠️  Warning (may need attention)
❌ Error (must be fixed)
```

### Example Output
```bash
Verifying branch: feature/login (Level: basic)
Running basic checks...
✓ Branch exists
⚠️  Warning: Branch is not up to date with remote
✓ No uncommitted changes
Running tests...
✓ All tests passed
Checking environment configuration...
✓ Environment configuration valid
```

## Common Issues and Solutions

### 1. Branch Not Up to Date
```bash
# When you see: "Branch is not up to date with remote"
git fetch origin
git rebase origin/development
```

### 2. Failed Tests
```bash
# When tests fail during verification
./scripts/run-tests.sh --verbose
# Fix failing tests before proceeding
```

### 3. Environment Issues
```bash
# When environment checks fail
./scripts/manage-env.sh verify dev
# Update environment configuration as needed
```

### 4. Sensitive Data Detection
```bash
# When sensitive data is detected
git diff --name-only HEAD
# Remove sensitive data and update .gitignore
```

## Best Practices

1. **Regular Verification**
   - Run basic verification daily
   - Run thorough verification before PRs
   - Run strict verification before deployment

2. **Automated Integration**
   ```bash
   # Add to pre-push hook
   echo './scripts/verify-branch.sh $(git branch --show-current)' > .git/hooks/pre-push
   chmod +x .git/hooks/pre-push
   ```

3. **CI/CD Integration**
   ```yaml
   # In your CI configuration
   verify_branch:
     script:
       - ./scripts/verify-branch.sh $CI_COMMIT_BRANCH thorough
   ```

## Customizing Verification

### Adding Custom Checks
```bash
# Example: Add custom verification
if [ "$LEVEL" = "thorough" ]; then
    # Add your custom checks here
    ./scripts/custom-verify.sh
fi
```

### Environment-Specific Checks
```bash
# Example: Different checks per environment
case "$BRANCH" in
    "development")
        # Development-specific checks
        ;;
    "staging")
        # Staging-specific checks
        ;;
    "main")
        # Production-specific checks
        ;;
esac
```

## Troubleshooting

1. **Script Permission Issues**
   ```bash
   chmod +x scripts/verify-branch.sh
   ```

2. **Environment Detection Issues**
   ```bash
   # Manually specify environment
   ENV=development ./scripts/verify-branch.sh feature/login
   ```

3. **Test Failures**
   ```bash
   # Run specific test suite
   ./scripts/run-tests.sh backend
   ```

Remember:
1. Always run verification before creating PRs
2. Address all warnings and errors
3. Use appropriate verification level
4. Keep verification logs for reference
5. Update verification checks as project evolves 