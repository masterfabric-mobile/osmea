# 📱 OSMEA Components App

<!-- <p align="center">
  <a href="https://apps.apple.com/tr/app/masterfabric-s-store/id6758958857"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" height="40" alt="Download on the App Store" style="vertical-align: middle" /></a>
  &nbsp;
  <a href="https://play.google.com/store/apps/details?id=com.masterfabric.storefrontSupabase"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Google_Play_Store_badge_EN.svg/960px-Google_Play_Store_badge_EN.svg.png" height="40" alt="Get it on Google Play" style="vertical-align: middle" /></a>
</p> -->

<div align="center">
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/Components%20App-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Components App" /></a>
  <a href="pubspec.yaml"><img src="https://img.shields.io/badge/Version-1.0.0-2D3748?style=for-the-badge&logoColor=white&labelColor=1A202C" alt="Version" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Platform-Flutter-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Platform" /></a>
  <a href="https://components.masterfabric.co"><img src="https://img.shields.io/badge/Web-Live%20Demo-2D3748?style=for-the-badge&logo=web&logoColor=white&labelColor=1A202C" alt="Web" /></a>
</div>

<br>

> *Interactive UI Components Showcase for OSMEA Design System*


[Overview](#-overview) • [Features](#-features) • [Tech Stack](#️-technology-stack) • [Getting Started](#-getting-started) • [Documentation](#-documentation) • [Contributing](#-contributing)


<details>
<summary>🌟 Overview</summary>

**OSMEA Components App** is a comprehensive Flutter application that serves as both a showcase and practical reference for the OSMEA UI component library. It demonstrates how to build modern, beautiful applications using OSMEA's extensive component set. Components are provided via the **core** package, which re-exports the OSMEA design system (OsmeaComponents, OsmeaColors, and related utilities).

### 🎯 Use Cases

- **Interactive showcase**: 50+ components in five categories (Layout, Input, Display, Navigation, Feedback) with search and filtering
- **Real-time testing**: Try components with different configurations
- **Reference**: Code examples and patterns for OsmeaComponents and core
- **Web preview**: Device frame (e.g. iPhone 16 Pro Max) on web

### Target Users

- **Developers** integrating or learning the OSMEA component library
- **Designers** exploring the design system and prototyping
- **Students & learners** studying Flutter UI and component-based architecture

</details>


<details>
<summary>✨ Features</summary>

### 🎨 Component Categories

The app organizes components into five tabs with search:

| Category | Examples |
|----------|----------|
| **Layout** | Container, Row, Column, Stack, Wrap, Padding, SizedBox, Spacer, Center, Align, Expanded, Flexible, FittedBox, SingleChildScrollView |
| **Input** | TextField, Checkbox, Radio, Switch, Dropdown, Phone Picker, Searchbar, Stepper |
| **Display** | Text, RichText, Image, ListItem, Divider, Colors (palette), Progress, Loading |
| **Navigation** | AppBar, AppBar with SearchBar, TabBar, BottomSheet, Popup |
| **Feedback** | Toast, Snackbar, Carousel, DotIndicator |

### 🧩 Basic & Utility Components

| Type | Components |
|------|------------|
| **Basic** | Buttons, Text & Typography, Badges & Chips, Avatars, Cards |
| **Helpers** | URL Launcher, File Download, Application Share, Viewer Helper, Sound Dialog, Ticket, Color Picker, Device Frame (web) |

### 🧱 Architecture & Dev

- **State**: StatefulWidget for local UI state; core provides cubits where needed
- **Routing**: go_router with ShellRoute; bottom nav (Login, Components, Info); dynamic `/component/:name`
- **UI**: OsmeaComponents and OsmeaColors from core; web-only DeviceFrame in `DeviceFrameWrapper`
- **Entry**: `main()` → `MasterApp.runBefore()` → `Core().init(GetIt.instance)` → `runApp(MyApp())`

### 🗂 Routes Overview

| Path | Description |
|------|-------------|
| `/splash` | Splash |
| `/intro` | Onboarding |
| `/login` | Login screen (standalone) |
| `/permissions` | Permissions |
| `/` | Home (Login screen inside shell) |
| `/components` | Components showcase (tabs + search) |
| `/helpers` | Helper utilities |
| `/info` | Project information |
| `/component/:name` | Single component detail (e.g. `/component/button`) |

Shell (bottom nav) covers `/`, `/components`, `/helpers`, `/info`.

### 🎨 Colors (OSMEA)

For errors, warnings, and accents use **orange tones** (workspace convention): `OsmeaColors.amberFlame`, `OsmeaColors.sunsetGlow`, `OsmeaColors.goldenHour`, `OsmeaColors.desertSand`. See the Colors component in the app or the core package.

</details>


<details>
<summary>🛠️ Technology Stack</summary>

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter / Dart 2.17+ (SDK `>=2.17.0 <3.0.0`) |
| **UI** | Material Design 3, core (OsmeaComponents, OsmeaColors) |
| **Navigation** | go_router |
| **Local package** | core (`../../packages/core`) – UI kit, MasterApp, helpers, DI |
| **Other** | device_frame (web), flutter_colorpicker, url_launcher, http, intl, flutter_dotenv |

### 📁 Project Structure

```
projects/components_app/
├── lib/
│   ├── main.dart                 # Entry: MasterApp, DeviceFrameWrapper, AppRoutes
│   ├── routes/
│   │   └── app_routes.dart       # GoRouter: splash, intro, login, permissions, shell, component/:name
│   ├── screens/
│   │   ├── main_screen.dart      # ShellRoute + bottom nav (Login, Components, Info)
│   │   ├── components_screen.dart
│   │   ├── helpers_screen.dart
│   │   ├── info_screen.dart
│   │   ├── intro_screen.dart
│   │   ├── login_screen.dart
│   │   ├── permissions_screen.dart
│   │   └── splash_screen.dart
│   ├── components/               # 50+ *_example.dart (button, card, text_field, toast, etc.)
│   ├── widgets/                 # common_appbar, device_frame_wrapper, home_content_widget, etc.
│   ├── constants/               # app_constants.dart, components_list.dart
│   ├── utils/                    # asset_paths, permission_navigation_helper
│   └── services/                 # production_auth_service.dart
├── assets/
│   ├── images/                  # app_icon.png
│   ├── screen_titles.json
│   └── ticket_form_example.json
├── test/
├── web/
├── android/
├── ios/
├── pubspec.yaml
└── README.md
```

</details>


<details>
<summary>🚀 Getting Started</summary>

### Prerequisites

- **Flutter SDK** 2.17.0+
- **Dart SDK** 2.17.0+
- **Android Studio** or **VS Code** with Flutter extensions
- **Git**

### Clone and install

```bash
git clone https://github.com/masterfabric-mobile/osmea.git
cd osmea/projects/components_app
flutter pub get
```

### Run

```bash
# Web (recommended for showcase)
flutter run -d chrome

# Mobile
flutter run

# Specific device
flutter run -d <device-id>
```

### 📦 Build & Release

```bash
# Web
flutter build web --release

# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### App icons (optional)

```bash
flutter pub run flutter_launcher_icons
```

</details>


<details>
<summary>💡 Usage Examples</summary>

Components are used via the **core** package. Import once and use OsmeaComponents, OsmeaColors, and context extensions.

```dart
import 'package:core/core.dart';

// Button
OsmeaComponents.button(
  text: 'Click Me',
  onPressed: () {},
);

// Text with styling
OsmeaComponents.text(
  'Hello OSMEA!',
  variant: OsmeaTextVariant.headlineLarge,
  color: OsmeaColors.nordicBlue,
);

// Card with content
OsmeaComponents.card(
  child: OsmeaComponents.padding(
    padding: context.paddingNormal,
    child: OsmeaComponents.text('Card content'),
  ),
);

// Layout
OsmeaComponents.column(
  children: [
    OsmeaComponents.text('Header'),
    OsmeaComponents.spacer(),
    OsmeaComponents.sizedBox(height: context.spacing12),
    OsmeaComponents.button(text: 'Action', onPressed: () {}),
  ],
);
```

You can also import the UI kit directly: `import 'package:osmea_components/osmea_components.dart';` — the app uses `package:core/core.dart` so that helpers, MasterApp, and the design system are available from one place.

</details>


<details>
<summary>📚 Documentation</summary>

- **Live Demo**: [components.masterfabric.co](https://components.masterfabric.co)
- **Monorepo**: [github.com/masterfabric-mobile/osmea](https://github.com/masterfabric-mobile/osmea)
- **Core package**: `packages/core` in this repo (OsmeaComponents, OsmeaColors, MasterApp)
- **Report issues**: [github.com/masterfabric-mobile/osmea/issues](https://github.com/masterfabric-mobile/osmea/issues)

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
    <td align="center"><img width="200" alt="1" src="https://github.com/user-attachments/assets/163668b9-7261-41ef-a7d0-aab79f6e3a09" /></td>
    <td align="center"><img width="200" alt="2" src="https://github.com/user-attachments/assets/3b6031bd-e196-44cd-a368-cb7d933540a7" /></td>
    <td align="center"><img width="200" alt="3" src="https://github.com/user-attachments/assets/82b96acc-ab17-4003-93aa-d4be674d8412" /></td>
  </tr>
  <tr>
    <td align="center"><img width="200" alt="4" src="https://github.com/user-attachments/assets/8b1bb44b-b90c-4638-8603-0ebd75df529e" /></td>
    <td align="center"><img width="200" alt="5" src="https://github.com/user-attachments/assets/7d49df2e-2488-4128-aa62-98e951b5bd60" /></td>
    <td align="center"><img width="200" alt="6" src="https://github.com/user-attachments/assets/7d040f11-39cb-43d2-8fbd-1ce2ccba84cf" /></td>
  </tr>
</table>


## 📄 License

This project is licensed under **GNU AGPL v3.0**. See the root `LICENSE` file in the repository.



