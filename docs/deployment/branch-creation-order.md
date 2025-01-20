# Branch Creation Order After Main Setup

## 1. Verify Main (Production) Branch
```bash
# Verify main branch is working
git checkout main
# Test the application
npm run test  # or your test command
```

## 2. Create Development Branch
```bash
# Create development from main
git checkout main
git checkout -b development
git push -u origin development
```

## 3. Set Up Branch Protections
1. For Main (Production):
   - Require pull request reviews
   - Require status checks
   - No direct pushes
   - Only merge from development

2. For Development:
   - Require basic pull request review
   - Allow merges from feature branches
   - Less strict than main

## 4. Create First Feature Branch
```bash
# Create feature branch from development
git checkout development
git checkout -b feature/your-feature-name
```

## Branch Structure
```
main (production)
  └── development
       └── feature/*
```

**Note**: Don't create a separate production branch - `main` is your production branch. This keeps things simpler and follows standard Git workflow practices. 