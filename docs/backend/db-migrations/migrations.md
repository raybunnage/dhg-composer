[← Back to Documentation Home](../README.md)

# Supabase Database Migrations Guide

## Understanding Database Migrations

Database migrations are like version control for your database schema. They help you:
- Track database changes
- Coordinate changes across team members
- Tie database changes to feature branches
- Roll back changes if needed

## Migration Workflow

### 1. Create a Feature Branch
```bash
# Start from main branch
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/user-profiles
```

### 2. Create Migration File
```bash
# In your project root
cd backend/migrations
```

Name your migration file with timestamp and description:
```
20240315123456_add_user_profiles.sql
```

### 3. Write Migration SQL

```sql
-- 20240315123456_add_user_profiles.sql

-- Up Migration
BEGIN;

-- Create new table
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    display_name VARCHAR(100),
    bio TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add indexes
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);

-- Add RLS (Row Level Security)
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view any profile"
    ON user_profiles FOR SELECT
    USING (true);

CREATE POLICY "Users can update own profile"
    ON user_profiles FOR UPDATE
    USING (auth.uid() = user_id);

COMMIT;

-- Down Migration (for rollback)
-- BEGIN;
-- DROP TABLE IF EXISTS user_profiles;
-- COMMIT;
```

### 4. Apply Migration in Development

1. Connect to Supabase Development Project
```bash
# Set environment variables
export SUPABASE_PROJECT_ID="your-dev-project-id"
export SUPABASE_DB_PASSWORD="your-db-password"

# Apply migration
supabase db push
```

2. Test the changes locally
```bash
# Update your backend models
cd backend
python manage.py makemigrations
python manage.py migrate
```

### 5. Commit Changes
```bash
git add backend/migrations/20240315123456_add_user_profiles.sql
git commit -m "Add user profiles table with RLS"
git push origin feature/user-profiles
```

## Best Practices

### 1. One Migration Per Feature
- Keep migrations focused on one feature
- Makes rollbacks easier
- Easier to review and understand

### 2. Always Include Down Migrations
```sql
-- Up Migration
BEGIN;
CREATE TABLE new_feature (...);
COMMIT;

-- Down Migration
BEGIN;
DROP TABLE IF EXISTS new_feature;
COMMIT;
```

### 3. Test Migrations Locally First
```bash
# Create a branch for testing
git checkout -b test/migration-dry-run

# Apply migration to development database
supabase db push

# Test thoroughly
# If issues found, modify migration and test again
```

### 4. Common Migration Patterns

#### Adding a New Table
```sql
BEGIN;
  CREATE TABLE new_table (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );

  -- Add RLS
  ALTER TABLE new_table ENABLE ROW LEVEL SECURITY;

  -- Add policies
  CREATE POLICY "Public read access"
    ON new_table FOR SELECT
    USING (true);
COMMIT;
```

#### Modifying Existing Table
```sql
BEGIN;
  -- Add column
  ALTER TABLE existing_table 
  ADD COLUMN new_column VARCHAR(255);

  -- Add index
  CREATE INDEX idx_new_column 
  ON existing_table(new_column);

  -- Update RLS if needed
  CREATE POLICY "New column access"
    ON existing_table FOR UPDATE
    USING (auth.uid() = user_id);
COMMIT;
```

### 5. Handling Production Deployments

1. Test in development first
2. Create PR with migration
3. Review changes carefully
4. Apply to staging environment
5. Finally apply to production:
```bash
# Switch to production environment
export SUPABASE_PROJECT_ID="your-prod-project-id"

# Apply migration
supabase db push
```

## Troubleshooting

### Common Issues

1. **Migration Failed to Apply**
```bash
# Check migration status
supabase db status

# View detailed logs
supabase db log
```

2. **Need to Rollback**
```bash
# Rollback last migration
supabase db reset

# Then apply migrations up to the desired version
supabase db push
```

3. **Conflict with Existing Schema**
- Always check existing schema before creating migrations
- Use IF NOT EXISTS in CREATE statements
- Use IF EXISTS in DROP statements

## Feature Branch Workflow Example

### 1. New Feature: User Profiles

```bash
# Create feature branch
git checkout -b feature/user-profiles

# Create migration
cat > backend/migrations/20240315_user_profiles.sql << EOL
-- Up Migration
BEGIN;
CREATE TABLE user_profiles (...);
COMMIT;

-- Down Migration
BEGIN;
DROP TABLE IF EXISTS user_profiles;
COMMIT;
EOL

# Apply migration
supabase db push

# Develop feature
# Test thoroughly
# Commit and push
```

### 2. New Feature: User Settings

```bash
# New branch from main
git checkout -b feature/user-settings

# Create migration
cat > backend/migrations/20240316_user_settings.sql << EOL
-- Up Migration
BEGIN;
CREATE TABLE user_settings (...);
COMMIT;

-- Down Migration
BEGIN;
DROP TABLE IF EXISTS user_settings;
COMMIT;
EOL

# Apply migration
supabase db push
```

This workflow ensures each feature has its required database changes properly tracked and versioned. 