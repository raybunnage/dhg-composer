# Current Branch Setup Guide

## Current State
- `main` branch is our source of truth and production branch
- Need to create development branch for new features
- Will use feature branches for development

## 1. Create Development Branch
```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Create and push development branch
git checkout -b development
git push -u origin development
```

## 2. Set Up Branch Protections

### For Main (Production)
- In GitHub repository settings:
  - Require pull request reviews
  - Only allow merges from development
  - No direct pushes
  - Require status checks to pass

### For Development
- In GitHub repository settings:
  - Basic pull request review
  - Allow feature branches to merge
  - Less strict than main

## 3. Workflow for New Features

1. Create feature branch from development:
```bash
git checkout development
git checkout -b feature/your-feature-name
```

2. Work on feature:
```bash
# Make changes
git add .
git commit -m "feat: your feature description"
git push -u origin feature/your-feature-name
```

3. Merge Process:
   - Feature branch → Development (via PR)
   - Test in development
   - Development → Main (via PR, when ready for production)

## Branch Structure
```
main (production)
  └── development
       └── feature/*
```

## Best Practices
1. Never commit directly to main
2. Always create feature branches from development
3. Keep feature branches short-lived
4. Use meaningful branch names (feature/, fix/, etc.)
5. Delete feature branches after merging

## Future Considerations
- Add staging environment when team grows
- Implement automated testing in PR process
- Set up CI/CD pipelines for each environment

---

**Note**: This setup allows for stable production (main) while enabling active development with proper isolation and review processes.
