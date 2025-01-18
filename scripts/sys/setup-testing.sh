#!/bin/bash

# Create testing directories
mkdir -p backend/tests/{e2e,performance,load}
mkdir -p frontend/tests/{unit,integration,e2e}

# Create config directory
mkdir -p config/{deployment,ci,env-templates}

# Create basic test setup files
touch backend/tests/e2e/conftest.py
touch backend/tests/performance/locustfile.py
touch backend/tests/load/k6-script.js

touch frontend/tests/jest.setup.ts
touch frontend/tests/e2e/cypress.config.ts 