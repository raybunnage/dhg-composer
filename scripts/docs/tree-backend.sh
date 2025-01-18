#!/usr/bin/env bash

# Print a tree of the backend directory structure,
# ignoring common build caches or unnecessary directories.
# Adjust these options as desired!

tree backend \
  -L 3 \
  -I "node_modules|__pycache__|*.pyc|dist|*.egg-info" \
  --dirsfirst \
  --filelimit 50 \
  --ignore-case 