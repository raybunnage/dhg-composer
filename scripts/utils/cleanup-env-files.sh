#!/bin/bash

# Exit on error
set -e

echo "🔍 Finding all .env files..."
find . -type f -name ".env*" -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/.vercel/*" -not -path "*/.config_backups/*"

echo -e "\n❌ The following files can be deleted:"
echo "- ./.env.production (move to apps/dhg-baseline)"
echo "- ./.env.staging (move to apps/dhg-baseline)"
echo "- ./.env.development (move to apps/dhg-baseline)"
echo "- ./file_types/envs/.env"
echo "- ./backups/* (use new backup system)"

read -p "Would you like to delete these files? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f ./.env.production ./.env.staging ./.env.development ./file_types/envs/.env
    rm -rf ./backups
    echo "✅ Files deleted"
fi

echo -e "\n✨ Recommended structure:"
echo "apps/dhg-baseline/"
echo "├── frontend/"
echo "│   ├── .env.production   (protected)"
echo "│   ├── .env.development  (protected)"
echo "│   ├── .env.local        (protected)"
echo "│   └── .env.example      (in git)"
echo "└── backend/"
echo "    ├── .env.production   (protected)"
echo "    ├── .env.development  (protected)"
echo "    ├── .env.local        (protected)"
echo "    └── .env.example      (in git)" 