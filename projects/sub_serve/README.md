# MasterFabric SubServe

A new Flutter project.

## Flavors

Proje **dev**, **staging** ve **prod** flavor’ları ile çalışır. Her flavor için uygulama adı, API base URL ve log ayarları `lib/flavor/app_config.dart` içinde tanımlıdır.

### Çalıştırma

Dart tarafında flavor `--dart-define=FLAVOR=<flavor>` ile verilir. Android’de aynı cihazda birden fazla flavor yüklü olabilir (farklı applicationId).

**Dev:**
```bash
flutter run --dart-define=FLAVOR=dev --flavor dev
```

**Staging:**
```bash
flutter run --dart-define=FLAVOR=staging --flavor staging
```

**Prod:**
```bash
flutter run --dart-define=FLAVOR=prod --flavor prod
```

### Build

```bash
# Android APK (prod)
flutter build apk --dart-define=FLAVOR=prod --flavor prod

# Android App Bundle (prod)
flutter build appbundle --dart-define=FLAVOR=prod --flavor prod

# iOS (prod) – Xcode’da scheme seçerek de yapılabilir
flutter build ios --dart-define=FLAVOR=prod
```

### Yapı (storefront_woo ile uyumlu)

- **`lib/starter.dart`** – `launchApp(environment: 'dev'|'staging'|'prod')`: MasterApp.runBefore, config yükleme, `configureDependencies`, `AppConfig` oluşturma, `runApp(MyApp(config))`
- **`lib/flavors/`** – Entry point’ler (storefront_woo ile aynı):
  - **`main_dev.dart`**, **`main_staging.dart`**, **`main_prod.dart`** – Flavor paketi ile ortam set edilir, `launchApp(environment: …)` çağrılır
- **`lib/flavor/`** – Flavor config (tip + konfig):
  - **`app_flavor.dart`** – `AppFlavor` enum (dev, staging, prod)
  - **`app_config.dart`** – `AppConfig` (appName, apiBaseUrl, enableLogging)
- **`lib/main.dart`** – Varsayılan giriş; `FLAVOR` dart-define ile ortam seçer ve `launchApp(environment: …)` çağırır
- **`lib/app/app_widget.dart`** – `MyApp` ve `MyHomePage` widget’ları
- **`lib/app/core/config/config_di.dart`** – `configureDependencies(environment)` ve `getIt` (DI yapısı)
- Android: `android/app/build.gradle.kts` içinde `productFlavors` (dev, staging, prod) ve `app_name` resValue

Flavor entry ile çalıştırma (dart-define kullanmadan):

```bash
flutter run -t lib/flavors/main_dev.dart --flavor dev
flutter run -t lib/flavors/main_staging.dart --flavor staging
flutter run -t lib/flavors/main_prod.dart --flavor prod
```

Kodda ortama özel davranış için `AppConfig` kullanın:

```dart
// Örnek: API base URL
final baseUrl = config.apiBaseUrl;

// Örnek: sadece dev’de log
if (config.enableLogging) debugPrint('...');
```

## Assets & App config

- **`assets/app_config.json`** – Uygulama konfigürasyonu (API, Supabase, UI, feature flags, splash, localization). Açılışta `MasterApp.runBefore(assetConfigPath: 'assets/app_config.json')` ile yüklenir; kodda `AssetConfigHelper()` ile erişilir (masterfabric_core).
- **`assets/i18n/`** – Slang çeviri dosyaları (`strings_en.i18n.json`, `strings_tr.i18n.json`). Üretilen kaynak: `lib/src/resources/resources.g.dart` (`dart run slang`).
- **`assets/images/`** – Görseller; launcher icon için `assets/images/app_icon.png` kullanılır.

Config’ten değer okumak için:

```dart
import 'package:masterfabric_core/masterfabric_core.dart';

final configHelper = AssetConfigHelper();
await configHelper.loadConfig('assets/app_config.json', false);

final appName = configHelper.getString('app_settings.app_name', 'MasterFabric SubServe');
final baseUrl = configHelper.getString('api_configuration.base_url', '');
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
