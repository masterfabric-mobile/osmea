# 🧪 OSMEA Storefront Supabase

<p align="center">
  <a href="https://apps.apple.com/tr/app/masterfabric-s-store/id6758958857"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" height="40" alt="Download on the App Store" style="vertical-align: middle" /></a>
  &nbsp;
  <a href="https://play.google.com/store/apps/details?id=com.masterfabric.storefrontSupabase"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Google_Play_Store_badge_EN.svg/960px-Google_Play_Store_badge_EN.svg.png" height="40" alt="Get it on Google Play" style="vertical-align: middle" /></a>
</p>


<div align="center">
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/Storefront%20Supabase-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Storefront Supabase" /></a>
  <a href="pubspec.yaml"><img src="https://img.shields.io/badge/Version-1.0.0-2D3748?style=for-the-badge&logoColor=white&labelColor=1A202C" alt="Version" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Platform-Flutter-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Platform" /></a>
  <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-2D3748?style=for-the-badge&logo=supabase&logoColor=white&labelColor=1A202C" alt="Supabase" /></a>
</div>

<br>

> *Modern Supabase-powered Storefront App for Mobil*


[Overview](#-overview) • [Features](#-features) • [Tech Stack](#️-technology-stack) • [Getting Started](#-getting-started) • [Documentation](#-documentation) • [Screenshots](#-screenshots)


<details>
<summary>🌟 Overview</summary>

**OSMEA Storefront Supabase** is a modern Flutter storefront application built on top of **Supabase**.  
It provides a fast, responsive, and extensible shopping experience targeting iOS, Android and Web with a shared codebase.

### 🎯 **Use Cases**

- **Full storefront**: Home, categories, products, cart, checkout, user account, favorites
- **Admin panel**: Dashboard, users, products, orders, coupons, settings
- **Config-driven**: App name, auth labels, navbar, theme, and feature flags via `app_config.json`
- **Multi-language**: Turkish, English, German, French (Slang i18n)
- **Flavors**: `dev` and `prod` for environment-specific config and bundle IDs

### Target Users

- **Startups & SMEs** that need a Supabase-based mobile storefront
- **Agencies** building white-label e-commerce apps
- **Developers** looking for a clean Flutter + Supabase + BLoC reference

</details>


<details>
<summary>✨ Features</summary>

### 🛒 **Storefront Features**

| Feature | Description |
|--------|-------------|
| **Home** | Configurable sections: banners, categories, brands, flash sale, recommended products, collections |
| **Search** | Full-text search with filters (categories, brands, price) |
| **Categories** | Category list and products-by-category with filters and sort |
| **Brands** | Brand list and products-by-brand |
| **Product detail** | Images, variants (size/color), description, reviews, add to cart |
| **Cart** | Cart items, quantity, coupons, collapsible order summary |
| **Checkout** | Multi-step: address, shipping, payment, summary |
| **Favorites** | Wishlist with groups; sync with Supabase |
| **Profile** | Login / Sign up, profile info, addresses, change password, orders, reviews, settings, help |
| **Auth** | Supabase Auth (email/password); configurable app bar and welcome text; password visibility toggle |
| **Onboarding** | Optional first-run onboarding (configurable pages) |
| **Bottom bar** | Configurable navbar (Home, Search, Cart, Favorites, Profile) with auth-aware profile item |

### 👤 Account & Auth

- **Sign In / Sign Up**: Configurable titles and "Welcome to …" text from `auth_configuration` in `app_config.json`
- **Profile**: Personal info, addresses (CRUD), change password, order history, reviews
- **Addresses**: Add, edit, delete; label and default address support
- **Orders**: List and order detail
- **Reviews**: User reviews and review form on product detail
- **Settings**: Language and currency (sheet)
- **Help & Support**: Static contact, FAQ, returns info
- **Delete account**: Request account deletion (flow can be wired to backend)

### 🛠 Admin Panel

| Section | Description |
|--------|-------------|
| **Dashboard** | Overview, charts, key metrics |
| **Users** | User list and management |
| **Products** | Product list, add/edit product (with categories, brands, variants) |
| **Orders** | Order list and management |
| **Coupons** | Create and edit discount coupons |
| **Settings** | Admin settings |

Access: available when the logged-in user has `role == 'admin'` (Profile → Admin Dashboard). Admin routes use a separate shell with bottom navigation.

### 🧱 Architecture & Dev

- **State**: BLoC/Cubit (`flutter_bloc`) per screen; view models extend `BaseViewModelCubit`
- **DI**: `get_it` + `injectable` (see `lib/app/core/config/`)
- **Routing**: `go_router` with shell routes (user shell with bottom bar, admin shell)
- **UI**: Shared `core` and `components` packages (OSMEA design system)
- **Config**: Single `assets/app_config.json`; read via `AssetConfigHelper` from core
- **Assets**: `flutter_gen` for typed asset references

### 🗂 Routes Overview

| Path | Description |
|------|-------------|
| `/` | Splash |
| `/onboarding` | Onboarding (optional first run) |
| `/home` | Home |
| `/search` | Search |
| `/products` | Product list (with optional query params) |
| `/product-detail/:id` | Product detail |
| `/categories` | Categories |
| `/categories/products/:categoryId` | Products by category |
| `/brands/:brandId` | Products by brand |
| `/cart` | Cart |
| `/checkout` | Checkout |
| `/favorites` | Favorites |
| `/profile` | Profile (when authenticated) |
| `/auth` | Login / Sign up (when not authenticated) |
| `/profile/info` | Personal info |
| `/profile/addresses` | Addresses |
| `/profile/change-password` | Change password |
| `/profile/orders` | Orders |
| `/profile/reviews` | My reviews |
| `/profile/help-support` | Help & support |
| `/settings` | App settings |
| `/admin/dashboard` | Admin dashboard |
| `/admin/users` | Admin users |
| `/admin/products` | Admin products |
| `/admin/orders` | Admin orders |
| `/admin/coupons` | Admin coupons |
| `/admin/settings` | Admin settings |

User routes (except splash/onboarding) sit in a **ShellRoute** that provides the bottom navigation bar. Admin routes use a separate shell with admin bottom nav.

### 🌐 Localization

- **Tool**: Slang
- **Locales**: `tr`, `en`, `de`, `fr`
- **Sources**: `assets/i18n/*.i18n.json` (or similar under `assets/i18n/`)
- **Generated**: `lib/src/resources/resources.g.dart` and `resources_<locale>.g.dart`
- **Usage**: `context.resources.xxx` (e.g. `context.resources.signIn`, `context.resources.myProfile`)
- **Settings**: User can change language (and currency) from Profile or Settings; language is applied app-wide.

</details>


<details>
<summary>🛠️ Technology Stack</summary>

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.9+ / Dart 3.9+ |
| **Backend** | Supabase (Auth, PostgreSQL, Storage, Realtime) |
| **State** | flutter_bloc (Cubit) |
| **DI** | get_it, injectable |
| **Navigation** | go_router |
| **i18n** | slang, slang_flutter |
| **Env** | flavor (dev / prod) |
| **Charts** | fl_chart (admin dashboard) |

### 📁 Project Structure

```
projects/storefront_supabase/
├── lib/
│   ├── app/
│   │   ├── core/
│   │   │   ├── bloc/           # Language, currency cubits
│   │   │   └── config/         # DI (config_di.dart, config_di.config.dart)
│   │   ├── models/             # Product, Order, User, Cart, etc.
│   │   ├── routes/
│   │   │   └── app_routes.dart # GoRouter routes, shells, navbar logic
│   │   ├── utils/              # Helpers (price, localization, navbar icons)
│   │   ├── views/
│   │   │   ├── view_home/      # Home + content widgets
│   │   │   ├── view_product_list/
│   │   │   ├── view_product_detail/
│   │   │   ├── view_cart/
│   │   │   ├── view_checkout/
│   │   │   ├── view_favorites/
│   │   │   ├── view_profile/   # Auth, profile, addresses, orders, etc.
│   │   │   ├── view_categories/
│   │   │   ├── view_brands/
│   │   │   ├── view_search/
│   │   │   ├── view_settings/
│   │   │   ├── view_splash/
│   │   │   ├── view_onboarding/
│   │   │   └── admin/          # Dashboard, users, products, orders, coupons, settings
│   │   └── widgets/            # Shared widgets (e.g. product_card_widget)
│   ├── flavors/
│   │   ├── main_dev.dart       # Dev entry
│   │   └── main_prod.dart      # Prod entry
│   ├── gen/                    # flutter_gen (assets)
│   ├── src/resources/         # Slang generated translations
│   └── starter.dart            # App bootstrap (launchApp)
├── assets/
│   ├── app_config.json         # Main configuration
│   └── i18n/                   # Slang locale JSONs
├── migrations/
│   ├── supabase_integration.sql
│   └── favorites_enhancement_v2.sql
├── pubspec.yaml
└── README.md
```

### 🗄 Database (Supabase)

The app expects Supabase (PostgreSQL) tables and RLS policies as in the migration files. Main entities include:

- **users** (extends Supabase Auth or links to `auth.uid()`)
- **products**, **product_variants**, **product_images**
- **categories**, **brand**
- **cart**, **order**, **order_items**
- **favorites**, **favorite_groups**
- **user_addresses**
- **product_reviews**
- **coupons**
- **admin_users**, **admin_settings**, **admin_activity_log**, etc.

See `migrations/supabase_integration.sql` and `migrations/favorites_enhancement_v2.sql` for the full schema. Apply and adjust for your project.

</details>


<details>
<summary>🚀 Getting Started</summary>

### Prerequisites

- **Flutter SDK** 3.9.0+
- **Dart SDK** 3.9.0+
- **Xcode** (iOS) / **Android Studio** (Android)
- **Supabase project** (URL + anon key)

### Clone and install

```bash
git clone https://github.com/masterfabric-mobile/osmea.git
cd osmea/projects/storefront_supabase
flutter pub get
```

### Code generation (recommended)

```bash
# From repo root or from projects/storefront_supabase
dart run build_runner build --delete-conflicting-outputs
dart run slang
dart run flutter_gen_runner
```

### Run

```bash
# Dev flavor (e.g. com.masterfabric.storefrontSupabase.dev on Android)
flutter run --flavor dev -t lib/flavors/main_dev.dart

# Prod flavor
flutter run --flavor prod -t lib/flavors/main_prod.dart
```

### Supabase setup

1. Create a project at [supabase.com](https://supabase.com).
2. Run the SQL in `migrations/supabase_integration.sql` (and any other migrations) in the SQL editor.
3. In `assets/app_config.json`, set:
   - `supabase_configuration.url`
   - `supabase_configuration.anon_key`
4. Enable Auth (email/password) and any Storage buckets your app uses.
5. Configure RLS policies so that `auth.uid()` and your `users` table are aligned.

### ⚙️ Configuration

All main configuration lives in **`assets/app_config.json`**. The app reads it via `AssetConfigHelper()` from the core package.

#### Main sections

| Section | Purpose |
|--------|---------|
| **app_settings** | `app_name`, `app_version`, `environment`, `debug_mode`, `maintenance_mode` |
| **api_configuration** | `base_url`, timeout, retry, logging |
| **supabase_configuration** | `url`, `anon_key` |
| **ui_configuration** | Theme, primary/accent colors, font scale, haptics |
| **feature_flags** | e.g. onboarding, dark mode, offline, analytics opt-out |
| **splash_configuration** | Logo URL, duration, colors, app name on splash |
| **onboarding_configuration** | Pages, style, skip/next labels |
| **auth_configuration** | Sign in / sign up: `app_bar_title`, `welcome_title`, labels, logo URL |
| **navbar_configuration** | Items (Home, Search, Cart, Favorites, Profile), colors, icons |
| **home_view** | App bar, components order, banners, sections |
| **cart_view_configuration** | App bar, refresh, loading overlay, order summary |
| **product_list_configuration** | Grid, filters, sort options |
| **checkout** | Steps, labels, validation |

#### Auth and welcome text

- **App bar title** (Sign In / Sign Up):  
  `auth_configuration.sign_in.app_bar_title`, `auth_configuration.sign_up.app_bar_title`
- **Welcome title** (e.g. "Welcome to Masterfabric S Store"):  
  `auth_configuration.sign_in.welcome_title`, `auth_configuration.sign_up.welcome_title`

#### Navbar

- `navbar_configuration.enabled`, `navbar_configuration.items` (route, text, icon, order_id).
- Profile item can be auth-aware: `authRoute` (e.g. `/profile`) and `guestRoute` (e.g. `/auth`).
- Navbar is hidden only on `/`, `/onboarding`, and `/admin/*`; it is shown on `/auth`, `/home`, `/profile`, etc.

### 📦 Build & Release

#### Android

- **Bundle ID (prod)**: `com.masterfabric.storefrontSupabase`
- **Bundle ID (dev)**: `com.masterfabric.storefrontSupabase.dev`
- **App label**: Set in `android/app/src/main/AndroidManifest.xml` (`android:label`).
- **Signing**: Configure `android/app/build.gradle.kts` signing configs and (e.g.) `masterfabric_store.properties` for release.

#### iOS

- **Bundle ID (prod)**: `com.masterfabric.storefrontSupabase`
- **Bundle ID (dev)**: `com.masterfabric.storefrontSupabase.dev`
- **Display name**: From Xcode project (PRODUCT_NAME) and/or Info.plist.
- **Signing**: Set team and provisioning in Xcode.

```bash
# Example release build (Android)
flutter build apk --flavor prod -t lib/flavors/main_prod.dart

# Example release build (iOS)
flutter build ios --flavor prod -t lib/flavors/main_prod.dart
```

</details>


<details>
<summary>📚 Documentation</summary>

- **Monorepo**: [github.com/masterfabric-mobile/osmea](https://github.com/masterfabric-mobile/osmea)
- **Supabase**: [supabase.com/docs](https://supabase.com/docs)
- **WooCommerce storefront (same monorepo)**: `projects/storefront_woo/README.md`

</details>


<details>
<summary>🤝 Contributing</summary>

1. Fork the repository.
2. Create a feature branch (e.g. `feature/my-feature`).
3. Implement and test your changes.
4. Open a Pull Request with a clear description.

Please follow Dart/Flutter style guidelines and update this README when adding or changing features.

</details>

<br>

<table>
  <tr>
    <td align="center"><img width="200" alt="23:15:21" src="https://github.com/user-attachments/assets/60fd2237-3f86-46a5-8534-e281c86d1900" /></td>
    <td align="center"><img width="200" alt="23:15:26" src="https://github.com/user-attachments/assets/65f1a939-3086-4f93-95fe-f7e7d557bc0a" /></td>
    <td align="center"><img width="200" alt="23:15:32" src="https://github.com/user-attachments/assets/f18b1ad5-25e5-468d-b8f1-1a98c2dfb8a1" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="23:15:37" src="https://github.com/user-attachments/assets/31fc70d6-416c-494e-9777-ce145cf0fbf8" /></td>
    <td align="center"><img width="200" alt="23:16:13" src="https://github.com/user-attachments/assets/0fa548e3-7385-43a8-8fe5-5d8f4628320d" /></td>
    <td align="center"><img width="200" alt="23:16:19" src="https://github.com/user-attachments/assets/71ed0fd9-5fd2-48ab-8444-f5e6f82d5ec5" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="23:16:33" src="https://github.com/user-attachments/assets/640d06df-92c5-4659-9f5f-76f650971e08" /></td>
    <td align="center"><img width="200" alt="23:16:36" src="https://github.com/user-attachments/assets/220a1a81-6650-453f-973d-60082ba82f6f" /></td>
    <td align="center"><img width="200" alt="23:16:47" src="https://github.com/user-attachments/assets/ff39a3ba-eacd-45f2-942a-4a697c35443f" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="23:16:55" src="https://github.com/user-attachments/assets/32542198-8fa3-4cdc-96a7-6ab9a8192980" /></td>
    <td align="center"><img width="200" alt="23:17:44" src="https://github.com/user-attachments/assets/e9d76a9f-3457-418c-9159-d42cc9eb1bbc" /></td>
    <td align="center"><img width="200" alt="23:17:49" src="https://github.com/user-attachments/assets/609b5776-e1cd-4bf4-a7b1-233f81de2479" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="23:17:55" src="https://github.com/user-attachments/assets/85f94d92-f7b3-43f6-ac5e-7883a3e93c30" /></td>
    <td align="center"><img width="200" alt="23:18:04" src="https://github.com/user-attachments/assets/3fb969d8-8cda-4037-b051-7073bdbe70d1" /></td>
    <td align="center"><img width="200" alt="23:18:10" src="https://github.com/user-attachments/assets/336ffbf0-a069-47cd-9b8e-37bf93e2839f" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="23:18:18" src="https://github.com/user-attachments/assets/7d010c3d-46cf-4916-a15e-fea3d1397ac6" /></td>
    <td align="center"><img width="200" alt="23:18:23" src="https://github.com/user-attachments/assets/79645629-2fc9-48c0-90eb-7986aa295a03" /></td>
    <td align="center"><img width="200" alt="23:18:50" src="https://github.com/user-attachments/assets/87233051-cd39-4e0b-8e18-cf3706eec745" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="23:18:54" src="https://github.com/user-attachments/assets/cf421471-df68-462f-b9fb-e986c2f95cd8" /></td>
    <td align="center"><img width="200" alt="23:18:58" src="https://github.com/user-attachments/assets/96dec733-3ce8-4545-b54e-099d0df6b3cf" /></td>
    <td align="center"><img width="200" alt="23:19:05" src="https://github.com/user-attachments/assets/af02699c-4af8-4d49-85f0-5ef7690bec29" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="23:19:10" src="https://github.com/user-attachments/assets/92681daa-e1a5-42d0-8464-6f3c1a82eb0e" /></td>
    <td align="center"><img width="200" alt="23:19:15" src="https://github.com/user-attachments/assets/8919b9e1-6181-452c-bdf9-a4ecc6f2ee02" /></td>
    <td align="center"><img width="200" alt="23:19:25" src="https://github.com/user-attachments/assets/a0eafb7e-d494-43bd-b4ae-61a8edbe3e3f" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="23:20:39" src="https://github.com/user-attachments/assets/1243914f-fc73-4a1d-b348-b75a264a8dd5" /></td>
    <td align="center"><img width="200" alt="23:20:44" src="https://github.com/user-attachments/assets/3175810e-eec7-4b7d-883c-d2e4c3ff4896" /></td>
    <td align="center"><img width="200" alt="23:20:48" src="https://github.com/user-attachments/assets/bdc39595-431e-45f5-985d-c7262104fa18" /></td>
  </tr>
</table>


## 📄 License

This project is licensed under **GNU AGPL v3.0**. See the root `LICENSE` file in the repository.
