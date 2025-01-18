# Environment Management Guide

## Environment Files

Each branch/environment has its own `.env` file:

- Development: `backend/.env.dev`
- Staging: `backend/.env.staging`
- Production: `backend/.env.prod`

## Setting Up Environments

1. Create new environment:
```bash
./scripts/manage-env.sh create dev
```

2. Update environment variables:
```bash
./scripts/manage-env.sh update staging
```

3. Verify environment setup:
```bash
./scripts/manage-env.sh verify prod
```

## Environment Variables by Branch

### Development
- Uses local databases
- Debug mode enabled
- Test API keys

### Staging
- Uses staging databases
- Production-like settings
- Test API keys

### Production
- Uses production databases
- Debug mode disabled
- Production API keys

## Best Practices

1. Never commit actual .env files
2. Keep .env.example updated
3. Document all environment variables
4. Use different values for each environment
5. Regularly verify environment setups 