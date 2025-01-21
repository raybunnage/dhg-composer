# Setting Up Shared Packages

## Package Structure

Create the following structure in the `packages` directory:

bash
packages/
├── ui/ # Shared UI components
├── supabase-client/ # Shared Supabase functionality
└── types/ # Shared TypeScript types

## 1. Shared UI Components Setup

```bash
# Create ui package directory
mkdir -p packages/ui/src/components
cd packages/ui
```

Initialize package:
```json:packages/ui/package.json
{
  "name": "@dhg/ui",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts",
  "scripts": {
    "build": "tsup",
    "dev": "tsup --watch",
    "lint": "eslint src/",
    "clean": "rm -rf .turbo && rm -rf node_modules && rm -rf dist"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@radix-ui/react-dialog": "^1.0.5",
    "@radix-ui/react-slot": "^1.0.2",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.1.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.43",
    "tsup": "^8.0.1",
    "typescript": "^5.2.2"
  }
}
```
