-- DoneTogether: Storage buckets and policies
-- Ref: docs/projects/done_together_plan/02_database_schema.md §3

-- Avatars bucket (public read)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatars',
  'avatars',
  true,
  5242880, -- 5MB
  array['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- Policy: anyone can read avatars
create policy "Avatar images are publicly accessible"
  on storage.objects for select
  to public
  using (bucket_id = 'avatars');

-- Policy: users can upload/update/delete their own avatar (path: {user_id}/avatar.*)
create policy "Users can upload own avatar"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can update own avatar"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Users can delete own avatar"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Task media bucket (private; access via RLS on task_media + group membership)
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'task-media',
  'task-media',
  false,
  10485760, -- 10MB
  array['image/jpeg', 'image/png', 'image/webp', 'image/gif', 'video/mp4', 'application/pdf']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

-- Policy: group members can read task-media for tasks in their group
-- Path assumed: {group_id}/{task_id}/{filename}
create policy "Group members can read task media"
  on storage.objects for select
  to authenticated
  using (
    bucket_id = 'task-media'
    and public.is_group_member(((storage.foldername(name))[1])::uuid, auth.uid())
  );

create policy "Group members can upload task media"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'task-media'
    and public.is_group_member(((storage.foldername(name))[1])::uuid, auth.uid())
  );

create policy "Creator or admin can delete task media"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'task-media'
    and public.is_group_member(((storage.foldername(name))[1])::uuid, auth.uid())
  );
