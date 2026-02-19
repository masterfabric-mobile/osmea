# DoneTogether: Technical Architecture & Screen Flow

**Supabase layout:** Database schema, RLS, RPC functions, and storage buckets are defined in the [supabase/](supabase/) folder via migration and seed files. Use `supabase db push` to apply migrations and `supabase db reset` (local) when needed. Details: [supabase/README.md](supabase/README.md).

---

## 1. Technical Architecture Overview

The application follows a modern, decoupled architecture with a Flutter frontend and a Supabase backend. This provides a clear separation of concerns, rapid development capabilities, and excellent scalability.

![DoneTogether Architecture](https://i.imgur.com/example.png)  <!-- Placeholder for a real diagram -->

- **Frontend (Flutter):** A single codebase for iOS, Android, and potentially Web/Desktop. The Flutter app is responsible for all UI rendering, state management, and user interaction. It communicates with Supabase via its dedicated client library.
- **Backend (Supabase):** Provides all backend services, acting as a "Backend-as-a-Service" (BaaS).
    - **Authentication:** `Supabase.auth` handles user sign-up, login, and session management. RLS policies in the database use `auth.uid()` to secure data.
    - **Database (Postgres):** The core data store for profiles, groups, tasks, etc. All data access is gated by RLS policies.
    - **Realtime:** The `supabase_flutter` client subscribes to database changes (e.g., new tasks, status updates) and updates the UI in realtime without needing manual polling.
    - **Storage:** `Supabase.storage` is used for storing user-generated content like profile avatars and task photos. Storage access is controlled by RLS-like policies.
    - **Edge Functions:** Server-side Dart functions for business logic that shouldn't live on the client, such as creating invite codes or sending scheduled reminders.

---

## 2. Platform Configuration

The Flutter app targets iOS and Android with a single codebase. The following configuration ensures consistent behaviour and store compliance.

### Flutter & Dart

- **Flutter SDK:** Use a stable channel version (e.g. 3.16+). Pin the exact version in the project README or CI so all developers and pipelines use the same SDK.
- **Dart:** Follow the SDK version required by the chosen Flutter version (e.g. Dart 3.2+).

### iOS

- **Minimum iOS version:** 12.0 or higher (recommended 13.0+ for broader API support).
- **Configuration:** Set in `ios/Podfile` (`platform :ios, '13.0'`) and in Xcode project settings.
- **Capabilities:** Enable "Sign in with Apple" if offering Apple sign-in; push notifications (V2) require the Push Notifications capability.
- **App Icon & Launch Screen:** Provide all required asset sizes in `ios/Runner/Assets.xcassets/AppIcon.appiconset` and a launch screen (e.g. `LaunchScreen.storyboard` or `Info.plist` + storyboard). Use a tool like `flutter_launcher_icons` for icon generation.

### Android

- **minSdkVersion:** 21 or higher (recommended 24+ for better security and APIs).
- **targetSdkVersion:** Align with current Play Store requirements (e.g. 34).
- **Configuration:** Set in `android/app/build.gradle` (`minSdkVersion`, `targetSdkVersion`, `compileSdkVersion`).
- **App Icon & Splash:** Provide adaptive and legacy icons; use `flutter_launcher_icons` and `flutter_native_splash` (or equivalent) for consistent icons and splash screen.

### Build Flavors / Environments

Use flavors to separate environments and avoid mixing credentials:

- **Flavors:** e.g. `dev`, `staging`, `prod`.
- **Per flavor:** Different Supabase URL and anon key (via `--dart-define` or environment-specific config files). Never commit production keys to the repo; use CI secrets for release builds.
- **App identifiers:** Different application IDs per flavor (e.g. `com.donetogether.app.dev`, `com.donetogether.app`) so dev and prod can be installed side by side.

### App Config from Supabase (Remote / Runtime)

Uygulama davranışını store güncellemesi olmadan değiştirmek için **app config Supabase üzerinden yönetilir**. Bu yapı platform bazlı (iOS / Android) farklı değerler taşıyabilir ve uygulama başlangıcında veya periyodik olarak çekilerek uygulamayı güncelleyebilir.

- **Kaynak:** Config, Supabase’te `app_config` tablosunda tutulur. Şema ve endpoint detayları için bkz. [02_database_schema.md](02_database_schema.md) (App Config tablosu) ve [03_supabase_endpoints.md](03_supabase_endpoints.md) (App Config endpoint’leri).
- **Platform bazlı değerler:** Her config anahtarı için:
    - **`common`:** Her iki platformda da geçerli değer.
    - **`ios`:** Sadece iOS için (varsa `common` üzerine yazar veya platform merge’de öncelik alır).
    - **`android`:** Sadece Android için (aynı mantık).
- **Kullanım alanları:**
    - **Zorunlu güncelleme:** Minimum desteklenen app sürümü (`min_app_version`); kullanıcı eski sürümdeyse store’a yönlendirme.
    - **Özellik bayrakları:** Yeni özellikleri belirli platformlarda veya kademeli açma (e.g. `feature_recurring_tasks_enabled`).
    - **Bakım modu:** Uygulama girişinde mesaj gösterme veya erişimi kısıtlama.
    - **API / iş mantığı:** Örneğin timeout süreleri, limitler, A/B test parametreleri (platforma göre farklı olabilir).
- **Akış:** Uygulama açıldığında (ve isteğe bağlı periyodik veya Realtime ile) client, kendi platformunu (iOS/Android) gönderir; backend `common` + ilgili platform değerlerini birleştirip döner. Uygulama bu config’i cache’leyip (örn. bellekte + isteğe bağlı local persistence) kullanır; değişince davranış güncellenir.
- **Güvenlik:** `app_config` sadece okunabilir olmalı (anon veya authenticated read); yazma sadece Supabase Dashboard veya service role ile yapılır. Hassas bilgi (API key vb.) konulmamalı; sadece uygulama davranışını yönlendiren genel parametreler kullanılmalı.

### Summary Table

| Platform | Key setting | Recommended value |
| :--- | :--- | :--- |
| Flutter | Stable channel | 3.16+ |
| iOS | Minimum version | 13.0 |
| Android | minSdkVersion | 24 |
| Android | targetSdkVersion | 34 (or current Play requirement) |

---

## 3. Permissions & Deep Linking

### Runtime Permissions

The app requests permissions only when the user performs an action that needs them. Use a permission-handling package (e.g. `permission_handler`) and follow platform guidelines (Android 13+ granular media, iOS usage descriptions).

| Permission | When to request | Purpose |
| :--- | :--- | :--- |
| **Camera** | When the user taps "Take photo" (avatar or task photo). | Capture profile avatar or task images. |
| **Photos / Media (Android 13+)** | When the user taps "Choose from gallery" or similar. | Pick existing images for avatar or task media. |
| **Notifications (V2)** | Before enabling push, e.g. on first launch or in Settings. | Send push notifications for task assignments, reminders, mentions. |

- **UX:** Show a short in-context explanation before requesting (e.g. "We need camera access to take a photo for this task"). If the user denies, show a fallback (e.g. "You can enable it in Settings") and avoid blocking core flows where possible.
- **Android:** Declare permissions in `AndroidManifest.xml`. For scoped storage and media, use the appropriate `<uses-permission>` and (if needed) `<uses-permission android:maxSdkVersion="32">` for legacy storage.
- **iOS:** Add usage description keys to `Info.plist` (e.g. `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription` if saving). For notifications, no usage description is required.

### Deep Linking (Invite Links)

Invite links should open the app directly to the join flow when possible.

- **Scheme:** Use a custom scheme (e.g. `donetogether://join?code=ABC-123`) for app-only links. Optionally support **Universal Links (iOS)** and **App Links (Android)** with a domain (e.g. `https://app.donetogether.com/join?code=ABC-123`) so links work from emails and messages and open the app when installed.
- **Route:** One canonical path for join, e.g. `/join` with query `code`. The app parses the code and shows the join-group screen (or a "Group invitation" preview then confirm).
- **Implementation:** Use `go_router` (or similar) with a path like `/join`, read `code` from query parameters, and navigate to the join dialog or dedicated screen. Configure iOS (Associated Domains) and Android (intent filters) for HTTPS links.
- **Fallback:** If the app is not installed, the HTTPS URL can show a simple web page with "Install the app" and store links.

---

## 4. Error Handling Strategy

### Frontend (Flutter)
-   **User-Friendly Messages:** Display clear, concise error messages to the user for API failures or invalid inputs. Avoid technical jargon.
-   **Retry Mechanisms:** Implement retry logic for transient network failures during API calls.
-   **Logging:** Use a logging package (e.g., `logger`) for development and debugging, with different log levels.
-   **Centralized Error Reporting:** Use **Sentry** for crash and error reporting (see Sentry integration below).

### Sentry Integration (Flutter)

Sentry is used to capture unhandled exceptions, Flutter framework errors, and optional breadcrumbs so issues can be diagnosed in production.

-   **Package:** Add `sentry_flutter` to `pubspec.yaml`. Initialize Sentry as early as possible in `main()` (e.g. wrap `runApp` with `SentryFlutter.init()` and use `runApp` inside the callback).
-   **Environment:** Only enable Sentry for non-debug builds (e.g. check `kReleaseMode` or flavor). Use a separate Sentry project or DSN for staging vs production so staging noise does not mix with production.
-   **DSN:** Store the Sentry DSN in environment config (dart-define or flavor-specific assets). Never hardcode the DSN in source control; inject it in CI for release builds.
-   **Context:** Set user context after login (e.g. `Sentry.configureScope` with `user.id`, and optionally `username`) so events can be filtered by user. Avoid sending PII beyond what is needed (e.g. no passwords, no tokens).
-   **Breadcrumbs:** Rely on Sentry’s default breadcrumbs (navigation, HTTP if configured). Add custom breadcrumbs for important actions (e.g. "Created task", "Joined group") to ease debugging.
-   **Manual capture:** For caught exceptions that should be reported (e.g. "expected" but rare failures), use `Sentry.captureException`. For non-fatal messages, use `Sentry.captureMessage` with an appropriate level.
-   **Release & environment:** Set `environment` (e.g. `dev`, `staging`, `prod`) and release version (e.g. from `package_info_plus`) so Sentry can group events by version and environment.
-   **Native crashes:** On both iOS and Android, Sentry Flutter captures native crashes when the SDK is correctly integrated (e.g. via the Sentry docs for iOS/Android). Ensure the native Sentry dependencies are added and that symbol upload is configured for release builds if desired.

### Backend (Supabase / Edge Functions)
-   **Detailed Logging:** Edge Functions should log detailed errors to Supabase logs for debugging.
-   **Graceful Degradation:** APIs should return standardized error structures (e.g., JSON with `code` and `message`) to the client.
-   **Database Error Handling:** Use `try-catch` blocks or appropriate SQL error handling in RPC functions to prevent unhandled exceptions.

---

## 5. Deployment Strategy

### Frontend (Flutter)
-   **Mobile Apps (iOS/Android):**
    -   Use Fastlane for automated build, testing, and deployment to Apple App Store Connect and Google Play Console.
    -   Leverage CI/CD pipelines (e.g., GitHub Actions, Bitrise) to automate the entire process from code commit to app store release.
-   **Web App (Optional, V2+):**
    -   Deploy to a static hosting service (e.g., Vercel, Netlify) with CI/CD integration.

### Backend (Supabase)
-   **Migrations:**
    -   Apply database schema changes using the Supabase CLI (`supabase migration new`, `supabase db push`).
    -   Changes are version-controlled in the `supabase/migrations` directory.
-   **Edge Functions:**
    -   Deploy Edge Functions using the Supabase CLI (`supabase functions deploy`).
    -   Version control the Dart source code for Edge Functions.
-   **RLS & Policies:** Managed directly within the database schema via migrations.

---

## 6. Screen Flow & Navigation

The app navigation is centered around a main `Scaffold` with a `BottomNavigationBar` for primary screens, and a `Navigator` for pushing detail screens.

### Primary Screens (Bottom Navigation Bar)

1.  **Dashboard / Task List Screen:**
    - **Default View:** The main screen after login.
    - **Content:**
        - A filterable list of tasks ("My Tasks", "All Tasks").
        - Tabs for "To Do" and "Completed".
        - A floating action button (FAB) to create a new task.
    - **Navigation:** Tapping a task opens the `Task Detail Screen`.

2.  **Leaderboard Screen:**
    - **Content:**
        - A list of group members ranked by points.
        - Tabs for "Weekly" and "Monthly" (V2) views.
    - **Navigation:** Tapping a user could open their `Profile Screen`.

3.  **Groups Screen:**
    - **Content:**
        - A list of groups the user is a member of.
        - A button to "Create Group" or "Join Group".
    - **Navigation:** Tapping a group opens the `Group Detail Screen`. Tapping "Join" might open a dialog to enter an invite code.

4.  **Profile & Settings Screen:**
    - **Content:**
        - Displays the user's avatar, name, and bio.
        - Button to "Edit Profile".
        - List of settings (e.g., Notifications, Dark Mode).
        - Logout button.
    - **Navigation:** Opens the `Profile Edit Screen`.

### Secondary (Pushed) Screens

- **Auth Flow Screens (pre-login):**
    - `Login Screen`: Email/password and social login buttons.
    - `Sign-Up Screen`: Form for creating a new account.

- **Task Flow:**
    - `Task Detail Screen`: Shows full task details, photos, assigned members, and completion history. Allows for marking a task as complete.
    - `Create/Edit Task Screen`: A form to create or edit a task, including title, description, photo upload, and member assignment.

- **Group Flow:**
    - `Group Detail Screen`: Shows group information and a list of members. For admins, provides options to "Generate Invite Link" or "Remove Member".
    - `Create Group Screen`: A simple form to name a new group.

- **Notifications/Invites:**
    - `Notifications Screen`: (Could be an icon in the AppBar). Shows a list of in-app notifications, primarily group invitations. Users can accept or reject invites here.

---
## Validation Checklist

### Platform Configuration
- [ ] Flutter SDK version is pinned (e.g. in README or CI).
- [ ] iOS minimum version is set (e.g. 13.0) in Podfile and Xcode.
- [ ] Android `minSdkVersion` and `targetSdkVersion` are set in `build.gradle`.
- [ ] App icon assets are configured for iOS and Android (e.g. via `flutter_launcher_icons`).
- [ ] Splash / launch screen is configured for both platforms.
- [ ] Build flavors (e.g. dev, staging, prod) are set up with separate Supabase config.
- [ ] Production Supabase URL and keys are not committed; they are injected via CI or secrets.
- [ ] App config is fetched from Supabase at runtime; client uses platform (ios/android) to get merged config.
- [ ] App config is cached (in-memory and optionally persisted) and used to drive min version check, feature flags, and other runtime behaviour.

### Permissions & Deep Linking
- [ ] Camera permission is requested only when the user taps "Take photo" (avatar or task).
- [ ] Photos/Media permission is requested when the user chooses gallery for avatar or task media.
- [ ] iOS: `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` are set in `Info.plist`.
- [ ] Android: Required permissions are declared in `AndroidManifest.xml`.
- [ ] Invite deep link route (e.g. `/join?code=`) is registered in the app router.
- [ ] Custom scheme (e.g. `donetogether://join?code=`) opens the app to the join flow.
- [ ] (Optional) Universal Links (iOS) and App Links (Android) are configured for HTTPS invite URLs.

### Sentry Integration
- [ ] `sentry_flutter` is added to `pubspec.yaml` and initialized in `main()`.
- [ ] Sentry is enabled only for release/staging builds (not in debug).
- [ ] Sentry DSN is loaded from environment (dart-define or config), not hardcoded.
- [ ] User context (e.g. id, username) is set after login; no sensitive PII is sent.
- [ ] Release and environment are set (e.g. from package_info and flavor).
- [ ] Manual `Sentry.captureException` is used for important caught errors where appropriate.

### Core Architecture
- [ ] Supabase client is initialized and available in the Flutter app.
- [ ] A clear separation exists between the `core`, `models`, and `features` directories.
- [ ] All backend communication is routed through `Repository` classes.
- [ ] `supabase_flutter` is used for authentication and realtime subscriptions.

### Authentication Flow
- [ ] Implement Login Screen UI.
- [ ] Implement Sign-Up Screen UI.
- [ ] Implement navigation logic to show Auth Flow screens to logged-out users.
- [ ] Implement navigation logic to show main app to logged-in users.

### Primary Screens (Bottom Navigation)
- [ ] A main `Scaffold` with a `BottomNavigationBar` is the root of the app post-login.
- [ ] **Dashboard / Task List Screen:**
    - [ ] Screen UI is created.
    - [ ] Floating Action Button for creating new tasks is present.
    - [ ] Tabs for "To Do" and "Completed" are functional.
    - [ ] Tapping a task navigates to the `Task Detail Screen`.
- [ ] **Leaderboard Screen:**
    - [ ] Screen UI is created.
    - [ ] List of ranked members is displayed.
- [ ] **Groups Screen:**
    - [ ] Screen UI is created.
    - [ ] "Create Group" and "Join Group" actions are available.
    - [ ] Tapping a group navigates to the `Group Detail Screen`.
- [ ] **Profile & Settings Screen:**
    - [ ] Screen UI is created.
    - [ ] Displays the current user's profile information.
    - [ ] "Edit Profile" button navigates to the `Profile Edit Screen`.
    - [ ] A "Logout" button is implemented and functional.

### Secondary (Pushed) Screens
- [ ] **Task Detail Screen:**
    - [ ] Screen UI is created.
    - [ ] Displays all task details, including photos and assignees.
    - [ ] A "Mark Complete" button is functional.
- [ ] **Create/Edit Task Screen:**
    - [ ] Screen UI (form) is created.
    - [ ] Form includes fields for title, description, and due date.
    - [ ] UI for selecting/assigning members is implemented.
    - [ ] UI for uploading photos is implemented.
- [ ] **Group Detail Screen:**
    - [ ] Screen UI is created.
    - [ ] Displays group member list.
    - [ ] For admins: "Generate Invite Link" button is visible and functional.
    - [ ] For admins: "Remove Member" functionality is implemented.
- [ ] **Notifications Screen / View:**
    - [ ] A UI element (e.g., AppBar icon) leads to the notification view.
    - [ ] The view lists pending group invitations.
    - [ ] Users can "Accept" or "Reject" invitations from this view.
