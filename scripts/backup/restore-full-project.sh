#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if timestamp provided
if [ "$#" -lt 1 ]; then
    echo -e "${RED}Usage: $0 <timestamp|latest>${NC}"
    echo "Example: $0 20240315_123456"
    echo "         $0 latest"
    exit 1
fi

TIMESTAMP=$1

# Handle 'latest' symlink
if [ "$TIMESTAMP" = "latest" ]; then
    if [ ! -L "backups/latest" ]; then
        echo -e "${RED}No 'latest' backup found${NC}"
        exit 1
    fi
    BACKUP_DIR=$(readlink -f "backups/latest")
    echo -e "${YELLOW}Using latest backup: ${BACKUP_DIR}${NC}"
else
    BACKUP_DIR="backups/${TIMESTAMP}"
fi

# Check if backup exists
if [ ! -d "${BACKUP_DIR}" ]; then
    echo -e "${RED}Backup directory not found: ${BACKUP_DIR}${NC}"
    exit 1
fi

echo -e "${YELLOW}Starting Full Project Restore from: ${BACKUP_DIR}${NC}"

# Restore database
restore_database() {
    echo "Restoring database..."
    if [ -f "${BACKUP_DIR}/database_${TIMESTAMP}.sql" ]; then
        psql -U postgres dbname < "${BACKUP_DIR}/database_${TIMESTAMP}.sql"
    else
        echo -e "${RED}Database backup not found${NC}"
    fi
}

# Restore code
restore_code() {
    echo "Restoring code..."
    if [ -f "${BACKUP_DIR}/code_${TIMESTAMP}.tar.gz" ]; then
        # Create temporary directory for extraction
        TMP_DIR=$(mktemp -d)
        tar -xzf "${BACKUP_DIR}/code_${TIMESTAMP}.tar.gz" -C "$TMP_DIR"
        
        # Confirm before overwriting
        read -p "This will overwrite current code. Continue? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rsync -av --exclude='backups/' "$TMP_DIR/" .
        fi
        rm -rf "$TMP_DIR"
    else
        echo -e "${RED}Code backup not found${NC}"
    fi
}

# Restore configurations
restore_configs() {
    echo "Restoring configurations..."
    if [ -d "${BACKUP_DIR}/configs" ]; then
        cp -r "${BACKUP_DIR}/configs/"* .
    else
        echo -e "${RED}Configuration backup not found${NC}"
    fi
}

# Run restores
restore_database
restore_code
restore_configs

echo -e "${GREEN}Restore completed from: ${BACKUP_DIR}${NC}" 