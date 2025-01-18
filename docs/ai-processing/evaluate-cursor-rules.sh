#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Evaluating Project for Potential Cursor Rules...${NC}"

# Function to check patterns in code
analyze_patterns() {
    local dir=$1
    local pattern=$2
    local description=$3
    
    count=$(find $dir -type f -name "*.$pattern" | wc -l)
    if [ $count -gt 0 ]; then
        echo -e "${GREEN}Found ${count} ${pattern} files:${NC} Consider adding rules for ${description}"
    fi
}

# Analyze frontend patterns
echo -e "\n${YELLOW}Frontend Patterns:${NC}"
analyze_patterns "frontend/src" "tsx" "React Component Structure"
analyze_patterns "frontend/src" "css" "CSS/Styling Conventions"
analyze_patterns "frontend/src/hooks" "ts" "Custom Hook Patterns"
analyze_patterns "frontend/src/services" "ts" "API Integration"

# Analyze backend patterns
echo -e "\n${YELLOW}Backend Patterns:${NC}"
analyze_patterns "backend/src" "py" "Python Service Structure"
analyze_patterns "backend/tests" "py" "Testing Patterns"
analyze_patterns "backend/migrations" "sql" "Database Migrations"

# Check for common patterns
echo -e "\n${YELLOW}Suggested Additional Rules:${NC}"

# Frontend Suggestions
if [ -d "frontend/src/components" ]; then
    echo "- Component Architecture Rule: Define patterns for component organization and props"
fi

if [ -d "frontend/src/hooks" ]; then
    echo "- Custom Hooks Rule: Standardize hook creation and naming"
fi

if [ -d "frontend/src/store" ]; then
    echo "- State Management Rule: Define patterns for state management"
fi

# Backend Suggestions
if [ -d "backend/src/services" ]; then
    echo "- Service Layer Rule: Define service class structure and patterns"
fi

if [ -d "backend/src/models" ]; then
    echo "- Data Model Rule: Standardize model definitions and validation"
fi

if [ -d "backend/migrations" ]; then
    echo "- Migration Rule: Define migration naming and structure"
fi

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Review suggested rules"
echo "2. Add rules to .cursorrules file"
echo "3. Test new rules with sample code generation"
echo "4. Refine based on team feedback" 