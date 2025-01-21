# Setting Up Shared Services in DHG Monorepo

This guide outlines the step-by-step process of setting up shared services for the DHG monorepo, including UI components, Supabase client, and shared types.

## 1. Create Package Directory Structure

bash
mkdir -p packages/{ui,supabase-client,types}/src
mkdir -p packages/ui/src/{components,lib}
mkdir -p packages/ui/src/components/{Button,Input,Card,AuthForm}
```

## 2. Set Up Shared UI Package

1. Initialize UI package:
```bash
cd packages/ui
yarn init -y
```

## 3. Set Up Shared Supabase Client

1. Initialize Supabase client package:
```bash
cd packages/supabase-client
yarn init -y
```

2. Create package.json:
```json
{
  "name": "@dhg/supabase-client",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts"
}
```

3. Create core files:
- `src/index.ts` - Main exports
- `src/auth.ts` - Authentication functions
- `src/queries.ts` - Database queries

## 4. Set Up Shared Types

1. Initialize types package:
```bash
cd packages/types
yarn init -y
```

2. Create package.json:
```json
{
  "name": "@dhg/types",
  "version": "0.0.1",
  "private": true,
  "main": "./src/index.ts",
  "types": "./src/index.ts"
}
```

3. Create type definitions:
- `src/index.ts` - Main type exports
- `src/supabase.ts` - Database types

## 5. Configure Build System

1. Add tsconfig.json to each package:
```json
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src"],
  "exclude": ["node_modules", "dist"]
}
```

2. Add tsup.config.ts to each package:
```typescript
import { defineConfig } from 'tsup'

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['cjs', 'esm'],
  dts: true,
  clean: true,
})
```

## 6. Set Up Testing

1. Create test directories:
```bash
mkdir -p packages/{ui,supabase-client}/src/__tests__
```

2. Add test files:
- UI component tests
- Supabase client tests
- Type validation tests

## 7. Update Root Configuration

1. Update root package.json:
```json
{
  "workspaces": [
    "apps/*",
    "packages/*"
  ],
  "scripts": {
    "build": "turbo run build",
    "dev": "turbo run dev",
    "lint": "turbo run lint",
    "clean": "turbo run clean"
  }
}
```

2. Configure Turborepo:
```json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    }
  }
}
```

## 8. Using Shared Packages

1. Add dependencies to applications:
```json
{
  "dependencies": {
    "@dhg/ui": "workspace:*",
    "@dhg/supabase-client": "workspace:*",
    "@dhg/types": "workspace:*"
  }
}
```

2. Import and use shared components:
```typescript
import { AuthForm } from '@dhg/ui'
import { createSupabaseClient } from '@dhg/supabase-client'
import type { User } from '@dhg/types'
```

## Benefits

- **Code Reusability**: Share components and logic across applications
- **Type Safety**: Consistent types across the monorepo
- **Maintainability**: Single source of truth for shared code
- **Development Efficiency**: Develop once, use everywhere
- **Consistency**: Unified UI and business logic

## Best Practices

1. **Version Control**
   - Commit shared packages separately
   - Use meaningful commit messages
   - Tag releases appropriately

2. **Documentation**
   - Document component APIs
   - Maintain changelog
   - Include usage examples

3. **Testing**
   - Write comprehensive tests
   - Test in isolation
   - Test integration with apps

4. **Maintenance**
   - Regular updates
   - Deprecation notices
   - Breaking change management

## Common Issues and Solutions

1. **Build Issues**
   - Clear cache: `yarn clean`
   - Rebuild: `yarn build`
   - Check dependencies

2. **Type Errors**
   - Update type definitions
   - Check version compatibility
   - Rebuild type declarations

3. **Package Resolution**
   - Check workspace configuration
   - Verify package.json
   - Clear node_modules