## Permission Handler Guidance (OSMEA)

This guide explains OSMEA's `permission_handler_helper` module: what it does, how it is structured, the lifecycle of permission checks and requests, platform nuances, and how to implement it in your apps with best practices.

---

## 1) What is it? Overview
- **Purpose**: Centralize Android/iOS runtime permission handling, provide consistent UX, abstract platform/version differences, and cache results for performance.
- **Core Class**: `packages/core/lib/src/helper/permission_handler_helper/permission_handler_helper.dart` → `PermissionHandlerHelper` (singleton)
- **Interface (Contract)**: `packages/core/lib/src/helper/permission_handler_helper/abstract/permission_handler_base.dart` → `IPermissionHandlerBase`
- **Models**: `packages/core/lib/src/helper/permission_handler_helper/models/permission_models.dart` → `AppPermission` enum, `PermissionResult`
- **Cache/Storage**: `packages/core/lib/src/helper/local_storage/local_storage_helper.dart` → `LocalStorageHelper`
- **External Package**: `permission_handler`

Why this exists: direct use of `permission_handler` across the app tends to create scattered logic, duplicated mapping, and inconsistent UX. The helper consolidates the logic, handles API-level specifics, adds caching, and exposes a single, predictable API.

---

## 2) Architecture and Flow
- `PermissionHandlerHelper` implements `IPermissionHandlerBase` and is the single entry point.
- Request/check flow:
  - Queries the platform using `permission_handler` for the current status or to request a permission.
  - Caches results via `LocalStorageHelper` (SQLite/SharedPreferences) with a configurable TTL.
  - Applies Android API-level aware strategies for tricky permissions (notably `storage` and `scheduleExactAlarm`).
- Smart flows of note:
  - **Storage (Android)**
    - API 33+ (Android 13+): evaluates `photos` (READ_MEDIA_* granular media) and may combine or fallback with `manageExternalStorage` when applicable.
    - API 30–32: prefers `manageExternalStorage` when the app needs broad file access.
    - API 23–29: classic `READ/WRITE_EXTERNAL_STORAGE` mapping through `permission_handler`.
  - **Schedule Exact Alarm (Android 12+)**: Requests `SCHEDULE_EXACT_ALARM` or gracefully downgrades behavior depending on OEM constraints and current status.
- iOS simulator behavior: in certain permanently denied edge-cases, the helper may interpret status in a simulator-friendly way to reduce friction during development (guarded, non-production behavior).

---

## 3) Files and Responsibilities
- `abstract/permission_handler_base.dart` → Contract with: `requestPermission`, `checkPermission`, `getPermissionStatus`, `requestMultiplePermissions`, `openAppSettings`, `shouldShowRequestPermissionRationale`, `clearPermissionCache`, `setCacheValidityHours`.
- `models/permission_models.dart` →
  - `AppPermission` enum: `camera`, `microphone`, `location`, `locationWhenInUse`, `storage`, `photos`, `notifications`, `contacts`, `calendar`, `manageExternalStorage`, `scheduleExactAlarm`.
  - `PermissionResult`: carries `status`, `isGranted`, `isPermanentlyDenied`, `isRestricted`, `isLimited`, `error`, and factory helpers.
- `permission_handler_helper.dart` →
  - Singleton access: `PermissionHandlerHelper.instance`.
  - Cache keys and TTL: default 24h, customizable with `setCacheValidityHours(int)`.
  - “Smart” methods encapsulating API-level decision trees for storage and exact alarms.
  - Public API surface: `requestPermission`, `checkPermission`, `getPermissionStatus`, `requestMultiplePermissions`, `openAppSettings`, `shouldShowRequestPermissionRationale`, `clearPermissionCache`, `getPermissionsSummary`, `getCacheStatistics`.
- `local_storage/local_storage_helper.dart` → Simple key/value store with list/clear support. Uses SQLite on mobile, SharedPreferences on Web.

---

## 4) Supported Permissions
`AppPermission` (summary):
- camera, microphone
- location, locationWhenInUse
- storage (Android smart handling by API level)
- photos (iOS Photo Library / Android 13+ granular media)
- notifications
- contacts
- calendar
- manageExternalStorage (Android 11+ special permission)
- scheduleExactAlarm (Android 12+)

---

## 5) How to Use (Code Examples)
All examples below use `PermissionHandlerHelper.instance`.

- Request a single permission:
```dart
final permissionHelper = PermissionHandlerHelper.instance;
final granted = await permissionHelper.requestPermission(AppPermission.camera);
if (granted) {
  // proceed
}
```

- Check permission with caching:
```dart
final hasLocation = await permissionHelper.checkPermission(AppPermission.location);
```

- Get detailed status and handle permanently denied:
```dart
final result = await permissionHelper.getPermissionStatus(AppPermission.storage);
if (result.isPermanentlyDenied) {
  await permissionHelper.openAppSettings();
}
```

- Request multiple permissions at once:
```dart
final results = await permissionHelper.requestMultiplePermissions([
  AppPermission.camera,
  AppPermission.microphone,
]);
```

- Android rationale support:
```dart
if (await permissionHelper.shouldShowRequestPermissionRationale(AppPermission.camera)) {
  // show an educational UI before requesting
}
```

- Cache operations:
```dart
await permissionHelper.clearPermissionCache(); // clear all cached permission states
await permissionHelper.setCacheValidityHours(12); // set TTL to 12 hours
```

- Diagnostics:
```dart
final summary = await permissionHelper.getPermissionsSummary();
final stats = await permissionHelper.getCacheStatistics();
```

---

## 6) Platform Configuration Notes
- Android Manifest must include version-appropriate permissions (e.g., `READ_MEDIA_IMAGES`, `MANAGE_EXTERNAL_STORAGE`, `SCHEDULE_EXACT_ALARM`).
- iOS `Info.plist` must include usage description keys for camera, microphone, location, photo library, etc.
- Follow `permission_handler` documentation for Gradle and CocoaPods setup.

Quick references:
- Android 13+ granular media: `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`, `READ_MEDIA_AUDIO`.
- Manage All Files: `MANAGE_EXTERNAL_STORAGE` (settings intent flow may be required by OEMs).
- Exact Alarms: `SCHEDULE_EXACT_ALARM` + special app-ops handling on some devices.

---

## 7) Implementation Details and Best Practices

### 7.1 Caching Strategy
- Default TTL: 24 hours. Adjust via `setCacheValidityHours(int hours)`.
- Use caching to avoid redundant system prompts and reduce UI flicker on repeated checks.
- After critical flows (e.g., user changes permission in a guided flow), call `clearPermissionCache([specificPermission])` to force a fresh read.

### 7.2 Android Storage Strategy
- Prefer requesting `AppPermission.storage` only; let the helper translate to API-specific permissions.
- For apps needing broad file access on Android 11+ (API 30+), the helper may route to `manageExternalStorage`. Ensure your UX explains why full access is needed and provide a direct path to settings when required.
- On Android 13+, granular media permissions may be sufficient (images/video/audio); avoid requesting broad access unnecessarily.

### 7.3 iOS Nuances
- iOS may return limited photo library access; `PermissionResult.isLimited` helps tailor UX (prompt to broaden scope if your feature truly needs it).
- Simulator-specific handling exists only to ease development; always verify on physical devices.

### 7.4 Rationale and UX
- Before calling `requestPermission` on Android, consider `shouldShowRequestPermissionRationale` and show an educational UI explaining the benefit to the user.
- If the permission is permanently denied, guide the user to `openAppSettings()` with a clear explanation of what to enable and why.
- Keep UI copy action-focused and respectful. Avoid blocking the entire app unless truly necessary.

### 7.5 Error Handling and Logging
- `PermissionResult.error` carries failure information; log with context and avoid silent failures.
- Use structured logging where possible and correlate with feature usage analytics to detect friction.

---

## 8) Integration Steps (New Project)
1) Add the dependency: ensure `packages/core` is available in the project and `permission_handler` is included in your app’s `pubspec.yaml`.
2) Add platform declarations: update Android Manifest and iOS `Info.plist` with the required permissions and usage descriptions.
3) No explicit init required: the helper lazily initializes `LocalStorageHelper`.
4) Use the helper in flows requiring permissions:
   - On Android, optionally check `shouldShowRequestPermissionRationale` to decide whether to show an educational UI first.
   - Use `requestPermission` to prompt; if denied, decide on fallback UX or `openAppSettings`.
   - For repeated checks, prefer `checkPermission`/`getPermissionStatus` (leverages cache) to minimize prompting.
5) For storage/media use cases, request only `AppPermission.storage`; the helper manages combinations and fallbacks.
6) Tune cache policy:
   - Default 24h is fine for most cases.
   - Shorten TTL if your feature depends on very fresh state; or explicitly clear cache after critical flows.
7) Use diagnostics: `getPermissionsSummary` and `getCacheStatistics` help during QA and debugging.

---

## 9) Extending the System (Adding a New Permission)
1) Add a new value to the `AppPermission` enum.
2) Map it inside `_mapToPermission` in `permission_handler_helper.dart`.
3) If behavior differs by platform/API level, add a dedicated smart pathway (e.g., `*_Smart`) and route `request/check/status` accordingly.
4) Update Android Manifest and/or iOS `Info.plist` as required.
5) Review UX: define behavior for denied, permanently denied, restricted, and limited states.

---

## 10) Troubleshooting / FAQ
- “Why do I see `photos`/`manageExternalStorage` instead of `storage` on Android 13?”
  - Android 13+ introduces granular media permissions; the helper chooses the appropriate mapping and combination for your request.
- “Permissions look granted on the iOS Simulator.”
  - Some flows relax permanent denial in simulators for convenience; always validate on real devices.
- “How long does the cache last?”
  - 24 hours by default; change with `setCacheValidityHours` or clear explicitly after permission-related flows.
- “Exact alarm still not firing after granting permission.”
  - Some OEMs gate exact alarms behind additional app-ops or battery optimizations. Provide a settings deep link and user guidance.

---

## 11) Quick Implementation Checklist
- Define the minimal set of permissions your feature truly needs.
- Add correct Manifest/Info.plist entries and usage strings.
- Use `PermissionHandlerHelper.instance` for all permission interactions.
- Show rationale where appropriate; avoid surprise prompts.
- Handle permanently denied by guiding users to settings.
- Leverage caching and clear it after critical permission changes.
- Test on: Android API 23–29, 30–32, 33+; iOS latest stable + one previous; simulator and physical devices.

You’re ready. Follow this guide to integrate permission handling quickly and correctly, with a consistent user experience across platforms and OS versions.
