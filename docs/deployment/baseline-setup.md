# Setting manage-branches as Production Baseline

## 1. Backup Current Branches
```bash
# Backup current main branch state (production)
git checkout main
git tag production-backup-$(date +%Y%m%d)

# Backup development branch
git checkout development
git tag development-backup-$(date +%Y%m%d)

# Backup staging branch
git checkout staging
git tag staging-backup-$(date +%Y%m%d)

# Push all backup tags
git push origin --tags
```

## 2. Clean Up Old Branches
```bash
# Delete production/main branch (local and remote)
git checkout manage-branches  # switch to our new source of truth
git branch -d main  # delete local main
git push origin :main  # delete remote main

# Delete development branch (local and remote)
git branch -d development
git push origin :development

# Delete staging branch (local and remote)
git branch -d staging
git push origin :staging
```

## 3. Update manage-branches
```bash
# Ensure manage-branches is up to date
git checkout manage-branches
git pull origin manage-branches

# Run tests and verify everything works
npm run test  # or your test command
```

## 4. Replace Main Branch
```bash
# Option 1: Force push manage-branches to main (simple but less traceable)
git checkout manage-branches
git push origin manage-branches:main -f

# Option 2: Merge approach (preserves history)
git checkout main
git merge manage-branches --strategy-option theirs
git push origin main
```

## 5. Create New Development Branch
```bash
# Create new development branch from new main
git checkout main
git checkout -b development
git push -u origin development
```

## 6. Cleanup (Optional)
```bash
# Remove old manage-branches branch if desired
git push origin :manage-branches  # only after confirming main is correct
```

## 7. Verify Setup
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

## 8. Update Documentation
1. Update README to reflect new baseline
2. Document current version/state
3. Update any branch-specific documentation

## 9. Next Steps
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

# Restore development if needed
git checkout development-backup-[date]
git checkout -b development-restore
git push origin development-restore:development -f

# Restore staging if needed (for future use)
git checkout staging-backup-[date]
git checkout -b staging-restore
git push origin staging-restore:staging -f
```

## Future Staging Recreation
When needed, staging can be recreated using:
```bash
# Create staging from main when ready
git checkout main
git checkout -b staging
git push -u origin staging

# Or restore from backup if needed
git checkout staging-backup-[date]
git checkout -b staging
git push -u origin staging
```

---

**Note**: Make sure to have all necessary backups before proceeding with branch deletions and modifications. 