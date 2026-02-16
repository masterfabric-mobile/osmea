# Commented-Out Helpers (iOS)

This document describes the **commented-out Helpers feature** in the Components App and how it relates to **iOS**. The Helpers section has been disabled for store release or configuration; this file explains what was commented out and how it is used on iOS.

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

## 2. How the Helpers Are Used on iOS

When the Helpers feature is **enabled** (uncommented), each helper uses iOS APIs and configuration as follows.

| Helper | iOS usage |
|--------|-----------|
| **URL Launcher** | Opens URLs via `UIApplication.open(_:options:completionHandler:)`. Uses URL schemes (e.g. `tel:`, `mailto:`, `maps:`). `Info.plist` may need `LSApplicationQueriesSchemes` for querying other apps. |
| **File Download** | Downloads files and may use `FileManager`, app sandbox, or shared containers. Storage and file access may require appropriate `Info.plist` usage descriptions if user-visible. |
| **Application Share** | Uses `UIActivityViewController` (share sheet) to share text, URLs, and files. No extra entitlements beyond normal app capabilities. |
| **WebViewerHelper** | Renders HTML and web content via `WKWebView`. May need App Transport Security / `NSAppTransportSecurity` and, if loading arbitrary URLs, appropriate network usage. |
| **Local Notifications** | Uses `UserNotifications` (UNUserNotificationCenter). Requires notification permission and may require `UIBackgroundModes` (e.g. `remote-notification`) if used with push. |
| **Permissions** | Uses permission-handling APIs (e.g. `PermissionHandler` plugin) that map to iOS system dialogs (camera, photos, notifications, etc.). `Info.plist` must include the corresponding usage description keys (e.g. `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSUserNotificationsUsageDescription`). |

---

## 3. iOS Configuration When Re-enabling Helpers

If you **re-enable** the Helpers feature:

1. **Uncomment** in `lib/screens/main_screen.dart`:
   - The Helpers `NavbarItem`.
   - The `case 2: AppRoutes.goToHelpers(context);` (and adjust the Info index if needed).
2. **Uncomment** in `lib/screens/helpers_screen.dart`:
   - The six helper entries in the `helpers` list.
   - The imports for the helper example widgets.
3. **iOS project** (`ios/`):
   - Ensure `Info.plist` has the required usage descriptions and URL schemes used by URL Launcher, Permissions, and any file/photo access.
   - Ensure capabilities (e.g. Push Notifications, Background Modes) match how you use notifications and sharing.

---

## 4. File Locations (Reference)

| Purpose | File |
|---------|------|
| Bottom navigation and Helpers tab | `lib/screens/main_screen.dart` |
| Helpers screen and helper list | `lib/screens/helpers_screen.dart` |
| Helpers route | `lib/routes/app_routes.dart` (path `helpers`, `goToHelpers`) |
| iOS project and Info.plist | `ios/Runner/Info.plist` |

This document is for **iOS**; see `android/COMMENTED_OUT_HELPERS.md` for Android-specific behaviour and configuration.
