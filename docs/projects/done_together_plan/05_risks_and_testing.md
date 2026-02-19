# DoneTogether: Risks, Edge Cases, and Testing

This document outlines potential risks, tricky edge cases to consider during development, and a checklist for testing to ensure a high-quality, robust application.

**RLS and schema testing:** Database policies and RPCs are defined in the [supabase/](supabase/) migration files. To validate RLS, run the manual tests in this document in an environment where migrations have been applied (e.g. after `supabase db reset`). Details: [supabase/README.md](supabase/README.md), [02_database_schema.md](02_database_schema.md).

---

## 1. Risks & Mitigation

| Risk | Likelihood | Impact | Mitigation Strategy |
| :--- | :--- | :--- | :--- |
| **Security Flaw in RLS** | Medium | High | **Strict Testing:** Rigorously test all RLS policies to ensure users cannot access or modify data outside their authorized scope. Implement tests that specifically try to cross-read/write between groups and users. Default to `DENY`. |
| **Invite Code Collision** | Low | Medium | **Entropy & Uniqueness:** Generate sufficiently random invite codes (e.g., UUID snippet or high-entropy string). Add a `UNIQUE` constraint to the `invite_code` column in the database. |
| **Scalability of Realtime** | Medium | Medium | **Scoped Subscriptions:** Only subscribe to the data needed for the current view (e.g., use `group_id=eq.{id}`). Avoid listening to entire tables. Use efficient state updates on the client to prevent UI jank. Monitor Supabase resource usage. |
| **Orphaned Data** | Medium | Low | **Cascade Deletes & Cleanup:** Use `ON DELETE CASCADE` for foreign key constraints where appropriate (e.g., deleting a group should delete its `group_members` entries). For Storage, use an Edge Function triggered on deletion to clean up associated files. |
| **Offline Capability** | High | Medium | **Acknowledge Limitation (MVP):** The MVP will be online-only. Clearly communicate this to the user with graceful error messages when the network is unavailable. For V2, plan for a local caching strategy (e.g., using `Isar` or `Drift`). |

---

## 2. Edge Cases to Handle

- **User Management:**
    - What happens when the last admin of a group tries to leave or is deleted? (The app should prevent this and prompt them to promote another admin first).
    - What happens to tasks assigned to a user who is removed from a group? (Decide on a rule: unassign them, or re-assign to the group admin).
    - A user tries to join a group they are already a member of.
    - A user is invited to a group multiple times.

- **Task Management:**
    - Creating a task with no assignees.
    - Editing a recurring task's rule: does it affect future instances only, or the current one as well?
    - Two users trying to mark the same task complete at the exact same time (Supabase's transactional nature should handle this, but the UI needs to react gracefully).
    - Tasks with due dates in the past.

- **Data Sync & Realtime:**
    - The app comes back online after being offline for an extended period. (The state should be fully refetched, not just relying on missed realtime events).
    - A user receives a realtime update for a resource they are currently editing (e.g., another admin changes a task title while you have the edit screen open).

---

## 3. Testing Checklist

### **Unit & Widget Tests (Automated)**

-   **Repositories:** Test every method in the repositories. Mock the Supabase client to return fake data and verify that the repository methods parse it correctly.
-   **Providers:** Test the logic within `StateNotifier` classes. Verify that state transitions are correct based on method calls.
-   **Widgets:** Write widget tests for small, reusable widgets (`PrimaryButton`) and key UI components (`TaskListTile`) to ensure they render correctly given different inputs.

### **Integration & E2E Tests (Automated)**

-   **Auth Flow:**
    -   [ ] User can sign up successfully.
    -   [ ] User can log in with correct credentials.
    -   [ ] User sees an error with incorrect credentials.
    -   [ ] User can log out.
-   **Core Task Flow:**
    -   [ ] User can create a new group.
    -   [ ] User can generate an invite code.
    -   [ ] A different user can join the group with the code.
    -   [ ] A member can create a task and assign it to another member.
    -   [ ] The assignee can see the task on their dashboard.
    -   [ ] The assignee can mark the task as complete.
    -   [ ] The task moves from the "To Do" list to the "Completed" list for all group members in realtime.
    -   [ ] The leaderboard correctly updates with points for the assignee.

### **Manual / QA Testing**

-   **RLS Policy Verification:**
    -   Log in as User A from Group 1.
    -   Attempt to fetch data (tasks, group details) belonging to Group 2 using a tool like Postman or by manipulating the app's API calls.
    -   Verify that all requests are denied.
    -   Log in as a non-admin member. Attempt to perform admin actions (e.g., remove a user, delete a task created by someone else). Verify all actions fail.
-   **UI/UX Testing:**
    -   [ ] Tested on multiple device sizes and orientations.
    -   [ ] Verified the app functions correctly in both light and dark modes.
    -   [ ] Ensure all interactive elements have sufficient touch targets.
-   **Platform Testing:**
    -   [ ] Tested on a physical iOS device.
    -   [ ] Tested on a physical Android device.
