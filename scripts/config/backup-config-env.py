#!/usr/bin/env python3

import os
import shutil
import datetime
import subprocess
from pathlib import Path
from typing import Optional, List


class ConfigBackup:
    """Handles backup and restore of environment configuration files."""

    def __init__(self):
        self.root_dir = Path(__file__).resolve().parents[2]  # Go up to project root
        self.backup_dir = self.root_dir / ".config_backups"
        self.env_files = [
            "backend/.env",
            "backend/.env.dev",
            "frontend/.env",
            "frontend/.env.local",
        ]

    def get_current_branch(self) -> str:
        """Get the name of the current git branch."""
        try:
            result = subprocess.run(
                ["git", "branch", "--show-current"],
                capture_output=True,
                text=True,
                check=True,
            )
            return result.stdout.strip()
        except subprocess.CalledProcessError:
            return "unknown_branch"

    def create_backup_dir(self, branch_name: str) -> Path:
        """Create a backup directory with timestamp for the current branch."""
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        backup_path = self.backup_dir / branch_name / timestamp
        backup_path.mkdir(parents=True, exist_ok=True)
        return backup_path

    def backup_configs(self) -> None:
        """Backup all environment configuration files."""
        branch_name = self.get_current_branch()
        backup_path = self.create_backup_dir(branch_name)

        print(f"\n🔄 Backing up configuration files for branch: {branch_name}")
        print(f"📁 Backup location: {backup_path}")

        backed_up_files = []
        for env_file in self.env_files:
            env_path = self.root_dir / env_file
            if env_path.exists():
                # Create necessary subdirectories in backup location
                backup_file_path = backup_path / env_file
                backup_file_path.parent.mkdir(parents=True, exist_ok=True)

                # Copy the file
                shutil.copy2(env_path, backup_file_path)
                backed_up_files.append(env_file)
                print(f"✅ Backed up: {env_file}")
            else:
                print(f"⚠️  Skipped (not found): {env_file}")

        if backed_up_files:
            print(
                f"\n✨ Successfully backed up {len(backed_up_files)} configuration files!"
            )
        else:
            print("\n⚠️  No configuration files were found to backup!")

    def list_backups(self) -> None:
        """List all available backups."""
        if not self.backup_dir.exists():
            print("\n⚠️  No backups found!")
            return

        print("\n📋 Available Backups:")
        for branch_dir in self.backup_dir.iterdir():
            if branch_dir.is_dir():
                print(f"\n🌿 Branch: {branch_dir.name}")
                timestamps = sorted(
                    [d for d in branch_dir.iterdir() if d.is_dir()],
                    key=lambda x: x.name,
                    reverse=True,
                )
                for timestamp_dir in timestamps:
                    print(f"   📅 {timestamp_dir.name}")
                    for env_file in timestamp_dir.rglob("*env*"):
                        if env_file.is_file():
                            relative_path = env_file.relative_to(timestamp_dir)
                            print(f"      📄 {relative_path}")

    def restore_backup(
        self, branch_name: Optional[str] = None, timestamp: Optional[str] = None
    ) -> None:
        """Restore configuration files from a backup."""
        if not branch_name:
            branch_name = self.get_current_branch()

        branch_backup_dir = self.backup_dir / branch_name
        if not branch_backup_dir.exists():
            print(f"\n❌ No backups found for branch: {branch_name}")
            return

        # Get available timestamps
        timestamps = sorted(
            [d for d in branch_backup_dir.iterdir() if d.is_dir()],
            key=lambda x: x.name,
            reverse=True,
        )

        if not timestamps:
            print(f"\n❌ No backup timestamps found for branch: {branch_name}")
            return

        # Use the most recent backup if no timestamp specified
        backup_dir = timestamps[0] if not timestamp else branch_backup_dir / timestamp
        if not backup_dir.exists():
            print(f"\n❌ Backup not found for timestamp: {timestamp}")
            return

        print(f"\n🔄 Restoring configuration from: {backup_dir}")
        restored_files = []
        for env_file in self.env_files:
            backup_file = backup_dir / env_file
            if backup_file.exists():
                target_path = self.root_dir / env_file
                target_path.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(backup_file, target_path)
                restored_files.append(env_file)
                print(f"✅ Restored: {env_file}")

        if restored_files:
            print(
                f"\n✨ Successfully restored {len(restored_files)} configuration files!"
            )
        else:
            print("\n⚠️  No configuration files were found to restore!")


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Backup and restore environment configuration files."
    )
    parser.add_argument(
        "action", choices=["backup", "restore", "list"], help="Action to perform"
    )
    parser.add_argument(
        "--branch", help="Branch name for restore (defaults to current branch)"
    )
    parser.add_argument("--timestamp", help="Specific backup timestamp to restore")

    args = parser.parse_args()
    config_backup = ConfigBackup()

    if args.action == "backup":
        config_backup.backup_configs()
    elif args.action == "list":
        config_backup.list_backups()
    elif args.action == "restore":
        config_backup.restore_backup(args.branch, args.timestamp)


if __name__ == "__main__":
    main()
