-- DoneTogether: Task media and group invites tables
-- Ref: docs/projects/done_together_plan/02_database_schema.md

create table if not exists public.task_media (
  id uuid primary key default gen_random_uuid(),
  task_id uuid not null references public.tasks (id) on delete cascade,
  storage_path text not null,
  created_at timestamptz default now() not null
);

comment on table public.task_media is 'Media attachments for tasks; storage_path is path in Supabase Storage.';

create index if not exists idx_task_media_task_id on public.task_media (task_id);

create table if not exists public.group_invites (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.groups (id) on delete cascade,
  invite_code text not null unique,
  expires_at timestamptz not null,
  created_at timestamptz default now() not null
);

comment on table public.group_invites is 'Short-lived invite codes for joining a group.';

create index if not exists idx_group_invites_invite_code on public.group_invites (invite_code);
create index if not exists idx_group_invites_expires_at on public.group_invites (expires_at);
