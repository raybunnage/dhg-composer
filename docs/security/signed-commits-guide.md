# Understanding Signed Commits: A Beginner's Guide

## What Are Signed Commits?
Think of signed commits like putting your official signature on your code changes. It proves that you (and not someone pretending to be you) made the changes.

## Why Use Signed Commits?
1. **Security**: Proves commits really came from you
2. **Trust**: Teams can verify code changes are authentic
3. **Requirement**: Some projects require signed commits

## Setting Up Signed Commits

### 1. Generate a GPG Key
```bash
# 1. Generate your key
gpg --full-generate-key

# 2. Choose these options when asked:
# - Kind of key: RSA and RSA (default)
# - Key size: 4096
# - Key validity: 0 (key does not expire)
# - Real name: Your Name
# - Email: your.email@example.com
# - Comment: (optional)

# 3. List your keys to get the ID
gpg --list-secret-keys --keyid-format=long

# Output looks like:
# sec   4096R/ABC123DEF456 2024-03-15 [SC]
#       ^ This is your key ID
```

### 2. Add Key to GitHub
```bash
# 1. Export your public key
gpg --armor --export ABC123DEF456

# 2. Copy the output (including BEGIN and END lines)

# 3. Go to GitHub:
# - Settings
# - SSH and GPG keys
# - New GPG key
# - Paste your key
```

### 3. Configure Git
```bash
# Tell Git about your signing key
git config --global user.signingkey ABC123DEF456

# Enable automatic signing for all commits
git config --global commit.gpgsign true
```

## Using Signed Commits

### Basic Usage
```bash
# Commit will be automatically signed
git commit -m "Add new feature"

# Force sign a commit
git commit -S -m "Add new feature"

# Verify signed commit
git verify-commit HEAD
```

### Common Scenarios

#### 1. Regular Development
```bash
# Make changes
git add .

# Commit (will be signed automatically)
git commit -m "Update login page"

# Push changes
git push origin main
```

#### 2. Amending Commits
```bash
# Fix last commit
git add forgotten-file
git commit --amend --no-edit  # Will be signed automatically
```

#### 3. Merging Branches
```bash
# Merge with signed commit
git merge feature-branch -S

# Or if automatic signing is enabled:
git merge feature-branch
```

## Troubleshooting

### 1. "Secret key not available"
```bash
# Check your key is available
gpg --list-secret-keys

# Re-import if needed
gpg --import your-key.gpg
```

### 2. "gpg failed to sign the data"
```bash
# Add to your shell profile (~/.bashrc or ~/.zshrc):
export GPG_TTY=$(tty)

# Reload shell
source ~/.bashrc  # or source ~/.zshrc
```

### 3. "No public key" on GitHub
```bash
# 1. Verify key is correctly exported
gpg --armor --export your-key-id

# 2. Check key matches GitHub
# 3. Re-add to GitHub if needed
```

## Best Practices

### 1. Key Safety
```bash
# Backup your key
gpg --export-secret-keys --armor your-key-id > private-key-backup.asc

# Store backup securely (not in git!)
```

### 2. Multiple Computers
```bash
# Export key from first computer
gpg --export-secret-keys --armor your-key-id > private-key.asc

# Import on second computer
gpg --import private-key.asc

# Configure git on second computer
git config --global user.signingkey your-key-id
```

### 3. Regular Verification
```bash
# Verify recent commits
git log --show-signature

# Verify specific commit
git verify-commit commit-hash
```

## Visual Confirmation

### GitHub Shows Verified Commits
```
✓ Verified
This commit was signed with a verified signature
```

### Command Line Shows Signatures
```bash
git log --show-signature
# Shows "Verified" for signed commits
```

## Remember:
1. Keep your private key secure
2. Back up your keys safely
3. Configure each computer you use
4. Verify signatures regularly
5. Never share private keys
6. Use strong passphrases
7. Keep GitHub GPG keys updated

## Quick Reference

### Setup Commands
```bash
# Generate key
gpg --full-generate-key

# Configure git
git config --global user.signingkey your-key-id
git config --global commit.gpgsign true

# Test setup
git commit --allow-empty -m "Test signed commit"
```

### Daily Use Commands
```bash
# Normal workflow (automatic signing)
git add .
git commit -m "Your message"

# Force sign if needed
git commit -S -m "Your message"

# Verify commits
git verify-commit HEAD
``` 