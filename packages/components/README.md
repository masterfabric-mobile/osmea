# 🌟 OSMEA Components

A comprehensive Flutter UI component library designed for e-commerce applications with a modern design tokens system. This package provides a complete set of reusable, customizable, and accessible components that follow Material Design 3 principles while maintaining the flexibility for custom styling.

## 📦 Package Overview

**osmea_components** is the core UI component library for the OSMEA (Open Source Mobile E-commerce Application) ecosystem. It provides developers with:

- 🎨 **40+ Ready-to-use Components** - From basic layout widgets to complex interactive elements
- 🎭 **Comprehensive Theme System** - Consistent styling across your entire application
- 📱 **Mobile-first Design** - Optimized for mobile e-commerce experiences
- ♿ **Accessibility Support** - Built-in accessibility features and semantic labels
- 🔧 **Extensive Customization** - Multiple variants, sizes, and styling options for each component
- 📚 **Rich Documentation** - Interactive Storybook with live examples

## 🏗️ Package Structure

```
packages/components/
├── lib/
│   ├── osmea_components.dart          # Main export file - import this in your app
│   └── src/
│       ├── components/                # Individual component implementations
│       │   ├── buttons/              # Button components (primary, secondary, icon, etc.)
│       │   ├── text_field/           # Input components (text field, OTP, search)
│       │   ├── cards/                # Card components (basic, image, action cards)
│       │   ├── navbar/               # Navigation components
│       │   ├── layout/               # Layout widgets (container, stack, etc.)
│       │   └── ...                   # 40+ other component categories
│       ├── core/                     # Core functionality and shared logic
│       │   ├── cubit_button/         # State management for interactive components
│       │   └── ...                   # Shared utilities and base classes
│       ├── enums/                    # Component variants, sizes, and state enums
│       ├── styles/                   # Text styles and color definitions
│       ├── theme/                    # Theme system and design tokens
│       └── utils/                    # Extension methods and utility functions
├── example_storybook/                # Interactive component showcase
│   ├── lib/storybook_test/          # Storybook implementation
│   └── ...                          # Component examples and documentation
└── example_mobile/                   # Mobile app examples
```

## 🎯 Component Categories

### 🔲 Layout Components
Perfect for structuring your app's layout and organizing content:
- **Container** - Flexible containers with styling options
- **Row/Column** - Flex-based layouts with alignment options  
- **Stack** - Layered positioning for overlays and complex layouts
- **Scaffold** - Complete page structure with app bar and navigation
- **Padding/Sized Box** - Spacing and sizing utilities

### 🎨 UI Elements
Beautiful visual components for enhanced user experience:
- **Avatar** - User profile images with fallbacks and variants
- **Badge** - Notification badges and status indicators
- **Chips** - Interactive tags and selection chips
- **Divider** - Section separators with multiple styles
- **Progress** - Loading indicators and progress bars

### 📝 Form Controls
Comprehensive input components for user interaction:
- **Text Field** - Standard text inputs with validation
- **OTP Text Field** - Specialized one-time password input
- **Checkbox** - Selection controls with multiple styles
- **Radio Button** - Single selection from options
- **Switch** - Toggle controls for settings

### 🔘 Interactive Elements
Engaging components that respond to user actions:
- **Button** - Primary, secondary, and specialized action buttons
- **Cards** - Interactive content containers (basic, image, action)
- **Carousel** - Image and content sliders
- **List Item** - Flexible list elements with selection and expansion
- **Bottom Sheet** - Modal content panels

### 🧭 Navigation
Components for app navigation and user guidance:
- **App Bar** - Flexible application headers with actions
- **Navbar** - Bottom and top navigation bars
- **Stepper** - Multi-step process navigation
- **Searchbar** - Search functionality with suggestions and history

### 🎪 Specialized
Advanced components for specific use cases:
- **Login Button** - Authentication component with built-in logic
- **Ticket Widget** - Dynamic form generator for support tickets
- **Toast** - Notification messages with multiple styles
- **Popup** - Modal dialogs and overlays

## 🚀 Quick Start

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  osmea_components: ^0.1.0
```

### Import and Usage

```dart
import 'package:osmea_components/osmea_components.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: OsmeaTheme.lightTheme, // Use OSMEA theme
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.scaffold(
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text('My E-commerce App'),
        actions: [
          AppBarAction(
            icon: Icon(Icons.search),
            onPressed: () => print('Search tapped'),
          ),
        ],
      ),
      body: OsmeaComponents.column(
        children: [
          OsmeaComponents.button(
            text: 'Shop Now',
            variant: ButtonVariant.primary,
            size: ButtonSize.large,
            onPressed: () => print('Shop button tapped'),
          ),
          OsmeaComponents.spacer(),
          OsmeaComponents.basicCard(
            title: 'Featured Product',
            subtitle: 'Limited Time Offer',
            content: 'Get 20% off on all electronics!',
            onTap: () => print('Card tapped'),
          ),
        ],
      ),
    );
  }
}
```

## 📋 Usage Guidelines

### 🎨 Theming

OSMEA Components come with a built-in theme system that ensures consistency across your app:

```dart
// Apply the default OSMEA theme
MaterialApp(
  theme: OsmeaTheme.lightTheme,
  darkTheme: OsmeaTheme.darkTheme,
  // Your app content
)

// Or customize with your own theme
MaterialApp(
  theme: OsmeaTheme.createCustomTheme(
    primaryColor: Colors.blue,
    accentColor: Colors.orange,
  ),
  // Your app content
)
```

### 🔧 Component Variants and Sizes

Most components support multiple variants and sizes for different use cases:

```dart
// Button variants
OsmeaComponents.button(
  text: 'Primary Action',
  variant: ButtonVariant.primary,     // primary, secondary, outlined, ghost
  size: ButtonSize.large,             // extraSmall, small, medium, large, extraLarge
  onPressed: () {},
)

// Text field variants  
OsmeaComponents.textField(
  label: 'Email Address',
  variant: TextFieldVariant.outlined, // outlined, filled, underlined
  size: TextFieldSize.medium,         // small, medium, large
)

// Card variants
OsmeaComponents.basicCard(
  title: 'Product Card',
  variant: ComponentAppearance.elevated, // filled, outlined, elevated
  size: ComponentSize.medium,             // small, medium, large, extraLarge
)
```

### 🎯 State Management

Interactive components include built-in state management using BLoC pattern:

```dart
// Components with loading states
OsmeaComponents.loginButton(
  text: 'Sign In',
  authService: MyAuthService(),
  getUsername: () => usernameController.text,
  getPassword: () => passwordController.text,
  onLoginSuccess: () {
    // Handle successful login
  },
  onLoginFailure: () {
    // Handle login failure
  },
)

// Manual state control
OsmeaComponents.button(
  text: 'Submit',
  state: ButtonState.loading, // enabled, disabled, loading, pressed
  onPressed: isLoading ? null : handleSubmit,
)
```

### ♿ Accessibility

Components are built with accessibility in mind:

```dart
OsmeaComponents.button(
  text: 'Submit Form',
  tooltip: 'Submit the registration form',
  semanticLabel: 'Submit registration form button',
  onPressed: () {},
)

OsmeaComponents.textField(
  label: 'Email Address',
  accessibilityLabel: 'Enter your email address',
  validator: (value) => value?.isEmpty ?? true ? 'Email is required' : null,
)
```

## 💡 Basic Examples

### Simple Login Form

```dart
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      padding: EdgeInsets.all(24),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.text(
            'Welcome Back',
            variant: OsmeaTextVariant.headlineMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          OsmeaComponents.textField(
            controller: _emailController,
            label: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined),
          ),
          SizedBox(height: 16),
          OsmeaComponents.textField(
            controller: _passwordController,
            label: 'Password',
            obscureText: true,
            prefixIcon: Icon(Icons.lock_outlined),
          ),
          SizedBox(height: 24),
          OsmeaComponents.loginButton(
            text: 'Sign In',
            variant: ButtonVariant.primary,
            size: ButtonSize.large,
            authService: MyAuthService(),
            getUsername: () => _emailController.text,
            getPassword: () => _passwordController.text,
            onLoginSuccess: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}
```

### Product Card Grid

```dart
class ProductGrid extends StatelessWidget {
  final List<Product> products;
  
  const ProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return OsmeaComponents.imageCard(
          title: product.name,
          subtitle: '\$${product.price}',
          imageUrl: product.imageUrl,
          variant: ComponentAppearance.elevated,
          onTap: () => Navigator.pushNamed(
            context, 
            '/product', 
            arguments: product,
          ),
          badge: product.isOnSale 
            ? OsmeaComponents.badge(
                content: 'SALE',
                variant: BadgeVariant.danger,
                size: BadgeSize.small,
              )
            : null,
        );
      },
    );
  }
}
```

### Interactive Checkout Stepper

```dart
class CheckoutStepper extends StatefulWidget {
  @override
  _CheckoutStepperState createState() => _CheckoutStepperState();
}

class _CheckoutStepperState extends State<CheckoutStepper> {
  int currentStep = 0;
  
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.stepper(
      currentStep: currentStep,
      onStepChanged: (step) => setState(() => currentStep = step),
      steps: [
        OsmeaStep(
          label: 'Cart Review',
          content: CartReviewWidget(),
          isActive: currentStep >= 0,
          isCompleted: currentStep > 0,
        ),
        OsmeaStep(
          label: 'Shipping Info',
          content: ShippingFormWidget(),
          isActive: currentStep >= 1,
          isCompleted: currentStep > 1,
        ),
        OsmeaStep(
          label: 'Payment',
          content: PaymentFormWidget(),
          isActive: currentStep >= 2,
          isCompleted: currentStep > 2,
        ),
        OsmeaStep(
          label: 'Confirmation',
          content: OrderConfirmationWidget(),
          isActive: currentStep >= 3,
          isCompleted: currentStep > 3,
        ),
      ],
    );
  }
}
```

## 🎨 Interactive Storybook

Explore all components interactively in our comprehensive Storybook:

```bash
cd packages/components/example_storybook
flutter run
```

The Storybook includes:
- **Live Component Demos** - See components in action with real-time property changes
- **Code Examples** - Copy-paste ready code snippets
- **Design Guidelines** - Best practices and usage recommendations
- **Accessibility Testing** - Screen reader and keyboard navigation demos

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](../../CONTRIBUTING.md) for details on:
- Adding new components
- Following our coding standards  
- Testing requirements
- Documentation expectations

## 📚 Additional Resources

- **[API Documentation](https://pub.dev/documentation/osmea_components)** - Complete API reference
- **[Design System](../../docs/design-system.md)** - Design principles and guidelines
- **[Component Templates](example_storybook/lib/storybook_test/_templates/)** - Templates for creating new components
- **[Examples](example_mobile/)** - Complete mobile app examples

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../../LICENSE) file for details.

---

**Built with ❤️ by the OSMEA Team**