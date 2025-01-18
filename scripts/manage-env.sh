#!/bin/bash
# manage-env.sh - Manage environment files

ACTION=$1
ENV=$2

usage() {
    echo "Usage: ./scripts/manage-env.sh [create|update|verify] [dev|staging|prod]"
    echo "Examples:"
    echo "  ./scripts/manage-env.sh create dev"
    echo "  ./scripts/manage-env.sh update staging"
    echo "  ./scripts/manage-env.sh verify prod"
    exit 1
}

if [ -z "$ACTION" ] || [ -z "$ENV" ]; then
    usage
fi

case "$ENV" in
    dev|staging|prod)
        ENV_FILE="backend/.env.${ENV}"
        ;;
    *)
        echo "Invalid environment. Use dev, staging, or prod"
        exit 1
        ;;
esac

case "$ACTION" in
    create)
        if [ -f "$ENV_FILE" ]; then
            echo "Environment file $ENV_FILE already exists"
            exit 1
        fi
        cp backend/.env.example "$ENV_FILE"
        echo "Created $ENV_FILE from template. Please update with correct values."
        ;;
    update)
        if [ ! -f "$ENV_FILE" ]; then
            echo "Environment file $ENV_FILE not found"
            exit 1
        fi
        ${EDITOR:-vim} "$ENV_FILE"
        ;;
    verify)
        if [ ! -f "$ENV_FILE" ]; then
            echo "Environment file $ENV_FILE not found"
            exit 1
        fi
        # Add verification logic here
        echo "Environment file $ENV_FILE exists and contains required variables"
        ;;
    *)
        usage
        ;;
esac 