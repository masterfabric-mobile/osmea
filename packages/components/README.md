# OSMEA Components 🧩

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/masterfabric-mobile/osmea)
[![License](https://img.shields.io/github/license/masterfabric-mobile/osmea?color=red&label=AGPLv3)](https://github.com/masterfabric-mobile/osmea/blob/dev/LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Flutter-blue)](https://flutter.dev)
[![Material Design 3](https://img.shields.io/badge/Material%20Design-3-6750A4)](https://m3.material.io/)

A comprehensive Flutter UI Kit for e-commerce applications with a complete design tokens system. OSMEA Components provides a robust collection of customizable, accessible, and production-ready UI components following Material Design 3 principles.

## ✨ Features

- **🎨 Comprehensive UI Kit** - 40+ production-ready components covering all e-commerce needs
- **🎭 Material Design 3** - Modern design system with dynamic theming support
- **🌙 Dark/Light Themes** - Built-in support for light and dark themes
- **📱 Responsive Design** - Components adapt to different screen sizes and orientations
- **♿ Accessibility First** - WCAG compliant with comprehensive accessibility features
- **🔧 Highly Customizable** - Extensive configuration options and style extensions
- **🧩 Modular Architecture** - Import only what you need for optimal bundle size
- **📚 Storybook Integration** - Interactive component documentation and testing
- **🚀 BLoC State Management** - Reactive state management with flutter_bloc
- **🎯 Type Safety** - Full TypeScript-like safety with Dart's type system

## 🏗️ Project Structure

```
packages/components/
├── lib/
│   ├── osmea_components.dart          # Main entry point
│   └── src/
│       ├── components/                # UI Components
│       │   ├── appbar/               # App bars and navigation
│       │   ├── avatar/               # User avatars and profile pictures
│       │   ├── badge/                # Notification badges and indicators
│       │   ├── bottom_sheet/         # Modal bottom sheets (S, M, L)
│       │   ├── buttons/              # Various button types and styles
│       │   ├── cards/                # Content cards and containers
│       │   ├── carousel/             # Image and content carousels
│       │   ├── checkbox/             # Checkbox form inputs
│       │   ├── chips/                # Selection and filter chips
│       │   ├── divider/              # Content dividers and separators
│       │   ├── list_item/            # List items and layouts
│       │   ├── loading/              # Loading indicators and progress
│       │   ├── navbar/               # Navigation bars
│       │   ├── popup/                # Popups and overlays
│       │   ├── progress/             # Progress bars and indicators
│       │   ├── radio_button/         # Radio button inputs
│       │   ├── searchbar/            # Search inputs and filters
│       │   ├── stepper/              # Step-by-step navigation
│       │   ├── switch_button/        # Toggle switches
│       │   ├── text_field/           # Text inputs and forms
│       │   ├── toast/                # Toast notifications
│       │   ├── ticket_widget/        # E-commerce ticket components
│       │   └── ...                   # Layout and utility components
│       ├── core/                     # Core functionality
│       │   └── cubit_button/         # Shared button state management
│       ├── enums/                    # Type definitions and enums
│       ├── styles/                   # Design tokens
│       │   ├── colors.dart           # Color system and palettes
│       │   └── text_style.dart       # Typography system
│       ├── theme/                    # Theme configuration
│       └── utils/                    # Extension utilities
│           ├── *_extensions.dart     # Component-specific extensions
│           └── sizer_extensions.dart # Responsive design utilities
├── example_mobile/                   # Mobile app example
├── example_storybook/               # Storybook documentation
│   └── lib/storybook_test/          # Interactive component showcase
└── test/                            # Unit and widget tests
```

## 🚀 Getting Started

### 1. Installation

Add this to your package's `pubspec.yaml`:

```yaml
dependencies:
  osmea_components:
    path: packages/components  # For local development
    # git:                     # For git dependency
    #   url: https://github.com/masterfabric-mobile/osmea
    #   path: packages/components
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Import and Use

```dart
import 'package:osmea_components/osmea_components.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My E-commerce App',
      theme: OsmeaTheme.lightTheme,
      darkTheme: OsmeaTheme.darkTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OsmeaScaffold(
      appBar: OsmeaAppBar(
        title: 'OSMEA Components Demo',
      ),
      body: Column(
        children: [
          OsmeaButton(
            text: 'Primary Button',
            onPressed: () => print('Button pressed'),
          ),
          OsmeaTextField(
            label: 'Email',
            hint: 'Enter your email',
          ),
          OsmeaBadge(
            text: 'New',
            variant: BadgeVariant.primary,
          ),
        ],
      ),
    );
  }
}
```

### 4. Run Examples

Explore the components with our interactive examples:

```bash
# Mobile app example
cd example_mobile
flutter run

# Storybook documentation
cd example_storybook
flutter run -d web
```

### 5. Run Tests

```bash
flutter test
```

## ⚙️ Configuration

### Theme Customization

OSMEA Components supports extensive theming through the design token system:

```dart
// Custom theme configuration
final customTheme = OsmeaTheme.lightTheme.copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.light,
  ),
);

MaterialApp(
  theme: customTheme,
  // ...
);
```

### Component Customization

Each component offers extensive customization options:

```dart
// Button customization
OsmeaButton(
  text: 'Custom Button',
  variant: ButtonVariant.secondary,
  size: ButtonSize.large,
  shape: ButtonShape.rounded,
  iconPosition: IconPosition.leading,
  icon: Icons.shopping_cart,
  onPressed: () {},
)

// Text field with validation
OsmeaTextField(
  label: 'Product Name',
  hint: 'Enter product name',
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
  prefixIcon: Icons.shopping_bag,
  size: TextFieldSize.large,
)
```

### Design Tokens

Access the complete design token system:

```dart
// Colors
final primaryColor = OsmeaColors.nordicBlue;
final errorColor = OsmeaColors.amberFlame;

// Typography
final headingStyle = OsmeaTextStyles.heading1;
final bodyStyle = OsmeaTextStyles.body1;

// Spacing (using sizer extensions)
final spacing = context.width16; // Responsive spacing
```

## 🎨 Available Components

### Navigation & Layout
- **OsmeaAppBar** - Customizable app bars with actions and theming
- **OsmeaNavbar** - Bottom navigation with badge support
- **OsmeaScaffold** - Enhanced scaffold with consistent styling

### Form & Input
- **OsmeaTextField** - Text inputs with validation and styling
- **OTPTextField** - One-time password input fields
- **OsmeaCheckbox** - Styled checkbox inputs
- **OsmeaRadioButton** - Radio button groups
- **OsmeaSwitchButton** - Toggle switches
- **OsmeaSearchbar** - Search inputs with suggestions

### Content & Display
- **OsmeaButton** - Various button types and styles
- **OsmeaBadge** - Notification badges and status indicators
- **OsmeaAvatar** - User profile pictures and placeholders
- **OsmeaCards** - Content cards and containers
- **OsmeaChips** - Selection and filter chips
- **OsmeaCarousel** - Image and content carousels
- **OsmeaListItem** - Structured list items

### Feedback & Overlay
- **OsmeaToast** - Toast notifications and messages
- **OsmeaBottomSheet** - Modal bottom sheets in multiple sizes
- **OsmeaPopup** - Popups and overlay components
- **OsmeaLoading** - Loading indicators and progress bars
- **OsmeaProgress** - Progress indicators and steppers

### Utility & Layout
- **OsmeaDivider** - Content dividers and separators
- **OsmeaStepper** - Step-by-step navigation
- **TicketWidget** - E-commerce specific ticket components

## 📖 Documentation

### Interactive Storybook

Explore all components interactively in our Storybook:

```bash
cd example_storybook
flutter run -d web
```

The Storybook includes:
- Live component previews
- Interactive property controls
- Usage examples and code snippets
- Accessibility testing tools
- Design token documentation

### API Documentation

Generate API documentation:

```bash
dart doc .
open doc/api/index.html
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Structure

- **Unit Tests** - Component logic and state management
- **Widget Tests** - Component rendering and interactions
- **Integration Tests** - Complete user workflows
- **Golden Tests** - Visual regression testing

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](../../CONTRIBUTING.md) for details.

### Development Workflow

1. **Fork** the repository
2. **Create** a feature branch
3. **Follow** our component checklist:
   - [ ] Follows Material Design 3 guidelines
   - [ ] Responsive across different screen sizes
   - [ ] Supports light and dark themes
   - [ ] Includes accessibility features
   - [ ] Has comprehensive documentation
   - [ ] Includes usage examples
   - [ ] Has unit and widget tests
4. **Submit** a pull request

### Component Development

When adding new components:

```bash
# Use our component template generator
cd example_storybook/lib/storybook_test/_templates
./create_component_structure.sh YourComponent
```

### Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful component and property names
- Include comprehensive documentation
- Add usage examples for complex components

## 📱 Examples & Demos

### Mobile App Example
Complete e-commerce mobile app showcasing all components:
- Product listing and details
- Shopping cart and checkout
- User authentication
- Search and filtering

### Storybook Documentation
Interactive component library with:
- Component playground
- Property controls
- Code examples
- Accessibility testing

## 🔧 Advanced Usage

### Custom Component Creation

Extend OSMEA Components for your specific needs:

```dart
class CustomProductCard extends StatelessWidget {
  const CustomProductCard({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OsmeaCards(
      variant: CardVariant.elevated,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          OsmeaAvatar(
            size: AvatarSize.large,
            imageUrl: product.imageUrl,
          ),
          context.height8, // Responsive spacing
          
          // Product title
          OsmeaText(
            product.title,
            style: OsmeaTextStyles.subtitle1,
          ),
          
          // Price badge
          OsmeaBadge(
            text: '\$${product.price}',
            variant: BadgeVariant.success,
          ),
        ],
      ),
    );
  }
}
```

### State Management Integration

Components work seamlessly with BLoC pattern:

```dart
class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return OsmeaLoading(type: LoadingType.spinner);
        }
        
        if (state is ProductError) {
          return OsmeaToast.error(message: state.message);
        }
        
        return ListView.builder(
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            return CustomProductCard(
              product: state.products[index],
              onTap: () => _navigateToProduct(state.products[index]),
            );
          },
        );
      },
    );
  }
}
```

## 📄 License

This project is licensed under the GNU Affero General Public License v3.0 - see the [LICENSE](../../LICENSE) file for details.

## 🙏 Acknowledgments

- **Material Design 3** - Design system and guidelines
- **Flutter Team** - Amazing framework and tools
- **Contributors** - Everyone who helps improve OSMEA Components

---

<div align="center">

**Built with ❤️ by the OSMEA Team**

[🌟 Star us on GitHub](https://github.com/masterfabric-mobile/osmea) • [📚 Documentation](https://github.com/masterfabric-mobile/osmea/tree/dev/docs) • [🐛 Report Issues](https://github.com/masterfabric-mobile/osmea/issues)

</div>