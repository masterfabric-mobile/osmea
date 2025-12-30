/// 🎨 **OSMEA Auth Design Variant**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Defines different design styles for authentication screens.
/// Each variant represents a distinct visual and UX approach.
///
/// {@category Enums}
/// {@subCategory Auth}
///
/// **Variants:**
/// - `enterprise`: Professional, corporate design with card-based layout
/// - `startup`: Modern, clean design inspired by e-commerce platforms
///
/// **Usage:**
/// ```dart
/// AuthWidget(
///   designVariant: AuthDesignVariant.startup,
///   config: config,
/// )
/// ```

enum AuthDesignVariant {
  /// 🏢 **Enterprise** - Professional, corporate design
  /// - Card-based layout with structured forms
  /// - Professional typography and spacing
  /// - Corporate color schemes
  /// - Use for: Business apps, enterprise solutions, professional services
  enterprise,

  /// ⚡ **Startup** - Modern, clean e-commerce design
  /// - Clean white background
  /// - Simple logo and title
  /// - Minimal form design
  /// - Use for: Consumer apps, e-commerce, modern platforms
  startup,
}

