# Project Scripts Guide

## Quick Access Index
- [Development Scripts](#development-scripts)
- [Deployment Scripts](#deployment-scripts)
- [Backup & Restore Scripts](#backup--restore-scripts)
- [Database Scripts](#database-scripts)
- [Documentation Scripts](#documentation-scripts)
- [Git Management Scripts](#git-management-scripts)
- [System Scripts](#system-scripts)
- [Security Scripts](#security-scripts)
- [Environment Scripts](#environment-scripts)

## Development Scripts
```bash
# Start development environments
./scripts/dev/start-dev.sh             # Full development environment
./scripts/dev/start-dev-light.sh       # Lightweight environment
./scripts/dev/manage-backend.sh        # Backend management
./scripts/dev/run-tests.sh             # Run test suite
```

## Deployment Scripts
```bash
# Staging and Production
./scripts/deploy/deploy-staging.sh     # Deploy to staging
./scripts/deploy/deploy-production.sh  # Deploy to production

# Development deployments
./scripts/dev/deploy-branch.sh         # Deploy to branch
./scripts/dev/deploy-prod.sh           # Deploy to production
./scripts/dev/promote.sh               # Promote changes
```

## Backup & Restore Scripts
```bash
# Full Project Backup
./scripts/backup/backup-full-project.sh         # Complete project backup
./scripts/backup/restore-full-project.sh        # Restore project backup

# Configuration Backup
./scripts/utils/backup-config-env.sh            # Backup environment configs
./scripts/utils/restore-config-env.sh           # Restore environment configs
```

## Database Scripts
```bash
# Database Operations
./scripts/db/db-migrate.sh             # Run database migrations
```

## Documentation Scripts
```bash
# Project Structure Documentation
./scripts/docs/tree-backend.sh         # Generate backend structure
./scripts/docs/tree-project.sh         # Generate project structure

# API Documentation
./scripts/docs/setup-api-docs.sh       # Setup API documentation
./scripts/docs/setup-test-docs.sh      # Setup test documentation
```

## Git Management Scripts
```bash
# Branch Operations
./scripts/git/backup-branches.sh       # Backup Git branches
./scripts/git/compare-branches.sh      # Compare branches
./scripts/git/merge-branch.sh          # Merge branches
./scripts/git/verify-branch.sh         # Verify branch status

# Feature Management
./scripts/git/new-feature.sh          # Create feature branch
./scripts/git/git-commit.sh           # Commit changes
```

## System Scripts
```bash
# Project Structure
./scripts/sys/enhance-project-structure.sh    # Enhance structure
./scripts/sys/reorganize-project.sh           # Reorganize project
./scripts/sys/verify_structure.py             # Verify structure
./scripts/sys/cleanup_backend.sh              # Clean backend

# Configuration
./scripts/sys/backup-config.sh                # Backup system config
./scripts/sys/restore-config.sh               # Restore system config
./scripts/sys/make-scripts-executable.sh      # Make scripts executable
./scripts/sys/setup-new-scripts.sh            # Setup new scripts
./scripts/sys/verify-scripts.sh               # Verify scripts
```

## Security Scripts
```bash
# Security Operations
./scripts/security/security-audit.sh          # Run security audit
./scripts/security/secret_key_manager.py      # Manage secret keys
```

## Environment Scripts
```bash
# Environment Management
./scripts/env/start-venv.sh                   # Start virtual environment
./scripts/setup/setup_environments.sh         # Setup environments
```

## Additional Tools
```bash
# Monitoring and Performance
./scripts/monitoring/monitor-services.sh       # Monitor services
./scripts/performance/run-performance-tests.sh # Run performance tests
```

## Notes
- All scripts should be run from the project root directory
- Scripts use consistent naming with hyphens (not underscores)
- Most scripts provide help text with -h or --help flag
- Configuration backups are environment and branch-specific
- Full project backups include database dumps
- Some scripts may require additional parameters

## Best Practices
1. Always run scripts from project root
2. Check script help text before running
3. Use version control for script changes
4. Test scripts in development first
5. Keep backups before major changes
6. Follow naming conventions (use hyphens)

## See Also
- [Project Structure Documentation](../architecture/project-structure.md)
- [Development Guide](./development.md)
- [Deployment Guide](./deployment.md) 