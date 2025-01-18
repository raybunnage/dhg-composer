# Understanding Merges and Merge Tools

## Types of Merges

### 1. Fast-Forward Merge
- **Definition**: Simplest type of merge - moves branch pointer forward
- **When it happens**: When target branch is direct descendant of source branch
```bash
# Example of fast-forward merge
git checkout main
git merge feature  # Will fast-forward if possible

# Force no fast-forward
git merge --no-ff feature  # Creates merge commit even if fast-forward possible
```

### 2. Three-Way Merge
- **Definition**: Creates a new merge commit combining changes from both branches
- **When it happens**: When branches have diverged
```bash
# Standard three-way merge
git checkout main
git merge feature  # Creates merge commit

# With commit message
git merge feature -m "Merging feature branch updates"
```

### 3. Squash Merge
- **Definition**: Combines all changes into one commit on target branch
- **When it happens**: When you want to simplify history
```bash
# Squash merge
git merge --squash feature
git commit -m "Feature: Combined all feature branch changes"
```

## Visual Comparison
```
# Fast-Forward Merge
Before:          After:
main     A---B   main     A---B---C
              \                    
feature        C   feature        C

# Three-Way Merge
Before:          After:
main     A---B   main     A---B---D
              \                /    
feature        C   feature    C     

# Squash Merge
Before:          After:
main     A---B   main     A---B---C'
              \                    
feature        C   feature        C
```

## Merge Tools

### VS Code as Merge Tool

1. **Setup VS Code as Git Merge Tool**
```bash
# Configure VS Code as git mergetool
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# Configure VS Code as git difftool
git config --global diff.tool vscode
git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
```

2. **Using VS Code for Conflicts**
- Open conflict file in VS Code
- Look for conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
- Use VS Code's built-in merge editor:
  - Click "Resolve in Merge Editor" above conflict
  - Choose between "Accept Current", "Accept Incoming", "Accept Both"
  - Or manually edit the merged result

### Cursor AI Merge Assistance

1. **Using Cursor for Merges**
- Cursor provides AI-powered conflict resolution suggestions
- Use `/` command to get merge help:
```bash
# In Cursor, type:
/help resolve merge conflict
```

2. **Cursor Merge Features**
- Automatic conflict analysis
- Suggested resolutions with explanations
- Context-aware merge recommendations

3. **Best Practices with Cursor**
```bash
# 1. Review conflicts first
git status

# 2. Open conflicted files in Cursor
cursor <conflicted-file>

# 3. Use AI suggestions
/explain conflict  # Understand the conflict
/suggest resolution  # Get AI-suggested fix

# 4. Verify and test changes
npm test  # Or appropriate test command
```

## When to Use Each Merge Type

### Fast-Forward Merge
- **Best for**: Simple feature branches that are up-to-date with target
- **Example scenarios**:
  - Quick bug fixes
  - Small features
  - Documentation updates

### Three-Way Merge
- **Best for**: Feature branches with meaningful commit history
- **Example scenarios**:
  - Major features
  - Multiple related changes
  - When commit history is important

### Squash Merge
- **Best for**: Cleaning up messy feature branches
- **Example scenarios**:
  - Experimental features
  - Multiple work-in-progress commits
  - When you want clean main branch history

## Common Merge Scenarios

### 1. Feature Branch Merge
```bash
# Three-way merge for feature
git checkout main
git merge feature-branch

# Or squash if history is messy
git merge --squash feature-branch
git commit -m "Feature: Add user authentication"
```

### 2. Hotfix Merge
```bash
# Fast-forward if possible
git checkout production
git merge hotfix/critical-fix

# Always create merge commit for tracking
git merge --no-ff hotfix/critical-fix
```

### 3. Release Branch Merge
```bash
# No fast-forward to maintain history
git checkout main
git merge --no-ff release/1.0.0
```

## Handling Merge Conflicts

### 1. Using VS Code
```bash
# When conflicts occur
git merge feature-branch
# If conflicts:
code .  # Open VS Code
# Use VS Code's merge editor
```

### 2. Using Cursor AI
```bash
# When conflicts occur
# Open file in Cursor
# Use AI commands:
/explain conflict
/suggest resolution
```

### 3. Manual Resolution
```bash
# View conflicted files
git status

# Choose resolution method
git mergetool  # Use configured tool
# or
git merge --abort  # Start over

# After resolving
git add .
git commit -m "Resolve merge conflicts"
```

## Best Practices

1. **Before Merging**
   ```bash
   # Update branches
   git fetch origin
   git checkout feature
   git rebase main
   ```

2. **During Merge**
   ```bash
   # Create backup branch
   git branch backup-feature-$(date +%Y%m%d)
   
   # Use appropriate merge type
   git merge --no-ff feature  # For important features
   git merge --squash feature # For cleanup
   ```

3. **After Merge**
   ```bash
   # Verify changes
   git log --graph --oneline
   
   # Clean up
   git branch -d feature
   ```

Remember:
- Always update branches before merging
- Choose merge type based on history needs
- Use tools (VS Code/Cursor) for complex conflicts
- Test after resolving conflicts
- Keep backup branches for safety 