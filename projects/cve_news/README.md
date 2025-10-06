# CVE News

A Flutter application for monitoring and exploring Common Vulnerabilities and Exposures (CVE).

## Overview

CVE News aggregates security vulnerability information and provides a fast, mobile-first experience for browsing, searching, and staying notified about the latest CVEs.

## Features

- Browse the latest CVEs with pagination
- Search and filter by keyword (via backend API)
- Light theme with smooth splash and onboarding
- Push/local notifications ready (config based)
- Production and development flavors

## Project Structure

- App entry: `lib/starter.dart`
- Flavors: `lib/flavors/main_dev.dart`, `lib/flavors/main_prod.dart`
- DI and config wiring: `lib/app/core/config/config_di.dart`
- App configuration (JSON): `assets/app_config.json`

## Configuration

Application behavior is driven by `assets/app_config.json`.

- API base URL: `api_configuration.base_url` (defaults to `https://api.masterfabric.co/cve_news`)
- Feature toggles: `feature_flags`
- Splash and onboarding: `splash_configuration`, `onboarding_configuration`

Update `assets/app_config.json` and rebuild the app if you change assets.

## Flavors

- Development: `lib/flavors/main_dev.dart`
- Production: `lib/flavors/main_prod.dart`

Run a specific flavor using the corresponding main file (see commands below).

## Run

```bash
# Get dependencies
flutter pub get

# Run development flavor
flutter run -t lib/flavors/main_dev.dart

# Run production flavor
flutter run -t lib/flavors/main_prod.dart
```

## Build

```bash
# Android (release)
flutter build apk -t lib/flavors/main_prod.dart --release

# iOS (release)
flutter build ios -t lib/flavors/main_prod.dart --release
```

## Notes

- Ensure your Flutter SDK is installed and up to date.
- If you modify assets (like `assets/app_config.json`), verify they are listed under `flutter.assets` in `pubspec.yaml` and run `flutter pub get`.

