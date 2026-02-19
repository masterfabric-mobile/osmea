# DoneTogether: Supabase Endpoint Map

This document provides a comprehensive map of all anticipated API interactions between the Flutter client and the Supabase backend.

**Implementation:** RPC functions (`get_leaderboard`, `join_group_with_code`), and table access RLS are all defined within the initial migration file: [supabase/migrations/20260217012054_initial_setup.sql](supabase/migrations/20260217012054_initial_setup.sql).

---

## 1. PostgREST Table Queries

These are the standard RESTful queries made directly to database tables and views. Access is governed by the RLS policies defined in the Database Schema document.

### **Users & Profiles (`profiles` table)**

- **`GET /profiles?id=eq.{user_id}`**
    - **Purpose:** Fetch a specific user's public profile.
    - **Screen:** Profile Screen, Task Assignee list.
    - **Output:** `{ "id", "username", "avatar_url", "bio" }`

- **`GET /profiles?select=id,username,avatar_url&group_id=eq.{group_id}`** (Assumes a view or RPC)
    - **Purpose:** Fetch all profiles belonging to a specific group.
    - **Screen:** Group Members Screen.
    - **Output:** `[ { "id", "username", "avatar_url" } ]`

- **`PATCH /profiles?id=eq.{auth.uid()}`**
    - **Purpose:** Update the authenticated user's own profile.
    - **Screen:** Edit Profile Screen.
    - **Input:** `{ "username": "new_name", "bio": "new_bio" }`
    - **Output:** The updated profile object.

### **Tasks (`tasks` table)**

- **`GET /tasks?group_id=eq.{group_id}&status=eq.pending&select=*,assignees:task_assignees(user_id,profiles(*))`**
    - **Purpose:** Fetch all pending tasks for a group, embedding the profile of each assignee.
    - **Screen:** Dashboard / Task List Screen.
    - **Output:** A list of task objects, each with a nested list of assignee profiles.

- **`POST /tasks`**
    - **Purpose:** Create a new task. The `created_by` and `group_id` are required.
    - **Screen:** Create Task Screen.
    - **Input:** `{ "group_id", "title", "description", "due_date" }` (plus `task_assignees` in a separate insert).
    - **Output:** The newly created task object.

- **`PATCH /tasks?id=eq.{task_id}`**
    - **Purpose:** Update a task. Used for marking as complete or editing details.
    - **Screen:** Task Detail Screen, Task List (for quick complete).
    - **Input:** `{ "status": "completed", "completed_at": "now()", "completed_by": "{user_id}" }`
    - **Output:** The updated task object.

- **`DELETE /tasks?id=eq.{task_id}`**
    - **Purpose:** Delete a task.
    - **Screen:** Task Detail Screen (Admin only).
    - **Output:** `204 No Content`.

### **App Config (`app_config` table)**

Uygulama yapılandırması platform bazlı (iOS/Android) veya ortak (`common`) olarak Supabase’ten okunur; store güncellemesi olmadan uygulama davranışı güncellenebilir.

- **`GET /app_config?platform=in.(common,ios)`** (iOS client)
    - **Purpose:** Fetch app config for merge: first `common`, then platform-specific (`ios`). Client merges so platform overrides common for same key.
    - **Screen:** App startup (and optionally on interval or Realtime).
    - **Query:** `platform=in.(common,ios)` for iOS; `platform=in.(common,android)` for Android.
    - **Output:** `[ { "key", "platform", "value", "updated_at" }, ... ]`

- **`GET /app_config?platform=in.(common,android)`** (Android client)
    - **Purpose:** Same as above for Android; use `platform=in.(common,android)`.

- **Alternative (RPC):** Use `get_app_config(platform_in)` RPC (see below) to get a single merged JSON object per platform.

---

## 2. RPC Functions (`pg_graphql` or direct `rpc`)

Custom SQL functions are exposed via the API for logic that is too complex for a simple PostgREST query.

- **`POST /rpc/get_leaderboard`**
    - **Purpose:** Calculate the weekly or monthly leaderboard for a group. This function will count completed tasks per user within a date range.
    - **Screen:** Leaderboard Screen.
    - **Input:** `{ "group_id_in": "{group_id}", "from_date_in": "YYYY-MM-DD" }` (optional; default: start of current month).
    - **Output:** `[ { "user_id", "username", "avatar_url", "tasks_completed": 15 }, ... ]`
    - **Implementation:** [supabase/migrations/20250615000005_create_rpc_functions.sql](supabase/migrations/20250615000005_create_rpc_functions.sql)

- **`POST /rpc/join_group_with_code`**
    - **Purpose:** Atomically validates an invite code and adds the user to the `group_members` table if the code is valid and not expired.
    - **Screen:** Join Group Dialog.
    - **Input:** `{ "invite_code_in": "ABC-123" }`
    - **Output:** `{ "success": true, "group_id": "{group_id}", "message": "Successfully joined group!" }` or `{ "success": false, "message": "Invalid or expired code." }`
    - **Implementation:** [supabase/migrations/20250615000005_create_rpc_functions.sql](supabase/migrations/20250615000005_create_rpc_functions.sql)

- **`POST /rpc/get_app_config`**
    - **Purpose:** Return merged app config for the given platform. Combines `common` and platform-specific rows into one JSON object; platform values override common for the same key.
    - **Screen:** App startup (before or after auth); can be called anonymously.
    - **Input:** `{ "platform_in": "ios" }` or `{ "platform_in": "android" }`
    - **Output:** `{ "min_app_version": "1.2.0", "feature_x_enabled": true, ... }` (key-value map; keys and types as stored in `app_config.value`).
    - **Implementation:** SQL function in migration (e.g. `20250615000007_app_config.sql` or appended to RPC migration). Reads `app_config` where `platform IN ('common', platform_in)` and merges into single jsonb.

---

## 3. Edge Functions (Dart)

Serverless functions for handling logic that requires external API calls, secrets, or complex workflows.

- **`POST /functions/v1/create-invite`**
    - **Purpose:** Create a new invite code for a group. It generates a unique code, stores it in the `group_invites` table with an expiry date, and returns the code.
    - **Security:** Can only be called by a group admin. The function should verify the caller's privileges.
    - **Screen:** Group Detail Screen (Admin view).
    - **Input (JSON Body):** `{ "group_id": "{group_id}" }`
    - **Output (JSON):** `{ "invite_code": "XYZ-456", "expires_at": "timestamp" }`

- **`GET /functions/v1/resolve-invite?code={code}`**
    - **Purpose:** (Optional) A public-facing endpoint that can be used in a URL (e.g., `app.com/join?code=XYZ-456`) to fetch details about an invite before joining.
    - **Security:** Public, but only returns non-sensitive information.
    - **Screen:** A web-based landing page or when the app is opened via a deep link.
    - **Input (Query Param):** `?code=XYZ-456`
    - **Output (JSON):** `{ "group_name": "Home", "group_id": "{group_id}" }`

- **`POST /functions/v1/send-reminders`**
    - **Purpose:** A scheduled function (via a cron job) that scans for tasks due in the next 24 hours and (in V2) sends push notifications.
    - **Security:** Invoked by Supabase's scheduler, not a client. Requires an internal service role key.
    - **Screen:** N/A (background process).
    - **Input:** None.
    - **Output:** `{ "reminders_sent": 5 }`

---
## Validation Checklist

### PostgREST Table Queries
- [ ] **`profiles` Table:**
    - [ ] `GET /profiles?id=eq.{user_id}`: Implemented for fetching user profiles.
    - [ ] `GET /profiles` (for group members): Implemented to fetch all members in a group.
    - [ ] `PATCH /profiles?id=eq.{auth.uid()}`: Implemented for profile updates.
- [ ] **`tasks` Table:**
    - [ ] `GET /tasks` (with group filter): Implemented and properly filtering by `group_id` and `status`.
    - [ ] Nested select on `task_assignees` and `profiles` is working correctly.
    - [ ] `POST /tasks`: Implemented for creating new tasks.
    - [ ] `PATCH /tasks?id=eq.{task_id}`: Implemented for updating task status and details.
    - [ ] `DELETE /tasks?id=eq.{task_id}`: Implemented for deleting tasks.
- [ ] **Other Tables:**
    - [ ] All necessary `INSERT` operations on junction tables (e.g., `task_assignees`) are implemented client-side.
- [ ] **`app_config` Table:**
    - [ ] `GET /app_config?platform=in.(common,ios)` and `platform=in.(common,android)` return config rows for merge.
    - [ ] Client (or RPC `get_app_config`) merges `common` + platform so platform overrides common per key.

### RPC Functions
- [ ] **`get_leaderboard` Function:**
    - [ ] SQL function is created and migrated in Supabase.
    - [ ] The function correctly calculates scores based on completed tasks within a date range.
    - [ ] The function is callable from Flutter via `supabase.rpc()`.
    - [ ] RLS is configured to allow group members to call this function.
- [ ] **`join_group_with_code` Function:**
    - [ ] SQL function is created and migrated in Supabase.
    - [ ] The function correctly validates the invite code and expiration date.
    - [ ] The function atomically inserts a new row into `group_members`.
    - [ ] The function returns a clear success or failure message.
    - [ ] The function is callable from Flutter via `supabase.rpc()`.
- [ ] **`get_app_config` Function:**
    - [ ] SQL function is created and returns merged config (common + platform) as a single JSON object.
    - [ ] Callable with `platform_in`: `'ios'` or `'android'`.
    - [ ] Callable from Flutter (optionally without auth) at app startup.

### Edge Functions
- [ ] **`create-invite` Function:**
    - [ ] Edge Function is created and deployed to Supabase.
    - [ ] The function correctly verifies that the caller is a group admin.
    - [ ] The function generates a unique, non-guessable code.
    - [ ] The function inserts the code and expiry date into the `group_invites` table.
    - [ ] The function is successfully called from the Flutter client.
- [ ] **`resolve-invite` Function (Optional):**
    - [ ] Edge Function is created and deployed.
    - [ ] It can be accessed publicly via a GET request.
    - [ ] It returns non-sensitive group information.
- [ ] **`send-reminders` Function (Scheduled):**
    - [ ] Edge Function is created and deployed.
    - [ ] A `cron` job is configured in Supabase to invoke it on a schedule.
    - [ ] The function correctly identifies tasks that are due soon.
    - [ ] (V2) The function successfully integrates with a push notification service.
