# 📦 OSMEA Packages

<div align="center">
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/OSMEA%20Packages-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="OSMEA Packages" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter%203.0+-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart%203.6+-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="Dart" /></a>
  <a href="https://bloclibrary.dev"><img src="https://img.shields.io/badge/BLoC%209.1-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="BLoC" /></a>
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/Packages-3-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="3 Packages" /></a>
</div>

<br>

> *Modular Flutter packages powering the entire OSMEA monorepo — UI kit, shared architecture, and API integrations*


[Overview](#-overview) • [Packages](#-available-packages) • [Architecture](#️-architecture) • [Getting Started](#-getting-started) • [Usage Examples](#-usage-examples)


<details>
<summary>🌟 Overview</summary>

The **OSMEA Packages** directory contains the three shared libraries used by every project in the monorepo. Each package is independently versioned, has its own `pubspec.yaml`, and is referenced via local path dependencies.

### 🎯 **Package Responsibilities**

| Package | Responsibility |
|---------|---------------|
| [`osmea_components`](components/) | 55+ production-ready Flutter UI widgets and the OSMEA design system |
| [`core`](core/) | Base architecture, config-driven views, Firebase integration, and 20+ utility helpers |
| [`apis`](apis/) | WooCommerce and Shopify REST/GraphQL API integration layer |

### Dependency Graph

```
Your Project
  ├── osmea_components  ──▶  core
  └── apis              ──▶  core
```

`core` is the foundation — it has no internal package dependencies.  
Both `osmea_components` and `apis` depend on `core`.

</details>


<details>
<summary>📦 Available Packages</summary>

### 🎨 osmea_components — UI Kit

**55+ production-ready Flutter widgets** for e-commerce storefronts and admin dashboards.

| Category | Components |
|----------|------------|
| **Layout** | Scaffold, Container, Column, Row, Stack, Wrap, Align, Padding, SizedBox, Spacer, FittedBox, ClipRRect, SingleChildScrollView |
| **Buttons & Actions** | Button (5 variants), Login Button, Switch Button, Checkbox, Radio Button, Counter |
| **Cards & Content** | Cards (5 variants), List Item, Ticket Widget, Rich Text, Image, Avatar, Badge, Chips |
| **Form & Input** | Text Field, OTP Text Field, Dropdown, Phone Picker, Location Picker, Searchbar, AppBar Searchbar |
| **Navigation** | AppBar, Navbar, TabBar, Stepper, Dot Indicator, Footer |
| **Overlays & Feedback** | Bottom Sheet, Popup, Sound Dialog, Toast, Snackbar, Loading |
| **Interactive** | Carousel, Collapse, Progress, Divider |

📖 [Full components documentation →](components/README.md)

---

### 🔧 core — Foundation Package

**Shared architecture and utilities** used by all OSMEA projects.

| Area | What's included |
|------|----------------|
| **Base Architecture** | `BaseViewModelCubit`, `BaseViewBloc`, `BaseViewHydratedCubit`, `MasterApp`, `MasterView` |
| **Config-Driven Views** | Splash, Onboarding, Auth, Loading, Error, Empty, Search, Image Detail (all via `app_config.json`) |
| **Firebase** | `firebase_analytics`, `firebase_core`, `firebase_remote_config` |
| **Localization** | Slang 4.11 — type-safe i18n, `assets/i18n/strings_en.i18n.json` → `gen/strings.g.dart` |
| **Helpers** | 20+ helpers: storage, permissions, device info, notifications, URL launcher, web viewer, share, logger, remote config… |
| **DI** | `injectable` + `get_it` — all services registered and auto-generated |
| **Routing** | `go_router` 15.1 with centralized `routes.dart` |

📖 [Full core documentation →](core/README.md)

---

### 🌐 apis — API Integration

**WooCommerce + Shopify REST/GraphQL** network layer built with Dio and Retrofit.

| Platform | Modules |
|----------|---------|
| **WooCommerce Admin** | Products, Orders, Customers, Coupons, Reports, Settings, Refunds, Shipping, Taxes, Reviews, Webhooks, Media, Analytics, Variations |
| **WooCommerce Store** | Cart, Checkout, Categories, Tags, Attributes, Shipping Zones, Payment Gateways, System Status, Wishlist, Auth (JWT) |
| **WooCommerce Auth** | JWT sign-in, token validation, user management |
| **Shopify REST** | Products, Orders, Customers, Collections, Discounts, Shipping, Inventory, Metafields, Refunds, Transactions, Fulfillments + 4 more |
| **Shopify GraphQL** | Storefront queries, mutations, fragments, subscriptions |

📖 [Full APIs documentation →](apis/README.md)

</details>


<details>
<summary>🏗️ Architecture</summary>

### Package Layer Diagram

```
┌─────────────────────────────────────────────────┐
│                  Your Project                   │
│  (storefront_woo / storefront_supabase / admin) │
└────────────┬──────────────────┬─────────────────┘
             │                  │
    ┌────────▼───────┐  ┌───────▼──────┐
    │osmea_components│  │     apis     │
    │  (UI Kit)      │  │ (API Layer)  │
    └────────┬───────┘  └───────┬──────┘
             │                  │
             └────────┬─────────┘
                      │
              ┌───────▼──────┐
              │     core     │
              │ (Foundation) │
              └──────────────┘
```

### Design Principles

- **`app_config.json` driven** — All pre-built views in `core` are controlled by a single JSON config file; no code changes required for UI customization
- **BLoC everywhere** — State management via `flutter_bloc` + `hydrated_bloc` across all packages
- **Injectable DI** — Every service is registered with `@injectable`; run `build_runner` to regenerate
- **Barrel exports** — Each package exposes a single entry point (`osmea_components.dart`, `core.dart`, `apis.dart`)
- **Slang i18n** — Type-safe localization with compile-time key checking

</details>


<details>
<summary>🚀 Getting Started</summary>

### Prerequisites

- **Flutter SDK** 3.0.0+
- **Dart SDK** 3.6.0+

### Add to your project

```yaml
# pubspec.yaml
dependencies:
  osmea_components:
    path: ../../packages/components

  core:
    path: ../../packages/core

  apis:
    path: ../../packages/apis
```

### Install & generate

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Initialize in `main.dart`

```dart
import 'package:core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Dependency injection
  await configureDependencies();

  // Localization
  LocaleSettings.useDeviceLocale();

  runApp(TranslationProvider(child: const MyApp()));
}
```

### Apply the theme

```dart
import 'package:osmea_components/osmea_components.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: OsmeaTheme.lightTheme,
      home: const HomeView(),
    );
  }
}
```

</details>


<details>
<summary>💡 Usage Examples</summary>

### View with BLoC (core)

```dart
class ProductsView extends BaseViewModelCubit<ProductsCubit, ProductsState> {
  const ProductsView({super.key});

  @override
  Widget buildView(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) => state.when(
        loading: () => const LoadingView(),
        success: (products) => ProductGrid(products: products),
        error: (msg) => ErrorHandlingView(message: msg),
      ),
    );
  }

  @override
  void onInit(BuildContext context) => cubit(context).loadProducts();
}
```

### UI Components (osmea_components)

```dart
// Button
OsmeaButton(
  label: 'Add to Cart',
  variant: ButtonVariant.primary,
  onPressed: () {},
),

// Product card
OsmeaCard(
  variant: CardVariant.elevated,
  imageUrl: product.imageUrl,
  title: product.name,
  subtitle: '\$\${product.price}',
  onTap: () => navigateToProduct(product.id),
),

// OTP field
OsmeaOtpTextField(
  length: 6,
  onCompleted: (pin) => verifyOtp(pin),
),
```

### API call (apis)

```dart
final repo = getIt<WooAdminProductsRepository>();

final products = await repo.getProducts(
  page: 1,
  perPage: 20,
  status: 'publish',
);
```

### Load app config (core)

```dart
final config = await AssetConfigHelper.loadConfig();

final splashTarget = config.splashConfiguration.navigationTarget; // "/onboarding"
final supportedLangs = config.localizationConfiguration.supportedLanguages;
```

</details>


<details>
<summary>🤝 Contributing</summary>

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/my-feature`)
3. Make your changes inside the relevant package
4. Run `dart run build_runner build` if you added any `@injectable` classes
5. Export new symbols from the package barrel file
6. **Open a Pull Request**

### Guidelines

- Each new component in `osmea_components` needs a matching enum file and extension file
- Each new helper in `core` needs an abstract class and `@injectable` registration
- Each new API module in `apis` needs a Retrofit abstract + Freezed models
- Use Conventional Commits
- Run `flutter test` before submitting

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
