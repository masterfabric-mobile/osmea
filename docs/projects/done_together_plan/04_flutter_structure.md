# DoneTogether: Flutter Structure & State Management

A well-organized Flutter project is crucial for scalability, maintainability, and developer productivity. This document proposes a feature-first folder structure and the use of Riverpod for state management.

**Backend reference:** API schema and endpoints are defined in [02_database_schema.md](02_database_schema.md) and [03_supabase_endpoints.md](03_supabase_endpoints.md); Supabase migration and RPC implementation are summarized in the [supabase/](supabase/) folder (see [supabase/README.md](supabase/README.md)). The repository layer should use `profiles`, `tasks`, `group_members`, and RPCs (`get_leaderboard`, `join_group_with_code`) according to this schema.

**Platform & observability:** Platform config (Flutter/iOS/Android versions, flavors), permissions (camera, photos, notifications), deep linking, and Sentry setup are in [01_technical_architecture.md](01_technical_architecture.md). Sentry should be initialized in `main.dart`; config (e.g. DSN, environment) can live under `core/config`.

**App config (Supabase):** Uygulama yapılandırması Supabase’ten okunur; platform bazlı (iOS/Android) değerler ve store güncellemesi olmadan davranış değişikliği için kullanılır. Detay: [01_technical_architecture.md](01_technical_architecture.md) (§2 App Config from Supabase), [02_database_schema.md](02_database_schema.md) (`app_config`), [03_supabase_endpoints.md](03_supabase_endpoints.md) (App Config endpoint’leri).

---

## 1. Recommended Folder Structure (Feature-First)

Instead of organizing by file type (e.g., `screens`, `widgets`), we organize by feature. This keeps related logic, UI, and state together, making features modular and easier to navigate.

```
lib/
|
├─── src/
│    |
│    ├─── **core**/                     # Shared services, models, constants
│    │   ├─── api/                    # Supabase client initialization, API wrappers
│    │   ├─── constants/             # App-wide constants (routes, keys)
│    │   ├─── config/                 # Build-time env (flavors, Supabase URL, Sentry DSN); runtime app config from Supabase (AppConfigRepository / provider)
│    │   ├─── theme/                  # App theme, colors, text styles
│    │   ├─── utils/                  # Utility functions (e.g., date formatters)
│    │   └─── widgets/                 # Truly generic widgets (e.g., `PrimaryButton`)
│    │
│    ├─── **models**/                   # Plain Dart objects for our data
│    │   ├─── app_user.dart
│    │   ├─── group.dart
│    │   └─── task.dart
│    │
│    ├─── **features**/                 # Main application features
│    │   |
│    │   ├─── **auth**/
│    │   │   ├─── providers/          # Riverpod providers for auth state
│    │   │   ├─── repositories/       # Logic to talk to Supabase Auth
│    │   │   └─── ui/                 # Login, SignUp screens and widgets
│    │   │
│    │   ├─── **dashboard**/
│    │   │   ├─── providers/          # Providers for tasks, etc.
│    │   │   ├─── repositories/       # Fetching tasks
│    │   │   └─── ui/                 # The main dashboard screen, task list, etc.
│    │   │
│    │   ├─── **groups**/
│    │   │   ├─── providers/
│    │   │   ├─── repositories/
│    │   │   └─── ui/
│    │   │       ├─── group_detail_screen.dart
│    │   │       └─── widgets/
│    │   │           └─── group_member_list.dart
│    │   │
│    │   └─── **profile**/
│    │       ├─── providers/
│    │       ├─── repositories/
│    │       └─── ui/
│    │
│    └─── **routing**/                  # Navigation and routing setup
│        └─── app_router.dart          # Using GoRouter or similar
│
└─── main.dart                      # App entry point
```

## 2. State Management: Riverpod

**Riverpod** is recommended for state management due to its compile-safe, decoupled, and highly testable nature. It solves many of the pain points of `Provider`.

### Why Riverpod?

1.  **Compile Safety:** Avoids runtime errors common with `Provider` (`ProviderNotFoundException`).
2.  **Decoupling:** Providers are global and can be accessed from anywhere without needing `BuildContext`. This makes it easy for repositories to access other providers.
3.  **Simplified Logic:** No need to combine providers. You can read as many as you need in a widget or another provider.
4.  **Support for Asynchronous Operations:** `FutureProvider` and `StreamProvider` are perfect for handling loading/error states when fetching data from Supabase or listening to Realtime streams.
5.  **Testability:** Dependencies can be easily mocked by overriding providers in the test environment.

### Provider Strategy

-   **`Provider`:** For exposing immutable values or objects that don't change, like a `SupabaseClient` instance or a `TaskRepository`.
    ```dart
    // Exposing the repository
    final taskRepositoryProvider = Provider((ref) => TaskRepository(ref.read));
    ```

-   **`StateNotifierProvider`:** For managing complex state that can change, such as the state of a form or the user's profile data.
    ```dart
    // Managing the state of the profile edit form
    final profileEditProvider = StateNotifierProvider<ProfileEditNotifier, ProfileEditState>((ref) {
      return ProfileEditNotifier();
    });
    ```

-   **`FutureProvider`:** For one-off asynchronous data fetching, like getting a single task's details. Riverpod automatically handles the `loading`, `data`, and `error` states.
    ```dart
    // Fetching a single task
    final taskProvider = FutureProvider.autoDispose.family<Task, String>((ref, taskId) {
      final taskRepo = ref.watch(taskRepositoryProvider);
      return taskRepo.getTask(taskId);
    });
    ```

-   **`StreamProvider`:** For listening to realtime data streams from Supabase. This is the ideal way to display the task list or notifications.
    ```dart
    // Listening to tasks in a group
    final tasksStreamProvider = StreamProvider.autoDispose.family<List<Task>, String>((ref, groupId) {
      final taskRepo = ref.watch(taskRepositoryProvider);
      return taskRepo.watchTasksInGroup(groupId);
    });
    ```

By using this provider-per-feature approach, we keep the app's state organized, predictable, and easy to debug. The UI layer becomes purely declarative, reacting to state changes from the providers.

---
## Validation Checklist

### Folder Structure
- [ ] The `lib/src` directory is created.
- [ ] A `core` directory exists for shared logic, widgets, and themes.
- [ ] A `core/config` (or equivalent) exists for build-time env (Supabase URL, Sentry DSN, flavor) and for runtime app config fetched from Supabase (e.g. `AppConfigRepository` / provider that calls `get_app_config(platform)` and caches merged config).
- [ ] A `models` directory exists for all Plain Old Dart Objects (PODOs).
- [ ] A `features` directory exists.
- [ ] App features (Auth, Dashboard, Groups, etc.) are organized into subdirectories inside `features`.
- [ ] Each feature directory contains its own `providers`, `repositories`, and `ui` subdirectories.
- [ ] A dedicated `routing` directory is set up for `GoRouter` or another navigation package.

### State Management (Riverpod)
- [ ] `flutter_riverpod` package is added to `pubspec.yaml`.
- [ ] The entire app is wrapped in a `ProviderScope` at the root (`main.dart`).
- [ ] `Provider` is used for exposing immutable repositories/clients.
    - [ ] e.g., `taskRepositoryProvider`
- [ ] `StateNotifierProvider` is used for managing complex, mutable state.
    - [ ] e.g., A provider for a form's state.
- [ ] `FutureProvider` is used for one-off async data fetches.
    - [ ] The UI correctly uses `.when(loading:, error:, data:)` to handle states.
    - [ ] `.family` modifier is used where a parameter is needed (e.g., fetching a single task by ID).
- [ ] `StreamProvider` is used for listening to realtime Supabase streams.
    - [ ] The UI correctly uses `.when()` to handle the stream's states.
    - [ ] The UI updates automatically when new data is emitted from the stream.
    - [ ] `.family` modifier is used to subscribe to a specific, filtered stream (e.g., tasks for one group).
- [ ] The widget tree is kept clean of business logic; logic resides within providers.
- [ ] `ref.watch` is used to rebuild the UI on state changes.
- [ ] `ref.read` is used for one-off function calls inside callbacks (e.g., `onPressed`).
