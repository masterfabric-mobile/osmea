# Database Schema & Migrations

**Project:** OSMEA Admin Website  
**Version:** 1.0.0  
**Date:** 2026-01-09  
**Database:** PostgreSQL (via Supabase)

---

## 📋 Overview

This document details the complete database schema for the Admin Website, including all tables, relationships, indexes, Row Level Security (RLS) policies, and migration scripts.

---

## 🗄️ Database Architecture

### Entity Relationship Diagram

```
┌─────────────┐       ┌──────────────────┐       ┌─────────────┐
│   auth.     │       │     stores       │       │   admin_    │
│   users     │──────▶│                  │◀──────│   users     │
│             │       │                  │       │             │
└─────────────┘       └────────┬─────────┘       └─────────────┘
                               │
                ┌──────────────┼──────────────┐
                │              │              │
                ▼              ▼              ▼
      ┌──────────────┐  ┌──────────┐  ┌──────────┐
      │     app_     │  │  sync_   │  │  builds  │
      │ configurations│  │  queue   │  │          │
      └──────────────┘  └──────────┘  └────┬─────┘
                                            │
                                            ▼
                                     ┌──────────┐
                                     │  build_  │
                                     │   logs   │
                                     └──────────┘
```

---

## 📊 Tables

### 1. `stores`

**Purpose:** Store information about WooCommerce stores

```sql
-- Migration: 001_stores.sql
CREATE TABLE stores (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) UNIQUE NOT NULL,
  
  -- WooCommerce Configuration
  woo_store_url VARCHAR(500) NOT NULL,
  woo_consumer_key VARCHAR(255),
  woo_consumer_secret VARCHAR(255),
  woo_auth_key TEXT,
  woo_api_version VARCHAR(10) DEFAULT 'wc/v3',
  
  -- Store Branding
  brand_name VARCHAR(100),
  logo_url TEXT,
  
  -- Store Status
  status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
  is_configured BOOLEAN DEFAULT false,
  
  -- Additional Settings
  settings JSONB DEFAULT '{}',
  metadata JSONB DEFAULT '{}',
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_sync_at TIMESTAMP WITH TIME ZONE,
  
  -- Constraints
  CONSTRAINT valid_woo_url CHECK (woo_store_url ~* '^https?://.*')
);

-- Indexes
CREATE INDEX idx_stores_status ON stores(status);
CREATE INDEX idx_stores_slug ON stores(slug);
CREATE INDEX idx_stores_created_at ON stores(created_at DESC);

-- Trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_stores_updated_at
  BEFORE UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE stores IS 'WooCommerce store configurations';
COMMENT ON COLUMN stores.woo_store_url IS 'Full URL to WooCommerce store';
COMMENT ON COLUMN stores.settings IS 'JSON object for store-specific settings';
```

### 2. `admin_users`

**Purpose:** Admin user profiles and permissions

```sql
-- Migration: 002_admin_users.sql
CREATE TABLE admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  auth_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  
  -- User Information
  display_name VARCHAR(255),
  avatar_url TEXT,
  
  -- Role & Permissions
  role VARCHAR(50) NOT NULL DEFAULT 'content_editor' 
    CHECK (role IN ('super_admin', 'store_manager', 'content_editor', 'viewer')),
  permissions JSONB DEFAULT '{}',
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  is_email_verified BOOLEAN DEFAULT false,
  
  -- Activity Tracking
  last_login_at TIMESTAMP WITH TIME ZONE,
  last_activity_at TIMESTAMP WITH TIME ZONE,
  login_count INTEGER DEFAULT 0,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Constraints
  UNIQUE(auth_user_id, store_id)
);

-- Indexes
CREATE INDEX idx_admin_users_auth_user ON admin_users(auth_user_id);
CREATE INDEX idx_admin_users_store ON admin_users(store_id);
CREATE INDEX idx_admin_users_role ON admin_users(role);
CREATE INDEX idx_admin_users_active ON admin_users(is_active);

-- Trigger for updated_at
CREATE TRIGGER update_admin_users_updated_at
  BEFORE UPDATE ON admin_users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE admin_users IS 'Admin user profiles with role-based permissions';
COMMENT ON COLUMN admin_users.role IS 'User role: super_admin, store_manager, content_editor, viewer';
COMMENT ON COLUMN admin_users.permissions IS 'JSON object for granular permissions';
```

### 3. `app_configurations`

**Purpose:** Application configuration storage with versioning

```sql
-- Migration: 003_app_configurations.sql
CREATE TABLE app_configurations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  
  -- Configuration Details
  config_key VARCHAR(255) NOT NULL,
  config_value JSONB NOT NULL,
  
  -- Versioning
  version INTEGER NOT NULL DEFAULT 1,
  parent_version_id UUID REFERENCES app_configurations(id),
  
  -- Status
  is_active BOOLEAN DEFAULT true,
  is_published BOOLEAN DEFAULT false,
  published_at TIMESTAMP WITH TIME ZONE,
  
  -- Environment
  environment VARCHAR(20) DEFAULT 'production' 
    CHECK (environment IN ('development', 'staging', 'production')),
  
  -- Metadata
  description TEXT,
  tags TEXT[],
  
  -- Audit
  created_by UUID REFERENCES admin_users(id),
  updated_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Constraints
  UNIQUE(store_id, config_key, version)
);

-- Indexes
CREATE INDEX idx_app_configs_store ON app_configurations(store_id);
CREATE INDEX idx_app_configs_key ON app_configurations(config_key);
CREATE INDEX idx_app_configs_active ON app_configurations(is_active);
CREATE INDEX idx_app_configs_published ON app_configurations(is_published);
CREATE INDEX idx_app_configs_environment ON app_configurations(environment);
CREATE INDEX idx_app_configs_version ON app_configurations(version DESC);
CREATE INDEX idx_app_configs_created_at ON app_configurations(created_at DESC);

-- GIN index for JSONB config_value
CREATE INDEX idx_app_configs_value_gin ON app_configurations USING GIN (config_value);

-- Trigger for updated_at
CREATE TRIGGER update_app_configurations_updated_at
  BEFORE UPDATE ON app_configurations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE app_configurations IS 'Application configurations with versioning support';
COMMENT ON COLUMN app_configurations.config_value IS 'JSON configuration data';
COMMENT ON COLUMN app_configurations.version IS 'Configuration version number';
```

### 4. `sync_queue`

**Purpose:** Offline sync queue for pending operations

```sql
-- Migration: 004_sync_queue.sql
CREATE TABLE sync_queue (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  
  -- Operation Details
  entity_type VARCHAR(100) NOT NULL 
    CHECK (entity_type IN ('config', 'product', 'order', 'customer', 'category')),
  entity_id VARCHAR(255),
  operation VARCHAR(50) NOT NULL 
    CHECK (operation IN ('create', 'update', 'delete', 'sync')),
  
  -- Data
  payload JSONB NOT NULL,
  
  -- Status
  status VARCHAR(50) DEFAULT 'pending' 
    CHECK (status IN ('pending', 'syncing', 'completed', 'failed', 'cancelled')),
  priority INTEGER DEFAULT 5 CHECK (priority BETWEEN 1 AND 10),
  
  -- Retry Logic
  retry_count INTEGER DEFAULT 0,
  max_retries INTEGER DEFAULT 3,
  error_message TEXT,
  error_stack TEXT,
  
  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  synced_at TIMESTAMP WITH TIME ZONE,
  next_retry_at TIMESTAMP WITH TIME ZONE,
  
  -- Constraints
  CHECK (retry_count <= max_retries)
);

-- Indexes
CREATE INDEX idx_sync_queue_store ON sync_queue(store_id);
CREATE INDEX idx_sync_queue_status ON sync_queue(status);
CREATE INDEX idx_sync_queue_entity_type ON sync_queue(entity_type);
CREATE INDEX idx_sync_queue_priority ON sync_queue(priority DESC);
CREATE INDEX idx_sync_queue_created_at ON sync_queue(created_at);
CREATE INDEX idx_sync_queue_next_retry ON sync_queue(next_retry_at) 
  WHERE status = 'failed' AND retry_count < max_retries;

-- Trigger for updated_at
CREATE TRIGGER update_sync_queue_updated_at
  BEFORE UPDATE ON sync_queue
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE sync_queue IS 'Queue for offline operations to be synced';
COMMENT ON COLUMN sync_queue.priority IS 'Priority: 1 (highest) to 10 (lowest)';
```

### 5. `builds`

**Purpose:** Mobile app build records with Fastlane integration

```sql
-- Migration: 005_builds.sql
CREATE TABLE builds (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  
  -- Build Configuration
  platform VARCHAR(20) NOT NULL CHECK (platform IN ('ios', 'android')),
  build_type VARCHAR(20) NOT NULL CHECK (build_type IN ('debug', 'release', 'adhoc')),
  environment VARCHAR(20) CHECK (environment IN ('dev', 'staging', 'prod')),
  
  -- Version Information
  build_number VARCHAR(50) NOT NULL,
  version VARCHAR(50) NOT NULL,
  git_commit_hash VARCHAR(40),
  git_branch VARCHAR(100),
  
  -- Build Status
  status VARCHAR(20) DEFAULT 'pending' 
    CHECK (status IN ('pending', 'queued', 'building', 'success', 'failed', 'cancelled')),
  
  -- Artifact Information
  artifact_type VARCHAR(20) CHECK (artifact_type IN ('ipa', 'apk', 'aab')),
  artifact_url TEXT,
  artifact_size BIGINT, -- in bytes
  artifact_md5 VARCHAR(32),
  
  -- Build Metrics
  build_duration INTEGER, -- in seconds
  queue_duration INTEGER, -- in seconds
  
  -- Timestamps
  started_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_by UUID REFERENCES admin_users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Metadata
  build_config JSONB DEFAULT '{}',
  metadata JSONB DEFAULT '{}'
);

-- Indexes
CREATE INDEX idx_builds_store ON builds(store_id);
CREATE INDEX idx_builds_platform ON builds(platform);
CREATE INDEX idx_builds_status ON builds(status);
CREATE INDEX idx_builds_environment ON builds(environment);
CREATE INDEX idx_builds_created_at ON builds(created_at DESC);
CREATE INDEX idx_builds_created_by ON builds(created_by);
CREATE INDEX idx_builds_build_number ON builds(build_number);

-- Composite indexes for common queries
CREATE INDEX idx_builds_store_platform_status ON builds(store_id, platform, status);
CREATE INDEX idx_builds_platform_env_created ON builds(platform, environment, created_at DESC);

-- Trigger for updated_at
CREATE TRIGGER update_builds_updated_at
  BEFORE UPDATE ON builds
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Comments
COMMENT ON TABLE builds IS 'Mobile app build records with Fastlane';
COMMENT ON COLUMN builds.artifact_size IS 'Artifact file size in bytes';
COMMENT ON COLUMN builds.build_duration IS 'Total build time in seconds';
```

### 6. `build_logs`

**Purpose:** Real-time build log entries

```sql
-- Migration: 006_build_logs.sql
CREATE TABLE build_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  build_id UUID NOT NULL REFERENCES builds(id) ON DELETE CASCADE,
  
  -- Log Details
  log_level VARCHAR(20) NOT NULL 
    CHECK (log_level IN ('debug', 'info', 'warning', 'error', 'critical')),
  message TEXT NOT NULL,
  
  -- Additional Context
  source VARCHAR(100), -- e.g., 'fastlane', 'gradle', 'xcodebuild'
  step VARCHAR(100), -- e.g., 'compile', 'sign', 'upload'
  metadata JSONB DEFAULT '{}',
  
  -- Timestamp
  timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Sequence for ordering
  sequence_number BIGSERIAL
);

-- Indexes
CREATE INDEX idx_build_logs_build ON build_logs(build_id);
CREATE INDEX idx_build_logs_level ON build_logs(log_level);
CREATE INDEX idx_build_logs_timestamp ON build_logs(timestamp);
CREATE INDEX idx_build_logs_sequence ON build_logs(sequence_number);

-- Composite index for common queries
CREATE INDEX idx_build_logs_build_timestamp ON build_logs(build_id, timestamp);

-- Comments
COMMENT ON TABLE build_logs IS 'Real-time build log entries for monitoring';
COMMENT ON COLUMN build_logs.sequence_number IS 'Auto-incrementing sequence for log ordering';
```

### 7. `audit_logs`

**Purpose:** Audit trail for all admin actions

```sql
-- Migration: 007_audit_logs.sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES admin_users(id) ON DELETE SET NULL,
  
  -- Action Details
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(100),
  entity_id VARCHAR(255),
  
  -- Change Tracking
  old_value JSONB,
  new_value JSONB,
  changes JSONB, -- Specific fields that changed
  
  -- Request Context
  ip_address INET,
  user_agent TEXT,
  request_id VARCHAR(100),
  
  -- Status
  status VARCHAR(20) DEFAULT 'success' CHECK (status IN ('success', 'failed')),
  error_message TEXT,
  
  -- Timestamp
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_audit_logs_store ON audit_logs(store_id);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at DESC);
CREATE INDEX idx_audit_logs_status ON audit_logs(status);

-- GIN index for JSONB columns
CREATE INDEX idx_audit_logs_changes_gin ON audit_logs USING GIN (changes);

-- Partitioning (optional, for large datasets)
-- Partition by month for better performance
-- CREATE TABLE audit_logs_y2026m01 PARTITION OF audit_logs
--   FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

-- Comments
COMMENT ON TABLE audit_logs IS 'Comprehensive audit trail for all admin actions';
COMMENT ON COLUMN audit_logs.changes IS 'JSON object containing only changed fields';
```

---

## 🔐 Row Level Security (RLS) Policies

### Enable RLS on All Tables

```sql
-- Migration: 008_enable_rls.sql

-- Enable RLS
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_configurations ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE builds ENABLE ROW LEVEL SECURITY;
ALTER TABLE build_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
```

### Policies for `stores`

```sql
-- Migration: 009_stores_policies.sql

-- Super admins can access all stores
CREATE POLICY "super_admins_all_stores" ON stores
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND role = 'super_admin'
        AND is_active = true
    )
  );

-- Users can access their assigned store
CREATE POLICY "users_own_store" ON stores
  FOR SELECT
  USING (
    id IN (
      SELECT store_id FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND is_active = true
    )
  );

-- Store managers can update their store
CREATE POLICY "managers_update_own_store" ON stores
  FOR UPDATE
  USING (
    id IN (
      SELECT store_id FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND role IN ('super_admin', 'store_manager')
        AND is_active = true
    )
  );
```

### Policies for `admin_users`

```sql
-- Migration: 010_admin_users_policies.sql

-- Users can view their own profile
CREATE POLICY "users_own_profile" ON admin_users
  FOR SELECT
  USING (auth_user_id = auth.uid());

-- Super admins can manage all users
CREATE POLICY "super_admins_all_users" ON admin_users
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM admin_users au
      WHERE au.auth_user_id = auth.uid()
        AND au.role = 'super_admin'
        AND au.is_active = true
    )
  );

-- Store managers can view users in their store
CREATE POLICY "managers_view_store_users" ON admin_users
  FOR SELECT
  USING (
    store_id IN (
      SELECT store_id FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND role IN ('super_admin', 'store_manager')
        AND is_active = true
    )
  );
```

### Policies for `app_configurations`

```sql
-- Migration: 011_configs_policies.sql

-- Users can read configs for their store
CREATE POLICY "users_read_store_configs" ON app_configurations
  FOR SELECT
  USING (
    store_id IN (
      SELECT store_id FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND is_active = true
    )
  );

-- Store managers and content editors can modify configs
CREATE POLICY "authorized_users_modify_configs" ON app_configurations
  FOR ALL
  USING (
    store_id IN (
      SELECT store_id FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND role IN ('super_admin', 'store_manager', 'content_editor')
        AND is_active = true
    )
  );
```

### Policies for `builds`

```sql
-- Migration: 012_builds_policies.sql

-- Users can view builds for their store
CREATE POLICY "users_view_store_builds" ON builds
  FOR SELECT
  USING (
    store_id IN (
      SELECT store_id FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND is_active = true
    )
  );

-- Store managers can trigger builds
CREATE POLICY "managers_trigger_builds" ON builds
  FOR INSERT
  WITH CHECK (
    store_id IN (
      SELECT store_id FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND role IN ('super_admin', 'store_manager')
        AND is_active = true
    )
  );

-- Users can update build status (for system operations)
CREATE POLICY "system_update_builds" ON builds
  FOR UPDATE
  USING (
    store_id IN (
      SELECT store_id FROM admin_users
      WHERE auth_user_id = auth.uid()
        AND is_active = true
    )
  );
```

### Policies for `build_logs`

```sql
-- Migration: 013_build_logs_policies.sql

-- Users can read logs for builds in their store
CREATE POLICY "users_read_build_logs" ON build_logs
  FOR SELECT
  USING (
    build_id IN (
      SELECT id FROM builds
      WHERE store_id IN (
        SELECT store_id FROM admin_users
        WHERE auth_user_id = auth.uid()
          AND is_active = true
      )
    )
  );

-- System can insert logs
CREATE POLICY "system_insert_logs" ON build_logs
  FOR INSERT
  WITH CHECK (
    build_id IN (
      SELECT id FROM builds
      WHERE store_id IN (
        SELECT store_id FROM admin_users
        WHERE auth_user_id = auth.uid()
          AND is_active = true
      )
    )
  );
```

---

## 🔧 Helper Functions

### Get Current User's Store ID

```sql
-- Migration: 014_helper_functions.sql

CREATE OR REPLACE FUNCTION get_user_store_id()
RETURNS UUID AS $$
  SELECT store_id
  FROM admin_users
  WHERE auth_user_id = auth.uid()
    AND is_active = true
  LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- Comments
COMMENT ON FUNCTION get_user_store_id IS 'Returns the store ID for the currently authenticated user';
```

### Check User Permission

```sql
CREATE OR REPLACE FUNCTION has_permission(permission_name TEXT)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1
    FROM admin_users
    WHERE auth_user_id = auth.uid()
      AND is_active = true
      AND (
        role = 'super_admin'
        OR permissions @> jsonb_build_object(permission_name, true)
      )
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- Comments
COMMENT ON FUNCTION has_permission IS 'Checks if the current user has a specific permission';
```

### Get Active Configuration

```sql
CREATE OR REPLACE FUNCTION get_active_config(
  p_store_id UUID,
  p_config_key VARCHAR,
  p_environment VARCHAR DEFAULT 'production'
)
RETURNS JSONB AS $$
  SELECT config_value
  FROM app_configurations
  WHERE store_id = p_store_id
    AND config_key = p_config_key
    AND environment = p_environment
    AND is_active = true
    AND is_published = true
  ORDER BY version DESC
  LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- Comments
COMMENT ON FUNCTION get_active_config IS 'Returns the latest active configuration for a store';
```

---

## 📊 Database Views

### Active Configurations View

```sql
-- Migration: 015_views.sql

CREATE OR REPLACE VIEW v_active_configurations AS
SELECT 
  ac.id,
  ac.store_id,
  s.name AS store_name,
  ac.config_key,
  ac.config_value,
  ac.version,
  ac.environment,
  ac.is_published,
  ac.created_at,
  ac.updated_at,
  au.display_name AS created_by_name
FROM app_configurations ac
JOIN stores s ON ac.store_id = s.id
LEFT JOIN admin_users au ON ac.created_by = au.id
WHERE ac.is_active = true
ORDER BY ac.config_key, ac.version DESC;

-- Comments
COMMENT ON VIEW v_active_configurations IS 'Active configurations with store and user details';
```

### Build Statistics View

```sql
CREATE OR REPLACE VIEW v_build_statistics AS
SELECT 
  store_id,
  platform,
  environment,
  COUNT(*) AS total_builds,
  COUNT(*) FILTER (WHERE status = 'success') AS successful_builds,
  COUNT(*) FILTER (WHERE status = 'failed') AS failed_builds,
  ROUND(
    COUNT(*) FILTER (WHERE status = 'success')::NUMERIC / 
    NULLIF(COUNT(*), 0) * 100, 
    2
  ) AS success_rate,
  AVG(build_duration) FILTER (WHERE status = 'success') AS avg_build_duration,
  MAX(created_at) AS last_build_at
FROM builds
GROUP BY store_id, platform, environment;

-- Comments
COMMENT ON VIEW v_build_statistics IS 'Build statistics by store, platform, and environment';
```

---

## 🔄 Migration Script

### Create Migration Runner

```bash
#!/bin/bash
# scripts/run-migrations.sh

set -e

echo "Running database migrations..."

# Array of migration files in order
MIGRATIONS=(
  "001_stores.sql"
  "002_admin_users.sql"
  "003_app_configurations.sql"
  "004_sync_queue.sql"
  "005_builds.sql"
  "006_build_logs.sql"
  "007_audit_logs.sql"
  "008_enable_rls.sql"
  "009_stores_policies.sql"
  "010_admin_users_policies.sql"
  "011_configs_policies.sql"
  "012_builds_policies.sql"
  "013_build_logs_policies.sql"
  "014_helper_functions.sql"
  "015_views.sql"
)

# Run each migration
for migration in "${MIGRATIONS[@]}"; do
  echo "Running migration: $migration"
  supabase db push "supabase/migrations/$migration"
done

echo "All migrations completed successfully!"
```

---

## ✅ Verification Queries

### Check All Tables

```sql
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Check RLS Status

```sql
SELECT 
  tablename,
  rowsecurity
FROM pg_tables
WHERE schemaname = 'public';
```

### Check Indexes

```sql
SELECT 
  tablename,
  indexname,
  indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename, indexname;
```

---

## 🆘 Troubleshooting

### Reset Database

```bash
# Warning: This will delete all data!
supabase db reset

# Re-run migrations
./scripts/run-migrations.sh
```

### Verify Migration

```bash
# Check migration status
supabase migration list

# Repair migration if needed
supabase migration repair <version>
```

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-01-09  
**Status:** Ready for Implementation
