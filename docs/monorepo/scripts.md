# Start dhg-baseline with default ports
./scripts/dev/start-dev-light.sh dhg-baseline

# Start dhg-baseline with custom ports
./scripts/dev/start-dev-light.sh dhg-baseline 8002 5174

# Start another app
./scripts/dev/start-dev-light.sh other-app 8003 5175

# Backup dhg-baseline configuration
./scripts/utils/backup-config-env.sh dhg-baseline

# Backup another app's configuration
./scripts/utils/backup-config-env.sh other-app

Key improvements in this version:
App-Specific Backups: Organizes backups by application name
Component Separation: Backs up both frontend and backend configurations separately
Environment Handling: Handles different environment files for both frontend and backend
Metadata: Includes application name in metadata
Directory Structure: Creates app-specific backup directories
Restore Command: Shows correct restore command with app name
Better Organization: Separates frontend and backend environment files in the backup structure
Usage:
