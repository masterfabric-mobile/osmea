-- DoneTogether: Row Level Security (RLS) for all tables
-- Ref: docs/projects/done_together_plan/02_database_schema.md §2

alter table public.profiles enable row level security;
alter table public.groups enable row level security;
alter table public.group_members enable row level security;
alter table public.tasks enable row level security;
alter table public.task_assignees enable row level security;
alter table public.task_media enable row level security;
alter table public.group_invites enable row level security;

-- Helper: user is member of a group
create or replace function public.is_group_member(gid uuid, uid uuid)
returns boolean
language sql
security definer
stable
as $$
  select exists (
    select 1 from public.group_members
    where group_id = gid and user_id = uid
  );
$$;

-- Helper: user is admin of a group
create or replace function public.is_group_admin(gid uuid, uid uuid)
returns boolean
language sql
security definer
stable
as $$
  select exists (
    select 1 from public.group_members
    where group_id = gid and user_id = uid and role = 'admin'
  );
$$;

-- ---------- profiles ----------
create policy "Profiles are viewable by authenticated users"
  on public.profiles for select
  to authenticated
  using (true);

create policy "Users can update own profile"
  on public.profiles for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ---------- groups ----------
create policy "Users can view groups they are members of"
  on public.groups for select
  to authenticated
  using (public.is_group_member(id, auth.uid()));

create policy "Authenticated users can create groups"
  on public.groups for insert
  to authenticated
  with check (auth.uid() = admin_id);

create policy "Group admins can update group"
  on public.groups for update
  to authenticated
  using (public.is_group_admin(id, auth.uid()));

-- ---------- group_members ----------
create policy "Members can view other members of their group"
  on public.group_members for select
  to authenticated
  using (public.is_group_member(group_id, auth.uid()));

create policy "Group admins can add members"
  on public.group_members for insert
  to authenticated
  with check (public.is_group_admin(group_id, auth.uid()));

create policy "Group admins can remove members; users can remove themselves"
  on public.group_members for delete
  to authenticated
  using (
    public.is_group_admin(group_id, auth.uid())
    or user_id = auth.uid()
  );

-- ---------- tasks ----------
create policy "Members can view tasks of their group"
  on public.tasks for select
  to authenticated
  using (public.is_group_member(group_id, auth.uid()));

create policy "Group members can create tasks"
  on public.tasks for insert
  to authenticated
  with check (
    public.is_group_member(group_id, auth.uid())
    and created_by = auth.uid()
  );

create policy "Creator or admin can update; assignees can complete"
  on public.tasks for update
  to authenticated
  using (public.is_group_member(group_id, auth.uid()))
  with check (public.is_group_member(group_id, auth.uid()));

create policy "Creator or group admin can delete task"
  on public.tasks for delete
  to authenticated
  using (
    created_by = auth.uid()
    or public.is_group_admin(group_id, auth.uid())
  );

-- ---------- task_assignees ----------
create policy "Group members can view assignees"
  on public.task_assignees for select
  to authenticated
  using (
    exists (
      select 1 from public.tasks t
      where t.id = task_assignees.task_id
      and public.is_group_member(t.group_id, auth.uid())
    )
  );

create policy "Group members can add assignees to group tasks"
  on public.task_assignees for insert
  to authenticated
  with check (
    exists (
      select 1 from public.tasks t
      where t.id = task_assignees.task_id
      and public.is_group_member(t.group_id, auth.uid())
    )
  );

create policy "Group members can remove assignees"
  on public.task_assignees for delete
  to authenticated
  using (
    exists (
      select 1 from public.tasks t
      where t.id = task_assignees.task_id
      and public.is_group_member(t.group_id, auth.uid())
    )
  );

-- ---------- task_media ----------
create policy "Group members can view task media"
  on public.task_media for select
  to authenticated
  using (
    exists (
      select 1 from public.tasks t
      where t.id = task_media.task_id
      and public.is_group_member(t.group_id, auth.uid())
    )
  );

create policy "Group members can insert task media"
  on public.task_media for insert
  to authenticated
  with check (
    exists (
      select 1 from public.tasks t
      where t.id = task_media.task_id
      and public.is_group_member(t.group_id, auth.uid())
    )
  );

create policy "Creator or admin can delete task media"
  on public.task_media for delete
  to authenticated
  using (
    exists (
      select 1 from public.tasks t
      where t.id = task_media.task_id
      and (
        t.created_by = auth.uid()
        or public.is_group_admin(t.group_id, auth.uid())
      )
    )
  );

-- ---------- group_invites ----------
-- Only group admins create invites (often via Edge Function). Anyone with code can read to validate.
create policy "Group members can view invites for their group"
  on public.group_invites for select
  to authenticated
  using (public.is_group_member(group_id, auth.uid()));

create policy "Group admins can create invites"
  on public.group_invites for insert
  to authenticated
  with check (public.is_group_admin(group_id, auth.uid()));

create policy "Group admins can delete invites"
  on public.group_invites for delete
  to authenticated
  using (public.is_group_admin(group_id, auth.uid()));
