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

## Core Commands

### Fetch
- **Definition**: Downloads changes from remote repository without merging
- **Usage**: Updates your remote-tracking branches
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
- **Types**:
  1. **Soft Reset** (`--soft`): Keeps changes staged
  2. **Mixed Reset** (default): Keeps changes unstaged
  3. **Hard Reset** (`--hard`): Discards all changes
```bash
# Soft reset - keep changes staged
git reset --soft HEAD~1

# Mixed reset - keep changes unstaged (default)
git reset HEAD~1

# Hard reset - discard all changes (dangerous!)
git reset --hard HEAD~1
```

### Revert
- **Definition**: Creates a new commit that undoes previous changes
- **Usage**: Safer than reset for shared branches
```bash
# Revert last commit
git revert HEAD

# Revert specific commit
git revert commit-hash

# Revert multiple commits
git revert HEAD~3..HEAD
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
- **Definition**: Temporarily store uncommitted changes
- **Usage**: Save work-in-progress without committing
```bash
# Stash changes
git stash

# List stashes
git stash list

# Apply and remove latest stash
git stash pop

# Apply but keep stash
git stash apply
```

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
```bash
# Rebase current branch onto main
git rebase main

# Interactive rebase for editing commits
git rebase -i HEAD~3

# Abort a rebase
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
git remote -v

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
git push origin development
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