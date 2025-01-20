# Supabase Version Testing Guide

## Overview
This guide provides a systematic approach to testing Supabase versions to identify proxy-related issues. It helps track which version combinations work with our proxy setup and which cause problems.

## Current Working Version
Our baseline working configuration:
```json
{
  "dependencies": {
    "@supabase/supabase-js": "1.0.3",
    "@supabase/auth-helpers-nextjs": "0.5.0",
    "@supabase/gotrue-js": "1.24.0"
  }
}
```

## Testing Infrastructure

### 1. Directory Structure
```bash
tests/
└── supabase/
    ├── version-tests/
    │   ├── test-version.sh     # Test runner script
    │   ├── proxy-test.ts       # Proxy functionality test
    │   └── version-matrix.ts   # Version combinations to test
    └── results/
        └── version-results.csv # Test results log
```

### 2. Test Runner Script
```bash
#!/bin/bash
# tests/supabase/version-tests/test-version.sh

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Error handling
set -e
trap 'echo -e "${RED}Error on line $LINENO${NC}"; exit 1' ERR

test_version() {
    local sb_version=$1
    local helpers_version=$2
    local gotrue_version=$3
    local results_file="tests/supabase/results/version-results.csv"

    echo -e "${YELLOW}Testing Supabase Version Combination:${NC}"
    echo "supabase-js: $sb_version"
    echo "auth-helpers: $helpers_version"
    echo "gotrue-js: $gotrue_version"

    # Create backup of package.json
    cp package.json package.json.backup

    # Install specific versions
    npm install @supabase/supabase-js@$sb_version \
               @supabase/auth-helpers-nextjs@$helpers_version \
               @supabase/gotrue-js@$gotrue_version

    # Run proxy test
    npm run test:proxy

    # Store result and timestamp
    local result=$?
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    if [ $result -eq 0 ]; then
        echo -e "${GREEN}✓ Version combination works${NC}"
        echo "$timestamp,$sb_version,$helpers_version,$gotrue_version,SUCCESS" >> "$results_file"
    else
        echo -e "${RED}✗ Version combination fails${NC}"
        echo "$timestamp,$sb_version,$helpers_version,$gotrue_version,FAIL" >> "$results_file"
    fi

    # Restore package.json
    mv package.json.backup package.json
    npm install

    return $result
}

# Run test if arguments provided
if [ "$#" -eq 3 ]; then
    test_version "$1" "$2" "$3"
fi
```

### 3. Proxy Test
```typescript
// tests/supabase/version-tests/proxy-test.ts

import { createClient } from '@supabase/supabase-js';

const testProxy = async () => {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );

  try {
    // Test basic query through proxy
    const { data, error } = await supabase
      .from('test_table')
      .select('*')
      .limit(1);

    if (error) throw error;
    
    // Test authentication
    const authResponse = await supabase.auth.getSession();
    if (authResponse.error) throw authResponse.error;

    console.log('✓ Proxy test successful');
    return true;
  } catch (error) {
    console.error('✗ Proxy test failed:', error);
    return false;
  }
};

export default testProxy;
```

### 4. Version Matrix
```typescript
// tests/supabase/version-tests/version-matrix.ts

interface VersionTest {
  supabaseJs: string;
  authHelpers: string;
  gotrueJs: string;
  description?: string;
}

const versionTests: VersionTest[] = [
  // Current working version (baseline)
  {
    supabaseJs: "1.0.3",
    authHelpers: "0.5.0",
    gotrueJs: "1.24.0",
    description: "Current working version"
  },
  // Incremental updates through v2
  {
    supabaseJs: "1.35.7",
    authHelpers: "0.5.0",
    gotrueJs: "1.24.0",
    description: "Last stable v1 release"
  },
  {
    supabaseJs: "2.0.0",
    authHelpers: "0.5.0",
    gotrueJs: "2.0.0",
    description: "Initial v2 release"
  },
  {
    supabaseJs: "2.1.0",
    authHelpers: "0.6.0",
    gotrueJs: "2.10.0",
    description: "First major v2 update"
  },
  {
    supabaseJs: "2.1.3",
    authHelpers: "0.7.0",
    gotrueJs: "2.22.0",
    description: "Mid v2 stable release"
  },
  {
    supabaseJs: "2.2.1",
    authHelpers: "0.8.7",
    gotrueJs: "2.62.0",
    description: "Target stable version"
  }
];

export default versionTests;
```

## Testing Strategy

### Phase 1: Baseline Verification
1. Confirm current setup works:
```bash
./tests/supabase/version-tests/test-version.sh "1.0.3" "0.5.0" "1.24.0"
```

### Phase 2: Last V1 Stable
2. Test last stable v1 release:
```bash
./tests/supabase/version-tests/test-version.sh "1.35.7" "0.5.0" "1.24.0"
```

### Phase 3: V2 Migration
3. Test initial v2 release:
```bash
./tests/supabase/version-tests/test-version.sh "2.0.0" "0.5.0" "2.0.0"
```

### Phase 4: V2 Stability
4. Test stable v2 versions:
```bash
# Test 2.1.0
./tests/supabase/version-tests/test-version.sh "2.1.0" "0.6.0" "2.10.0"

# Test 2.1.3
./tests/supabase/version-tests/test-version.sh "2.1.3" "0.7.0" "2.22.0"

# Test 2.2.1
./tests/supabase/version-tests/test-version.sh "2.2.1" "0.8.7" "2.62.0"
```

### Version Migration Notes

#### V1 to V2 Breaking Changes
- Authentication API changes
- Type system updates
- Configuration changes
- Middleware adjustments

#### Key Configuration Changes
```typescript
// V1 configuration
const supabase = createClient(supabaseUrl, supabaseKey);

// V2 configuration
const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  }
});
```

## Detailed Migration Guide: v1.0.3 to v2

### 1. Authentication Changes

#### v1.0.3 Authentication
```typescript
// Old auth methods
const { user, session, error } = await supabase.auth.signIn({
  email: 'example@email.com',
  password: 'password'
});

const { error } = await supabase.auth.signOut();

// Session handling
const session = supabase.auth.session();
const user = supabase.auth.user();
```

#### v2.x Authentication
```typescript
// New auth methods
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'example@email.com',
  password: 'password'
});

const { error } = await supabase.auth.signOut();

// Session handling
const { data: { session } } = await supabase.auth.getSession();
const { data: { user } } = await supabase.auth.getUser();
```

### 2. Client Configuration Changes

#### v1.0.3 Configuration
```typescript
// Old client setup
const supabase = createClient(supabaseUrl, supabaseKey);

// Old options
const supabase = createClient(supabaseUrl, supabaseKey, {
  localStorage: window.localStorage,
  autoRefreshToken: true,
  persistSession: true
});
```

#### v2.x Configuration
```typescript
// New client setup with required options
const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true,
    storage: window.localStorage
  }
});
```

### 3. Middleware Changes

#### v1.0.3 Middleware
```typescript
// Old middleware approach
import { supabaseClient } from '@supabase/auth-helpers-nextjs';

export async function getServerSideProps({ req }) {
  const { user } = await supabaseClient.auth.api.getUserByCookie(req);
  return { props: { user } };
}
```

#### v2.x Middleware
```typescript
// New middleware setup
import { createMiddlewareClient } from '@supabase/auth-helpers-nextjs';

export async function middleware(req) {
  const res = NextResponse.next();
  const supabase = createMiddlewareClient({ req, res });
  await supabase.auth.getSession();
  return res;
}
```

### 4. Database Query Changes

#### v1.0.3 Queries
```typescript
// Old query patterns
const { data, error } = await supabase
  .from('table')
  .select('*')
  .eq('column', value)
  .single();

// Old real-time subscription
const subscription = supabase
  .from('table')
  .on('*', payload => {
    console.log('Change received!', payload);
  })
  .subscribe();
```

#### v2.x Queries
```typescript
// New query patterns with improved types
const { data, error } = await supabase
  .from('table')
  .select('*')
  .eq('column', value)
  .single();

// New real-time subscription
const channel = supabase
  .channel('table_changes')
  .on('postgres_changes', { 
    event: '*', 
    schema: 'public',
    table: 'table'
  }, payload => {
    console.log('Change received!', payload);
  })
  .subscribe();
```

### 5. Step-by-Step Migration Process

1. **Preparation**
   ```bash
   # Create backup of package.json
   cp package.json package.json.backup
   
   # Create new feature branch
   ./scripts/git/new-feature.sh supabase-v2-migration
   ```

2. **Update Dependencies**
   ```bash
   # Remove old versions
   npm remove @supabase/supabase-js @supabase/auth-helpers-nextjs @supabase/gotrue-js
   
   # Install new versions one at a time
   npm install @supabase/supabase-js@2.0.0
   npm install @supabase/auth-helpers-nextjs@0.5.0
   npm install @supabase/gotrue-js@2.0.0
   ```

3. **Update Client Configuration**
   ```typescript
   // Update all createClient calls
   const supabase = createClient(supabaseUrl, supabaseKey, {
     auth: {
       autoRefreshToken: true,
       persistSession: true,
       detectSessionInUrl: true
     }
   });
   ```

4. **Update Auth Methods**
   - Replace all `signIn` with `signInWithPassword`
   - Update session handling to use `getSession`
   - Update user fetching to use `getUser`

5. **Update Middleware**
   - Replace old middleware with new createMiddlewareClient
   - Update server-side auth checks
   - Test protected routes

6. **Update Database Queries**
   - Update real-time subscriptions to use new channel-based API
   - Test all database operations
   - Verify type safety improvements

7. **Testing Steps**
   ```bash
   # Test each version increment
   ./tests/supabase/version-tests/test-version.sh "1.35.7" "0.5.0" "1.24.0"
   ./tests/supabase/version-tests/test-version.sh "2.0.0" "0.5.0" "2.0.0"
   ```

### 6. Common Migration Issues

1. **Authentication Flows**
   - Session persistence changes
   - Cookie handling differences
   - OAuth flow updates

2. **Type System Changes**
   - Stricter type checking
   - New type definitions needed
   - Generic type parameters required

3. **Real-time Subscriptions**
   - Channel-based API requires different setup
   - Event payload structure changes
   - Connection handling differences

4. **Middleware Integration**
   - Session handling changes
   - Cookie management updates
   - Protected route modifications

### 7. Rollback Procedure

If issues are encountered:
```bash
# Restore old package.json
mv package.json.backup package.json

# Reinstall original dependencies
npm install

# Reset feature branch
git reset --hard origin/development
```

## Usage

### 1. Setup Testing Environment
```bash
# Create new feature branch
./scripts/git/new-feature.sh supabase-version-test

# Create test directory structure
mkdir -p tests/supabase/{version-tests,results}

# Copy test files
cp docs/supabase/guides/test-files/* tests/supabase/version-tests/
```

### 2. Run Individual Version Test
```bash
# Test specific version combination
./tests/supabase/version-tests/test-version.sh "2.2.1" "0.8.7" "2.62.0"
```

### 3. Run All Tests
```bash
# Add to package.json scripts
{
  "scripts": {
    "test:supabase-versions": "ts-node tests/supabase/version-tests/run-all.ts",
    "test:proxy": "ts-node tests/supabase/version-tests/proxy-test.ts"
  }
}

# Run all version tests
npm run test:supabase-versions
```

### 4. Review Results
Results are stored in `tests/supabase/results/version-results.csv` with timestamps and outcomes.

## Troubleshooting

### Common Issues

1. **Proxy Connection Failures**
   - Check proxy configuration in `next.config.js`
   - Verify Supabase URL and API keys
   - Check for CORS issues in browser console

2. **Version Conflicts**
   - Review peer dependency warnings
   - Check for breaking changes in release notes
   - Try updating related packages together

3. **Authentication Issues**
   - Verify auth helpers configuration
   - Check session handling changes between versions
   - Review auth middleware setup

## Best Practices

1. **Testing Process**
   - Always start from known working version
   - Test one version change at a time
   - Document any breaking changes encountered
   - Keep track of successful version combinations

2. **Version Management**
   - Use exact versions (no ^ or ~)
   - Update all related packages together
   - Maintain a version compatibility matrix
   - Document required configuration changes

3. **Rollback Plan**
   - Keep package.json backups
   - Document configuration changes
   - Maintain restore points
   - Test downgrade procedures

## Next Steps

1. Run baseline test with current versions
2. Test incremental updates one package at a time
3. Document working combinations
4. Update production dependencies to latest stable version
5. Maintain version testing as part of upgrade procedure 