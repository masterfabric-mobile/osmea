# 📖 OSMEA Storybook

<div align="center">
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/Storybook-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Storybook" /></a>
  <a href="pubspec.yaml"><img src="https://img.shields.io/badge/Version-1.0.0-2D3748?style=for-the-badge&logoColor=white&labelColor=1A202C" alt="Version" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter%202.17+-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart%202.17+-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="Dart" /></a>
  <a href="https://storybook.js.org"><img src="https://img.shields.io/badge/Components-41-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="41 Components" /></a>
</div>

<br>

> *Interactive component documentation and playground for the OSMEA design system*


[Overview](#-overview) • [Features](#-features) • [Tech Stack](#️-technology-stack) • [Getting Started](#-getting-started) • [Project Structure](#-project-structure)


<details>
<summary>🌟 Overview</summary>

**OSMEA Storybook** is an interactive documentation and testing environment for all 41 components in the OSMEA UI kit. Built with `storybook_flutter` and `device_frame`, it provides a comprehensive playground to explore, test, and develop components in isolation.

### 🎯 **Use Cases**

- **Component exploration** — Browse all 41 OSMEA components with live demos
- **Interactive testing** — Test components with different props and states
- **Device preview** — See how components look on different device frames
- **Developer documentation** — Living docs with code examples and usage guidelines
- **Design system** — Centralized component library and design tokens

### Target Users

- **Flutter developers** working with the OSMEA component library
- **UI/UX designers** exploring the design system and component variants
- **QA testers** verifying component behavior across different scenarios
- **Product teams** showcasing component capabilities

</details>


<details>
<summary>✨ Features</summary>

### 📚 **Component Documentation**

| Category | Components |
|----------|------------|
| **Layout** | Align, Column, Row, Stack, Padding, SizedBox, Spacer, ClipRRect |
| **Buttons & Actions** | Button (5 variants), Checkbox, Radio Button, Switch Button, Counter |
| **Cards & Content** | Cards, Avatar, Badge, Chips, Rich Text, Ticket Widget |
| **Form & Input** | Text Field, Dropdown, Search Bar |
| **Navigation** | AppBar, Navbar, TabBar, Bottom Sheet, Stepper |
| **Feedback** | Loading, Progress, Toast, Snackbar, Popup |
| **Interactive** | Carousel, Collapse, Divider |

### 🎮 **Interactive Features**

| Feature | Description |
|---------|-------------|
| **Live Controls** | Real-time property adjustment with knobs |
| **Device Frames** | Mobile, tablet, desktop preview modes |
| **Component Isolation** | Test components independently |
| **Theme Switching** | Light/dark theme toggle |
| **Color Picker** | Interactive color selection |
| **Typography Guide** | Complete text style documentation |

### 🏗️ **Development Tools**

| Tool | Description |
|------|-------------|
| **Component Templates** | Auto-generate new component stories |
| **Structure Validator** | Ensure consistent story organization |
| **Component Registry** | Centralized component management |
| **Story Config** | Unified configuration system |

</details>


<details>
<summary>🛠️ Technology Stack</summary>

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 2.17+ / Dart 2.17+ |
| **Storybook** | storybook_flutter 0.14 |
| **Device Preview** | device_frame 1.3 |
| **State Management** | provider 6.0 |
| **UI Components** | osmea_components (local package) |
| **Color Picker** | flutter_colorpicker 1.1 |
| **URL Launcher** | url_launcher 6.3 |
| **Internationalization** | intl 0.20 |

### 📁 Project Structure

```
projects/storybook/
├── lib/
│   ├── main.dart                        # Storybook entry point
│   ├── components/                      # 41 component stories
│   │   ├── align_storybook/
│   │   │   ├── aligns.dart              # Component story
│   │   │   ├── data/                    # Test data
│   │   │   ├── sections/                # Demo sections
│   │   │   ├── showcase/                # Live demos
│   │   │   ├── utils/                   # Helper functions
│   │   │   └── widgets/                 # Story widgets
│   │   ├── appbar_storybook/
│   │   ├── avatar_storybook/
│   │   ├── badge_storybook/
│   │   ├── bottom_sheet_storybook/
│   │   ├── button_storybook/
│   │   ├── cards_storybook/
│   │   ├── carousel_storybook/
│   │   ├── checkbox_storybook/
│   │   ├── chips_storybook/
│   │   ├── clip_r_rect_storybook/
│   │   ├── collapse_storybook/
│   │   ├── column_storybook/
│   │   ├── container_storybook/
│   │   ├── counter_storybook/
│   │   ├── divider_storybook/
│   │   ├── dropdown_storybook/
│   │   ├── footer_storybook/
│   │   ├── image_storybook/
│   │   ├── list_item_storybook/
│   │   ├── loading_storybook/
│   │   ├── navbar_storybook/
│   │   ├── padding_storybook/
│   │   ├── popup_storybook/
│   │   ├── progress_storybook/
│   │   ├── radio_button_storybook/
│   │   ├── rich_text_storybook/
│   │   ├── row_storybook/
│   │   ├── searchbar_storybook/
│   │   ├── sized_box_storybook/
│   │   ├── snackbar_storybook/
│   │   ├── spacer_storybook/
│   │   ├── stack_storybook/
│   │   ├── stepper_storybook/
│   │   ├── switch_button_storybook/
│   │   ├── tabbar_storybook/
│   │   ├── text_field_storybook/
│   │   ├── text_storybook/
│   │   ├── ticket_storybook/
│   │   ├── toast_storybook/
│   │   └── wrap_storybook/
│   ├── config/                          # Storybook configuration
│   │   ├── component_registry.dart      # Register all components
│   │   ├── config.dart                  # App configuration
│   │   ├── device_frame_config.dart     # Device frame setup
│   │   ├── story_config.dart            # Story configuration
│   │   ├── storybook_app.dart           # Main app setup
│   │   └── storybook_theme_plugin.dart  # Theme plugin
│   ├── pages/                           # Documentation pages
│   │   ├── colors_page.dart             # Color system guide
│   │   ├── home_page.dart               # Overview page
│   │   └── typography_page.dart         # Typography guide
│   └── _templates/                      # Development templates
│       ├── create_component_structure.sh # Auto-generate stories
│       ├── storybook_validator.dart     # Validate story structure
│       ├── README.md                    # Template usage guide
│       └── component_template/          # Story template files
└── web/
    ├── index.html                       # Web entry
    ├── manifest.json                    # PWA manifest
    └── icons/                           # App icons
```

</details>


<details>
<summary>🚀 Getting Started</summary>

### Prerequisites

- **Flutter SDK** 2.17.0+
- **Dart SDK** 2.17.0+
- Completed setup of `packages/osmea_components`

### Install Dependencies

```bash
cd projects/storybook
flutter pub get
```

### Run Storybook

```bash
# Web (recommended)
flutter run -d chrome

# Mobile device
flutter run

# Specific device
flutter run -d <device-id>
```

### Access Features

The storybook opens with three main sections:

- **Overview/Home Page** — Component library introduction
- **Overview/Typography** — Text styles and typography guide
- **Overview/Colors** — Color system documentation
- **Components/** — 41 individual component stories with device frames

</details>


<details>
<summary>💡 Usage Examples</summary>

### Creating New Component Stories

```bash
cd lib/_templates
./create_component_structure.sh my_new_component
```

This creates:
```
lib/components/my_new_component_storybook/
├── my_new_components.dart      # Main story file
├── data/                       # Test data
├── sections/                   # Demo sections  
├── showcase/                   # Live demos
├── utils/                      # Helper functions
└── widgets/                    # Story widgets
```

### Component Story Structure

```dart
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:osmea_components/osmea_components.dart';

class ButtonStoryComponent {
  static List<Story> getStories() {
    return [
      Story(
        name: 'Default',
        description: 'Basic button implementation',
        builder: (context) => Container(
          padding: const EdgeInsets.all(16),
          child: OsmeaButton(
            label: context.knobs.text(
              label: 'Text',
              initial: 'Click me',
            ),
            variant: context.knobs.options(
              label: 'Variant',
              initial: ButtonVariant.primary,
              options: ButtonVariant.values,
            ),
            onPressed: () {},
          ),
        ),
      ),
    ];
  }
}
```

### Device Frame Usage

Components automatically appear in device frames. The main app config handles this:

```dart
wrapperBuilder: (context, child) {
  final currentStoryName = context.read<StoryNotifier>().currentStoryName;
  
  if (currentStoryName?.startsWith('Overview/') == true) {
    return child ?? Container(); // No frame for overview pages
  } else {
    return DeviceFrameWrapper(child: child); // Frame for components
  }
},
```

### Validating Stories

```bash
cd lib/_templates
dart storybook_validator.dart
```

This validates:
- Required folder structure (`data/`, `sections/`, `showcase/`, `utils/`, `widgets/`)
- Main dart file exists and follows naming convention
- Component registration in `component_registry.dart`

</details>


<details>
<summary>🤝 Contributing</summary>

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/new-component-story`)
3. Use the template script: `./create_component_structure.sh <component_name>`
4. Add your component story files
5. Register in `component_registry.dart`
6. Run `dart storybook_validator.dart` to validate
7. **Open a Pull Request**

### Guidelines

- Every component story must have the complete folder structure (`data/`, `sections/`, `showcase/`, `utils/`, `widgets/`)
- Use knobs for interactive properties
- Include multiple story variants for different use cases
- Follow the naming convention: `ComponentNameStoryComponent.getStories()`
- Update component registry when adding new stories

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
