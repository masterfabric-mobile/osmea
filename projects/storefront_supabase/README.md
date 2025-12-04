# 🧪 OSMEA Storefront Supabase

<div align="center">

[![Storefront Supabase](https://img.shields.io/badge/Storefront%20Supabase-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C)](https://github.com/masterfabric-mobile/osmea)
[![Version](https://img.shields.io/badge/Version-1.0.0-2D3748?style=for-the-badge&logo=package&logoColor=white&labelColor=1A202C)](pubspec.yaml)
[![Platform](https://img.shields.io/badge/Platform-Flutter-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-2D3748?style=for-the-badge&logo=supabase&logoColor=white&labelColor=1A202C)](https://supabase.com)

</div>

<div align="center">

**"Modern Supabase-powered Storefront App for Mobile"**

[🚀 Getting Started](#-getting-started) • [📚 Documentation](#-documentation) • [🐛 Report Issues](https://github.com/masterfabric-mobile/osmea/issues) • [💬 Discussions](https://github.com/masterfabric-mobile/osmea/discussions)

</div>

---

## 🌟 Overview

**OSMEA Storefront Supabase** is a modern Flutter storefront application built on top of **Supabase**.  
It provides a fast, responsive, and extensible shopping experience targeting iOS, Android and Web with a shared codebase.

### 🎯 **Use Cases**

- **Startups & SMEs** that want a ready-to-extend Supabase-based storefront
- **Agencies** building multiple white-label e-commerce apps
- **Developers** who want a clean architecture Supabase + Flutter example

---

## ✨ Features

### 🛒 **Storefront Features**

- **Product listing & detail pages**
- **Cart & checkout flow (extendable)**
- **User accounts & profiles (via Supabase Auth)**
- **Wishlist / favorites (optional, extendable)**

### 🧱 **Architecture & Dev Features**

- **BLoC state management** with `flutter_bloc`
- **Dependency injection** with `get_it` + `injectable`
- **Routing** using `go_router`
- **Multi-environment flavors** (`dev`, `prod`)
- **Localization (i18n)** with `slang` + `slang_flutter`
- **Generated assets** via `flutter_gen`

---

## 🛠️ Technology Stack

- **Flutter 3.9+**
- **Dart 3.9+**
- **Supabase** as backend (Auth, DB, Storage, etc.)
- **BLoC** for state management
- **GetIt + Injectable** for DI
- **GoRouter** for navigation
- **Slang** for translations
- **Flavor** for environment management

---

## 📁 Project Structure

```bash
projects/storefront_supabase/
├── 📦 lib/
│   ├── app/
│   │   ├── core/
│   │   │   └── config/          # DI & core config
│   │   └── routes/              # App routes
│   ├── flavors/
│   │   ├── main_dev.dart        # Dev flavor entry
│   │   └── main_prod.dart       # Prod flavor entry
│   ├── gen/                     # Generated code (assets, strings, etc.)
│   └── starter.dart             # App starter
├── 📁 assets/
│   └── app_config.json          # Environment & app config
├── 📄 pubspec.yaml              # Dependencies
└── 📖 README.md                 # This file
```

---

## 🚀 Getting Started

### 📋 Prerequisites

- **Flutter SDK** `3.9.0+`
- **Dart SDK** `3.9.0+`
- **Xcode** (for iOS) / **Android Studio** (for Android)
- A **Supabase project** (URL & anon/public key)

### 🔧 Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/masterfabric-mobile/osmea.git
   cd osmea/projects/storefront_supabase
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code (optional but recommended)**

   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   flutter packages pub run slang_build_runner build --delete-conflicting-outputs
   flutter packages pub run flutter_gen_runner
   ```

4. **Run the app**

   ```bash
   # Development flavor
   flutter run --flavor dev -t lib/flavors/main_dev.dart

   # Production flavor
   flutter run --flavor prod -t lib/flavors/main_prod.dart
   ```

---

## 🔧 Configuration

### 🌍 Supabase Configuration

- Configure Supabase **URL** and **anon/public key** inside `assets/app_config.json` for each environment.
- The correct config is selected based on the active flavor (`dev` / `prod`).

### 🎨 Theming & Branding

- Global theme, typography and colors are provided via the shared `core` and `components` packages.
- The architecture is designed to support **multi-store** and **multi-theme** setups.

---

## 📚 Documentation

- Main monorepo documentation: `https://github.com/masterfabric-mobile/osmea`
- Detailed WooCommerce storefront example: `projects/storefront_woo/README.md`
- Supabase docs: `https://supabase.com/docs`

---

## 🤝 Contributing

We happily welcome contributions:

1. **Fork** this repository
2. **Create** a feature branch (e.g. `feature/my-feature`)
3. **Implement & test** your changes
4. **Open** a Pull Request with a clear description

Please:

- Follow standard **Dart/Flutter style guidelines**
- Add tests where it makes sense
- Keep README and other docs **up to date**

---

## 📄 License

This project is licensed under **GNU AGPL v3.0**.  
For full details, see the `LICENSE` file in the repository root.

