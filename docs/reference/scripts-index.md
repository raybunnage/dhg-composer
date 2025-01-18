# Scripts Directory Index

## Branch Management Scripts
- `scripts/backup-branches.sh` - Creates timestamped backups of important branches
- `scripts/compare-branches.sh` - Shows differences between branches
- `scripts/verify-branch.sh` - Validates branch structure and configuration

## Configuration Scripts
- `scripts/backup-config.sh` - Backs up configuration files
- `scripts/restore-config.sh` - Restores configuration from backup
- `scripts/manage-env.sh` - Manages environment configurations

## Development Scripts
- `scripts/start-dev.sh` - Starts development environment
- `scripts/rebuild_project.sh` - Rebuilds entire project
- `scripts/run-tests.sh` - Runs project tests

## Usage Examples

### Branch Management
```bash
# Backup branches
./scripts/backup-branches.sh

# Compare branches
./scripts/compare-branches.sh development main

# Verify branch
./scripts/verify-branch.sh feature/new-feature
```

### Configuration Management
```bash
# Backup config
./scripts/backup-config.sh

# Restore config
./scripts/restore-config.sh

# Manage environment
./scripts/manage-env.sh verify dev
```

### Development
```bash
# Start development
./scripts/start-dev.sh

# Rebuild project
./scripts/rebuild_project.sh

# Run tests
./scripts/run-tests.sh
```

## Script Permissions
Make sure scripts are executable:
```bash
# Make all scripts executable
chmod +x scripts/*.sh

# Make specific script executable
chmod +x scripts/specific-script.sh
```

## Adding New Scripts
1. Create script in scripts directory
2. Make executable with `chmod +x`
3. Add to this index
4. Update documentation
5. Commit changes

## Script Standards
- All scripts should:
  - Have a descriptive shebang line
  - Include documentation header
  - Handle errors appropriately
  - Include usage instructions
  - Be executable 