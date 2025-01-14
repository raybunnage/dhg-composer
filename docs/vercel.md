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