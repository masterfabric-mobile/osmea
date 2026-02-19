-- DoneTogether: Tasks and task_assignees tables
-- Ref: docs/projects/done_together_plan/02_database_schema.md

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.groups (id) on delete cascade,
  created_by uuid not null references public.profiles (id) on delete restrict,
  title text not null,
  description text,
  due_date timestamptz,
  status text not null default 'pending' check (status in ('pending', 'completed')),
  completed_at timestamptz,
  completed_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null
);

comment on table public.tasks is 'Chores/tasks belonging to a group.';

create index if not exists idx_tasks_group_id on public.tasks (group_id);
create index if not exists idx_tasks_status on public.tasks (status);
create index if not exists idx_tasks_due_date on public.tasks (due_date);

create table if not exists public.task_assignees (
  task_id uuid not null references public.tasks (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  primary key (task_id, user_id)
);

comment on table public.task_assignees is 'Junction: users assigned to tasks.';

create index if not exists idx_task_assignees_user_id on public.task_assignees (user_id);

create trigger tasks_updated_at
  before update on public.tasks
  for each row execute function public.set_updated_at();
