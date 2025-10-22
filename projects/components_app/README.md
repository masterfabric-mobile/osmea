# OSMEA Components App 📱

<div align="center">

[![Version](https://img.shields.io/badge/version-1.0.0-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C)](https://github.com/masterfabric-mobile/osmea)
[![Platform](https://img.shields.io/badge/platform-Flutter-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C)](https://dart.dev)
[![Web](https://img.shields.io/badge/Web-2D3748?style=for-the-badge&logo=web&logoColor=white&labelColor=1A202C)](https://web.dev)

</div>

<div align="center">

**"Interactive UI Components Showcase"**

[🚀 Live Demo](https://components.masterfabric.co) • [📚 Documentation](https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components) • [🐛 Report Issues](https://github.com/masterfabric-mobile/osmea/issues)

</div>

---

## 🌟 What is OSMEA Components App?

**OSMEA Components App** is a comprehensive Flutter application that serves as both a showcase and practical reference for the OSMEA Components UI library. It demonstrates how to build modern, and beautiful applications using OSMEA's extensive component library.

### ✨ **Key Features**

- **🔌 Interactive Showcase** - Live examples of all OSMEA components
- **⚡ Real-time Testing** - Test components with different configurations
- **🎨 Modern UI Design** - Beautiful, themed components
- **📱 Cross-Platform** - Works on iOS, Android, and Web
- **🔧 Developer Friendly** - Comprehensive examples and clear code patterns
- **📖 Learning Resource** - Perfect for understanding component usage

---

## 🚀 Live Demo

<div align="center">

> **Experience OSMEA Components in Action**
> 
> 🌐 **[components.masterfabric.co](https://components.masterfabric.co)**
>
> *Interactive playground showcasing all OSMEA components with real-time examples*

</div>

---

## ✨ What's Inside?

### 🎨 **UI Components Showcase**

<table>
<tr>
<td width="50%">

#### **Basic Components**
- 🎯 **Buttons**: Primary, Secondary, Outline, Ghost variants
- 📝 **Text & Typography**: Rich text formatting and headings
- 🏷️ **Badges & Chips**: Status indicators and labels
- 👤 **Avatars**: User profile images with fallbacks
- 📄 **Cards**: Information containers with layouts

#### **Form Components**
- 📝 **Input Fields**: Text fields with validation
- ☑️ **Checkboxes & Radio**: Selection controls
- 🔄 **Switches & Toggles**: Binary state controls
- 📋 **Dropdowns**: Selection menus with search
- 📊 **Steppers**: Multi-step form navigation

</td>
<td width="50%">

#### **Layout Components**
- 📦 **Containers**: Flexible layout containers
- 🔲 **Grid System**: Row, Column, Stack, Wrap
- 📏 **Spacing**: Padding, Margin, Spacer utilities
- 🎯 **Alignment**: Center, Align, Positioned
- 🔧 **Flexible Layouts**: Expanded, Flexible sizing

#### **Navigation Components**
- 📱 **App Bars**: Customizable headers
- 🧭 **Navigation Bars**: Bottom navigation
- 📑 **Tab Bars**: Horizontal tab navigation
- 📄 **Bottom Sheets**: Modal overlays
- 💬 **Popups**: Contextual information

</td>
</tr>
</table>

### 🎨 **Advanced Components**

<table>
<tr>
<td width="50%">

#### **Dynamic Components**
- ⏳ **Loading Indicators**: Spinners and progress bars
- 🍞 **Toast Notifications**: Success, error, info messages
- 📊 **Progress Indicators**: Linear and circular progress
- ⚠️ **Alerts & Dialogs**: Modal confirmations

#### **Interactive Components**
- 🎠 **Carousels**: Image and content sliders
- 🔍 **Search Bars**: Intelligent search with suggestions
- 📝 **Rich Text**: Formatted text with styling
- 📋 **List Items**: Structured list components

</td>
<td width="50%">

#### **Utility Components**
- 🎨 **Color Picker**: Interactive color selection
- 📱 **Device Frame**: Web preview with device frames
- 🔗 **URL Launcher**: External link handling
- 📤 **Share Helper**: Content sharing utilities
- 📁 **File Download**: File download management

</td>
</tr>
</table>

---

## 🛠️ Technology Stack

- **Flutter 3.19+** - Cross-platform UI framework
- **Dart 2.17+** - Type-safe programming language
- **GoRouter** - Declarative routing solution
- **Device Frame** - Device frame for web preview
- **Color Picker** - Interactive color selection
- **URL Launcher** - External link handling
- **Share Plus** - Content sharing utilities

---

## 📁 Project Structure

```bash
projects/components_app/
├── 📦 lib/                          # Source code
│   ├── main.dart                    # Application entry point
│   ├── components/                  # Component examples
│   │   ├── button_example.dart      # Button variants
│   │   ├── text_example.dart        # Text components
│   │   ├── card_example.dart        # Card layouts
│   │   ├── form_examples/           # Form components
│   │   └── ...                      # 50+ component examples
│   ├── screens/                     # Application screens
│   │   ├── main_screen.dart         # Main navigation
│   │   ├── components_screen.dart   # Components showcase
│   │   ├── helpers_screen.dart      # Helper utilities
│   │   └── info_screen.dart         # App information
│   ├── widgets/                     # Reusable UI components
│   │   ├── common_appbar.dart       # Common app bar
│   │   ├── device_frame_wrapper.dart # Device frame
│   │   └── ...                      # Custom widgets
│   ├── services/                    # Business logic
│   │   └── production_auth_service.dart # Authentication
│   ├── routes/                      # Application routing
│   │   └── app_routes.dart          # Route definitions
│   └── constants/                   # App constants
│       ├── app_constants.dart       # General constants
│       └── components_list.dart     # Components registry
├── 🧪 test/                         # Unit and integration tests
├── 🌐 web/                          # Web platform files
├── 📱 android/                      # Android platform files
├── 🍎 ios/                          # iOS platform files
├── 📦 assets/                       # Static assets
│   └── images/                      # Image assets
├── 📄 pubspec.yaml                  # Package dependencies
└── 📖 README.md                     # This file
```

---

## 🚀 Quick Start

### 📋 Prerequisites

- **Flutter SDK** (3.19.0 or higher)
- **Dart SDK** (2.17.0 or higher)
- **Android Studio** or **VS Code** with Flutter extensions
- **Git** for version control

### 📦 Installation

1. **Clone the repository:**

```bash
   git clone https://github.com/masterfabric-mobile/osmea.git
   cd osmea/projects/components_app
```

2. **Install dependencies:**

```bash
   flutter pub get
```

3. **Run the application:**

```bash
   # Run on web (recommended for showcase)
   flutter run -d chrome
   
   # Run on mobile
   flutter run
   
   # Run on specific device
   flutter run -d <device-id>
```

### 🌐 **Web Deployment**

For production deployment:

```bash
# Build for web
flutter build web --release

# Deploy to your hosting service
# The build/web directory contains all static files
```

---

## 💡 Usage Examples

### 🎨 **Basic Component Usage**

```dart
import 'package:osmea_components/osmea_components.dart';

// Simple button
OsmeaComponents.button(
  text: 'Click Me',
  variant: ButtonVariant.primary,
  onPressed: () => print('Button clicked!'),
)

// Text with styling
OsmeaComponents.text(
  'Hello OSMEA!',
  color: OsmeaColors.nordicBlue,
  size: TextSize.large,
  weight: TextWeight.bold,
)

// Card with content
OsmeaComponents.card(
  child: OsmeaComponents.padding(
    padding: context.paddingMedium,
    child: OsmeaComponents.text('Card content'),
  ),
)
```

### 🏗️ **Layout Examples**

```dart
// Responsive column layout
OsmeaComponents.column(
  children: [
    OsmeaComponents.text('Header'),
    OsmeaComponents.spacer(),
    OsmeaComponents.text('Content'),
    OsmeaComponents.sizedBox(height: 16),
    OsmeaComponents.button(text: 'Action'),
  ],
)

// Flexible row layout
OsmeaComponents.row(
  children: [
    OsmeaComponents.expanded(
      child: OsmeaComponents.text('Flexible content'),
    ),
    OsmeaComponents.button(text: 'Fixed button'),
  ],
)
```

### 🎯 **Form Components**

```dart
// Text field with validation
OsmeaComponents.textField(
  controller: _controller,
  label: 'Email',
  variant: TextFieldVariant.outlined,
  type: TextFieldType.email,
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Email is required';
    return null;
  },
)

// Checkbox with label
OsmeaComponents.checkbox(
  value: _isChecked,
  onChanged: (value) => setState(() => _isChecked = value!),
  label: 'I agree to terms',
)
```

---

## 🎨 Customization

### 🎨 **Color System**

OSMEA provides a comprehensive color system:

```dart
// Primary colors
OsmeaColors.nordicBlue    // Primary brand color
OsmeaColors.white         // Pure white
OsmeaColors.black         // Pure black

// Semantic colors
OsmeaColors.green         // Success states
OsmeaColors.red           // Error states
OsmeaColors.orange        // Warning states
OsmeaColors.blue          // Information states

// Neutral colors
OsmeaColors.gray50        // Lightest gray
OsmeaColors.gray100       // Very light gray
// ... up to gray900
```

---

## 🎯 Use Cases

### 👨‍💻 **Developers**
- **Component Testing** - Test components with different configurations
- **Code Examples** - Learn how to use OSMEA components
- **Best Practices** - See modern Flutter development patterns
- **Integration** - Understand component integration

### 🎨 **Designers**
- **UI Exploration** - Explore component variations and themes
- **Design System** - Understand the design system structure
- **Prototyping** - Use components for rapid prototyping
- **Consistency** - Ensure design consistency across projects

### 🎓 **Students & Learners**
- **Flutter Learning** - Learn Flutter through component examples
- **UI Development** - Understand modern UI development
- **Component Library** - Learn how to build component libraries
- **Best Practices** - See production-ready code patterns

---

## 🛠️ Development

### **Code Generation**

```bash
# Generate app icons
flutter packages pub run flutter_launcher_icons:main

# Run tests
flutter test
```

### **Building**

```bash
# Build for web
flutter build web --release

# Build for mobile
flutter build apk --release
flutter build ios --release
```

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### **Development Guidelines**
- **Code Style**: Follow Dart/Flutter conventions
- **Testing**: Write tests for new features
- **Documentation**: Update docs for API changes
- **Commit Messages**: Use conventional commits

### **How to Contribute**
1. **Fork the Repository**
2. **Create a Feature Branch**
3. **Make Your Changes**
4. **Submit a Pull Request**

---

## 📄 License

> 🔐 **License:** GNU AGPL v3.0
> 
> 📜 This project is protected under the **GNU Affero General Public License v3.0**.
>
> 📎 Full details available in the [LICENSE](LICENSE) file.

### 📚 Third-Party Licenses

This project uses the following third-party packages:

#### **Google Maps Flutter**
- **Package:** [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
- **License:** BSD-3-Clause
- **Copyright:** Copyright 2013 The Flutter Authors. All rights reserved.

<details>
<summary>View Full License</summary>

```
Copyright 2013 The Flutter Authors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the following
  disclaimer in the documentation and/or other materials provided
  with the distribution.
* Neither the name of Google Inc. nor the names of its
  contributors may be used to endorse or promote products derived
  from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

</details>

> 📝 **Note:** For a complete list of all third-party dependencies and their licenses, please refer to the `pubspec.yaml` file and run `flutter pub licenses` in your terminal.

---

<div align="center">

**Built with ❤️ by the OSMEA Team**

© 2025 MasterFabric Mobile • Maintained by the OSMEA Engineering Team

[⬆ Back to Top](#osmea-components-app-)

</div>