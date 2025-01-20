# Setting manage-branches as Production Baseline

## 1. Backup Current State
```bash
# Backup current main branch state
git checkout main
git tag main-backup-$(date +%Y%m%d)
git push origin --tags
```

## 2. Update manage-branches
```bash
# Ensure manage-branches is up to date
git checkout manage-branches
git pull origin manage-branches

# Run tests and verify everything works
npm run test  # or your test command
```

## 3. Replace Main Branch
```bash
# Option 1: Force push manage-branches to main (simple but less traceable)
git checkout manage-branches
git push origin manage-branches:main -f

# Option 2: Merge approach (preserves history)
git checkout main
git merge manage-branches --strategy-option theirs
git push origin main
```

## 4. Update Development Branch
```bash
# Create new development branch from new main
git checkout main
git checkout -b development
git push -u origin development
```

## 5. Cleanup (Optional)
```bash
# Remove old manage-branches branch if desired
git push origin :manage-branches  # only after confirming main is correct
```

## 6. Verify Setup
1. Check GitHub repository
   - Verify main branch contains manage-branches code
   - Confirm development branch is created
   - Test branch protections

2. Verify local development
   ```bash
   git fetch --all
   git checkout main
   git pull origin main
   git checkout development
   ```

## 7. Update Documentation
1. Update README to reflect new baseline
2. Document current version/state
3. Update any branch-specific documentation

## 8. Next Steps
1. Set up branch protections for main and development
2. Create first feature branch from development
3. Begin implementing new features using the new workflow

## Recovery Plan
If anything goes wrong:
```bash
# Restore from backup tag
git checkout main-backup-[date]
git checkout -b main-restore
git push origin main-restore:main -f
``` 