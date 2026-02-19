# Done Together

Flutter app for shared tasks and responsibilities in small groups (families, roommates, teams). Part of the OSMEA monorepo.

**Platforms:** Android & iOS only (Windows, Web, Linux, macOS runners removed).

## Stack

- **Flutter** 3.9+ / **Dart** 3.9+
- **Supabase** (Auth, DB, Realtime, Storage)
- **BLoC** + **GetIt** + **Injectable**
- **GoRouter**
- **Flavor** (dev / prod)

## Project structure

```
lib/
├── app/
│   ├── core/config/     # DI (config_di.dart)
│   ├── routes/          # go_router (app_routes.dart)
│   └── views/           # Feature views (home, …)
├── flavors/
│   ├── main_dev.dart    # Dev entry
│   └── main_prod.dart   # Prod entry
├── main.dart            # Default entry (delegates to dev)
└── starter.dart         # Bootstrap: config, Supabase, router
assets/
└── app_config.json      # Supabase URL & anon key (per env)
```

## Setup

1. From repo root or this directory:
   ```bash
   cd projects/done_together
   flutter pub get
   ```
2. Copy or create `assets/app_config.json` with your Supabase URL and anon key (see `app_config.json` placeholders).

## Run

- **Dev flavor (default from CLI):**
  ```bash
  flutter run --flavor dev -t lib/flavors/main_dev.dart
  ```
- **Prod flavor:**
  ```bash
  flutter run --flavor prod -t lib/flavors/main_prod.dart
  ```
- **Without flavor** (uses dev entry):
  ```bash
  flutter run
  ```

## Android

Flavors are configured in `android/app/build.gradle.kts`:

- `dev`: `applicationIdSuffix = ".dev"`
- `prod`: no suffix

So you can install dev and prod side by side on the same device.

## iOS

The project uses the default Runner scheme. To run with a flavor from the command line:

```bash
flutter run --flavor dev -t lib/flavors/main_dev.dart
```

To have separate bundle IDs per flavor (e.g. `com.donetogether.done_together.dev`), add build configurations (Debug-dev, Debug-prod, Release-dev, Release-prod, Profile-dev, Profile-prod) in Xcode and create **dev** / **prod** schemes that use them, similar to `storefront_supabase`.

## Docs

Product and technical docs: `docs/projects/done_together_plan/`.
