#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Performance Tests...${NC}"

# Backend Performance Tests
run_backend_tests() {
    echo -e "\n${YELLOW}Running Backend Performance Tests...${NC}"
    
    # Run locust tests if file exists
    if [ -f "backend/tests/performance/locustfile.py" ]; then
        locust -f backend/tests/performance/locustfile.py --headless -u 100 -r 10 --run-time 1m
    fi
    
    # Run k6 tests if file exists
    if [ -f "backend/tests/load/k6-script.js" ]; then
        k6 run backend/tests/load/k6-script.js
    fi
}

# Frontend Performance Tests
run_frontend_tests() {
    echo -e "\n${YELLOW}Running Frontend Performance Tests...${NC}"
    
    # Run Lighthouse tests
    lighthouse http://localhost:3000 --output json --output-path ./frontend/tests/performance/lighthouse-report.json
    
    # Run React profiler tests
    if [ -f "frontend/tests/performance/profile-tests.js" ]; then
        node frontend/tests/performance/profile-tests.js
    fi
}

# Database Performance Tests
run_database_tests() {
    echo -e "\n${YELLOW}Running Database Performance Tests...${NC}"
    
    # Run pgbench if available
    if command -v pgbench &> /dev/null; then
        pgbench -i -s 50 dbname
        pgbench -c 10 -j 2 -t 1000 dbname
    fi
}

# Generate Report
generate_report() {
    echo -e "\n${YELLOW}Generating Performance Report...${NC}"
    
    REPORT_DIR="reports/performance/${TIMESTAMP}"
    mkdir -p "${REPORT_DIR}"
    
    # Combine all test results
    echo "Performance Test Results - $(date)" > "${REPORT_DIR}/summary.md"
    
    # Add test results to report
    if [ -f "frontend/tests/performance/lighthouse-report.json" ]; then
        echo "## Lighthouse Scores" >> "${REPORT_DIR}/summary.md"
        jq '.categories' frontend/tests/performance/lighthouse-report.json >> "${REPORT_DIR}/summary.md"
    fi
}

# Run all tests
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
run_backend_tests
run_frontend_tests
run_database_tests
generate_report

echo -e "${GREEN}Performance testing completed. See reports/performance/${TIMESTAMP}/summary.md${NC}" 