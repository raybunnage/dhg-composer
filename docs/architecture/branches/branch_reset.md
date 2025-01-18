# Branch Reset Process

## Backup Current State
First, let's create a backup branch just in case:

```bash
# Create backup of current state
git checkout main
git branch backup/pre-reset-main main
git checkout staging
git branch backup/pre-reset-staging staging
git checkout development
git branch backup/pre-reset-development development
```

## Reset Process

### 1. Delete Existing Branches
```bash
# Switch to your golden branch first
git checkout your-golden-branch

# Delete existing branches (use -D for force delete)
git branch -D main
git branch -D staging
git branch -D development

# If you have remote branches, you'll need to delete those too (requires admin rights)
git push origin --delete main
git push origin --delete staging
git push origin --delete development
```

### 2. Recreate Branch Structure
```bash
# Create new main branch from golden
git checkout -b main
git push -u origin main

# Create new staging from main
git checkout -b staging
git push -u origin staging

# Create new development from staging
git checkout -b development
git push -u origin development
```

### 3. Setup Branch Protection
After recreating the branches, ensure you:
1. Re-enable branch protection rules in GitHub/GitLab
2. Set up required reviews
3. Set up CI/CD triggers

### 4. Update Local Development
Team members will need to run:
```bash
# Update local repo
git fetch --all --prune
git checkout development
git pull origin development

# Delete their old local branches
git branch -D staging
git branch -D main
```

### 5. Environment Setup
For each environment:

```bash
# Development
git checkout development
./scripts/setup-env.sh development

# Staging
git checkout staging
./scripts/setup-env.sh staging

# Production
git checkout main
./scripts/setup-env.sh production
```

## Verification Checklist

- [ ] All three branches (main, staging, development) exist
- [ ] Branch protection rules are in place
- [ ] CI/CD pipelines are working
- [ ] Environment configurations are correct
- [ ] Team members have updated their local repositories
- [ ] Backup branches exist for recovery if needed

## Recovery Plan
If anything goes wrong:

```bash
# Restore main
git checkout backup/pre-reset-main
git branch -D main
git checkout -b main
git push -f origin main

# Restore staging
git checkout backup/pre-reset-staging
git branch -D staging
git checkout -b staging
git push -f origin staging

# Restore development
git checkout backup/pre-reset-development
git branch -D development
git checkout -b development
git push -f origin development
```

## Cleanup
After everything is verified working (wait at least a week):

```bash
# Remove backup branches
git branch -D backup/pre-reset-main
git branch -D backup/pre-reset-staging
git branch -D backup/pre-reset-development
```