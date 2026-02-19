-- Seed file: docs/projects/done_together_plan/supabase/seed.sql

-- Clear existing data (optional, useful for development)
-- DELETE FROM public.group_invites;
-- DELETE FROM public.task_assignees;
-- DELETE FROM public.task_media;
-- DELETE FROM public.tasks;
-- DELETE FROM public.group_members;
-- DELETE FROM public.groups;
-- DELETE FROM public.users;
-- DELETE FROM auth.users; -- Use with extreme caution in development

-- Create some dummy auth.users (will trigger public.users creation)
INSERT INTO auth.users (id, email, encrypted_password, confirmed_at, instance_id, aud, role)
VALUES
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'user1@example.com', crypt('password123', gen_salt('bf')), NOW(), '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated'),
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'user2@example.com', crypt('password123', gen_salt('bf')), NOW(), '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated'),
  ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'user3@example.com', crypt('password123', gen_salt('bf')), NOW(), '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated');

-- Update public.users profiles
UPDATE public.users SET username = 'Alice', bio = 'Loves clean houses.' WHERE id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
UPDATE public.users SET username = 'Bob', bio = 'Task master general.' WHERE id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12';
UPDATE public.users SET username = 'Charlie', bio = 'Always forgets the trash.' WHERE id = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13';

-- Create groups
INSERT INTO public.groups (id, name, admin_id)
VALUES
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'Home Chores', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b12', 'Work Project X', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12');

-- Add group members
INSERT INTO public.group_members (group_id, user_id, role)
VALUES
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'admin'),
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'member'),
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'member'),
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b12', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'admin'),
  ('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b12', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'member');

-- Create tasks for Home Chores
INSERT INTO public.tasks (id, group_id, created_by, title, description, due_date, status)
VALUES
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Take out the trash', 'Bins are full, please take them out tonight.', NOW() + INTERVAL '1 day', 'pending'),
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c12', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'Wash dishes', 'Kitchen sink is overflowing. Use dishwasher.', NOW() + INTERVAL '2 hours', 'pending'),
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c13', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Clean bathroom', 'Full scrub down, mop floor.', NOW() - INTERVAL '1 day', 'completed');

-- Assign tasks
INSERT INTO public.task_assignees (task_id, user_id)
VALUES
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c11', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13'), -- Charlie: Take out trash
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c12', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'), -- Alice: Wash dishes
  ('c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c13', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12'); -- Bob: Clean bathroom (already completed)

-- Update completed task details
UPDATE public.tasks SET completed_at = NOW() - INTERVAL '1 day' + INTERVAL '30 minutes', completed_by = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12' WHERE id = 'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380c13';

-- Create some group invites
INSERT INTO public.group_invites (id, group_id, invite_code, created_by, expires_at)
VALUES
  ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b11', 'HOME-INVITE', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', NOW() + INTERVAL '7 day'),
  ('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380d11', 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380b12', 'WORK-INVITE', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', NOW() + INTERVAL '3 day');