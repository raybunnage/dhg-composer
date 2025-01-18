# Python Requirements Management

This document describes how we manage Python dependencies across different environments.

## Requirements Structure

```
requirements/
├── requirements.txt          # Base requirements for all environments
├── requirements.dev.txt      # Development-specific requirements
├── requirements.staging.txt  # Staging-specific requirements
└── requirements.prod.txt     # Production-specific requirements
```

## File Purposes

### Base Requirements (requirements.txt)
- Core dependencies needed in all environments
- Framework dependencies (FastAPI, SQLAlchemy, etc.)
- Authentication libraries
- Database connectors

### Development Requirements (requirements.dev.txt)
- Includes all base requirements
- Testing frameworks (pytest)
- Linting and formatting tools
- Debugging tools
- Documentation generators
- Development server

### Staging Requirements (requirements.staging.txt)
- Includes all base requirements
- Monitoring tools
- Testing frameworks
- Logging enhancements

### Production Requirements (requirements.prod.txt)
- Includes all base requirements
- Production server (Gunicorn)
- Performance monitoring
- Error tracking
- Production-grade logging

## Usage

### Initial Setup
```bash
# Create all requirements files
./scripts/manage-requirements.sh
```

### Installing Dependencies

Development:
```bash
pip install -r requirements/requirements.dev.txt
```

Staging:
```bash
pip install -r requirements/requirements.staging.txt
```

Production:
```bash
pip install -r requirements/requirements.prod.txt
```

### Adding New Dependencies

1. Determine which environment needs the dependency
2. Add to appropriate requirements file
3. If needed in all environments, add to `requirements.txt`
4. Document version constraints

### Version Pinning

We use these version specifiers:
- `>=x.y.z`: Minimum version required
- `==x.y.z`: Exact version required
- `~=x.y.z`: Compatible release

### Best Practices

1. **Keep Base Requirements Minimal**
   - Only include truly shared dependencies
   - Move environment-specific packages to appropriate files

2. **Version Control**
   - All requirements files should be in version control
   - Generated `pip freeze` outputs should not be committed

3. **Regular Updates**
   ```bash
   # Check for outdated packages
   pip list --outdated
   
   # Update after testing
   pip install --upgrade -r requirements/requirements.dev.txt
   ```

4. **Security**
   ```bash
   # Run security check
   pip-audit
   
   # Update vulnerable packages
   pip-audit --fix
   ```

5. **Virtual Environments**
   ```bash
   # Create new environment
   python -m venv venv
   
   # Activate environment
   source venv/bin/activate  # Unix
   venv\Scripts\activate     # Windows
   ```

## Dependency Management Commands

### Check Dependencies
```bash
# List installed packages
pip list

# Show dependency tree
pip install pipdeptree
pipdeptree

# Find outdated packages
pip list --outdated
```

### Update Dependencies
```bash
# Update single package
pip install --upgrade package-name

# Update all packages in requirements
pip install --upgrade -r requirements/requirements.dev.txt
```

### Generate Requirements
```bash
# Create requirements from current environment
pip freeze > requirements/requirements.new.txt
```

## Troubleshooting

### Common Issues

1. **Dependency Conflicts**
   ```bash
   # Show detailed dependency information
   pip install --verbose package-name
   ```

2. **Version Mismatch**
   ```bash
   # Check specific package version
   pip show package-name
   ```

3. **Missing Dependencies**
   ```bash
   # Install with verbose output
   pip install -v -r requirements/requirements.txt
   ```

Remember to:
- Regularly update dependencies for security
- Test thoroughly after updates
- Document any special dependency requirements
- Use virtual environments for isolation 