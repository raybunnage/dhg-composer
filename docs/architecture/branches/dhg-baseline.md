[← Back to Documentation Home](../README.md)

# DHG Branch Management Guide

## DHG Baseline Branch

This branch (`dhg-baseline`) represents our stable foundation with core functionality.
It includes:

- Basic authentication
- Core data models
- Essential API endpoints

### Deployment URLs
- Production: https://your-app.vercel.app
- Baseline: https://dhg-baseline-your-app.vercel.app
- Development: https://development-your-app.vercel.app

### Working with the Baseline

1. To start a new feature:
   ```bash
   git checkout dhg-baseline
   git checkout -b feature/your-feature
   ```

2. To update baseline:
   - Create PR against dhg-baseline
   - Ensure all tests pass
   - Get required reviews
   - Merge only stable, tested features

3. Recovery process:
   If a feature branch becomes unstable:
   ```bash
   git checkout dhg-baseline
   git checkout -b feature/new-attempt
   ```

## Branch Structure

### Production Branch
- Name: `production`
- URLs:
  - Frontend: https://www.dhg-hub.org
  - API: https://api.dhg-hub.org
- Structure:
  ```text
  production/
  ├── frontend/    # React/TypeScript app
  └── backend/     # FastAPI server
  ```

### Baseline Branch
- Name: `dhg-baseline`
- URLs:
  - Frontend: https://baseline.dhg-hub.org
  - API: https://baseline-api.dhg-hub.org
- Structure:
  ```text
  dhg-baseline/
  ├── frontend/    # Stable frontend foundation
  └── backend/     # Stable backend foundation
  ```

### Staging Branch
- Name: `staging`
- URLs:
  - Frontend: https://staging.dhg-hub.org
  - API: https://staging-api.dhg-hub.org
- Structure:
  ```text
  staging/
  ├── frontend/    # Pre-release testing
  └── backend/     # Pre-release API testing
  ```

### Development Branch
- Name: `development`
- URLs:
  - Frontend: https://dev.dhg-hub.org
  - API: https://dev-api.dhg-hub.org
- Structure:
  ```text
  development/
  ├── frontend/    # Active frontend development
  └── backend/     # Active backend development
  ```

### Feature Branches
```text
feature/auth/
├── frontend/    # Auth-related frontend changes
└── backend/     # Auth-related backend changes

feature/data-model/
├── frontend/    # Data model frontend implementation
└── backend/     # Data model backend implementation
```