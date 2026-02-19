-- Migration file: 20260217012054_initial_setup.sql

-- Enable the "uuid-ossp" extension for generating UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===============================================
-- USERS Table
-- ===============================================

-- Create the public.users table to store user profiles
CREATE TABLE public.users (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL PRIMARY KEY,
    username TEXT UNIQUE,
    bio TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Set up Row Level Security (RLS) for the public.users table
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Policy: Allow users to read all profiles
CREATE POLICY "Public profiles are viewable by everyone." ON public.users
  FOR SELECT USING (TRUE);

-- Policy: Allow users to update their own profile
CREATE POLICY "Users can update own profile." ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- Create a function to set the username on new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, username, avatar_url)
  VALUES (NEW.id, NEW.email, ''); -- Default username to email, can be updated later
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a trigger to call the handle_new_user() function on auth.users inserts
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ===============================================
-- GROUPS Table
-- ===============================================

-- Create the public.groups table
CREATE TABLE public.groups (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    admin_id UUID REFERENCES public.users(id) ON DELETE RESTRICT NOT NULL, -- The user who created the group
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Set up RLS for the public.groups table
ALTER TABLE public.groups ENABLE ROW LEVEL SECURITY;

-- Policy: Group members can read group details
CREATE POLICY "Group members can read group details." ON public.groups
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.group_members WHERE group_id = public.groups.id AND user_id = auth.uid())
  );

-- Policy: Any authenticated user can create a group
CREATE POLICY "Authenticated users can create groups." ON public.groups
  FOR INSERT WITH CHECK (auth.role() = 'authenticated'); -- Ensure admin_id matches auth.uid() in client-side insert

-- Policy: Group admin can update group details
CREATE POLICY "Group admin can update group details." ON public.groups
  FOR UPDATE USING (auth.uid() = admin_id) WITH CHECK (auth.uid() = admin_id);

-- ===============================================
-- GROUP MEMBERS Table (Junction Table)
-- ===============================================

-- Create the public.group_members table
CREATE TABLE public.group_members (
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    role TEXT DEFAULT 'member' NOT NULL, -- e.g., 'admin', 'member'
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (group_id, user_id)
);

-- Set up RLS for the public.group_members table
ALTER TABLE public.group_members ENABLE ROW LEVEL SECURITY;

-- Policy: Group members can read other members of their group
CREATE POLICY "Group members can read other members." ON public.group_members
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.group_members gm2 WHERE gm2.group_id = public.group_members.group_id AND gm2.user_id = auth.uid())
  );

-- Policy: Group admin can insert new members (via invite flow)
CREATE POLICY "Group admin can insert new members." ON public.group_members
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.groups WHERE id = public.group_members.group_id AND admin_id = auth.uid())
  );

-- Policy: Group admin can delete members, users can delete themselves
CREATE POLICY "Group admin can remove members or user can leave." ON public.group_members
  FOR DELETE USING (
    (EXISTS (SELECT 1 FROM public.groups WHERE id = public.group_members.group_id AND admin_id = auth.uid()))
    OR (public.group_members.user_id = auth.uid())
  );

-- Index for quickly finding a user's groups
CREATE INDEX ON public.group_members (user_id);

-- ===============================================
-- TASKS Table
-- ===============================================

-- Create the public.tasks table
CREATE TABLE public.tasks (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE NOT NULL,
    created_by UUID REFERENCES public.users(id) ON DELETE RESTRICT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    due_date TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'pending' NOT NULL, -- 'pending', 'completed'
    completed_at TIMESTAMP WITH TIME ZONE,
    completed_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Set up RLS for the public.tasks table
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- Policy: Group members can read tasks in their group
CREATE POLICY "Group members can read tasks." ON public.tasks
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.group_members WHERE group_id = public.tasks.group_id AND user_id = auth.uid())
  );

-- Policy: Group members can create tasks
CREATE POLICY "Group members can create tasks." ON public.tasks
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM public.group_members WHERE group_id = public.tasks.group_id AND user_id = auth.uid())
    AND created_by = auth.uid()
  );

-- Policy: Task creator or group admin can update task details
CREATE POLICY "Task creator or admin can update task details." ON public.tasks
  FOR UPDATE USING (
    (created_by = auth.uid())
    OR (EXISTS (SELECT 1 FROM public.groups WHERE id = public.tasks.group_id AND admin_id = auth.uid()))
  );
  -- Assignees can update status to 'completed'
  -- Need a more granular update policy if only status is allowed for assignees

-- Policy: Task creator or group admin can delete tasks
CREATE POLICY "Task creator or admin can delete tasks." ON public.tasks
  FOR DELETE USING (
    (created_by = auth.uid())
    OR (EXISTS (SELECT 1 FROM public.groups WHERE id = public.tasks.group_id AND admin_id = auth.uid()))
  );

-- Index on group_id and status for task lists
CREATE INDEX ON public.tasks (group_id, status);
-- Index on due_date for sorting/filtering
CREATE INDEX ON public.tasks (due_date);

-- ===============================================
-- TASK ASSIGNEES Table (Junction Table)
-- ===============================================

-- Create the public.task_assignees table
CREATE TABLE public.task_assignees (
    task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE NOT NULL,
    user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (task_id, user_id)
);

-- Set up RLS for the public.task_assignees table
ALTER TABLE public.task_assignees ENABLE ROW LEVEL SECURITY;

-- Policy: Group members can read assignees for tasks in their group
CREATE POLICY "Group members can read task assignees." ON public.task_assignees
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.tasks t JOIN public.group_members gm ON t.group_id = gm.group_id WHERE t.id = public.task_assignees.task_id AND gm.user_id = auth.uid())
  );

-- Policy: Only task creator or group admin can manage assignees
CREATE POLICY "Task creator or admin can manage assignees." ON public.task_assignees
  FOR ALL USING (
    (EXISTS (SELECT 1 FROM public.tasks WHERE id = public.task_assignees.task_id AND created_by = auth.uid()))
    OR (EXISTS (SELECT 1 FROM public.tasks t JOIN public.groups g ON t.group_id = g.id WHERE t.id = public.task_assignees.task_id AND g.admin_id = auth.uid()))
  );

-- Index for quickly finding tasks assigned to a user
CREATE INDEX ON public.task_assignees (user_id);

-- ===============================================
-- TASK MEDIA Table
-- ===============================================

-- Create the public.task_media table
CREATE TABLE public.task_media (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    task_id UUID REFERENCES public.tasks(id) ON DELETE CASCADE NOT NULL,
    storage_path TEXT NOT NULL, -- Path in Supabase Storage
    uploaded_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Set up RLS for the public.task_media table
ALTER TABLE public.task_media ENABLE ROW LEVEL SECURITY;

-- Policy: Group members can read media for tasks in their group
CREATE POLICY "Group members can read task media." ON public.task_media
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM public.tasks t JOIN public.group_members gm ON t.group_id = gm.group_id WHERE t.id = public.task_media.task_id AND gm.user_id = auth.uid())
  );

-- Policy: Task creator or group admin can insert media
CREATE POLICY "Task creator or admin can insert task media." ON public.task_media
  FOR INSERT WITH CHECK (
    (EXISTS (SELECT 1 FROM public.tasks WHERE id = public.task_media.task_id AND created_by = auth.uid()))
    OR (EXISTS (SELECT 1 FROM public.tasks t JOIN public.groups g ON t.group_id = g.id WHERE t.id = public.task_media.task_id AND g.admin_id = auth.uid()))
    AND uploaded_by = auth.uid()
  );

-- Policy: Task creator or group admin can delete media
CREATE POLICY "Task creator or admin can delete task media." ON public.task_media
  FOR DELETE USING (
    (EXISTS (SELECT 1 FROM public.tasks WHERE id = public.task_media.task_id AND created_by = auth.uid()))
    OR (EXISTS (SELECT 1 FROM public.tasks t JOIN public.groups g ON t.group_id = g.id WHERE t.id = public.task_media.task_id AND g.admin_id = auth.uid()))
  );

-- ===============================================
-- GROUP INVITES Table
-- ===============================================

-- Create the public.group_invites table
CREATE TABLE public.group_invites (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    group_id UUID REFERENCES public.groups(id) ON DELETE CASCADE NOT NULL,
    invite_code TEXT UNIQUE NOT NULL, -- Unique short code
    created_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Set up RLS for the public.group_invites table
ALTER TABLE public.group_invites ENABLE ROW LEVEL SECURITY;

-- Policy: Group admin can read/create/delete invites for their group
CREATE POLICY "Group admin can manage invites." ON public.group_invites
  FOR ALL USING (
    EXISTS (SELECT 1 FROM public.groups WHERE id = public.group_invites.group_id AND admin_id = auth.uid())
  ) WITH CHECK (
    EXISTS (SELECT 1 FROM public.groups WHERE id = public.group_invites.group_id AND admin_id = auth.uid())
    AND created_by = auth.uid() -- Only admins can create, and must be the one creating it
  );

-- RPC for Leaderboard (placeholder, actual function definition would be here)
-- This is just an example signature for the RPC call
CREATE OR REPLACE FUNCTION public.get_leaderboard(group_id_in UUID, from_date_in TIMESTAMP WITH TIME ZONE)
RETURNS TABLE (user_id UUID, username TEXT, avatar_url TEXT, tasks_completed BIGINT)
LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  RETURN QUERY
    SELECT
      u.id AS user_id,
      u.username,
      u.avatar_url,
      COUNT(t.id) AS tasks_completed
    FROM public.users u
    JOIN public.tasks t ON u.id = t.completed_by
    WHERE t.group_id = group_id_in AND t.completed_at >= from_date_in
    GROUP BY u.id, u.username, u.avatar_url
    ORDER BY tasks_completed DESC;
END;
$$;

ALTER FUNCTION public.get_leaderboard(group_id_in UUID, from_date_in TIMESTAMP WITH TIME ZONE) OWNER TO postgres;

-- Grant usage to authenticated role
GRANT EXECUTE ON FUNCTION public.get_leaderboard(group_id_in UUID, from_date_in TIMESTAMP WITH TIME ZONE) TO authenticated;

-- RPC for Joining Group with Code (placeholder, actual function definition would be here)
CREATE OR REPLACE FUNCTION public.join_group_with_code(invite_code_in TEXT)
RETURNS JSON
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  _invite_record public.group_invites;
  _group_id UUID;
  _user_id UUID := auth.uid();
  _current_timestamp TIMESTAMP WITH TIME ZONE := NOW();
BEGIN
  -- Find the invite
  SELECT * INTO _invite_record
  FROM public.group_invites
  WHERE invite_code = invite_code_in AND expires_at > _current_timestamp;

  IF _invite_record IS NULL THEN
    RETURN '{"success": false, "message": "Invalid or expired invite code."}';
  END IF;

  _group_id := _invite_record.group_id;

  -- Check if user is already a member
  IF EXISTS (SELECT 1 FROM public.group_members WHERE group_id = _group_id AND user_id = _user_id) THEN
    RETURN '{"success": false, "message": "You are already a member of this group."}';
  END IF;

  -- Add user to group_members
  INSERT INTO public.group_members (group_id, user_id, role)
  VALUES (_group_id, _user_id, 'member');

  RETURN json_build_object('success', true, 'group_id', _group_id, 'message', 'Successfully joined group!');
END;
$$;

ALTER FUNCTION public.join_group_with_code(invite_code_in TEXT) OWNER TO postgres;

-- Grant usage to authenticated role
GRANT EXECUTE ON FUNCTION public.join_group_with_code(invite_code_in TEXT) TO authenticated;