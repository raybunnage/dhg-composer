#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Cleaning up multi-app references...${NC}"

# Files to check/update
files_to_check=(
    "docs/architecture/multi-app-guide.md"
    "docs/architecture/multi_app_evaluation.md"
    "docs/architecture/monorepo_vs_multiapp.md"
    "scripts/docs/multi-app-guide.md"
)

# Add notice to multi-app files
for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${YELLOW}Adding deprecation notice to $file${NC}"
        temp_file=$(mktemp)
        cat > "$temp_file" << 'EOL'
# DEPRECATED

> **Note**: This documentation refers to the previous multi-app approach. 
> The project has since moved to a monorepo pattern. 
> Please refer to the monorepo documentation for current architecture.

---

EOL
        cat "$file" >> "$temp_file"
        mv "$temp_file" "$file"
    fi
done

# Move deprecated files to archive
mkdir -p docs/archive/multi-app
for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        dir=$(dirname "$file")
        mkdir -p "docs/archive/multi-app/$dir"
        mv "$file" "docs/archive/multi-app/$file"
        echo -e "${GREEN}Moved $file to archive${NC}"
    fi
done

echo -e "${GREEN}Cleanup complete!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review docs/archive/multi-app for any relevant information to preserve"
echo "2. Update any remaining references to multi-app approach"
echo "3. Ensure all documentation reflects current monorepo pattern" 