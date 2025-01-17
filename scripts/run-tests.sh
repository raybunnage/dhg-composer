#!/bin/bash
# run-tests.sh
# Run tests for frontend and backend

# Run frontend tests
cd frontend
npm test

# Run backend tests
cd ../backend
pytest