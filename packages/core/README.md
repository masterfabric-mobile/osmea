# 🔧 OSMEA Core

<div align="center">
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/OSMEA%20Core-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="OSMEA Core" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter%203.0+-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart%203.6+-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="Dart" /></a>
  <a href="https://bloclibrary.dev"><img src="https://img.shields.io/badge/BLoC%209.1-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="BLoC" /></a>
  <a href="https://firebase.google.com"><img src="https://img.shields.io/badge/Firebase-2D3748?style=for-the-badge&logo=firebase&logoColor=white&labelColor=1A202C" alt="Firebase" /></a>
</div>

<br>

> *Foundation architecture, shared utilities, and config-driven views for all OSMEA Flutter projects*


[Overview](#-overview) • [Features](#-features) • [Tech Stack](#️-technology-stack) • [Getting Started](#-getting-started) • [Usage Examples](#-usage-examples) • [Project Structure](#-project-structure)


<details>
<summary>🌟 Overview</summary>

**OSMEA Core** is the shared foundation package of the OSMEA monorepo.  
Every project in the workspace depends on it. It provides the base architecture (BLoC/Cubit), dependency injection, config-driven views, Firebase integration, localization (Slang), and 20+ utility helpers — all driven by a single `app_config.json` file.

### 🎯 **Use Cases**

- **Base Architecture** — All views extend `BaseViewModelCubit` or `BaseViewBloc` from this package
- **Config-Driven UI** — Splash, onboarding, auth, error, loading and empty screens are all configured via `app_config.json`
- **Shared Utilities** — Device info, permissions, local storage, notifications, file download, URL launcher, web viewer
- **Firebase Layer** — Analytics, Remote Config, and Crashlytics initialization
- **Localization** — Slang-powered type-safe i18n with auto-detection

### Target Users

- **All OSMEA projects** — `storefront_woo`, `storefront_supabase`, `admin_dashboard`, `api_explorer`
- **Flutter developers** building on top of the OSMEA monorepo
- **Contributors** extending the shared architecture or adding new utilities

</details>


<details>
<summary>✨ Features</summary>

### 🏗️ **Base Architecture**

| Class | Description |
|-------|-------------|
| `BaseViewModelCubit` | Base Cubit view with state management |
| `BaseViewModelHydratedCubit` | Persisted Cubit view via `hydrated_bloc` |
| `BaseViewBloc` | Base BLoC view with event/state pattern |
| `BaseViewHydratedCubit` | Hydrated variant for persistent UI state |
| `BaseViewState` | Shared state model (loading / success / error) |
| `BaseViewModel` | Base view model class |
| `MasterApp` | Root application wrapper |
| `MasterView` | Unified page-level view with mixins |
| `MasterViewMixins` | Common view behaviors |
| `MasterViewEnums` | View-level enumerations |

### ⚙️ **Config-Driven Views**

All screens are fully controlled by `assets/app_config.json`:

| Screen | Config Key | Description |
|--------|------------|-------------|
| **Splash** | `splash_configuration` | Duration, logo, animation, nav target |
| **Onboarding** | `onboarding_configuration` | Pages, skip/next buttons, auto-advance |
| **Auth** | `auth_configuration` | Sign-in/sign-up UI labels, logo, checkboxes |
| **Loading** | `loading_configuration` | Style (startup / space / enterprise), indicator type |
| **Error Handling** | `error_handling_configuration` | 5 error types (general, network, server, auth, maintenance) |
| **Empty View** | `empty_view_configuration` | 13 empty state types (cart, search, orders, wishlist…) |
| **Search** | `search_view_configuration` | AppBar color, hints, barcode/voice scanner toggles |
| **Image Detail** | `image_detail_configuration` | Back/close button styles |

### 🔥 **Firebase Integration**

- `firebase_analytics` — Page tracking and custom events
- `firebase_core` — Firebase initialization via `firebase_options.dart`
- `firebase_remote_config` — Runtime feature flags and configuration via `RemoteConfigHelper`

### 🌐 **Localization (Slang)**

- **Engine:** Slang 4.11 + `slang_flutter`
- **Languages:** `en` (base) — extensible to `tr`, `de`, `fr`, `es` via `localization_configuration`
- **Source:** `assets/i18n/strings_en.i18n.json`
- **Generated:** `gen/strings.g.dart` + `gen/strings_en.g.dart`
- **Usage:** `context.t.welcome`, `context.t.hello(name: 'Ali')`

### 🛠️ **Helpers & Utilities**

| Helper | Description |
|--------|-------------|
| `AssetConfigHelper` | Load & parse `app_config.json` |
| `AuthStorageHelper` | Persist auth tokens and session data |
| `LocalStorageHelper` | `SharedPreferences` wrapper with typed accessors |
| `DeviceInfoHelper` | Device model, OS, platform, physical/emulator check |
| `PackageInfoHelper` | App version, build number, package name |
| `PermissionHandlerHelper` | Runtime permission request and status check |
| `LocalNotificationHelper` | Schedule and show local notifications |
| `UrlLauncherHelper` | Open URLs, emails, phone, SMS, social/map apps |
| `WebViewerHelper` | In-app web view and HTML rendering |
| `FileDownloadHelper` | Download files to device storage |
| `ApplicationShareHelper` | Share text and files via `share_plus` |
| `RemoteConfigHelper` | Fetch Firebase Remote Config values |
| `AnimationHelper` | Reusable animation utilities |
| `ColorHelper` | Color manipulation and parsing |
| `DatetimeHelper` | Date formatting, relative time, timezone |
| `DoubleExtensionHelper` | Numeric extension utilities |
| `PriceInfoCurrencyHelper` | Currency formatting |
| `FirstLetterCapitalizeHelper` | String capitalization utility |
| `GridHelper` | Grid layout utilities |
| `SpacerHelper` | Spacing and dimension helpers |
| `CommonLoggerHelper` | Structured logging via `logger` |
| `OnboardingHelper` | Onboarding completion state management |

### 📐 **Pre-built Views**

| View | Route | Description |
|------|-------|-------------|
| `SplashView` | `/splash` | Config-driven startup screen |
| `OnboardingView` | `/onboarding` | Multi-page first-run flow |
| `AuthView` | `/auth` | Sign in / sign up with tab layout |
| `LoadingView` | `/loading` | Full-screen loading overlay |
| `ErrorHandlingView` | `/error` | 5 error type variants |
| `EmptyView` | `/empty` | 13 empty state variants |
| `SearchView` | `/search` | Search input with voice & barcode |
| `ImageDetailView` | `/image-detail` | Full-screen image viewer |
| `InfoBottomSheetView` | — | Info modal bottom sheet |
| `AboutView` | `/about` | App about page |
| `FaqView` | `/faq` | FAQ accordion view |
| `ContactUsView` | `/contact` | Contact form |
| `AccountView` | `/account` | Account management |
| `PermissionsView` | `/permissions` | Permission request screen |

</details>


<details>
<summary>🛠️ Technology Stack</summary>

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.0+ / Dart 3.6+ |
| **State Management** | flutter_bloc 9.1 + hydrated_bloc 10.1 |
| **DI** | injectable 2.7 + get_it |
| **Routing** | go_router 15.1 |
| **Localization** | slang 4.11 + slang_flutter 4.11 + intl 0.20 |
| **Firebase** | firebase_core 3.13 + analytics 11.4 + remote_config 5.3 |
| **Storage** | sqflite 2.4 + shared_preferences 2.5 |
| **Permissions** | permission_handler 11.2 |
| **Notifications** | flutter_local_notifications 19.4 |
| **HTTP** | dio 5.7 |
| **Device** | device_info_plus 11.4 + package_info_plus 8.3 |
| **Sharing** | share_plus 10.1 |
| **Web** | flutter_inappwebview 6.1 + webview_flutter 4.10 + flutter_html 3.0 |
| **Misc** | url_launcher 6.3 + timezone 0.10 + logger 2.5 |

### 📁 Project Structure

```
packages/core/
├── lib/
│   ├── core.dart                        # Main barrel export
│   ├── firebase_options.dart            # Firebase platform options
│   └── src/
│       ├── core.dart                    # Src barrel
│       ├── base/
│       │   ├── base_view_bloc.dart
│       │   ├── base_view_cubit.dart
│       │   ├── base_view_hydrated_cubit.dart
│       │   ├── base_view_model_cubit.dart
│       │   ├── base_view_model_hydrated_cubit.dart
│       │   ├── base_view_model.dart
│       │   ├── base_view_state.dart
│       │   ├── master_view/
│       │   │   ├── master_app.dart
│       │   │   ├── master_view.dart
│       │   │   ├── master_view_enums.dart
│       │   │   └── master_view_mixins.dart
│       │   ├── master_view_cubit/
│       │   ├── master_view_hydrated_cubit/
│       │   └── widgets/
│       ├── di/
│       │   └── config/                  # Injectable DI config
│       ├── helper/
│       │   ├── asset_config_helper.dart
│       │   ├── auth_storage_helper.dart
│       │   ├── animation_helper.dart
│       │   ├── color_helper.dart
│       │   ├── datetime_helper.dart
│       │   ├── device_info_helper.dart
│       │   ├── double_extension_helper.dart
│       │   ├── file_download_helper.dart
│       │   ├── first_letter_capitalize_helper.dart
│       │   ├── grid_helper.dart
│       │   ├── local_notification_helper.dart
│       │   ├── onboarding_helper.dart
│       │   ├── package_info_helper.dart
│       │   ├── price_info_currency_helper.dart
│       │   ├── remote_config_helper.dart
│       │   ├── spacer_helper.dart
│       │   ├── url_launcher_helper.dart
│       │   ├── web_viewer_helper.dart
│       │   ├── application_share_helper.dart
│       │   ├── common_logger_helper/
│       │   │   ├── abstract/
│       │   │   └── common_logger_helper.dart
│       │   ├── local_storage/
│       │   │   ├── local_storage.dart
│       │   │   └── local_storage_helper.dart
│       │   └── permission_handler_helper/
│       │       ├── abstract/
│       │       ├── models/
│       │       └── permission_handler_helper.dart
│       ├── layout/
│       │   ├── grid.dart
│       │   └── spacer.dart
│       ├── models/
│       │   ├── about_models.dart
│       │   ├── contact_us_models.dart
│       │   ├── empty_view_models.dart
│       │   ├── error_handling_models.dart
│       │   ├── faq_models.dart
│       │   ├── info_models.dart
│       │   ├── loading_models.dart
│       │   ├── onboarding_models.dart
│       │   └── splash_models.dart
│       ├── resources/
│       │   ├── resources.g.dart
│       │   └── resources_en.g.dart
│       └── views/
│           ├── routes.dart
│           ├── splash/
│           ├── onboarding/
│           ├── auth/
│           ├── loading/
│           ├── error_handling/
│           ├── empty_view/
│           ├── search/
│           ├── image_detail/
│           ├── info_bottom_sheet/
│           ├── about/
│           ├── faq/
│           ├── contact_us/
│           ├── account/
│           └── permissions/
├── assets/
│   ├── app_config.json                  # Master configuration file
│   └── i18n/
│       └── strings_en.i18n.json         # English string definitions
└── gen/
    ├── strings.g.dart                   # Slang generated (all locales)
    └── strings_en.g.dart                # Slang generated (English)
```

</details>


<details>
<summary>🚀 Getting Started</summary>

### Prerequisites

- **Flutter SDK** 3.0.0+
- **Dart SDK** 3.6.0+
- Firebase project configured (for analytics/remote config)

### Add the Package

```yaml
# pubspec.yaml
dependencies:
  core:
    path: ../../packages/core   # monorepo local usage
```

### Install Dependencies

```bash
flutter pub get
```

### Code Generation

```bash
# Injectable DI + Slang localization
dart run build_runner build --delete-conflicting-outputs
```

### Initialize in main.dart

```dart
import 'package:core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Dependency injection
  await configureDependencies();

  // Slang localization
  LocaleSettings.useDeviceLocale();

  runApp(TranslationProvider(child: const MyApp()));
}
```

</details>


<details>
<summary>💡 Usage Examples</summary>

### Extending BaseViewModelCubit

```dart
class HomeView extends BaseViewModelCubit<HomeCubit, HomeState> {
  const HomeView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => state.when(
        loading: () => const CoreLoadingView(),
        success: (data) => ProductListWidget(data: data),
        error: (msg) => CoreErrorView(message: msg),
      ),
    );
  }

  @override
  void onInit(BuildContext context) {
    cubit(context).loadProducts();
  }
}
```

### Loading App Config

```dart
final config = await AssetConfigHelper.loadConfig();

final appName    = config.appSettings.appName;        // "OSMEA Mobile App"
final env        = config.appSettings.environment;    // "production"
final baseUrl    = config.apiConfiguration.baseUrl;
final splashNav  = config.splashConfiguration.navigationTarget; // "/onboarding"
final languages  = config.localizationConfiguration.supportedLanguages;
```

### Local Storage

```dart
final storage = getIt<LocalStorageHelper>();

await storage.setString('user_id', '42');
await storage.setBool('onboarding_done', true);

final userId = await storage.getString('user_id');
```

### Permissions

```dart
final permissions = getIt<PermissionHandlerHelper>();

final granted = await permissions.requestPermission(Permission.camera);
if (!granted) {
  // show rationale
}
```

### Localization

```dart
// In any widget
Text(context.t.welcome)
Text(context.t.itemCount(count: 5))

// Switch locale at runtime
await LocaleSettings.setLocale(AppLocale.tr);
```

### URL Launcher

```dart
await getIt<UrlLauncherHelper>().launchUrl('https://masterfabric.co');
await getIt<UrlLauncherHelper>().launchEmail('support@masterfabric.co');
await getIt<UrlLauncherHelper>().launchPhone('+905551234567');
```

### Local Notifications

```dart
final notif = getIt<LocalNotificationHelper>();
await notif.initialize();

await notif.showNotification(
  id: 1,
  title: 'Order Confirmed',
  body: 'Your order #1042 has been confirmed.',
);
```

### Firebase Remote Config

```dart
final remoteConfig = getIt<RemoteConfigHelper>();
await remoteConfig.initialize();

final showBanner = remoteConfig.getBool('show_promo_banner', defaultValue: false);
```

</details>


<details>
<summary>⚙️ app_config.json Reference</summary>

The `assets/app_config.json` file is the single source of truth for all config-driven views:

```json
{
  "app_settings":              { "app_name", "environment", "debug_mode" },
  "api_configuration":         { "base_url", "timeout_seconds", "retry_count" },
  "firebase_configuration":    { "analytics_enabled", "remote_config_enabled" },
  "ui_configuration":          { "theme_mode", "primary_color", "font_scale" },
  "feature_flags":             { "onboarding_enabled", "dark_mode_available" },
  "localization_configuration":{ "default_language", "supported_languages" },
  "splash_configuration":      { "duration", "logo_url", "navigation_target" },
  "onboarding_configuration":  { "pages", "show_skip_button", "auto_advance" },
  "auth_configuration":        { "sign_in", "sign_up", "forgot_password" },
  "loading_configuration":     { "style", "progress_indicator_type" },
  "error_handling_configuration": { "error_pages" (5 types) },
  "empty_view_configuration":  { "empty_pages" (13 types) },
  "search_view_configuration": { "hints", "show_barcode_scanner", "colors" },
  "security_configuration":    { "ssl_pinning", "session_timeout_minutes" },
  "storage_configuration":     { "enable_encryption", "cache_size_mb" },
  "notification_configuration":{ "push_notifications_enabled" },
  "url_launcher_configuration":{ "social_media_urls", "maps_urls", "website_urls" },
  "performance_configuration": { "image_cache_size_mb", "lazy_loading_enabled" }
}
```

</details>


<details>
<summary>🤝 Contributing</summary>

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/new-helper`)
3. Add your helper under `lib/src/helper/`
4. Register it with `@injectable` in DI
5. Export it from `lib/core.dart`
6. **Open a Pull Request**

### Development Guidelines

- Every new helper must have a corresponding abstract class
- BLoC-based views must extend `BaseViewModelCubit` or `BaseViewBloc`
- New config-driven views must have a matching key in `app_config.json`
- Run `build_runner` after adding `@injectable` annotations
- Use Conventional Commits

</details>


---

## 📄 License

> 🔐 **License:** GNU AGPL v3.0  
> 📜 This project is protected under the **GNU Affero General Public License v3.0**.

---

<div align="center">

**Built with ❤️ by the OSMEA Team**

© 2025 MasterFabric Mobile • Maintained by the OSMEA Engineering Team

</div>

