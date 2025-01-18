# GitHub Guide: From Beginner to Advanced

[Jump to Glossary](#git-terminology-glossary)

## Beginner's Guide

### Understanding Basic Concepts

#### Push vs Pull Request
- **Push**: Think of it as "pushing" your code up to GitHub
  ```bash
  git push origin your-branch-name
  ```
  - Like pushing a box up onto a shelf
  - Directly updates the remote repository
  - Used when you have direct write access

- **Pull Request (PR)**: Think of it as "requesting to pull" your changes into another branch
  ```bash
  # First push your changes
  git push origin your-feature-branch
  
  # Then create PR through GitHub interface
  ```
  - Like asking permission to merge your changes
  - Allows for code review
  - Creates discussion thread
  - Required for protected branches

### Common GitHub Interface Actions

1. **Creating a Pull Request**
   - Push your branch to GitHub
   - Click "Compare & pull request" button
   - Fill in description
   - Select reviewers
   - Click "Create pull request"

2. **Reviewing Pull Requests**
   - Navigate to "Pull requests" tab
   - Select PR to review
   - Click "Files changed"
   - Add comments or suggestions
   - Approve or request changes

3. **Merging Pull Requests**
   - Wait for approvals
   - Resolve any conflicts
   - Click "Merge pull request"
   - Delete branch (optional)

### Initial Setup and Configuration

1. **First-Time Git Setup**
```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Set default editor
git config --global core.editor "code --wait"  # For VS Code
```

2. **GitHub SSH Setup**
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"

# Start ssh-agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# Copy public key to clipboard (Mac)
pbcopy < ~/.ssh/id_ed25519.pub

# Add key to GitHub account
# Go to GitHub → Settings → SSH and GPG keys → New SSH key
```

## Intermediate Guide

### Branch Management Workflow

#### Environment Branch Structure
```
main (production)
  └── staging
       └── development
            ├── feature/user-auth
            ├── feature/payment-integration
            └── hotfix/critical-bug
```

#### Common Branch Operations
```bash
# Create new feature branch
git checkout development
git checkout -b feature/new-feature

# Update feature branch with development changes
git checkout feature/new-feature
git fetch origin
git rebase origin/development

# Merge feature into development
git checkout development
git merge feature/new-feature
```

### Environment Management

1. **Development Environment**
```bash
# Create feature branch
./scripts/new-feature.sh feature-name

# Set up environment
./scripts/manage-env.sh create dev
./scripts/start-dev.sh
```

2. **Staging Environment**
```bash
# Merge to staging
git checkout staging
git merge development
./scripts/manage-env.sh verify staging
./scripts/deploy-branch.sh
```

3. **Production Environment**
```bash
# Deploy to production
git checkout main
git merge staging
./scripts/manage-env.sh verify prod
./scripts/deploy-prod.sh
```

### Hotfix Process
```bash
# Create hotfix branch from main
git checkout main
git checkout -b hotfix/critical-bug

# Make fixes and test
./scripts/run-tests.sh

# Deploy hotfix
./scripts/deploy-branch.sh

# Merge to main and development
git checkout main
git merge hotfix/critical-bug
git checkout development
git merge hotfix/critical-bug
```

## Advanced Guide

### Complex Scenarios

1. **Resolving Merge Conflicts**
```bash
# When conflict occurs
git status  # Check conflicting files
git checkout --ours filename.txt   # Keep our changes
git checkout --theirs filename.txt # Keep their changes
# Or manually edit files
git add filename.txt
git commit -m "Resolved merge conflict"
```

2. **Interactive Rebase**
```bash
# Clean up commits before PR
git rebase -i HEAD~3  # Last 3 commits

# Commands in rebase:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# s, squash = use commit, but meld into previous commit
# f, fixup = like squash, but discard commit message
```

3. **Cherry-Picking**
```bash
# Apply specific commit to another branch
git cherry-pick commit-hash

# Cherry-pick without committing
git cherry-pick -n commit-hash
```

### Advanced Configuration

1. **Git Hooks**
```bash
# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOL'
#!/bin/bash
./scripts/run-tests.sh
EOL
chmod +x .git/hooks/pre-commit
```

2. **Git Aliases**
```bash
# Add useful aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
```

3. **Branch Protection Rules**
- Require pull request reviews
- Require status checks to pass
- Require linear history
- Require signed commits

### Troubleshooting

1. **Recovering Lost Changes**
```bash
# Find lost commits
git reflog

# Recover deleted branch
git checkout -b recovered-branch commit-hash
```

2. **Fixing Wrong Branch**
```bash
# Save changes when committed to wrong branch
git checkout correct-branch
git merge wrong-branch
git checkout wrong-branch
git reset --hard HEAD~1
```

3. **Undoing Changes**
```bash
# Undo last commit but keep changes
git reset --soft HEAD~1

# Completely undo last commit
git reset --hard HEAD~1

# Revert public commit
git revert commit-hash
```

Remember: Always backup important changes before performing complex git operations!

## Understanding Merging

### Merging Concepts for Beginners

Think of merging like combining recipe changes:
- You have a main cookbook (main branch)
- Your friend makes changes to their copy (feature branch)
- You want to add their changes to the main cookbook (merge)

#### Visual Example
```
Before Merge:
main:     A -> B -> C
feature:  A -> B -> X -> Y

After Merge:
main:     A -> B -> C -> X -> Y
feature:  A -> B -> X -> Y
```

### Types of Merges

1. **Fast-forward Merge** (Simplest)
   - Like adding new pages to a book
   - No conflicts because changes are sequential
   ```bash
   # Example of fast-forward merge
   git checkout main
   git merge feature-branch   # Smoothly adds changes
   ```

2. **Recursive Merge** (Most Common)
   - Like combining two different versions of a recipe
   - May have conflicts that need resolution
   ```bash
   # Example of merge with possible conflicts
   git checkout development
   git merge feature/new-login
   ```

3. **Squash Merge** (Clean History)
   - Like combining multiple draft changes into one final version
   ```bash
   # Combine all feature commits into one
   git merge --squash feature/user-profile
   git commit -m "Added user profile feature"
   ```

### Our Branch Merging Workflow

#### 1. Feature Branch → Development
```bash
# Using our scripts
./scripts/merge-feature.sh feature/new-feature

# What it does behind the scenes:
git checkout development
git pull origin development
git merge feature/new-feature
git push origin development
```

#### 2. Development → Staging
```bash
# Using our scripts
./scripts/promote.sh development staging

# Manual process would be:
git checkout staging
git pull origin staging
git merge development
./scripts/manage-env.sh verify staging
git push origin staging
```

#### 3. Staging → Production
```bash
# Using our scripts
./scripts/promote.sh staging main

# Manual process would be:
git checkout main
git pull origin main
git merge staging
./scripts/manage-env.sh verify prod
git push origin main
```

### Common Merging Scenarios

#### 1. Feature Complete
```bash
# Scenario: Your feature is ready for development
./scripts/run-tests.sh                    # Verify tests pass
./scripts/backup-config.sh                # Backup configs
./scripts/merge-feature.sh feature/login  # Merge to development
```

#### 2. Release to Staging
```bash
# Scenario: Development ready for testing
./scripts/verify-branch.sh development    # Check all tests
./scripts/promote.sh development staging  # Promote to staging
./scripts/deploy-branch.sh               # Deploy to staging env
```

#### 3. Hotfix Required
```bash
# Scenario: Production bug needs immediate fix
./scripts/new-hotfix.sh bug-description  # Create hotfix branch
# Make fixes
./scripts/run-tests.sh                   # Verify fix
./scripts/promote.sh hotfix main         # Merge to production
./scripts/promote.sh main development    # Backport to development
```

### Handling Merge Conflicts

When git can't automatically merge changes:

1. **Understand the Conflict**
   ```bash
   # Check which files have conflicts
   git status
   
   # Files will contain markers:
   <<<<<<< HEAD
   your changes
   =======
   their changes
   >>>>>>> feature-branch
   ```

2. **Resolve Using Tools**
   ```bash
   # Use VS Code or preferred editor
   code conflicted-file.txt
   
   # Or use git's built-in tool
   git mergetool
   ```

3. **Complete the Merge**
   ```bash
   # After resolving conflicts
   git add resolved-file.txt
   git commit -m "Resolved merge conflicts"
   ```

### Best Practices

1. **Before Merging**
   - Pull latest changes
   - Run tests
   - Backup configurations
   - Review changes

2. **During Merge**
   - Use appropriate merge strategy
   - Handle conflicts carefully
   - Verify changes after merge

3. **After Merging**
   - Push changes promptly
   - Deploy if needed
   - Clean up branches

### Merge Safety Tips

1. **Always Backup First**
   ```bash
   ./scripts/backup-config.sh
   ```

2. **Create Safety Branch**
   ```bash
   git checkout -b backup/pre-merge-feature
   ```

3. **Verify After Merge**
   ```bash
   ./scripts/run-tests.sh
   ./scripts/verify-branch.sh
   ```

4. **Undo Bad Merge**
   ```bash
   # If merge was not pushed
   git reset --hard HEAD@{1}
   
   # If merge was pushed
   git revert -m 1 HEAD
   ```

Remember: Our scripts handle most common merge scenarios, making the process safer and more consistent. When in doubt, use the scripts rather than manual git commands.

## Git Best Practices

### 1. Commit Practices
- **Write Clear Commit Messages**
  ```bash
  # Good:
  git commit -m "Add user authentication to login page"
  
  # Better (multi-line):
  git commit -m "Add user authentication to login page
  
  - Implement OAuth2 flow
  - Add error handling
  - Create user session management"
  ```

- **Commit Atomic Changes**
  - One logical change per commit
  - Makes review easier
  - Simplifies rollback if needed

### 2. Branch Management
- **Keep Branches Updated**
  ```bash
  # Update your feature branch regularly
  git checkout feature/your-feature
  git fetch origin
  git rebase origin/development
  ```

- **Clean Up After Merging**
  ```bash
  # Delete merged branches
  git branch --merged | grep -v "\*" | xargs -n 1 git branch -d
  ```

### 3. Environment Safety
- **Always Use Environment Templates**
  ```bash
  # Create from template
  ./scripts/manage-env.sh create dev
  
  # Never commit actual .env files
  git reset backend/.env
  ```

- **Backup Before Major Changes**
  ```bash
  # Before merging or rebasing
  ./scripts/backup-config.sh
  ```

### 4. Code Review
- **Review Your Own Code First**
  ```bash
  # Check your changes before pushing
  git diff development...your-branch
  ./scripts/run-tests.sh
  ```

- **Keep PRs Focused**
  - One feature per PR
  - Limit to 400 lines when possible
  - Include tests and documentation

### 5. Workflow Practices
- **Use Feature Branches**
  ```bash
  # Create feature branch
  ./scripts/new-feature.sh feature-name
  
  # Never work directly on main branches
  ```

- **Follow Branch Hierarchy**
  ```
  feature → development → staging → main
  ```

### 6. Security Practices
- **Protect Sensitive Data**
  ```bash
  # Add sensitive files to .gitignore
  echo ".env*" >> .gitignore
  echo "*.key" >> .gitignore
  ```

- **Use Signed Commits**
  ```bash
  # Configure GPG signing
  git config --global commit.gpgsign true
  ```

### 7. Documentation
- **Keep README Updated**
  - Document new features
  - Update setup instructions
  - Include troubleshooting tips

- **Document Branch Strategy**
  ```bash
  # Add branch documentation
  touch docs/branch-strategy.md
  git add docs/branch-strategy.md
  ```

### 8. Testing
- **Test Before Merging**
  ```bash
  # Run full test suite
  ./scripts/run-tests.sh
  
  # Test in correct environment
  ./scripts/manage-env.sh verify staging
  ```

### 9. Recovery Preparation
- **Regular Backups**
  ```bash
  # Backup configurations weekly
  ./scripts/backup-config.sh weekly-backup
  ```

- **Document Recovery Steps**
  ```bash
  # Create recovery documentation
  touch docs/disaster-recovery.md
  ```

### 10. Automation
- **Use Available Scripts**
  ```bash
  # For common operations
  ./scripts/promote.sh development staging
  ./scripts/deploy-branch.sh
  ```

- **Create New Scripts for Patterns**
  ```bash
  # If you repeat something often
  touch scripts/new-helpful-script.sh
  chmod +x scripts/new-helpful-script.sh
  ```

### Common Mistakes to Avoid
1. Working directly on protected branches
2. Pushing sensitive data
3. Forgetting to update branches
4. Skipping tests before merging
5. Not backing up configurations

### Quick Reference
```bash
# Daily workflow
./scripts/start-dev.sh
git pull origin development
./scripts/run-tests.sh

# Before merge
./scripts/backup-config.sh
./scripts/verify-branch.sh

# After merge
./scripts/promote.sh source target
git branch -d old-feature-branch
```

Remember: These practices are enforced and simplified by our scripts, but understanding the underlying principles helps make better decisions when unusual situations arise.

## Additional Git Operations

### Cleaning Repository
```bash
# Remove .DS_Store files from repository
find . -name .DS_Store -print0 | xargs -0 git rm --ignore-unmatch
git commit -m "Remove .DS_Store files"

# Add to .gitignore
echo ".DS_Store" >> .gitignore
echo "._.DS_Store" >> .gitignore
echo "**/.DS_Store" >> .gitignore
echo "**/._.DS_Store" >> .gitignore

# Clean ignored files from working tree
git clean -fdX  # Remove only ignored files
git clean -fd   # Remove untracked files
```

### Branch Comparison and Diffs

#### Command Line Diffs
```bash
# Compare two branches
git diff branch1..branch2

# Compare specific files between branches
git diff branch1..branch2 -- path/to/file

# Show files that differ between branches
git diff --name-status branch1..branch2

# Compare branches from their split point
git diff branch1...branch2  # Note: three dots
```

#### GitHub Pull Request Comparisons
1. **Creating Meaningful PRs**
   - Use the "Files Changed" tab
   - Review commit by commit
   - Use "viewed" checkbox for tracked progress
   - Add line comments for specific feedback

2. **Advanced PR Features**
   - Use "File finder" to locate changes
   - Toggle whitespace changes
   - View changes in "Split" or "Unified" mode
   - Use suggestions feature for small fixes

### Branch Reset Operations

#### Safe Reset Process
```bash
# Create backup branch first
git checkout your-branch
git checkout -b backup/your-branch-YYYYMMDD

# Reset to specific commit
git reset --hard commit-hash

# Reset to remote branch
git reset --hard origin/branch-name

# Force push (if necessary)
git push --force-with-lease origin your-branch
```

#### Starting Over Safely

1. **Backup Current State**
```bash
# Create timestamped backup branches
./scripts/backup-branches.sh  # New script needed

# Or manually
git checkout main
git checkout -b backup/main-$(date +%Y%m%d)
git checkout staging
git checkout -b backup/staging-$(date +%Y%m%d)
git checkout development
git checkout -b backup/development-$(date +%Y%m%d)
```

2. **Reset from Golden Branch**
```bash
# Assuming your-golden-branch is the source of truth
git checkout your-golden-branch

# Reset main
git checkout -B main
git push -f origin main

# Reset staging from main
git checkout -B staging main
git push -f origin staging

# Reset development from staging
git checkout -B development staging
git push -f origin development
```

### Testing Branches

#### Test Branch Strategy
```
main
  └── staging
       └── development
            ├── feature/*
            ├── test/*      # Dedicated test branches
            └── hotfix/*
```

#### Testing Branch Practices
1. **Creating Test Branches**
   ```bash
   # Create test branch from feature
   git checkout feature/new-feature
   git checkout -b test/new-feature-tests
   ```

2. **Parallel Testing**
   ```bash
   # Create multiple test variants
   git checkout -b test/feature-variant1
   git checkout -b test/feature-variant2
   ```

3. **Integration Testing**
   ```bash
   # Create integration test branch
   git checkout development
   git checkout -b test/integration-sprint5
   ```

### Common Gotchas and Solutions

1. **Accidentally Committed Sensitive Data**
   ```bash
   # Remove sensitive file from git history
   git filter-branch --force --index-filter \
   "git rm --cached --ignore-unmatch path/to/sensitive-file" \
   --prune-empty --tag-name-filter cat -- --all
   
   # Force push all branches
   git push origin --force --all
   ```

2. **Wrong Branch Base**
   ```bash
   # Change branch base
   git rebase --onto new-base old-base your-branch
   ```

3. **Merged Wrong Branch**
   ```bash
   # Revert merge
   git revert -m 1 merge-commit-hash
   ```

### Initial Branch Setup Best Practices

1. **Starting from Golden Branch**
   ```bash
   # Create main from golden branch
   git checkout golden-branch
   git checkout -b main
   
   # Create staging
   git checkout main
   git checkout -b staging
   
   # Create development
   git checkout staging
   git checkout -b development
   ```

2. **Setting Branch Protection**
   - Protect all environment branches
   - Set up required reviews
   - Enable status checks
   - Disable force push

3. **Environment Configuration**
   ```bash
   # Set up environment files
   ./scripts/manage-env.sh create prod
   ./scripts/manage-env.sh create staging
   ./scripts/manage-env.sh create dev
   ```

### New Script Suggestions

1. **backup-branches.sh**
   - Creates timestamped backups of all important branches
   - Stores backup branch list in documentation

2. **compare-branches.sh**
   - Shows diff summary between branches
   - Highlights environment file differences
   - Checks for missing commits

3. **verify-branch.sh**
   - Validates branch structure
   - Checks environment configurations
   - Runs appropriate tests

Remember: Always document branch operations in team wiki or documentation, especially when performing major resets or restructuring.

## Git Terminology Glossary

### Basic Terms
- **Repository (Repo)**: Think of it as a project's folder that Git tracks. Like a filing cabinet for your code.

- **Clone**: Making a copy of a repository on your computer. Like downloading a complete project folder.

- **Commit**: A snapshot of your changes. Like taking a photo of your code at a specific moment.

- **Push**: Uploading your commits to GitHub. Like backing up your work to the cloud.

- **Pull**: Downloading changes from GitHub. Like getting the latest version of a shared document.

- **Origin**: The default name for your remote repository (usually on GitHub). Like a nickname for the central storage location of your code.
  ```bash
  # Common uses of origin:
  git push origin main     # Send changes to main branch on GitHub
  git pull origin dev      # Get changes from dev branch on GitHub
  
  # See what origin points to
  git remote -v
  
  # Add a different remote
  git remote add upstream https://github.com/original/repo.git
  ```

- **Remote**: Any version of your repository hosted somewhere else (like GitHub). You can have multiple remotes:
  - `origin`: Your default remote (usually your GitHub repository)
  - `upstream`: Common name for the original repository you forked from
  - You can name remotes anything you want
  ```bash
  # List all remotes
  git remote -v
  
  # Add a new remote
  git remote add staging https://github.com/your/staging-repo.git
  
  # Remove a remote
  git remote remove staging
  ```

### Branch Operations
- **Branch**: A separate version of your code. Like creating a copy of a document to make edits safely.

- **Checkout**: Switching to a different branch. Like opening a different version of your document.

- **Merge**: Combining changes from one branch into another. Like combining edits from two documents.

- **Rebase**: Moving or combining a sequence of commits to a new base commit. Like rewriting history to make it cleaner.
  ```bash
  # Example: Update feature branch with latest development changes
  git checkout feature-branch
  git rebase development
  ```

- **Cherry-pick**: Applying a specific commit from one branch to another. Like copying one specific change from one document to another.
  ```bash
  # Copy a specific change to your current branch
  git cherry-pick abc123  # where abc123 is the commit hash
  ```

### Protection and Security
- **Status Checks**: Automated tests that must pass before merging. Like having a proofreader check your document.

- **Linear History**: Requiring branches to be up-to-date before merging. Like making sure you're editing the latest version.

- **Signed Commits**: Commits verified with your cryptographic signature. Like adding your digital signature to changes.
  ```bash
  # Set up commit signing
  git config --global commit.gpgsign true
  ```

### Advanced Operations
- **Force Push**: Overwriting remote history (dangerous!). Like forcing your version of a document over others'.
  ```bash
  # Safe force push
  git push --force-with-lease
  ```

- **Reflog**: Git's log of all changes to branch tips. Like a backup log of all your actions.
  ```bash
  # View reflog
  git reflog
  ```

- **Stash**: Temporarily saving uncommitted changes. Like putting work-in-progress in a drawer.
  ```bash
  # Save current changes
  git stash
  
  # Retrieve saved changes
  git stash pop
  ```

### Common Terms in Pull Requests
- **Review**: Someone checking your changes before they're merged. Like having an editor review your work.

- **Approval**: Reviewer accepting your changes. Like getting a thumbs-up from your editor.

- **CI/CD**: Continuous Integration/Continuous Deployment. Like having automatic quality checks and publishing.

### Environment Terms
- **Environment Variables**: Configuration settings that change between environments. Like having different settings for test and live versions.

- **Production**: Live environment that users see. Like the published version of your work.

- **Staging**: Pre-production testing environment. Like the final draft before publishing.

- **Development**: Environment for active development. Like your working draft.

### Common Git Commands Explained
```bash
# Show current status (what files changed?)
git status

# Add files to be committed (prepare changes)
git add filename

# Save changes with a message (take a snapshot)
git commit -m "message"

# Get latest changes from GitHub
git pull

# Send your changes to GitHub
git push

# Create new branch
git checkout -b branch-name

# Switch branches
git checkout branch-name

# Show commit history
git log
```

### Common GitHub Terms
- **Fork**: Your copy of someone else's repository. Like making your own copy of a shared document.

- **Pull Request (PR)**: Requesting to merge your changes. Like submitting your work for review.

- **Issue**: A task, enhancement, or bug report. Like a to-do item or problem report.

- **Actions**: Automated workflows. Like having a robot helper do tasks automatically.

Remember: These terms become clearer with practice. Don't hesitate to reference this glossary whenever needed!

### Verification Terms
- **Verify**: A comprehensive check of code and configuration readiness. Like a pre-flight checklist before takeoff.
  ```bash
  ./scripts/verify-branch.sh development
  ```

- **Status Checks**: Automated tests and verifications that must pass. Types include:
  - Code linting (style checks)
  - Unit tests
  - Integration tests
  - Environment configuration validation
  - Security scans

## Understanding Verification

### What Verification Does

Our verification scripts perform multiple checks to ensure code and configuration quality:

1. **Environment Verification**
```bash
./scripts/manage-env.sh verify prod

# Checks performed:
- Required environment variables present
- Database connection strings valid
- API keys and secrets formatted correctly
- Environment-specific settings appropriate
```

2. **Branch Verification**
```bash
./scripts/verify-branch.sh staging

# Checks performed:
- Branch is up to date with parent
- No merge conflicts present
- All tests passing
- Environment configurations correct
- No sensitive data in commits
```

3. **Deployment Verification**
```bash
./scripts/verify-deploy.sh

# Checks performed:
- Build succeeds
- Dependencies resolved
- Environment variables set
- Required services available
```

### When to Use Verification

1. **Before Merging**
```bash
# Check feature branch before PR
./scripts/verify-branch.sh feature/new-feature

# Check development before staging merge
./scripts/verify-branch.sh development
```

2. **Before Deployment**
```bash
# Verify staging environment
./scripts/manage-env.sh verify staging

# Verify production readiness
./scripts/manage-env.sh verify prod
```

3. **After Configuration Changes**
```bash
# Verify new environment setup
./scripts/manage-env.sh verify dev

# Verify after updating variables
./scripts/verify-config.sh
```

### Common Verification Issues and Solutions

1. **Missing Environment Variables**
```bash
# Check which variables are missing
./scripts/manage-env.sh verify dev

# Copy from template if needed
./scripts/manage-env.sh create dev
```

2. **Failed Tests**
```bash
# Run specific test suite
./scripts/run-tests.sh backend

# Debug test failures
./scripts/run-tests.sh --verbose
```

3. **Configuration Mismatches**
```bash
# Compare environments
./scripts/compare-env.sh staging prod

# Update from template
./scripts/manage-env.sh update staging
```

### Verification Best Practices

1. **Regular Verification**
   - Run verification daily on development
   - Verify before any significant merge
   - Verify after environment changes

2. **Environment-Specific Checks**
   ```bash
   # Development checks
   ./scripts/verify-branch.sh development --level=basic
   
   # Staging checks
   ./scripts/verify-branch.sh staging --level=thorough
   
   # Production checks
   ./scripts/verify-branch.sh main --level=strict
   ```

3. **Custom Verifications**
   ```bash
   # Add project-specific checks
   ./scripts/verify-custom.sh
   
   # Verify specific components
   ./scripts/verify-component.sh auth
   ```

### Automated Verification

1. **GitHub Actions**
   - Runs verification on PR creation
   - Checks branch status automatically
   - Prevents merging if verification fails

2. **Pre-commit Hooks**
   ```bash
   # Add verification to pre-commit
   ./scripts/install-hooks.sh
   ```

3. **Scheduled Verification**
   ```bash
   # Daily verification job
   ./scripts/schedule-verify.sh daily
   ```

Remember: Verification is your safety net. Never skip verification steps, especially before merging to protected branches or deploying to production.
