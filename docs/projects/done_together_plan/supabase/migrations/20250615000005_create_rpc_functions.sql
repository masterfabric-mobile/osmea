-- DoneTogether: RPC functions for leaderboard and join-by-code
-- Ref: docs/projects/done_together_plan/03_supabase_endpoints.md §2

-- Leaderboard: completed tasks per user in a group from a given date
create or replace function public.get_leaderboard(
  group_id_in uuid,
  from_date_in timestamptz default (date_trunc('month', now()) at time zone 'utc')
)
returns table (
  user_id uuid,
  username text,
  avatar_url text,
  tasks_completed bigint
)
language sql
security definer
stable
set search_path = public
as $$
  select
    p.id as user_id,
    p.username,
    p.avatar_url,
    count(t.id)::bigint as tasks_completed
  from public.profiles p
  left join public.tasks t
    on t.completed_by = p.id
    and t.group_id = group_id_in
    and t.completed_at >= from_date_in
    and t.status = 'completed'
  where public.is_group_member(group_id_in, p.id)
  group by p.id, p.username, p.avatar_url
  order by tasks_completed desc;
$$;

comment on function public.get_leaderboard is 'Returns leaderboard for a group from from_date_in (default: start of current month).';

-- Join group with invite code (atomic: validate + insert member)
create or replace function public.join_group_with_code(invite_code_in text)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  inv record;
  uid uuid;
begin
  uid := auth.uid();
  if uid is null then
    return jsonb_build_object(
      'success', false,
      'message', 'Not authenticated.'
    );
  end if;

  select id, group_id, expires_at
  into inv
  from public.group_invites
  where invite_code = invite_code_in
  limit 1;

  if inv is null then
    return jsonb_build_object(
      'success', false,
      'message', 'Invalid or expired code.'
    );
  end if;

  if inv.expires_at < now() then
    return jsonb_build_object(
      'success', false,
      'message', 'Invalid or expired code.'
    );
  end if;

  -- Already a member?
  if public.is_group_member(inv.group_id, uid) then
    return jsonb_build_object(
      'success', true,
      'group_id', inv.group_id,
      'message', 'Already a member.'
    );
  end if;

  insert into public.group_members (group_id, user_id, role)
  values (inv.group_id, uid, 'member');

  return jsonb_build_object(
    'success', true,
    'group_id', inv.group_id,
    'message', 'Successfully joined group!'
  );
end;
$$;

comment on function public.join_group_with_code is 'Validates invite code and adds current user to group_members if valid and not expired.';
