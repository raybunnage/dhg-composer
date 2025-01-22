# Vercel Configuration Guide

## Overview
This guide covers the setup and configuration of Vercel deployments for the DHG Baseline project, focusing on preview environments with feature branches.

## Prerequisites
- GitHub account connected to Vercel
- Admin access to the Vercel project
- Node.js >=18.0.0 installed locally

## Configuration Files

### 1. .vercelignore
Create this file in the project root to control which files Vercel processes:

```text:.vercelignore
# Ignore everything
*

# Include frontend files
!apps/dhg-baseline/frontend/
!apps/dhg-baseline/frontend/src/
!apps/dhg-baseline/frontend/public/
!apps/dhg-baseline/frontend/index.html
!apps/dhg-baseline/frontend/package.json
!apps/dhg-baseline/frontend/tsconfig.json
!apps/dhg-baseline/frontend/vite.config.ts
!apps/dhg-baseline/frontend/tailwind.config.js
!apps/dhg-baseline/frontend/postcss.config.js

# Include root config files
!package.json
!turbo.json
!.npmrc
```

### 2. vercel.json
Create this configuration file in the project root:

```json:vercel.json
{
  "version": 2,
  "buildCommand": "cd apps/dhg-baseline/frontend && npm install --legacy-peer-deps && npm run build",
  "outputDirectory": "apps/dhg-baseline/frontend/dist",
  "framework": "vite",
  "installCommand": "true",
  "ignoreCommand": "exit 0",
  "git": {
    "deploymentEnabled": {
      "feature/*": true
    }
  }
}
```

### 3. Package.json Updates
Add Vercel-specific build script to `apps/dhg-baseline/frontend/package.json`:

```json:apps/dhg-baseline/frontend/package.json
{
  "scripts": {
    "vercel-build": "vite build"
  }
}
```

## Environment Variables

### Required Variables
Set these in Vercel Dashboard → Project Settings → Environment Variables:

```bash
VITE_SUPABASE_URL=https://jdksnfkupzywjdfefkyj.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Impka3NuZmt1cHp5d2pkZmVma3lqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQxODkwMTMsImV4cCI6MjA0OTc2NTAxM30.035475oKIiE1pSsfQbRoje4-FRT9XDKAk6ScHYtaPsQ
VITE_API_URL=http://localhost:8001
```

Note: For preview deployments, adjust `VITE_API_URL` to point to a publicly accessible API endpoint.

## Deployment Process

### Initial Setup
1. Commit configuration files:
```bash
git add .vercelignore vercel.json apps/dhg-baseline/frontend/package.json
git commit -m "chore: configure vercel preview deployment"
git push origin feature/for-vercel
```

### Verify Deployment
1. Go to Vercel Dashboard
2. Check deployment status
3. Review build logs
4. Test preview URL
5. Verify functionality:
   - Login system
   - API connections
   - Environment variables

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check Node.js version compatibility
   - Verify all dependencies are included
   - Review build logs for errors

2. **Runtime Issues**
   - Check environment variables
   - Verify API endpoints are accessible
   - Review browser console for errors

3. **API Connection Problems**
   - Confirm Supabase credentials
   - Check CORS settings
   - Verify API endpoint accessibility

## Next Steps

After confirming preview deployments work:
1. Set up Development environment
2. Configure Production environment
3. Implement branch protection rules
4. Set up monitoring and alerts

## References
- [Vercel Documentation](https://vercel.com/docs)
- [Vite Documentation](https://vitejs.dev/guide/)
- [Troubleshooting Guide](https://vercel.com/guides/troubleshooting-vercel-cli) 