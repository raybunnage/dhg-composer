#!/bin/bash

# Backend restructuring
mkdir -p backend/src/{routes,middleware,schemas,config}

# Frontend restructuring
mkdir -p frontend/src/{state,constants,middleware,styles,tests}

# Documentation consolidation
mkdir -p docs/{api,deployment,contributing}

# Move and consolidate guides
mv docs/frontend/typescript/tsx-guide*.md docs/frontend/typescript/archived/
touch docs/frontend/typescript/typescript-guide.md

# Create new documentation files
touch docs/api/README.md
touch docs/deployment/README.md
touch docs/contributing/CONTRIBUTING.md 