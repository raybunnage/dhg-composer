#!/bin/bash
# git-commit.sh
# Add, commit, and push changes

git add .
git commit -m "$1"  # Pass commit message as an argument
git push origin main