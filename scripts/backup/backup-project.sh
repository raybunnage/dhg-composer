#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Timestamp for backup files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="backups/${TIMESTAMP}"

echo -e "${YELLOW}Starting Project Backup...${NC}"

# Create backup directory
mkdir -p "${BACKUP_DIR}"

# Backup database
backup_database() {
    echo "Backing up database..."
    pg_dump -U postgres dbname > "${BACKUP_DIR}/database_${TIMESTAMP}.sql"
}

# Backup code
backup_code() {
    echo "Backing up code..."
    # Exclude node_modules, venv, and other large directories
    tar --exclude='node_modules' \
        --exclude='venv' \
        --exclude='.git' \
        --exclude='__pycache__' \
        -czf "${BACKUP_DIR}/code_${TIMESTAMP}.tar.gz" .
}

# Backup configurations
backup_configs() {
    echo "Backing up configurations..."
    mkdir -p "${BACKUP_DIR}/configs"
    cp .env* "${BACKUP_DIR}/configs/" 2>/dev/null || true
    cp backend/config/*.yaml "${BACKUP_DIR}/configs/" 2>/dev/null || true
}

# Run backups
backup_database
backup_code
backup_configs

echo -e "${GREEN}Backup completed: ${BACKUP_DIR}${NC}" 