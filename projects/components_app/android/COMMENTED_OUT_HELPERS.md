# Commented-Out Helpers (Android)

This document describes the **commented-out Helpers feature** in the Components App and how it relates to **Android**. The Helpers section has been disabled for store release or configuration; this file explains what was commented out and how it is used on Android.

---

## 1. What Was Commented Out

### 1.1 Main navigation (`lib/screens/main_screen.dart`)

- **Helpers bottom navigation item**  
  The "Helpers" tab (wrench icon) in the bottom bar is commented out. Users no longer see or tap this tab.
- **Navigation handler**  
  The `case 2: AppRoutes.goToHelpers(context)` branch in `_navigateToPage()` is commented out. Index 2 now navigates to Info instead.

### 1.2 Helpers screen (`lib/screens/helpers_screen.dart`)

- **Helper screen imports**  
  Imports for helper example widgets are commented out:
  - `application_share_helper_example.dart`
  - `url_launcher_example.dart`
  - `file_download_helper_example.dart`
  - `viewer_helper_example.dart`
  - `permission_handler_example.dart`
  - `local_notification_helper_example.dart`
- **Helper list**  
  The list of six helper entries (URL Launcher, File Download, Application Share, WebViewerHelper, Local Notifications, Permissions) is commented out. The screen uses an empty list, so the Helpers screen shows no cards.

The **route** `/helpers` and **HelpersScreen** widget remain in the app; only the tab and the helper entries are disabled.

---

## 2. How the Helpers Are Used on Android

When the Helpers feature is **enabled** (uncommented), each helper uses Android APIs and configuration as follows.

| Helper | Android usage |
|--------|---------------|
| **URL Launcher** | Opens URLs via `Intent.ACTION_VIEW` and `Intent.ACTION_DIAL`, `Intent.ACTION_SENDTO`, etc. Uses `Intent` resolution and may require `<queries>` in the manifest for package visibility (Android 11+). |
| **File Download** | Downloads files (e.g. via `DownloadManager` or HTTP client) and stores them in app-specific or shared storage. May use `Storage Access Framework` or `MANAGE_EXTERNAL_STORAGE` / `READ_EXTERNAL_STORAGE` / `WRITE_EXTERNAL_STORAGE` depending on target SDK and scoped storage. |
| **Application Share** | Uses `Intent.ACTION_SEND` / `Intent.ACTION_SEND_MULTIPLE` with `Intent.createChooser()` to share text, URLs, and files. May need `FileProvider` for sharing file URIs. |
| **WebViewerHelper** | Renders HTML and web content via `WebView` (or the implementation used by the Flutter plugin). May require `android.permission.INTERNET` and, for mixed content, `WebSettings` configuration. |
| **Local Notifications** | Uses `NotificationManager` and notification channels. Requires `POST_NOTIFICATIONS` on Android 13+ (API 33+). Notification channels are typically created in native code or by the Flutter notification plugin. |
| **Permissions** | Uses the permission-handling APIs (e.g. `PermissionHandler` plugin) that map to `Activity.requestPermissions()` and runtime permissions. `AndroidManifest.xml` must declare the permissions (e.g. `CAMERA`, `READ_EXTERNAL_STORAGE`, `POST_NOTIFICATIONS`). |

---

## 3. Android Configuration When Re-enabling Helpers

If you **re-enable** the Helpers feature:

1. **Uncomment** in `lib/screens/main_screen.dart`:
   - The Helpers `NavbarItem`.
   - The `case 2: AppRoutes.goToHelpers(context);` (and adjust the Info index if needed).
2. **Uncomment** in `lib/screens/helpers_screen.dart`:
   - The six helper entries in the `helpers` list.
   - The imports for the helper example widgets.
3. **Android project** (`android/`):
   - **AndroidManifest.xml**: Ensure all required `<uses-permission>` and, if needed, `<queries>` elements are present for URL launching, storage, notifications, and other features used by the helpers.
   - **Notification channels**: If using local notifications, ensure notification channels are created (e.g. in `MainActivity` or via the plugin).
   - **FileProvider**: If sharing files, ensure `FileProvider` is configured in the manifest and in `res/xml/file_paths.xml` if used.

---

## 4. File Locations (Reference)

| Purpose | File |
|---------|------|
| Bottom navigation and Helpers tab | `lib/screens/main_screen.dart` |
| Helpers screen and helper list | `lib/screens/helpers_screen.dart` |
| Helpers route | `lib/routes/app_routes.dart` (path `helpers`, `goToHelpers`) |
| Android manifest | `android/app/src/main/AndroidManifest.xml` |
| MainActivity (e.g. notification channels) | `android/app/src/main/kotlin/.../MainActivity.kt` |

This document is for **Android**; see `ios/COMMENTED_OUT_HELPERS.md` for iOS-specific behaviour and configuration.
