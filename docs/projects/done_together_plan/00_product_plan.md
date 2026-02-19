# DoneTogether: Product Plan

**Backend (Supabase) implementation:** Schema, RLS, RPC, and storage structures are defined in the [supabase/](supabase/) folder as migration and seed files per this plan. See [02_database_schema.md](02_database_schema.md) and [03_supabase_endpoints.md](03_supabase_endpoints.md) for details.

**Platform & tooling:** Flutter platform configuration (SDK versions, icons, splash, flavors), runtime permissions (camera, photos, notifications), deep linking for invite links, Sentry integration, and **Supabase-managed app config** (platform-specific iOS/Android values; updates app behaviour without a store release) are described in [01_technical_architecture.md](01_technical_architecture.md), with schema and endpoints in [02_database_schema.md](02_database_schema.md) and [03_supabase_endpoints.md](03_supabase_endpoints.md).

---

## 1. Vision & Core Value Proposition

**Vision:** To be the go-to app for small, trust-based groups (families, partners, roommates, close-knit teams) to collaboratively manage shared responsibilities, reduce friction, and foster a sense of accomplishment.

**Core Value:** DoneTogether makes shared tasks transparent, easy to track, and even a little bit fun. It replaces the nagging, forgetfulness, and lack of clarity with a simple, shared to-do list that keeps everyone accountable and appreciated.

---

## 2. Target Audience

**Primary Users:**
-   **Households & Families:** Couples, roommates, or family members who share household chores, grocery lists, or communal responsibilities.
-   **Small Teams & Study Groups:** Groups collaborating on projects, assignments, or shared administrative tasks.
-   **Event Organizers:** Individuals managing tasks for small events, gatherings, or community activities.

**Secondary Users:**
-   Clubs and organizations with recurring tasks.
-   Anyone seeking to delegate and track shared responsibilities within a trusted group.

---

## 3. Monetization Strategy (V3+)

Initially, DoneTogether will be a **free** application to maximize user adoption and gather feedback. Future monetization strategies (V3 and beyond) could include:

-   **Premium Features (Subscription):**
    -   Unlimited groups / members per group.
    -   Advanced reporting and analytics.
    -   Priority support.
    -   Custom themes and app icons.
-   **Increased Storage:** Charging for additional storage space for task media.
-   **Integrations:** Premium integrations with other productivity tools (e.g., calendar apps, smart home devices).

---

## 4. Product Roadmap

### **MVP: The Foundation of Collaboration**

The MVP is focused on establishing the core functionality for a single group to manage tasks effectively.

| Feature | Description |
| :--- | :--- |
| **User Authentication** | Secure sign-up and login using Supabase Auth (Email/Password, Google). |
| **Profile Management** | Users can set their display name, upload a profile avatar, and write a short bio. |
| **Group Creation & Joining** | - A user can create a new group (e.g., "Home", "Office Project").<br>- The creator becomes the first admin.<br>- Creator can share a unique, time-limited invite link/code. |
| **Group Management** | - View all members in a group.<br>- Admins can remove members. |
| **Task Creation** | - Create tasks with a title, description, and due date.<br>- Ability to upload one or more photos to a task. |
| **Task Assignment** | - Assign a task to one or multiple members of the group. |
| **Task Lifecycle** | - View tasks in a central list (e.g., "To Do", "Completed").<br>- Mark tasks as complete.<br>- View a simple history of completed tasks. |
| **Basic Leaderboard** | - A simple view showing points for completed tasks (e.g., 1 task = 10 points).<br>- Resets weekly. |
| **In-App Notifications** | - A simple inbox for invite notifications.<br>- Basic alerts for new task assignments. |

### **V2: Driving Engagement & Automation**

V2 builds on the core by introducing features that enhance long-term engagement, automate recurring duties, and improve communication.

| Feature | Description |
| :--- | :--- |
| **Recurring Tasks** | - Define tasks that repeat on a schedule (e.g., "Take out trash" every Tuesday).<br>- Automatic re-creation and assignment based on rules. |
| **Advanced Leaderboards** | - Monthly, all-time, and custom date range filters.<br>- Trophies or badges for achievements. |
| **Push Notifications** | - Push notifications for critical events: task assignment, task completion, mentions, and reminders for upcoming due dates. |
| **Task Comments & Mentions** | - A comment thread on each task for discussion.<br>- Ability to `@mention` other group members to notify them. |
| **Multiple Groups** | - Seamlessly switch between different groups from a central dashboard or drawer. |
| **Enhanced Task History** | - Detailed audit trail for each task: who created it, who marked it complete, when it was completed. |
| **Invite Inbox** | - A dedicated screen to view and accept/reject group invitations. |
| **Settings & Customization** | - Granular notification controls.<br>- Theme selection (Light/Dark mode). |
| **Advanced Admin Controls** | - Promote other members to admin status.<br>- Ability to edit or delete any task within the group. |

---
## Validation Checklist

### MVP: The Foundation of Collaboration

#### User & Profile
- [ ] Implement email/password authentication via Supabase Auth.
- [ ] Implement Google social login via Supabase Auth.
- [ ] Users can view their own profile screen.
- [ ] Users can edit their display name.
- [ ] Users can edit their bio.
- [ ] Users can upload a profile avatar.

#### Groups
- [ ] A user can create a new group.
- [ ] The group creator is assigned the 'admin' role.
- [ ] An admin can generate a unique invite link/code.
- [ ] A user can join a group using an invite code.
- [ ] All group members can view the list of other members.
- [ ] An admin can remove a member from a group.

#### Tasks & Core Loop
- [ ] A group member can create a task with a title and description.
- [ ] A task can be assigned to one member.
- [ ] A task can be assigned to multiple members.
- [ ] Optional: A user can attach photos to a task.
- [ ] The main screen displays "To Do" and "Completed" task lists.
- [ ] An assigned user can mark a task as complete.
- [ ] A basic history of completed tasks is viewable.

#### Engagement & Notifications
- [ ] A basic weekly leaderboard is implemented.
- [ ] Points are awarded for completed tasks.
- [ ] A basic in-app notification inbox exists.
- [ ] Users receive an in-app notification for group invitations.
- [ ] Users receive an in-app notification when assigned to a new task.

### V2: Driving Engagement & Automation

#### Core Features
- [ ] Users can define tasks that recur on a schedule (weekly/monthly).
- [ ] The system automatically re-creates recurring tasks.
- [ ] Implement push notifications for key events.
- [ ] Users can add comments to tasks.
- [ ] Users can @mention other users in comments.
- [ ] Users can belong to and switch between multiple groups.

#### Enhancements
- [ ] Leaderboards can be filtered by monthly and all-time ranges.
- [ ] Implement a trophy or badge system for achievements.
- [ ] Task history shows a detailed audit trail (creator, completer, timestamp).
- [ ] A dedicated "Invites" screen is available to manage pending invitations.
- [ ] Admins can promote other members to 'admin' status.
- [ ] Users can select a Light/Dark theme.
- [ ] Users have granular control over which push notifications they receive.
