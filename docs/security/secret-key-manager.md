# Generate a base64 secret key
python secret_key_manager.py --generate

# Generate a human-readable secret key
python secret_key_manager.py --generate --readable

# Generate a key with custom length
python secret_key_manager.py --generate --length 64

# Validate an existing key
python secret_key_manager.py --validate "your-secret-key-here"