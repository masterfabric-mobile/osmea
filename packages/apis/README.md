# 🌐 OSMEA APIs

<div align="center">
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/OSMEA%20APIs-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="OSMEA APIs" /></a>
  <a href="https://pub.dev/packages/dio"><img src="https://img.shields.io/badge/Dio%205.7-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="Dio" /></a>
  <a href="https://pub.dev/packages/retrofit"><img src="https://img.shields.io/badge/Retrofit-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="Retrofit" /></a>
  <a href="https://pub.dev/packages/get_it"><img src="https://img.shields.io/badge/GetIt-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="GetIt" /></a>
  <a href="https://pub.dev/packages/injectable"><img src="https://img.shields.io/badge/Injectable-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="Injectable" /></a>
</div>

<br>

> *Comprehensive Flutter API integration package for WooCommerce & Shopify*


[Overview](#-overview) • [Features](#-features) • [Tech Stack](#️-technology-stack) • [Getting Started](#-getting-started) • [API Reference](#-api-reference) • [Project Structure](#-project-structure)


<details>
<summary>🌟 Overview</summary>

**OSMEA APIs** is a powerful network layer package built for Flutter e-commerce applications.  
It unifies WooCommerce REST API, Shopify REST & GraphQL API, and custom user management endpoints under a single, consistent interface.

### 🎯 **Use Cases**

- **WooCommerce Stores** — Full CRUD support via Admin API and Store API
- **Shopify Integration** — Product, order, and customer management via REST and GraphQL
- **Cross-Platform** — Single codebase for iOS, Android, and Web (SQLite3 / SharedPreferences)
- **Authentication** — JWT-based WooCommerce auth flow
- **Wizard Setup** — Step-by-step store connection wizard

### Target Users

- **Flutter developers** building WooCommerce or Shopify-based applications
- **Agencies** working on projects that require multi-store management
- **Open-source contributors** looking to extend the API layer

</details>


<details>
<summary>✨ Features</summary>

### 🛍️ **WooCommerce Admin API**

| Module | Operations |
|--------|------------|
| **Coupons** | Create, update, delete, list, batch update |
| **Customers** | Full customer CRUD, batch update |
| **Orders** | Order management, notes, refunds |
| **Products** | Products, variations, attributes, tags, categories, brands |
| **Payment Gateways** | List and update payment methods |
| **Shipping Zones & Methods** | Manage shipping zones and methods |
| **Taxes** | Tax rates and tax classes management |
| **Reports** | Sales, customer, and stock reports |
| **Settings** | Store settings, groups, and options |
| **System Status** | System status and tools |
| **Webhooks** | Webhook CRUD and batch update |

### 🛒 **WooCommerce Store API**

| Module | Operations |
|--------|------------|
| **Cart** | Create/retrieve cart, update customer, select shipping rate |
| **Cart Items** | Add, update, remove items |
| **Cart Coupons** | Add, retrieve, list coupons |
| **Checkout** | Update checkout data, create order and process payment |
| **Orders** | List user orders |
| **Products** | List products, retrieve by slug, list variations |
| **Categories / Brands / Tags** | Browse categories, brands, and tags |
| **Attributes** | Product attributes and attribute terms |
| **Reviews** | List product reviews |
| **Collection Data** | Collection dataset |

### 🔵 **Shopify REST API**

| Module | Operations |
|--------|------------|
| **Products** | Products, variants, images, collections |
| **Orders** | Orders, fulfillments, transactions |
| **Customers** | Customer management, addresses |
| **Discounts** | Discount codes and price rules |
| **Inventory** | Inventory levels and locations |
| **Smart Collections** | Smart collection management |
| **Billing / Gift Card** | Billing and gift card management |
| **Webhooks / Events** | Event and webhook management |

### 🟣 **Shopify GraphQL API**

| Module | Operations |
|--------|------------|
| **Products** | GraphQL queries and mutations |
| **Customers** | Customer queries |
| **Services** | Service layer |
| **Webhooks** | GraphQL webhooks |

### 👤 **WooCommerce Auth & Users Manager**

- **JWT Auth** — Sign in, sign up, password reset, password update, account deletion
- **Users Manager** — Profile CRUD, address management, metadata, statistics, activity, orders, contracts
- **Wishlist** — Create/update/delete wishlist groups, add/remove products

### 🔧 **Infrastructure**

- **DI** — `get_it` + `injectable` with code generation support
- **HTTP Client** — Type-safe API calls via `dio` + `retrofit`
- **Interceptors** — JWT token, WooCommerce cart token, default interceptor
- **Logging** — Colorful request/response logging via `logger`
- **Storage** — SQLite3 for mobile, SharedPreferences for web
- **Freezed Models** — All request/response models generated with `freezed`

</details>


<details>
<summary>🛠️ Technology Stack</summary>

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter / Dart 3.5+ |
| **HTTP Client** | Dio 5.7 |
| **REST Codegen** | Retrofit 4.1 |
| **DI** | GetIt 8 + Injectable 2.7 |
| **Models** | Freezed 2.4 + json_serializable |
| **GraphQL** | graphql / graphql_flutter 5.1 |
| **Storage (mobile)** | sqflite 2.4 |
| **Storage (web)** | shared_preferences 2.5 |
| **Logging** | logger 2.5 |

### 📁 Project Structure

```
packages/apis/
├── lib/
│   ├── apis.dart                        # Main barrel export
│   ├── di/
│   │   └── config/
│   │       ├── config_di.dart           # GetIt setup
│   │       └── config_di.config.dart    # Injectable generated code
│   ├── dio_config/
│   │   ├── cookie_manager/
│   │   │   └── web_cookie_manager.dart
│   │   ├── dio_client/
│   │   │   ├── api_dio_client.dart      # Main Dio client
│   │   │   ├── shopify_graphql_client.dart
│   │   │   └── abstract/
│   │   │       └── api_base_client.dart
│   │   ├── dio_logger/
│   │   │   ├── api_dio_logger.dart
│   │   │   └── abstract/
│   │   ├── interceptors/
│   │   │   ├── api_interceptor_default.dart
│   │   │   ├── woo_cart_token_interceptor.dart
│   │   │   └── woo_jwt_interceptor.dart
│   ├── models/
│   │   ├── store_configuration.dart
│   │   ├── auth/
│   │   │   └── woo_jwt_token.dart
│   │   └── cart/
│   │       └── woo_cart_token.dart
│   ├── network/
│   │   └── remote/
│   │       ├── shopify/
│   │       │   ├── graphql/             # GraphQL schema + queries
│   │       │   └── rest/                # 15 REST modules
│   │       └── woocommerce/
│   │           ├── admin_api/           # 13 admin modules
│   │           ├── auth/                # JWT auth
│   │           ├── store_api/           # 15 store modules
│   │           ├── users_manager/       # User management
│   │           └── wishlist/            # Wishlist
│   ├── services/
│   │   ├── cross_platform_storage.dart  # SQLite3 / SharedPreferences
│   │   ├── store_change_notifier.dart
│   │   ├── store_management_service.dart
│   │   ├── wizard_helper.dart
│   │   └── auth/
│   │       ├── woo_auth_manager.dart
│   │       ├── woo_jwt_auth_service.dart
│   │       └── woo_jwt_signin_manager.dart
│   └── utils/
│       ├── api_error_utils.dart
│       └── cart_token_utils.dart
├── build.yaml                           # Build configuration
├── codegen.yaml                         # Code generation configuration
└── pubspec.yaml
```

</details>


<details>
<summary>🚀 Getting Started</summary>

### Prerequisites

- **Flutter SDK** 3.5.0+
- **Dart SDK** 3.5.0+
- A WooCommerce or Shopify store (Consumer Key / API Key)

### Add the Package

```yaml
# pubspec.yaml
dependencies:
  apis:
    path: ../../packages/apis   # monorepo local usage
```

### Install Dependencies

```bash
flutter pub get
```

### Code Generation

```bash
# Retrofit + Injectable + Freezed
dart run build_runner build --delete-conflicting-outputs
```

### DI Setup

```dart
import 'package:apis/di/config/config_di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(MyApp());
}
```

### Store Configuration

```dart
// Configure WooCommerce connection
final storeConfig = StoreConfiguration(
  baseUrl: 'https://your-store.com',
  consumerKey: 'ck_xxxx',
  consumerSecret: 'cs_xxxx',
);

await getIt<StoreManagementService>().configure(storeConfig);
```

</details>


<details>
<summary>📖 API Reference</summary>

### 🛒 WooCommerce Store API — Usage Examples

```dart
// List products
final productService = getIt<ProductService>();
final products = await productService.listAllProducts(page: 1, perPage: 20);

// Add item to cart
final cartService = getIt<CartService>();
await cartService.addItem(AddItemRequest(id: 42, quantity: 1));

// Create order and process payment
final checkoutService = getIt<CheckoutOrderService>();
await checkoutService.processPaymentAndOrder(
  ProcessPaymentAndOrderRequestModel(
    paymentMethod: 'stripe',
    billing: billingAddress,
  ),
);
```

### 🔐 WooCommerce Auth — Usage Examples

```dart
// Sign in
final authService = getIt<WooJwtAuthService>();
final token = await authService.login(
  UserLoginRequest(username: 'user@mail.com', password: '****'),
);

// Get user profile
final usersService = getIt<OsmeaUsersManagerService>();
final profile = await usersService.getUserProfile(userId: 1);
```

### 🔵 Shopify REST — Usage Examples

```dart
// List products
final shopifyProducts = getIt<ShopifyProductsRestService>();
final result = await shopifyProducts.listProducts(limit: 50);
```

### Interceptor Overview

| Interceptor | Responsibility |
|-------------|----------------|
| `ApiInterceptorDefault` | General header management and error handling |
| `WooJwtInterceptor` | Attaches JWT token to every request |
| `WooCartTokenInterceptor` | Manages WooCommerce Store API cart nonce |

</details>


<details>
<summary>⚙️ Configuration</summary>

### Freezed Model Structure

All request and response models are generated with `freezed` + `json_serializable`:

```dart
// Example: AddItemRequest
@freezed
class AddItemRequest with _$AddItemRequest {
  const factory AddItemRequest({
    required int id,
    required int quantity,
    Map<String, dynamic>? variation,
  }) = _AddItemRequest;

  factory AddItemRequest.fromJson(Map<String, dynamic> json) =>
      _$AddItemRequestFromJson(json);
}
```

### Cross-Platform Storage

| Platform | Storage |
|----------|---------|
| iOS / Android | `sqflite` (SQLite3) |
| Web | `shared_preferences` |

```dart
final storage = getIt<CrossPlatformStorage>();
await storage.save(key: 'cart_token', value: token);
final saved = await storage.read(key: 'cart_token');
```

### Build Configuration

```bash
# build.yaml — Retrofit + Injectable code generation
dart run build_runner build

# Regenerate while deleting conflicting outputs
dart run build_runner build --delete-conflicting-outputs
```

</details>


---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/new-endpoint`)
3. Make your changes and test them
4. **Open a Pull Request**

### Development Guidelines

- Follow the `abstract/` → `api/` → `freezed_model/` structure for every new endpoint
- All models must use `freezed`
- Commit the generated `*.g.dart` and `*.freezed.dart` files after running `build_runner`
- Use Conventional Commits

---

## 📄 License

> 🔐 **License:** GNU AGPL v3.0  
> 📜 This project is protected under the **GNU Affero General Public License v3.0**.

---

<div align="center">

**Built with ❤️ by the OSMEA Team**

© 2025 MasterFabric Mobile • Maintained by the OSMEA Engineering Team

</div>