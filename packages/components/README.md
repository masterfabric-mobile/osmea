# 🧩 OSMEA Components

<div align="center">

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/masterfabric-mobile/osmea)
[![Platform](https://img.shields.io/badge/Platform-Flutter-blue)](https://flutter.dev)
[![License](https://img.shields.io/github/license/masterfabric-mobile/osmea?color=red&label=AGPLv3)](https://github.com/masterfabric-mobile/osmea/blob/dev/LICENSE)

**OSMEA UI Kit for e-commerce applications with design tokens system**

</div>

---

## 🌟 Package Introduction

The OSMEA Components package provides a comprehensive collection of reusable Flutter UI components specifically designed for e-commerce applications. Built with a design tokens system and state management in mind, this package offers:

- 🎨 **Consistent Design System** - Unified styling with design tokens
- 🛍️ **E-commerce Focus** - Components tailored for shopping experiences
- 🔄 **State Management** - Built-in Cubit/Bloc integration for complex components
- 📱 **Responsive Design** - Optimized for mobile-first development
- 🎯 **Production Ready** - Battle-tested components with comprehensive validation
- 🧩 **Modular Architecture** - Import only what you need

---

## 📁 Directory Structure

```
packages/components/
├── lib/
│   ├── osmea_components.dart           # Main export file
│   └── src/
│       ├── components/                 # UI Components
│       │   ├── appbar/                # App bars and headers
│       │   ├── buttons/               # Button variants
│       │   ├── cards/                 # Card components
│       │   ├── navbar/                # Navigation components
│       │   ├── text_field/            # Input components
│       │   ├── ticket_widget/         # Dynamic form generator
│       │   └── ... (40+ components)
│       ├── core/                      # Core functionality
│       ├── enums/                     # Component enums
│       ├── styles/                    # Design tokens & styles
│       ├── theme/                     # Theme configuration
│       └── utils/                     # Extension methods & utilities
├── example_mobile/                     # Example mobile app
├── example_storybook/                  # Storybook documentation
├── pubspec.yaml                        # Package configuration
└── README.md                           # This file
```

---

## 🧩 Available Components

### 📱 Navigation & Layout
- **AppBar** - Customizable app bars with actions
- **NavBar** - Bottom navigation with badges
- **Scaffold** - Page structure with consistent styling
- **Container** - Enhanced containers with design tokens
- **Stack**, **Row**, **Column** - Layout primitives

### 🔘 Form Elements
- **TextField** - Advanced text inputs with validation
- **Radio Button** - Single selection controls
- **Checkbox** - Multiple selection controls
- **Switch Button** - Toggle controls
- **SearchBar** - Search input with suggestions

### 🎮 Interactive Components
- **Buttons** - Primary, secondary, and specialized buttons
- **Chips** - Selection and filter chips
- **Progress** - Loading and progress indicators
- **Stepper** - Step-by-step navigation
- **Carousel** - Image and content carousels

### 🎨 Display Components
- **Avatar** - User profile images with fallbacks
- **Badge** - Notification and status badges
- **Cards** - Content containers with shadows
- **Divider** - Section separators
- **Toast** - Notification messages

### 🎫 Advanced Components
- **Ticket Widget** - Dynamic form generator from JSON
- **Bottom Sheet** - Modal bottom sheets
- **Popup** - Custom popup dialogs
- **Loading** - Various loading states
- **Rich Text** - Formatted text with spans

---

## 🎯 Component Guidelines

### ✅ Best Practices

- **Import Specifically**: Import only the components you need
  ```dart
  import 'package:osmea_components/osmea_components.dart';
  ```

- **Use Design Tokens**: Leverage the built-in theme system
  ```dart
  // Good: Use theme colors
  color: Theme.of(context).primaryColor
  
  // Avoid: Hardcoded colors
  color: Colors.blue
  ```

- **State Management**: Use provided Cubits for complex components
  ```dart
  BlocProvider(
    create: (context) => TextFieldCubit(),
    child: CustomTextField(...),
  )
  ```

- **Responsive Design**: Utilize built-in responsive utilities
  ```dart
  // Use size extensions
  width: context.screenWidth * 0.8,
  ```

### 🚫 Common Pitfalls

- Don't override theme properties directly on components
- Avoid mixing design systems (stick to OSMEA tokens)
- Don't bypass state management for stateful components
- Avoid hardcoding dimensions (use responsive utilities)

---

## 🚀 Usage Examples

### Basic Button Implementation

```dart
import 'package:osmea_components/osmea_components.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'OSMEA Components',
        showBackButton: true,
      ),
      body: Column(
        children: [
          PrimaryButton(
            text: 'Shop Now',
            onPressed: () => Navigator.push(...),
            size: ButtonSize.large,
          ),
          SecondaryButton(
            text: 'View Details',
            onPressed: () => showDetails(),
          ),
        ],
      ),
    );
  }
}
```

### Advanced Form with Validation

```dart
class CheckoutForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextFieldCubit(),
      child: Column(
        children: [
          CustomTextField(
            label: 'Email Address',
            validationMode: ValidationMode.email,
            isRequired: true,
          ),
          CustomTextField(
            label: 'Phone Number',
            validationMode: ValidationMode.phone,
            isRequired: true,
          ),
          PrimaryButton(
            text: 'Continue',
            onPressed: () => _submitForm(context),
          ),
        ],
      ),
    );
  }
}
```

### Dynamic Ticket Form

```dart
class SupportTicket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TicketWidget(
      config: TicketFormConfig.fromJson(formConfiguration),
      onSubmit: (response) async {
        await submitTicket(response);
        Navigator.pop(context);
      },
      onSaveDraft: (response) => saveDraft(response),
      theme: TicketTheme.fromContext(context),
    );
  }
}
```

---

## 🛠️ Development Guidelines

### For Contributors

1. **Component Structure**: Follow the modular component template
   ```
   component_name/
   ├── component_name.dart          # Main component
   ├── cubit/                       # State management (if needed)
   ├── models/                      # Data models
   └── widgets/                     # Sub-components
   ```

2. **Testing**: Ensure comprehensive test coverage
   ```bash
   # Run tests for components
   flutter test
   ```

3. **Documentation**: Use the Storybook for component documentation
   ```bash
   # See example_storybook/ for documentation examples
   ```

### Adding New Components

1. Create component in appropriate category folder
2. Export in `osmea_components.dart`
3. Add to Storybook documentation
4. Write comprehensive tests
5. Update this README if needed

---

## 📚 Related Links

- **[Example Mobile App](example_mobile/)** - Complete mobile app implementation
- **[Storybook Documentation](example_storybook/)** - Interactive component gallery
- **[Component Templates](example_storybook/lib/storybook_test/_templates/)** - Development templates
- **[Main OSMEA Repository](../../)** - Complete project documentation
- **[Ticket Widget Guide](lib/src/components/ticket_widget/README.md)** - Advanced form component

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](../../CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md).

### Quick Start for Developers

```bash
# Clone the repository
git clone https://github.com/masterfabric-mobile/osmea.git

# Navigate to components package
cd osmea/packages/components

# Install dependencies
flutter pub get

# Run example app
cd example_mobile && flutter run

# Or run storybook
cd ../example_storybook && flutter run -d web
```

---

<div align="center">

**Built with ❤️ by the OSMEA Team**

[🌟 Star us on GitHub](https://github.com/masterfabric-mobile/osmea) • [📚 Documentation](https://github.com/masterfabric-mobile/osmea/tree/dev/docs) • [🐛 Report Issues](https://github.com/masterfabric-mobile/osmea/issues)

</div>