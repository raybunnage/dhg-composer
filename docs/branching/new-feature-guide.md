# New Feature Branch Guide

## Overview
The `new-feature.sh` script automates the creation of feature branches with proper naming and structure.

## Usage
```bash
./scripts/git/new-feature.sh <feature-name> [base-branch]
```

## Parameters
- `feature-name`: Name of the feature (required)
- `base-branch`: Branch to base feature on (default: main)

## Features
- Standardized branch naming
- Automatic branch creation
- Initial commit template
- Basic test structure setup
- Documentation template

## Examples
```bash
# Create feature branch from main
./scripts/git/new-feature.sh add-user-auth

# Create feature branch from specific base
./scripts/git/new-feature.sh update-api develop

# Create feature with full name
./scripts/git/new-feature.sh "Add OAuth Integration"
```

## Branch Structure
```
feature/
└── feature-name/
    ├── implementation/
    ├── tests/
    └── docs/
``` 