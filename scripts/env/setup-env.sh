#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up development environment...${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print section headers
print_section() {
    echo -e "\n${YELLOW}=== $1 ===${NC}"
}

# Check for git installation
print_section "Checking Git Installation"
if ! command_exists git; then
    echo -e "${RED}Git is not installed. Please install Git first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Git is installed${NC}"

# Git configuration
print_section "Configuring Git"

# Get user input for git config
echo -n "Enter your name for git commits: "
read git_name
echo -n "Enter your email for git commits: "
read git_email

# Configure git globals
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"
git config --global pull.rebase false

# Configure useful aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual '!gitk'

echo -e "${GREEN}✓ Git configuration complete${NC}"

# SSH Key Setup
print_section "Setting up SSH Key"

if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo -n "Enter your email for SSH key: "
    read ssh_email
    
    # Generate SSH key
    ssh-keygen -t ed25519 -C "$ssh_email"
    
    # Start ssh-agent
    eval "$(ssh-agent -s)"
    
    # Add SSH key to agent
    ssh-add ~/.ssh/id_ed25519
    
    echo -e "${GREEN}✓ SSH key generated${NC}"
    
    # Display public key
    echo -e "\n${YELLOW}Your SSH public key:${NC}"
    cat ~/.ssh/id_ed25519.pub
    echo -e "\n${YELLOW}Add this key to your GitHub account:${NC}"
    echo "1. Go to GitHub → Settings → SSH and GPG keys"
    echo "2. Click 'New SSH key'"
    echo "3. Paste the key above"
else
    echo -e "${GREEN}✓ SSH key already exists${NC}"
fi

# Create common git ignore
print_section "Creating global gitignore"

cat > ~/.gitignore_global << EOL
# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.idea/
.vscode/
*.swp
*.swo

# Environment files
.env
.env.local
.env.*
!.env.*.template    # Don't ignore templates

# Dependencies
node_modules/
vendor/

# Build output
dist/
build/
*.log
EOL

git config --global core.excludesfile ~/.gitignore_global
echo -e "${GREEN}✓ Global gitignore created${NC}"

# Create common git hooks
print_section "Setting up Git hooks"

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Pre-commit hook
cat > .git/hooks/pre-commit << 'EOL'
#!/bin/bash

# Check for debugging statements
if git diff --cached | grep -E 'console.log|debugger|var_dump|print_r|dd\('; then
    echo "WARNING: Debugging statements found in commit"
    exit 1
fi

# Run tests if they exist
if [ -f "package.json" ] && grep -q "\"test\":" "package.json"; then
    npm test
fi
EOL

chmod +x .git/hooks/pre-commit
echo -e "${GREEN}✓ Git hooks configured${NC}"

# After git hooks setup and before final instructions
print_section "Setting up Environment Templates"

# Create environment templates
./scripts/manage-env.sh create development
./scripts/manage-env.sh create staging
./scripts/manage-env.sh create production

echo -e "${GREEN}✓ Environment templates created${NC}"

# After environment templates setup
print_section "Setting up Python Requirements"

# Create requirements files
./scripts/manage-requirements.sh

echo -e "${GREEN}✓ Requirements files created${NC}"

# Final instructions
print_section "Setup Complete!"
echo -e "Your git environment has been configured with:"
echo "- Git global configuration"
echo "- SSH key setup"
echo "- Global gitignore"
echo "- Git hooks"
echo "- Useful git aliases"
echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Add your SSH key to GitHub if you haven't already"
echo "2. Test your setup with: git clone git@github.com:username/repo.git"
echo "3. Review the created git hooks in .git/hooks/"
echo -e "\n${GREEN}Happy coding!${NC}" 