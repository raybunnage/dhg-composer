#!/usr/bin/env python3

import os
import base64
import argparse
import secrets
import string
from typing import Optional, Tuple

class SecretKeyManager:
    """Utility class for generating and validating secret keys."""
    
    @staticmethod
    def generate_key(length: int = 32) -> str:
        """
        Generate a cryptographically secure secret key.
        
        Args:
            length (int): Length of the key in bytes (default: 32)
            
        Returns:
            str: URL-safe base64 encoded secret key
        """
        return base64.urlsafe_b64encode(os.urandom(length)).decode('utf-8')

    @staticmethod
    def generate_readable_key(length: int = 32) -> str:
        """
        Generate a human-readable secret key using alphanumeric characters.
        
        Args:
            length (int): Length of the key in characters (default: 32)
            
        Returns:
            str: Human-readable secret key
        """
        alphabet = string.ascii_letters + string.digits
        return ''.join(secrets.choice(alphabet) for _ in range(length))

    @staticmethod
    def validate_key(key: str) -> Tuple[bool, Optional[str]]:
        """
        Validate a secret key.
        
        Args:
            key (str): The secret key to validate
            
        Returns:
            Tuple[bool, Optional[str]]: (is_valid, error_message)
        """
        if not key:
            return False, "Key cannot be empty"
        
        if len(key) < 32:
            return False, "Key should be at least 32 characters long"
            
        try:
            # Try to decode if it's a base64 key
            base64.urlsafe_b64decode(key.encode('utf-8'))
            return True, None
        except Exception:
            # If not base64, check if it's a readable key
            if not all(c in string.ascii_letters + string.digits for c in key):
                return False, "Key contains invalid characters"
            return True, None

def main():
    parser = argparse.ArgumentParser(description='Secret Key Management Utility')
    parser.add_argument('--generate', action='store_true', help='Generate a new secret key')
    parser.add_argument('--readable', action='store_true', help='Generate a human-readable key')
    parser.add_argument('--length', type=int, default=32, help='Length of the key (default: 32)')
    parser.add_argument('--validate', type=str, help='Validate an existing secret key')

    args = parser.parse_args()
    
    if args.generate:
        if args.readable:
            key = SecretKeyManager.generate_readable_key(args.length)
            print(f"\nGenerated readable secret key (length: {len(key)}):")
        else:
            key = SecretKeyManager.generate_key(args.length)
            print(f"\nGenerated base64 secret key (length: {len(key)}):")
        print(f"{key}\n")
        
    elif args.validate:
        is_valid, error = SecretKeyManager.validate_key(args.validate)
        if is_valid:
            print("\n✅ Valid secret key")
            print(f"Length: {len(args.validate)} characters\n")
        else:
            print(f"\n❌ Invalid secret key: {error}\n")
    
    else:
        parser.print_help()

if __name__ == "__main__":
    main()