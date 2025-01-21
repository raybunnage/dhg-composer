# Starting DHG Baseline Frontend

## Development Server

Navigate to the frontend directory:

bash
cd apps/dhg-baseline/frontend

Install dependencies (first time only):
```bash
yarn install
```

Start the development server:
```bash
yarn dev
```

The server will start on `http://localhost:5173` by default.

## Alternative Commands

From the root directory:
```bash
# Using yarn workspace
yarn workspace @dhg/baseline-frontend dev

# Or using the shorthand command (if configured in root package.json)
yarn baseline:frontend dev
```

## Production Preview

To build and preview the production version:
```bash
# Build
yarn build

# Preview the build
yarn preview
```

## Environment Setup

Make sure you have the required environment variables:
```bash
cp .env.example .env
```

Required variables in `.env`:
```
VITE_SUPABASE_URL=your-supabase-url
VITE_SUPABASE_ANON_KEY=your-supabase-anon-key
```

## Common Issues

1. If port 5173 is in use, Vite will automatically try the next available port
2. Make sure you're using Node.js version 18 or higher
3. Clear the cache if you encounter module resolution issues:
   ```bash
   yarn clean
   yarn install
   ```