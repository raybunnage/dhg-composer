# Git Command Glossary

## Basic Concepts

### HEAD
- **Definition**: A pointer to the latest commit in your current branch
- **Usage**: Acts as a reference to "where you are now" in git history
```bash
# Show where HEAD points to
git rev-parse HEAD

# Show the previous commit
git show HEAD~1

# Show commits HEAD points to
git log HEAD
```

### Branch
- **Definition**: A lightweight movable pointer to a commit
- **Usage**: Used to develop features isolated from each other
```bash
# Create new branch
git checkout -b feature/new-feature

# List all branches
git branch -a
```

### Understanding Git Status
- **Definition**: Shows the current state of your working directory and staging area
- **Think of it like**: A health check of your repository

#### Reading Status Output
```bash
# Run git status
$ git status
On branch main                     # Shows which branch you're on
Your branch is up to date...       # Relationship to remote branch

Changes to be committed:           # Files staged (green)
  (use "git restore --staged..." to unstage)
        modified:   file1.txt      # Will be in next commit
        new file:   file2.txt      # New file added to git

Changes not staged for commit:     # Modified but not staged (red)
  (use "git add..." to stage)
        modified:   file3.txt      # Changed but not staged
        deleted:    file4.txt      # Deleted but not staged

Untracked files:                   # Files git doesn't track (red)
  (use "git add..." to track)
        file5.txt                  # New file, not added to git
```

#### Common Status Messages Explained

1. **Branch Status**
   ```bash
   On branch feature/login         # You are here
   Your branch is ahead by 2       # You have 2 commits to push
   Your branch is behind by 3      # You need to pull 3 commits
   ```

2. **File States**
   ```bash
   modified:   file.txt           # File changed from last commit
   new file:   file.txt          # New file added to git
   deleted:    file.txt          # File removed
   renamed:    old.txt → new.txt # File renamed
   ```

3. **Common Scenarios**
   ```bash
   # Nothing to commit
   nothing to commit, working tree clean  # All changes committed

   # Unmerged paths (during merge conflict)
   both modified:   file.txt      # Same file changed in both branches
   ```

#### Status Best Practices

1. **Check Status Frequently**
   ```bash
   # Before making changes
   git status  # Is working directory clean?

   # Before committing
   git status  # Are the right files staged?

   # After operations
   git status  # Did the command do what you expected?
   ```

2. **Using Short Status**
   ```bash
   git status -s  # Compact view
   M  file.txt    # Modified and staged
   M file.txt    # Modified but not staged
   ?? file.txt   # Untracked file
   A  file.txt   # New file staged
   D  file.txt   # Deleted
   ```

3. **Status Checks Before Operations**
   ```bash
   # Before switching branches
   git status  # Ensure changes are committed/stashed

   # Before pulling
   git status  # Check for local changes

   # Before pushing
   git status  # Verify all changes are committed
   ```

Remember:
- Green means staged (will be in next commit)
- Red means changes not staged yet
- ?? means git doesn't know about the file
- Always check status before and after operations
- Use status to avoid losing work

## Core Commands

### Fetch
- **Definition**: Downloads changes from remote repository without merging
- **Usage**: Updates your remote-tracking branches
- **Think of it like**: Checking what's new in the remote repository without actually applying changes
- **Why use fetch**: Safer than pull because it lets you review changes before merging
```bash
# Basic fetch from origin
git fetch origin

# Fetch all branches
git fetch --all

# Fetch and prune deleted remote branches
git fetch --prune
```

### Reset
- **Definition**: Moves HEAD and branch pointer to a different commit
- **Warning**: `--hard` can permanently delete work - use with caution
- **Types**:
  1. **Soft Reset** (`--soft`): Keeps changes staged
  2. **Mixed Reset** (default): Keeps changes unstaged
  3. **Hard Reset** (`--hard`): Discards all changes
```bash
# Soft reset - keep changes staged
git reset --soft HEAD~1

# Mixed reset (default) - keep changes unstaged
git reset HEAD~1

# Hard reset - DANGER: discards all changes
git reset --hard HEAD~1

# Reset to specific commit
git reset --hard abc123

# Reset single file
git reset HEAD file.txt
```

### Revert
- **Definition**: Creates a new commit that undoes previous changes
- **Usage**: Safer than reset for shared branches
- **Best for**: Undoing changes in public branches
```bash
# Revert last commit
git revert HEAD

# Revert specific commit
git revert abc123

# Revert multiple commits
git revert HEAD~3..HEAD

# Revert merge commit
git revert -m 1 merge-commit-hash
```

## Advanced Concepts

### Reflog
- **Definition**: Git's safety net - records all HEAD updates
- **Usage**: Recover lost commits or branches
```bash
# View reflog
git reflog

# Restore to previous state
git reset --hard HEAD@{1}
```

### Cherry-pick
- **Definition**: Apply specific commits to current branch
- **Usage**: Selectively apply changes from other branches
```bash
# Cherry-pick a commit
git cherry-pick commit-hash

# Cherry-pick without committing
git cherry-pick -n commit-hash
```

### Stash
- **Definition**: Temporarily saves your changes without committing them
- **Think of it like**: Putting your changes in a drawer to work on later
- **When to use**: 
  - Need to switch branches but aren't ready to commit
  - Want to save work-in-progress quickly
  - Need to pull changes but have uncommitted work

#### Basic Stash Usage
```bash
# Save your changes to stash
git stash     # Stashes tracked files
git stash -u  # Also stashes untracked files

# Get your changes back
git stash pop   # Apply and remove from stash
git stash apply # Apply but keep in stash

# View your stashed changes
git stash list  # Shows all stashes
git stash show  # Shows files in latest stash
```

#### Common Stash Scenarios

1. **Quick Branch Switch**
   ```bash
   # Scenario: Need to fix bug but have WIP changes
   git stash                  # Save current changes
   git checkout bugfix       # Switch to bug fix branch
   # Fix bug...
   git checkout previous-branch
   git stash pop            # Get changes back
   ```

2. **Pull Without Committing**
   ```bash
   # Scenario: Need to pull but have local changes
   git stash         # Save changes
   git pull         # Get remote updates
   git stash pop    # Restore changes
   ```

3. **Multiple Stashes**
   ```bash
   # Save with description
   git stash push -m "feature half done"
   
   # List all stashes
   git stash list
   # stash@{0}: On feature: feature half done
   # stash@{1}: WIP on main: abc123
   
   # Apply specific stash
   git stash apply stash@{1}
   ```

#### Stash Best Practices

1. **Add Messages**
   ```bash
   # Good: Descriptive stash
   git stash push -m "halfway through login feature"
   
   # Bad: Default message
   git stash  # Creates generic "WIP on branch" message
   ```

2. **Check Status**
   ```bash
   # Before stashing
   git status  # See what will be stashed
   
   # After applying
   git status  # Verify changes restored
   ```

3. **Clean Up**
   ```bash
   # Remove single stash
   git stash drop stash@{0}
   
   # Remove all stashes
   git stash clear
   ```

#### Stash Safety Tips

1. **Before Stashing**
   ```bash
   # Review changes first
   git diff  # See what you're about to stash
   
   # Stash with untracked files
   git stash -u  # Include untracked files
   ```

2. **Applying Stashes**
   ```bash
   # Safer apply (won't delete stash)
   git stash apply  # Keep stash for backup
   
   # Check for conflicts
   git status      # After applying stash
   ```

3. **Recovery Options**
   ```bash
   # If stash pop fails
   git stash show -p stash@{0} > changes.patch  # Backup to patch
   
   # List all stashes with dates
   git stash list --date=local
   ```

Remember:
- Stash is temporary storage
- Always use descriptive messages
- Clean up old stashes regularly
- Be careful with pop vs apply
- Check status before and after

## Common Workflows

### Feature Branch Workflow
```bash
# Create feature branch
git checkout -b feature/new-feature

# Get latest changes
git fetch origin
git rebase origin/main

# Push feature branch
git push -u origin feature/new-feature
```

### Fixing Mistakes
```bash
# Undo last commit but keep changes
git reset --soft HEAD~1

# Completely undo last commit
git reset --hard HEAD~1

# Revert a public commit
git revert bad-commit-hash
```

### Cleaning Up
```bash
# Remove untracked files (dry run)
git clean -n

# Remove untracked files (for real)
git clean -f

# Remove untracked files and directories
git clean -fd
```

## Best Practices

1. **Before Reset or Revert**
   ```bash
   # Create backup branch
   git branch backup-$(date +%Y%m%d)
   ```

2. **Working with Remote**
   ```bash
   # Update remote references
   git fetch --all --prune
   
   # Check remote status
   git remote -v
   ```

3. **Commit Management**
   ```bash
   # Amend last commit
   git commit --amend
   
   # Squash last 3 commits
   git rebase -i HEAD~3
   ```

## Safety Tips

1. **Always create backups before destructive operations**
2. **Use `--dry-run` when available to preview changes**
3. **Prefer `revert` over `reset` for public branches**
4. **Keep local repository up-to-date with `fetch`**
5. **Use meaningful commit messages**

Remember:
- `fetch` is safe - it doesn't change your working code
- `reset --hard` is dangerous - it discards changes permanently
- `revert` is safer than `reset` for shared branches
- Always verify what HEAD points to before operations 

### Merge
- **Definition**: Combines changes from different branches
- **Usage**: Integrate changes from one branch into another
```bash
# Merge a branch into current branch
git merge feature-branch

# Merge with no fast forward
git merge --no-ff feature-branch

# Abort a merge with conflicts
git merge --abort
```

### Rebase
- **Definition**: Reapplies commits on top of another base commit
- **Usage**: Create a cleaner, linear project history
- **Think of it like**: Moving your work to start from a different point
```bash
# Rebase current branch onto main
git rebase main

# Interactive rebase for cleaning up commits
git rebase -i HEAD~3

# Abort a problematic rebase
git rebase --abort
```

### Remote Management
- **Definition**: Commands for handling remote repositories
```bash
# Add a remote
git remote add origin git@github.com:user/repo.git

# Change remote URL
git remote set-url origin new-url

# Remove a remote
git remote remove origin

# Show remote details
git remote -v
```

### Diff
- **Definition**: Show changes between commits, branches, etc.
```bash
# Show unstaged changes
git diff

# Show staged changes
git diff --staged

# Show changes between branches
git diff main..feature-branch

# Show changes in specific file
git diff path/to/file
```

### Log
- **Definition**: View commit history
```bash
# Show commit history
git log

# Show pretty one-line log
git log --oneline

# Show graph of branches
git log --graph --oneline --all

# Show changes in each commit
git log -p
```

### Tag
- **Definition**: Mark specific points in history as important
```bash
# Create lightweight tag
git tag v1.0

# Create annotated tag
git tag -a v1.0 -m "Version 1.0"

# Push tags to remote
git push origin --tags

# Delete tag
git tag -d v1.0
```

### Submodules
- **Definition**: Include other git repositories within your repository
```bash
# Add submodule
git submodule add git@github.com:user/repo.git path/to/submodule

# Initialize submodules
git submodule init

# Update submodules
git submodule update --recursive

# Update all submodules to latest
git submodule update --remote
```

### Bisect
- **Definition**: Binary search through commits to find bugs
```bash
# Start bisect
git bisect start

# Mark current version as bad
git bisect bad

# Mark known good commit
git bisect good commit-hash

# End bisect
git bisect reset
```

### Worktree
- **Definition**: Manage multiple working trees attached to the same repository
```bash
# Create new worktree
git worktree add ../path branch-name

# List worktrees
git worktree list

# Remove worktree
git worktree remove ../path
```

## Advanced Workflows

### Temporary Commits
```bash
# Create temporary commit
git commit -m "WIP: temporary commit"

# Undo temporary commit but keep changes
git reset --soft HEAD~1
```

### Branch Management
```bash
# Delete local branch
git branch -d branch-name

# Force delete local branch
git branch -D branch-name

# Delete remote branch
git push origin --delete branch-name

# Rename branch
git branch -m old-name new-name
```

### Conflict Resolution
```bash
# Show current conflicts
git status

# Use visual merge tool
git mergetool

# After resolving conflicts
git add .
git commit -m "Resolved merge conflicts"
```

### History Rewriting
```bash
# Change last commit message
git commit --amend -m "New message"

# Add files to last commit
git add forgotten-file
git commit --amend --no-edit

# Rewrite author of all commits
git rebase -r --root --exec "git commit --amend --no-edit --author='New Author <email@example.com>'"
```

### Remote and Origin
- **Definition**: 
  - A "remote" is a copy of the repository hosted elsewhere (usually on a server)
  - "origin" is the default name Git gives to the server you cloned from
  - You can have multiple remotes with different names

```bash
# Show all remotes and their URLs
git remote -v          # View remote repositories
                      # If stuck in pager view:
                      # - Press 'q' to exit
                      # - Or press Ctrl + C

# Common origin operations
git fetch origin          # Get updates from origin
git pull origin main     # Fetch and merge from origin's main branch
git push origin feature  # Push local branch to origin

# Add a different remote
git remote add upstream git@github.com:original/repo.git

# Rename a remote
git remote rename origin github

# Remove a remote
git remote remove upstream

# Show detailed remote info
git remote show origin
```

### Remote Branches
- **Definition**: Local copies of branches from your remote repository
- **Format**: `<remote-name>/<branch-name>` (e.g., `origin/main`)
```bash
# List all remote branches
git branch -r

# List all branches (local and remote)
git branch -a

# Track remote branch
git checkout -b feature origin/feature

# Push new branch to remote
git push -u origin feature  # -u sets up tracking

# Show branch tracking info
git branch -vv
```

### Remote Best Practices
1. **Verify Remote Before Push**
   ```bash
   # Check remote URL
   git remote -v
   
   # Show remote details
   git remote show origin
   ```

2. **Managing Multiple Remotes**
   ```bash
   # Common setup for forked repos
   git remote add upstream git@github.com:original/repo.git
   git fetch upstream
   git rebase upstream/main
   ```

3. **Cleaning Up Remote References**
   ```bash
   # Remove references to deleted remote branches
   git remote prune origin
   
   # Or during fetch
   git fetch --prune
   ```

Remember:
- "origin" is just a conventional name - it could be named anything
- Most commands assume "origin" if no remote is specified
- You can have different remotes for fetching and pushing
- Remote branches are read-only copies - you need to create local branches to work with them 

### Verify Commands
- **Definition**: Commands that check the state or validity of different aspects of your repository and environment
```bash
# Git verification commands
git verify-commit <commit>      # Verify GPG signature of commit
git verify-tag <tag-name>       # Verify GPG signature of tag
git fsck                        # Check repository integrity

# Environment verification
./scripts/verify-branch.sh main # Verify branch state
./scripts/manage-env.sh verify dev # Verify environment setup

# Common verification scenarios
git status                      # Verify working tree status
git remote -v                   # Verify remote configurations
git branch -vv                  # Verify branch tracking
```

### Vercel Deployment
- **Definition**: Commands and processes for deploying to Vercel's hosting platform
```bash
# Basic deployment commands
vercel                         # Deploy to preview URL
vercel --prod                  # Deploy to production
vercel --env-file .env.prod    # Deploy with environment file

# Environment management
vercel env add                 # Add environment variable
vercel env ls                  # List environment variables
vercel env rm                  # Remove environment variable

# Project management
vercel link                    # Link to existing project
vercel switch                  # Switch between projects
vercel inspect                 # Show project details
```

#### Common Vercel Workflows

1. **Initial Setup**
   ```bash
   # Initialize Vercel in project
   vercel init
   
   # Link to existing project
   vercel link
   ```

2. **Development Flow**
   ```bash
   # Deploy preview
   vercel
   
   # Deploy to production
   git push origin main        # Automatic deployment
   # or
   vercel --prod              # Manual deployment
   ```

3. **Environment Management**
   ```bash
   # Add production secret
   vercel env add SUPABASE_KEY production
   
   # Pull environment variables locally
   vercel env pull .env.local
   ```

4. **Domain Management**
   ```bash
   # Add custom domain
   vercel domains add myapp.com
   
   # List domains
   vercel domains ls
   ```

5. **Deployment Management**
   ```bash
   # List deployments
   vercel ls
   
   # Remove deployment
   vercel remove deployment-url
   ```

### Deployment Best Practices

1. **Verification Before Deployment**
   ```bash
   # Check environment
   ./scripts/verify-branch.sh main
   
   # Verify build locally
   npm run build
   ```

2. **Environment Safety**
   ```bash
   # Verify environment variables
   vercel env ls
   
   # Pull latest environment
   vercel env pull
   ```

3. **Deployment Protection**
   ```bash
   # Preview deployment first
   vercel
   
   # Check preview URL
   # Only then deploy to production
   vercel --prod
   ```

Remember:
- Always verify before deploying
- Keep environment variables secure
- Use preview deployments for testing
- Monitor deployment status
- Maintain proper access controls 

### Hotfix
- **Definition**: Emergency fixes for critical production issues that can't wait for regular release cycle
- **Purpose**: Quickly patch production bugs while maintaining proper git workflow

```bash
# 1. Create hotfix branch from production
git checkout production
git pull origin production
git checkout -b hotfix/critical-bug-fix

# 2. Make and test your fixes
git add .
git commit -m "fix: critical production issue"

# 3. Deploy hotfix to production
git checkout production
git merge --no-ff hotfix/critical-bug-fix
git tag -a v1.0.1 -m "Emergency fix for critical issue"
git push origin production --tags

# 4. Sync with development branch
git checkout development
git merge --no-ff hotfix/critical-bug-fix
```

#### Hotfix Best Practices

1. **Before Starting Hotfix**
   ```bash
   # Create backup of production state
   git checkout production
   git branch backup-prod-$(date +%Y%m%d)
   
   # Verify production state
   git log -1  # Check last commit
   git status  # Ensure clean working tree
   ```

2. **During Hotfix**
   ```bash
   # Keep changes minimal
   git diff  # Review changes
   
   # Test thoroughly
   npm run test
   ```

3. **After Hotfix**
   ```bash
   # Update version numbers
   npm version patch  # For Node.js projects
   
   # Document the fix
   git log -p -1  # Get detailed change info for docs
   ```

#### Common Hotfix Scenarios

1. **Quick Security Patch**
   ```bash
   # Create security hotfix
   git checkout -b hotfix/security-patch production
   
   # Apply and test fix
   git add .
   git commit -m "fix: security vulnerability CVE-2023-xxx"
   
   # Deploy with urgency
   git checkout production
   git merge --no-ff hotfix/security-patch
   git push origin production
   ```

2. **Critical Bug Fix**
   ```bash
   # Start hotfix from last stable tag
   git checkout -b hotfix/login-fix v1.0.0
   
   # Fix and test
   git commit -am "fix: login system failure"
   
   # Update both production and development
   git checkout production
   git merge --no-ff hotfix/login-fix
   git checkout development
   git merge --no-ff hotfix/login-fix
   ```

3. **Database Hotfix**
   ```bash
   # Create DB hotfix branch
   git checkout -b hotfix/db-patch production
   
   # Apply database fixes
   git add db/migrations/emergency-fix.sql
   git commit -m "fix: critical database issue"
   
   # Deploy with extra caution
   git checkout production
   git merge --no-ff hotfix/db-patch
   ```

#### Hotfix Rules to Remember

1. **Always Branch from Production**
   - Hotfixes should fix production issues
   - Start from the current production state

2. **Keep Changes Minimal**
   - Fix only the critical issue
   - Avoid adding features or non-critical fixes

3. **Test Thoroughly**
   - Despite urgency, testing is crucial
   - Focus on regression testing

4. **Update All Branches**
   - Merge into production first
   - Then sync with development
   - Update any intermediate branches

5. **Document Everything**
   - Write clear commit messages
   - Update changelog
   - Document deployment steps

Remember:
- Hotfixes are for emergencies only
- Always create backup branches
- Test thoroughly despite time pressure
- Keep team informed of changes
- Document the fix and its deployment 

### Fetch
- **Definition**: Downloads changes from remote repository without merging
- **Usage**: Updates your remote-tracking branches
- **Think of it like**: Checking what's new in the remote repository without actually applying changes
- **Why use fetch**: Safer than pull because it lets you review changes before merging
```bash
# Basic fetch from origin
git fetch origin

# Fetch all branches
git fetch --all

# Fetch and prune deleted remote branches
git fetch --prune
```

### Understanding Fetch
```bash
# Imagine your friend has a document you're both working on.
# 'fetch' is like getting a copy of their changes to look at,
# without changing your version yet.

# Basic fetch - see what's new
git fetch origin

# After fetch, you can:
git log origin/main    # See what changed
git diff main origin/main  # Compare your version with remote
```

### Common Fetch Scenarios

1. **Daily Update Check**
```bash
# Start of your workday
git fetch origin  # Download updates
git status       # See how far behind/ahead you are

# If you want the changes:
git merge origin/main  # Apply downloaded changes
# Or
git pull  # Same as: git fetch + git merge
```

2. **Check Before Push**
```bash
# Before pushing your changes
git fetch origin  # Get latest updates
git status       # Check if you need to update first
```

3. **Safe Update Process**
```bash
# Step 1: Get updates without changing your code
git fetch origin

# Step 2: Look at the changes
git log --oneline main..origin/main

# Step 3: Only if changes look good
git merge origin/main
```

### Fetch vs Pull Explained
```bash
# Fetch (Safe: Two-Step Process)
git fetch origin     # 1. Download changes
git merge origin/main # 2. Apply changes when ready

# Pull (Direct: One-Step)
git pull origin main # Downloads AND applies changes immediately
```

### Best Practices for Beginners
```bash
# 1. Start with fetch
git fetch origin

# 2. Check what's new
git log --oneline HEAD..origin/main

# 3. If changes look good
git merge origin/main

# If anything goes wrong
git merge --abort  # Cancel the merge
```

Remember:
- Fetch is like looking before you leap
- It's safer than pull because you can review first
- No changes happen to your work until you merge
- When in doubt, fetch before pull 

### Prune
- **Definition**: Removes references to remote branches that no longer exist on the remote repository
- **Think of it like**: Cleaning up your local repository of outdated branch information

```bash
# Basic prune
git remote prune origin  # Remove references to deleted remote branches

# Fetch and prune in one command
git fetch --prune  # or git fetch -p

# Show what would be pruned without doing it
git remote prune origin --dry-run
```

#### When to Use Prune
```bash
# Common scenarios:

# 1. After branches are deleted on remote
git fetch --prune  # Update your local references

# 2. Cleaning up old references
git remote prune origin  # Remove stale remote-tracking branches

# 3. During regular maintenance
git fetch --all --prune  # Update all remotes and clean up
```

#### Understanding Prune Output
```bash
# Example output:
Pruning origin
URL: git@github.com:user/repo.git
 * [pruned] origin/feature/old-feature
 * [pruned] origin/feature/removed-branch
```

#### Best Practices
```bash
# 1. Regular cleanup
# Add to your daily/weekly routine:
git fetch --prune

# 2. Before important operations
git fetch --all --prune  # Clean state before merging/rebasing

# 3. After branch cleanup
# After deleting remote branches:
git remote prune origin
```

Remember:
- Prune only removes remote-tracking references
- Does not delete local branches
- Safe to run regularly
- Use `--dry-run` to preview changes 

### Index (Staging Area)
- **Definition**: The intermediate area between your working directory and repository
- **Think of it like**: A preparation area where you organize changes before committing

```bash
# View current staged changes
git diff --cached

# Add files to index
git add file.txt          # Add specific file
git add .                 # Add all changes
git add -p               # Add changes interactively

# Remove from index (but keep in working directory)
git reset HEAD file.txt

# Check index status
git status
```

#### Understanding the Index
```bash
# Three areas in Git:
1. Working Directory (your files)
2. Index/Staging (preparation area)
3. Repository (committed history)

# Common workflow:
git add file.txt     # Working Directory → Index
git commit          # Index → Repository
```

#### Index Best Practices
```bash
# Review changes before staging
git diff            # See unstaged changes

# Stage changes in logical chunks
git add -p          # Review and stage by hunks

# Verify staged changes
git diff --staged   # Review what will be committed
``` 

### CI/CD (Continuous Integration/Continuous Deployment)
- **Definition**: 
  - **CI (Continuous Integration)**: Automatically testing code changes when they're pushed
  - **CD (Continuous Deployment)**: Automatically deploying tested code to production
  - Think of it like a robot assistant that checks and ships your code

#### Understanding CI/CD for Beginners
```bash
# Typical CI/CD Flow:
1. Push code → GitHub
2. Automated tests run
3. If tests pass → Deploy
4. If tests fail → Get notified

# Example with GitHub Actions
git push origin feature  # Triggers CI/CD pipeline
# GitHub Actions runs:
# - Linting
# - Tests
# - Build
# - Deploy (if all above pass)
```

#### Common CI/CD Components

1. **Automated Testing**
   ```bash
   # Tests that typically run:
   npm run lint         # Code style checks
   npm run test        # Unit tests
   npm run e2e        # End-to-end tests
   npm run build      # Build verification
   ```

2. **Environment Deployments**
   ```bash
   # Common deployment flow:
   Feature Branch → Development → Staging → Production
   
   # Each environment might run:
   - Different test suites
   - Security scans
   - Performance checks
   ```

3. **Quality Gates**
   ```bash
   # Examples of quality checks:
   - Test coverage must be > 80%
   - No security vulnerabilities
   - Performance benchmarks met
   - Code review approved
   ```

#### CI/CD Best Practices

1. **Fast Feedback**
   ```bash
   # Local testing before push
   npm run test        # Run tests locally first
   npm run lint        # Check code style
   
   # Watch CI/CD status
   git push origin feature
   # Check GitHub Actions tab for results
   ```

2. **Branch Protection**
   ```bash
   # Common branch rules:
   main branch:
   - Require passing CI checks
   - Require code review
   - No direct pushes
   ```

3. **Environment Management**
   ```bash
   # Environment variables per stage
   development:
   - Use development API keys
   - Debug mode enabled
   
   production:
   - Use production API keys
   - Debug mode disabled
   ```

#### When to Use CI/CD

1. **Every Code Push**
   ```bash
   # Good habits:
   - Push small, frequent changes
   - Watch CI results
   - Fix failures immediately
   ```

2. **Before Merging**
   ```bash
   # Merge checklist:
   1. CI checks pass
   2. Code reviewed
   3. Tests added
   4. Documentation updated
   ```

3. **Production Deployments**
   ```bash
   # Deployment safety:
   1. All tests pass
   2. Staging environment verified
   3. Deployment window appropriate
   4. Rollback plan ready
   ```

#### Common CI/CD Tools

1. **GitHub Actions**
   ```yaml
   # Example workflow file
   name: CI
   on: [push]
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v2
         - run: npm test
   ```

2. **Environment Variables**
   ```bash
   # Secure secrets management
   - Store in GitHub Secrets
   - Never commit to repo
   - Use different values per environment
   ```

3. **Deployment Platforms**
   ```bash
   # Common platforms:
   - Vercel (automatic deployments)
   - Heroku (git-based deploys)
   - AWS (infrastructure as code)
   ```

#### CI/CD Safety Tips

1. **Always Test Locally**
   ```bash
   # Before pushing:
   npm run test
   npm run build
   ```

2. **Monitor Deployments**
   ```bash
   # Watch for:
   - Build failures
   - Test failures
   - Deployment status
   - Application logs
   ```

3. **Have a Rollback Plan**
   ```bash
   # If deployment fails:
   - Know how to revert
   - Have backup deployment ready
   - Monitor error rates
   ```

Remember:
- CI/CD is your safety net
- Don't bypass CI checks
- Keep pipelines fast
- Monitor and maintain regularly
- Start simple and expand gradually 