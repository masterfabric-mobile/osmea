-- DoneTogether: Groups and group_members tables
-- Ref: docs/projects/done_together_plan/02_database_schema.md

create table if not exists public.groups (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  admin_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

comment on table public.groups is 'Household/roommate groups.';

create table if not exists public.group_members (
  group_id uuid not null references public.groups (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  role text not null default 'member' check (role in ('admin', 'member')),
  created_at timestamptz default now() not null,
  primary key (group_id, user_id)
);

comment on table public.group_members is 'Junction: users belonging to groups.';

create index if not exists idx_group_members_user_id on public.group_members (user_id);

-- Ensure group creator is added as admin
create or replace function public.handle_new_group()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.group_members (group_id, user_id, role)
  values (new.id, new.admin_id, 'admin');
  return new;
end;
$$;

create or replace trigger on_group_created
  after insert on public.groups
  for each row execute function public.handle_new_group();

create trigger groups_updated_at
  before update on public.groups
  for each row execute function public.set_updated_at();
