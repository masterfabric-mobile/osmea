# DoneTogether – Supabase

Backend (Postgres, Auth, Storage, Realtime) for the Done Together app.

## Plan docs (reference)

- [02_database_schema.md](../02_database_schema.md) – Tables, RLS, storage, realtime
- [03_supabase_endpoints.md](../03_supabase_endpoints.md) – PostgREST, RPC, Edge Functions

## Layout

```
supabase/
├── migrations/   # SQL migrations (order by timestamp prefix)
│   ├── 20250615000000_create_profiles_and_auth_trigger.sql
│   ├── 20250615000001_create_groups_and_members.sql
│   ├── 20250615000002_create_tasks_and_assignees.sql
│   ├── 20250615000003_create_task_media_and_invites.sql
│   ├── 20250615000004_create_rls_policies.sql
│   ├── 20250615000005_create_rpc_functions.sql
│   ├── 20250615000006_create_storage_buckets.sql
│   └── 20250615000007_app_config.sql   # app_config table + get_app_config RPC (platform-based remote config)
├── seed/
│   └── seed.sql  # Dev seed data
└── README.md     # This file
```

## Commands (Supabase CLI)

```bash
# Link to your project (once)
supabase link --project-ref <your-project-ref>

# Run migrations
supabase db push

# Reset DB and run migrations + seed (local)
supabase db reset
```

## Seed

`seed/seed.sql` inserts a sample profile, group, tasks, and an invite code. Replace the placeholder profile UUID with a real `auth.users.id` from your dev environment (e.g. create a user in the Dashboard or via the app, then copy their id into the seed or run a one-off SQL update).

## RPC (from Flutter)

- **Leaderboard:** `supabase.rpc('get_leaderboard', params: {'group_id_in': groupId, 'from_date_in': fromDate})`
- **Join by code:** `supabase.rpc('join_group_with_code', params: {'invite_code_in': code})`
- **App config (platform-based):** `supabase.rpc('get_app_config', params: {'platform_in': 'ios'})` or `'android'` — returns merged config (common + platform) so the app can update behaviour without a store release (e.g. min version, feature flags). Table: `app_config` (key, platform, value jsonb). See [02_database_schema.md](../02_database_schema.md) and [03_supabase_endpoints.md](../03_supabase_endpoints.md).

## Storage

- **avatars** – Public bucket; path pattern `{user_id}/avatar.*`
- **task-media** – Private bucket; path pattern `{group_id}/{task_id}/{filename}`
