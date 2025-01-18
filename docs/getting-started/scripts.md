# Project Scripts Guide

## Overview
Our project uses shell scripts to automate common tasks and ensure consistency across environments.

## Core Scripts

### Development Setup
- `setup-env.sh`: Initial development environment setup
  ```bash
  ./scripts/setup-env.sh
  ```

### Environment Management
- `manage-env.sh`: Manage environment configurations
  ```bash
  ./scripts/manage-env.sh create development
  ./scripts/manage-env.sh verify production
  ```

### Testing
- `run-tests.sh`: Run project tests
  ```bash
  ./scripts/run-tests.sh
  ./scripts/run-tests.sh backend
  ```

### Project Management
- `rebuild_project.sh`: Rebuild project
  ```bash
  ./scripts/rebuild_project.sh
  ```

### Configuration
- `backup-config.sh`: Backup configurations
  ```bash
  ./scripts/backup-config.sh
  ```
- `restore-config.sh`: Restore configurations
  ```bash
  ./scripts/restore-config.sh
  ```

## Script Locations

All scripts are located in the `scripts/` directory at the project root:

```
project/
├── scripts/
│   ├── setup-env.sh
│   ├── manage-env.sh
│   ├── run-tests.sh
│   ├── backup-config.sh
│   └── restore-config.sh
```

## Making Scripts Executable

Before using any script, make it executable:

```bash
# Make single script executable
chmod +x scripts/script-name.sh

# Make all scripts executable
chmod +x scripts/*.sh
```

## Script Standards

All scripts follow these standards:
1. Include documentation header
2. Handle errors appropriately
3. Use consistent color coding
4. Provide usage instructions
5. Follow shell scripting best practices

## Common Issues

### Permission Denied
```bash
# If you see "Permission denied", make script executable:
chmod +x scripts/script-name.sh
```

### Script Not Found
```bash
# Ensure you're in project root:
cd /path/to/project
./scripts/script-name.sh
```

## Adding New Scripts

1. Create script in scripts directory
2. Make executable
3. Add to documentation
4. Update scripts/README.md
5. Commit changes

## Best Practices

1. Always run scripts from project root
2. Keep scripts updated with project changes
3. Test scripts in development first
4. Document script changes
5. Follow naming conventions 