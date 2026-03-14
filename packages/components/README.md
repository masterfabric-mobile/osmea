# 🎨 OSMEA Components

<div align="center">
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/OSMEA%20Components-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="OSMEA Components" /></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter%203.0+-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="Flutter" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart%202.17+-2D3748?style=for-the-badge&logo=dart&logoColor=white&labelColor=1A202C" alt="Dart" /></a>
  <a href="https://pub.dev/packages/flutter_bloc"><img src="https://img.shields.io/badge/BLoC-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="BLoC" /></a>
  <a href="https://github.com/masterfabric-mobile/osmea"><img src="https://img.shields.io/badge/Components-55+-2D3748?style=for-the-badge&logo=flutter&logoColor=white&labelColor=1A202C" alt="55+ Components" /></a>
</div>

<br>

> *55+ production-ready Flutter UI components for e-commerce applications*


[Overview](#-overview) • [Components](#-components) • [Tech Stack](#️-technology-stack) • [Getting Started](#-getting-started) • [Usage Examples](#-usage-examples) • [Project Structure](#-project-structure)


<details>
<summary>🌟 Overview</summary>

**OSMEA Components** is the official UI kit package of the OSMEA design system.  
It provides 55+ production-ready, fully customizable Flutter widgets built with a consistent API, design tokens, BLoC-powered interactivity, and comprehensive enum-driven variants.

### 🎯 **Use Cases**

- **E-commerce Storefronts** — Product cards, carousels, cart UI, checkout forms, badges
- **Admin Dashboards** — Data tables, progress indicators, collapse panels, steppers
- **Auth Screens** — Text fields, OTP input, login buttons, phone picker
- **Navigation** — AppBar, Navbar, TabBar, Searchbar, AppBar Searchbar
- **Design System** — Shared theme, colors, text styles, and extension utilities

### Target Users

- **Flutter developers** building on top of the OSMEA monorepo
- **Product teams** that need a consistent, themeable component library
- **Contributors** extending the OSMEA design system with new components

</details>


<details>
<summary>✨ Components</summary>

### 🧱 **Layout & Structure**

| Component | Description |
|-----------|-------------|
| **Scaffold** | Page-level layout with app bar and body slots |
| **Container** | Flexible box with padding, margin, decoration |
| **Column / Row** | Vertical and horizontal flex layouts |
| **Stack / Positioned** | Overlapping widget layers |
| **Wrap** | Flow layout that wraps children |
| **Expanded / Flexible** | Flex children sizing |
| **Align / Center** | Alignment utilities |
| **Padding / SizedBox / Spacer** | Spacing and dimension helpers |
| **FittedBox / ClipRRect** | Scaling and clipping utilities |
| **SingleChildScrollView** | Scrollable single-child container |

### 🔘 **Buttons & Actions**

| Component | Description |
|-----------|-------------|
| **Button** | Primary, secondary, outlined, text, destructive variants |
| **Text Button** | Lightweight inline action button |
| **Login Button** | Pre-styled social / auth login button |
| **Switch Button** | Binary toggle with size variants |
| **Checkbox** | Multi-select toggle with size variants |
| **Radio Button** | Single-select with size variants |
| **Counter** | Increment/decrement quantity control |

### 🃏 **Cards & Content**

| Component | Description |
|-----------|-------------|
| **Cards** | Basic, image, list, elevated, outlined card variants |
| **List Item** | Row-based list tile with leading/trailing slots |
| **Ticket Widget** | Coupon/ticket-shaped card with notch effect |
| **Rich Text** | Mixed-style inline text spans |
| **Image** | Network/asset image with fit, placeholder, error states |
| **Avatar** | Circular user or brand avatar |
| **Badge** | Notification dot or label overlay |
| **Chips** | Selectable filter and tag chips |

### 📝 **Form & Input**

| Component | Description |
|-----------|-------------|
| **Text Field** | Input with label, prefix/suffix, validation |
| **OTP Text Field** | One-time password multi-box input |
| **Dropdown** | Single-select dropdown with search |
| **Phone Picker** | Country flag + phone number input |
| **Location Picker** | Address / location selection field |
| **Searchbar** | Search input with clear and submit actions |
| **AppBar Searchbar** | Inline search embedded in app bar |

### 🧭 **Navigation**

| Component | Description |
|-----------|-------------|
| **AppBar** | Top navigation bar with title, leading, actions |
| **Navbar** | Bottom navigation bar with icon + label items |
| **TabBar** | Tab container and tab row with scroll support |
| **Stepper** | Step-by-step progress flow |
| **Dot Indicator** | Page/carousel position dots |
| **Footer** | Page footer with configurable content |

### 🎭 **Overlays & Feedback**

| Component | Description |
|-----------|-------------|
| **Bottom Sheet** | Modal and persistent slide-up panel |
| **Popup** | Modal dialog with configurable actions |
| **Sound Dialog** | Alert dialog with audio feedback variant |
| **Toast** | Non-blocking temporary message |
| **Snackbar** | Bottom-anchored notification bar |
| **Loading** | Spinner, skeleton, and overlay loaders |

### 🎠 **Interactive & Display**

| Component | Description |
|-----------|-------------|
| **Carousel** | Auto-play / swipeable image or widget slider |
| **Collapse** | Expandable/collapsible content panel |
| **Progress** | Linear and circular progress indicators |
| **Divider** | Horizontal and vertical separator |

</details>


<details>
<summary>🛠️ Technology Stack</summary>

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter 3.0+ / Dart 2.17+ |
| **State Management** | flutter_bloc 9.1 + BLoC 9.0 |
| **Internationalization** | intl 0.20 |
| **URL Handling** | url_launcher 6.3 |
| **Equality** | equatable 2.0 |
| **Design Tokens** | Custom color system (`colors.dart`) |
| **Typography** | Custom text styles (`text_style.dart`) |
| **Theming** | `OsmeaTheme` via `theme.dart` |
| **Extensions** | 40+ extension files in `utils/` |

### 📁 Project Structure

```
packages/components/
├── lib/
│   ├── osmea_components.dart          # Main barrel export
│   └── src/
│       ├── components.dart            # Components barrel
│       ├── components/                # 55+ component implementations
│       │   ├── align/
│       │   ├── appbar/
│       │   ├── appbar_searchbar/
│       │   ├── avatar/
│       │   ├── badge/
│       │   ├── bottom_sheet/
│       │   ├── buttons/
│       │   │   ├── button.dart
│       │   │   └── text_button.dart
│       │   ├── cards/
│       │   │   └── cards.dart
│       │   ├── carousel/
│       │   ├── checkbox/
│       │   ├── chips/
│       │   ├── collapse/
│       │   ├── counter/
│       │   ├── divider/
│       │   ├── dot_indicator/
│       │   ├── dropdown/
│       │   ├── footer/
│       │   ├── image/
│       │   ├── list_item/
│       │   ├── loading/
│       │   ├── location_picker/
│       │   ├── login_button/
│       │   ├── navbar/
│       │   ├── phone_picker/
│       │   ├── popup/
│       │   ├── progress/
│       │   ├── radio_button/
│       │   ├── rich_text/
│       │   ├── scaffold/
│       │   ├── searchbar/
│       │   ├── snackbar/
│       │   ├── sound_dialog/
│       │   ├── stepper/
│       │   ├── switch_button/
│       │   ├── tabbar/
│       │   ├── text/
│       │   ├── text_field/
│       │   │   ├── text_field.dart
│       │   │   ├── otp_text_field.dart
│       │   │   ├── controllers/
│       │   │   └── cubit/
│       │   ├── ticket_widget/
│       │   └── toast/
│       ├── core/                      # Base widget classes & cubit_button
│       │   ├── abstract/
│       │   ├── cubit_button/
│       │   └── *_widget.dart          # Core layout widgets
│       ├── enums/                     # Variant & state enums (per component)
│       ├── styles/
│       │   ├── colors.dart            # Design token color palette
│       │   └── text_style.dart        # Typography scale
│       ├── theme/
│       │   └── theme.dart             # OsmeaTheme
│       └── utils/                     # 40+ extension files
│           ├── sizer_extensions.dart
│           ├── theme_extensions.dart
│           └── *_extensions.dart
└── assets/
    └── flags/                         # Country flag assets for PhonePicker
```

</details>


<details>
<summary>🚀 Getting Started</summary>

### Prerequisites

- **Flutter SDK** 3.0.0+
- **Dart SDK** 2.17.0+

### Add the Package

```yaml
# pubspec.yaml
dependencies:
  osmea_components:
    path: ../../packages/components   # monorepo local usage
```

### Install Dependencies

```bash
flutter pub get
```

### Apply the Theme

```dart
import 'package:osmea_components/osmea_components.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: OsmeaTheme.lightTheme,
      home: const MyHomePage(),
    );
  }
}
```

</details>


<details>
<summary>💡 Usage Examples</summary>

### Button Variants

```dart
// Primary button
OsmeaButton(
  label: 'Add to Cart',
  variant: ButtonVariant.primary,
  size: ButtonSize.large,
  onPressed: () {},
),

// Outlined button
OsmeaButton(
  label: 'View Details',
  variant: ButtonVariant.outlined,
  size: ButtonSize.medium,
  onPressed: () {},
),
```

### Text Field & OTP Input

```dart
// Standard text field
OsmeaTextField(
  label: 'Email Address',
  keyboardType: TextInputType.emailAddress,
  prefixIcon: const Icon(Icons.email_outlined),
  onChanged: (value) {},
),

// OTP input
OsmeaOtpTextField(
  length: 6,
  onCompleted: (pin) => verifyOtp(pin),
),
```

### Product Card

```dart
OsmeaCard(
  variant: CardVariant.elevated,
  imageUrl: product.imageUrl,
  title: product.name,
  subtitle: '\$${product.price}',
  badge: product.isOnSale
    ? OsmeaBadge(label: 'SALE', variant: BadgeVariant.danger)
    : null,
  onTap: () => navigateToProduct(product.id),
),
```

### Carousel

```dart
OsmeaCarousel(
  items: banners.map((b) => OsmeaImage(url: b.imageUrl)).toList(),
  autoPlay: true,
  autoPlayInterval: const Duration(seconds: 3),
  indicatorVariant: DotIndicatorVariant.circle,
),
```

### Bottom Sheet

```dart
OsmeaBottomSheet.show(
  context,
  variant: BottomSheetVariant.modal,
  title: 'Select Size',
  child: SizePickerWidget(),
),
```

### Collapse Panel

```dart
OsmeaCollapse(
  title: 'Product Description',
  variant: CollapseVariant.bordered,
  child: Text(product.description),
),
```

### Chips

```dart
OsmeaChips(
  items: categories.map((c) => ChipItem(label: c.name)).toList(),
  variant: ChipsVariant.filter,
  onSelected: (selected) => filterByCategory(selected),
),
```

### Phone Picker

```dart
OsmeaPhonePicker(
  onChanged: (phone) => setState(() => _phone = phone),
  defaultCountryCode: 'TR',
),
```

</details>


<details>
<summary>⚙️ Design System</summary>

### Color Tokens

All colors are defined as design tokens in `styles/colors.dart` and exposed via `OsmeaTheme`:

```dart
// Access theme colors
context.osmeaColors.primary
context.osmeaColors.surface
context.osmeaColors.onPrimary
context.osmeaColors.error
```

### Typography Scale

Text styles are defined in `styles/text_style.dart`:

```dart
OsmeaText(
  'Section Title',
  variant: TextVariant.titleLarge,
),

OsmeaText(
  'Body paragraph content',
  variant: TextVariant.bodyMedium,
),
```

### Sizer Extensions

Responsive sizing utilities from `utils/sizer_extensions.dart`:

```dart
// Responsive width/height
SizedBox(width: 200.w, height: 48.h),

// Spacing shorthand
16.verticalSpace,
12.horizontalSpace,
```

### Enum-Driven Variants

Every component exposes strongly typed enums for variants, sizes, and states:

```dart
// Button
ButtonVariant.primary | secondary | outlined | text | destructive
ButtonSize.small | medium | large

// Badge
BadgeVariant.primary | success | warning | danger | info

// Loading
LoadingVariant.spinner | skeleton | overlay

// Stepper
StepperVariant.horizontal | vertical
```

</details>


---

<details>
<summary>🤝 Contributing</summary>

We welcome contributions! Here's how you can help:

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/new-component`)
3. Add your component under `lib/src/components/<name>/`
4. Add the corresponding enum file under `lib/src/enums/`
5. Add the extension file under `lib/src/utils/`
6. Export it from `lib/src/components.dart`
7. **Open a Pull Request**

### Development Guidelines

- Every component must have a corresponding enum file for its variants and sizes
- Use `abstract/` base classes from `core/` where applicable
- BLoC-powered components must use the `cubit_button` pattern from `core/`
- Follow the existing naming convention: `osmea_<component_name>.dart`
- Use Conventional Commits

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