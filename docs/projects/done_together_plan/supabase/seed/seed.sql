-- DoneTogether: Seed data for local development
-- Ref: docs/projects/done_together_plan (02_database_schema, 03_supabase_endpoints)
--
-- Prerequisite: At least one user must exist (sign up via app or Auth Dashboard).
-- This seed uses the first available profile as group admin; or pass a specific id.

do $$
declare
  dev_user_id uuid;
  group_id_1 uuid;
  task_id_1 uuid;
begin
  -- Use first existing profile as admin (create one user in Auth first)
  select id into dev_user_id from public.profiles limit 1;

  if dev_user_id is null then
    raise notice 'Seed skipped: no profiles found. Create a user via Auth first.';
    return;
  end if;

  -- Group
  insert into public.groups (id, name, admin_id)
  values (gen_random_uuid(), 'Home', dev_user_id)
  returning id into group_id_1;

  -- Sample tasks
  insert into public.tasks (id, group_id, created_by, title, description, status)
  values
    (gen_random_uuid(), group_id_1, dev_user_id, 'Take out trash', 'Kitchen and bathroom bins', 'pending'),
    (gen_random_uuid(), group_id_1, dev_user_id, 'Vacuum living room', null, 'pending')
  returning id into task_id_1;

  -- Assign first task to admin
  insert into public.task_assignees (task_id, user_id)
  select id, dev_user_id from public.tasks where group_id = group_id_1 limit 1;

  -- Invite code for joining (expires in 7 days)
  insert into public.group_invites (group_id, invite_code, expires_at)
  values (group_id_1, 'DEV-JOIN-001', now() + interval '7 days');

  raise notice 'Seed done. Group id: %, admin: %', group_id_1, dev_user_id;
end $$;
