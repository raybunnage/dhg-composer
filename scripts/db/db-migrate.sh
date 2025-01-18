#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Error handling
set -e
trap 'echo -e "${RED}Error on line $LINENO${NC}"; exit 1' ERR

# Help message
show_help() {
    echo "Usage: $0 [up|down|create|status|history] [options]"
    echo
    echo "Commands:"
    echo "  up        Apply pending migrations"
    echo "  down      Rollback last migration"
    echo "  create    Create new migration"
    echo "  status    Show migration status"
    echo "  history   Show migration history"
}

# Main function
main() {
    case "$1" in
        up)
            echo -e "${YELLOW}Applying migrations...${NC}"
            alembic upgrade head
            ;;
        down)
            echo -e "${YELLOW}Rolling back migration...${NC}"
            alembic downgrade -1
            ;;
        create)
            if [ -z "$2" ]; then
                echo -e "${RED}Error: Migration name required${NC}"
                exit 1
            fi
            echo -e "${YELLOW}Creating migration: $2${NC}"
            alembic revision -m "$2"
            ;;
        status)
            echo -e "${YELLOW}Migration status:${NC}"
            alembic current
            ;;
        history)
            echo -e "${YELLOW}Migration history:${NC}"
            alembic history
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@" 