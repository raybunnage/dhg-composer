[← Back to Documentation Home](../../../README.md)

# Vercel Deployment Process

## 1. Initial Setup & Branch Creation
- Created a new `vercel` branch to isolate deployment changes:
  ```bash
  git checkout -b vercel
  ```

## 2. Vercel Project Setup
- Installed Vercel CLI globally
- Initialized the Vercel project from the root directory
- Configured the project settings:
  - Project name: `dhg-hub`
  - Framework: Vite (auto-detected)
  - Root directory: `frontend`
  - Build settings (auto-detected):
    - Build Command: `vite build`
    - Output Directory: `dist`
    - Development Command: `vite --port $PORT`

## 3. Build Issues & Fixes
- Initial build failed due to TypeScript errors
- Fixed unused variables in:
  - `frontend/src/App.tsx`: Removed unused error state
  - `frontend/src/components/DataFetch.tsx`: Removed unused states and interfaces
- Rebuilt successfully after fixes

## 4. Environment Variables Setup
- Added two critical Supabase environment variables to Vercel:
  - `VITE_SUPABASE_URL`: Your Supabase project URL
  - `VITE_SUPABASE_ANON_KEY`: Your Supabase anonymous key
- These variables are necessary for the frontend to communicate with Supabase

## 5. Deployment
- Deployed to Vercel using:
  ```bash
  vercel --prod
  ```
- Got a production URL: `https://dhg-me8ygwvpl-ray-bunnages-projects.vercel.app`

## 6. Code Promotion
- Merged the changes back to main branch:
  ```bash
  git checkout main
  git pull origin main
  git merge vercel
  git push origin main
  ```

## Benefits
Your React application is now:
- Hosted on Vercel's global CDN
- Automatically builds and deploys when you push to main
- Has proper environment variable configuration for Supabase
- Maintains a clean separation between development and production environments

## Understanding Build Output
When you run `npm run build`, you'll see output like this:
```bash
> frontend@0.0.0 build
> tsc -b && vite build

vite v6.0.7 building for production...
✓ 31 modules transformed.
dist/index.html                   0.46 kB │ gzip:  0.30 kB
dist/assets/index-X8tvmyKQ.css    2.06 kB │ gzip:  0.92 kB
dist/assets/index-CYAlU2D6.js   145.83 kB │ gzip: 47.01 kB
✓ built in 268ms
```

This output tells you:
1. **Build Process**:
   - First runs TypeScript compilation (`tsc -b`)
   - Then runs Vite's production build (`vite build`)

2. **Build Results**:
   - Successfully transformed 31 modules
   - Created three main files in the `dist` directory:
     - `index.html`: The entry point (0.46 KB)
     - `index-X8tvmyKQ.css`: Bundled CSS (2.06 KB)
     - `index-CYAlU2D6.js`: Bundled JavaScript (145.83 KB)
   - Each file shows both original and gzipped sizes
   - Build completed in 268ms

3. **What This Means**:
   - Your code has been minified and bundled for production
   - Assets have unique hashes (e.g., X8tvmyKQ) for cache busting
   - Files are ready to be served by Vercel's CDN

# Vercel Deployment Process

## Quick Start for Beginners
If you're new to deploying with Vercel, here's a simplified workflow for regular development:

1. **Before Starting New Features**
   ```bash
   # Make sure you're on main and up-to-date
   git checkout main
   git pull origin main
   
   # Create a new feature branch
   git checkout -b feature-name
   ```

2. **During Development**
   - Make your changes
   - Test locally using `npm run dev`
   - Commit your changes regularly:
     ```bash
     git add .
     git commit -m "Description of changes"
     ```

3. **Ready to Deploy?**
   - First, deploy to a preview environment:
     ```bash
     vercel
     ```
   - Test your changes on the preview URL Vercel provides
   - If everything looks good, deploy to production:
     ```bash
     vercel --prod
     ```

4. **After Successful Deployment**
   ```bash
   # Update main branch
   git checkout main
   git pull origin main
   git merge feature-name
   git push origin main
   ```

## Recommendations for Smooth Deployments
- Always test in a preview deployment before pushing to production
- Keep your feature branches small and focused
- Check your TypeScript errors locally before deploying:
  ```bash
  cd frontend
  npm run build
  ```
- If you add new environment variables:
  1. Add them to your local `.env` file
  2. Add them to Vercel using `vercel env add VARIABLE_NAME`
  3. Document them in your project's README
- Monitor your deployment logs in the Vercel dashboard for any issues

// ... existing code ...


# Vercel Deployment Process

## Understanding Build Output
When you run `npm run build`, you'll see output like this:
```bash
> frontend@0.0.0 build
> tsc -b && vite build

vite v6.0.7 building for production...
✓ 31 modules transformed.
dist/index.html                   0.46 kB │ gzip:  0.30 kB
dist/assets/index-X8tvmyKQ.css    2.06 kB │ gzip:  0.92 kB
dist/assets/index-CYAlU2D6.js   145.83 kB │ gzip: 47.01 kB
✓ built in 268ms
```

This output tells you:
1. **Build Process**:
   - First runs TypeScript compilation (`tsc -b`)
   - Then runs Vite's production build (`vite build`)

2. **Build Results**:
   - Successfully transformed 31 modules
   - Created three main files in the `dist` directory:
     - `index.html`: The entry point (0.46 KB)
     - `index-X8tvmyKQ.css`: Bundled CSS (2.06 KB)
     - `index-CYAlU2D6.js`: Bundled JavaScript (145.83 KB)
   - Each file shows both original and gzipped sizes
   - Build completed in 268ms

3. **What This Means**:
   - Your code has been minified and bundled for production
   - Assets have unique hashes (e.g., X8tvmyKQ) for cache busting
   - Files are ready to be served by Vercel's CDN

// ... rest of existing content ...