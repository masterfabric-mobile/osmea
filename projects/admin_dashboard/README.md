# 🎛️ OSMEA Admin Dashboard

<div align="center">
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/Admin%20Dashboard-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Admin Dashboard" /></a>
  <a href="pubspec.yaml"><img src="https://img.shields.io/badge/Version-1.0.0-2D3748?style=for-the-badge&logoColor=white&labelColor=1A202C" alt="Version" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter%203.7+-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart%203.7+-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="Dart" /></a>
  <a href="https://bloclibrary.dev"><img src="https://img.shields.io/badge/BLoC%209.1-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="BLoC" /></a>
</div>

<br>

> *Modern e-commerce admin dashboard for managing products, orders, and analytics*


[Overview](#-overview) • [Features](#-features) • [Tech Stack](#️-technology-stack) • [Getting Started](#-getting-started) • [Project Structure](#-project-structure)


<details>
<summary>🌟 Overview</summary>

**OSMEA Admin Dashboard** is a Flutter application designed for e-commerce administrators to manage products, orders, customers, and analytics. Built on the shared `core` and `apis` packages, it provides a scalable, modular admin experience for iOS, Android, and Web.

### 🎯 **Use Cases**

- **Product management** — Add, edit, delete, categorize products
- **Order processing** — View, track, and fulfill orders
- **Analytics dashboard** — Real-time metrics and KPIs
- **Customer management** — Customer profiles and order history
- **Multi-environment** — `dev` and `prod` flavors with separate bundle IDs

### Target Users

- **E-commerce operators** managing an OSMEA-powered storefront
- **Business admins** who need a mobile-friendly back-office app
- **Developers** looking for a clean Flutter + BLoC admin reference

</details>


<details>
<summary>✨ Features</summary>

### 🎛️ **Dashboard**

| Feature | Description |
|---------|-------------|
| **Analytics overview** | Key metrics, charts, revenue, orders, customers |
| **Real-time data** | Live updates from WooCommerce / Shopify via `apis` |
| **Quick actions** | Shortcuts to recent orders, low-stock products |

### 📦 **Product Management**

| Feature | Description |
|---------|-------------|
| **Product list** | Paginated grid/list with search and filters |
| **Add / Edit product** | Title, description, images, variants, categories, brands |
| **Inventory** | Stock levels, low-stock alerts |
| **Categories & brands** | CRUD for taxonomies |

### 🛒 **Order Management**

| Feature | Description |
|---------|-------------|
| **Order list** | Status filters (pending, processing, shipped, completed) |
| **Order detail** | Line items, shipping, payment, customer info |
| **Fulfillment** | Update status, add tracking, print packing slip |
| **Refunds** | Process partial or full refunds |

### 👥 **Customer Management**

| Feature | Description |
|---------|-------------|
| **Customer list** | Search, filter by spend, orders |
| **Customer profile** | Order history, addresses, notes |

### ⚙️ **Settings & Auth**

| Feature | Description |
|---------|-------------|
| **Admin auth** | Secure login with JWT via `apis` |
| **Role-based access** | Admin vs editor permissions |
| **Multi-language** | English (base) via Slang i18n |
| **Theme** | Light / dark mode support |

</details>


<details>
<summary>🛠️ Technology Stack</summary>

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.7+ / Dart 3.7+ |
| **State Management** | flutter_bloc 9.1 |
| **DI** | get_it 7.7 + injectable 2.5 |
| **Routing** | go_router 15.1 |
| **Localization** | slang 4.7 + slang_flutter 4.7 |
| **Environment** | flavor 2.0 (`dev` / `prod`) |
| **Assets** | flutter_gen 5.10 (typed asset refs) |
| **Local Packages** | `core` (shared foundation) + `apis` (network layer) |

### 📁 Project Structure

```
projects/admin_dashboard/
├── lib/
│   ├── starter.dart                     # App entry widget
│   ├── app/
│   │   ├── routes/
│   │   │   └── app_routes.dart          # GoRouter config
│   │   └── views/
│   │       ├── view_splash/             # Splash screen
│   │       ├── view_onboarding/         # Onboarding flow
│   │       └── view_welcome/            # Welcome / home screen
│   ├── core/
│   │   ├── config/
│   │   │   ├── config_di.dart           # Injectable setup
│   │   │   └── config_di.config.dart    # Generated DI
│   │   ├── constants/
│   │   │   └── text_constants.dart
│   │   └── resources/
│   │       ├── resources.g.dart         # Slang generated (all locales)
│   │       └── resources_en.g.dart      # Slang generated (English)
│   ├── flavors/
│   │   ├── main_dev.dart                # Dev entry point
│   │   └── main_prod.dart               # Prod entry point
│   └── gen/
│       ├── assets.gen.dart              # flutter_gen assets
│       ├── strings.g.dart               # Slang strings
│       └── strings_en.g.dart
├── assets/
│   ├── i18n/
│   │   └── resources_en.i18n.json       # English translations
│   └── images/
├── android/                             # Android platform
├── ios/                                 # iOS platform
├── slang.yaml                           # Slang config
└── pubspec.yaml
```

</details>


<details>
<summary>🚀 Getting Started</summary>

### Prerequisites

- **Flutter SDK** 3.7.0+
- **Dart SDK** 3.7.0+
- Completed setup of `packages/core` and `packages/apis`

### Install Dependencies

```bash
cd projects/admin_dashboard
flutter pub get
```

### Code Generation

```bash
# DI + Slang + flutter_gen
dart run build_runner build --delete-conflicting-outputs
```

### Run the App

```bash
# Development flavor
flutter run --flavor dev -t lib/flavors/main_dev.dart

# Production flavor
flutter run --flavor prod -t lib/flavors/main_prod.dart
```

### Initialize in `main_dev.dart`

```dart
import 'package:flutter/material.dart';
import 'package:admin_dashboard/core/config/config_di.dart';
import 'package:admin_dashboard/starter.dart';
import 'package:flavor/flavor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set flavor
  Flavor.init(Environment.dev);

  // DI
  await configureDependencies();

  runApp(const AdminDashboardApp());
}
```

</details>


<details>
<summary>💡 Usage Examples</summary>

### Routes (go_router)

```dart
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashView(
        arguments: {"title": "Splash"},
        currentView: MasterViewTypes.content,
      ),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingView(
        arguments: {"title": "Onboarding"},
        currentView: MasterViewTypes.content,
      ),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => WelcomeView(
        arguments: {"title": "Welcome"},
        currentView: MasterViewTypes.content,
      ),
    ),
  ],
);
```

### Using core & apis

```dart
import 'package:core/core.dart';
import 'package:apis/apis.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final WooAdminOrdersRepository _ordersRepo;

  DashboardCubit(this._ordersRepo) : super(DashboardLoading());

  Future<void> loadMetrics() async {
    final orders = await _ordersRepo.getOrders(page: 1, perPage: 50);
    final revenue = orders.fold<double>(0, (sum, o) => sum + o.total);
    emit(DashboardLoaded(orderCount: orders.length, revenue: revenue));
  }
}
```

### Localization (Slang)

```dart
// assets/i18n/resources_en.i18n.json
{
  "dashboard": "Dashboard",
  "products": "Products",
  "orders": "Orders"
}

// In widget
Text(context.resource.dashboard)
```

</details>


<details>
<summary>🤝 Contributing</summary>

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/admin-charts`)
3. Add your views under `lib/app/views/`
4. Register routes in `app_routes.dart`
5. Run `build_runner` if you add `@injectable` classes
6. **Open a Pull Request**

### Guidelines

- Views extend `MasterView` from `core`
- BLoC classes extend `BaseViewModelCubit` or `BaseViewBloc`
- Use Slang for all user-facing strings
- Use Conventional Commits
- Run `flutter analyze` before submitting

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
