/// 🧭 **OSMEA Navbar Enums**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// Comprehensive enum definitions for navbar components.
///
/// {@category Enums}
/// {@subCategory Navigation}
///
/// Enums:
/// * 📏 NavbarSize - Size variants for navbar
/// * 🎨 NavbarVariant - Style variants for navbar
/// * 📍 NavbarPosition - Position options for navbar
/// * 🔄 NavbarType - Type variants for navbar
///
/// ```dart
/// OsmeaNavbar(
///   size: NavbarSize.medium,
///   variant: NavbarVariant.primary,
///   position: NavbarPosition.top,
///   type: NavbarType.fixed,
/// )
/// ```

/// 📏 **Navbar Size Variants**
///
/// Defines the available size options for navbar components.
/// Each size has specific dimensions, padding, and typography scaling.
///
/// **Size Guidelines:**
/// - `small`: Compact navbar for minimal interfaces (48px height)
/// - `medium`: Standard navbar size for most use cases (56px height)
/// - `large`: Prominent navbar for important navigation (64px height)
///
/// **Usage:**
/// ```dart
/// OsmeaNavbar(
///   size: NavbarSize.medium, // Standard size
///   items: navItems,
/// )
/// ```
enum NavbarSize {
  /// 🔸 **Small** - Compact navbar for minimal spaces
  /// - Height: 48px
  /// - Padding: 8px horizontal, 4px vertical
  /// - Font: Small (14px)
  /// - Use for: Mobile interfaces, compact layouts
  small,

  /// 🔶 **Medium** - Standard navbar size for most interfaces
  /// - Height: 56px
  /// - Padding: 16px horizontal, 8px vertical
  /// - Font: Medium (16px)
  /// - Use for: Desktop applications, main navigation
  medium,

  /// 🔷 **Large** - Prominent navbar for important navigation
  /// - Height: 64px
  /// - Padding: 20px horizontal, 12px vertical
  /// - Font: Large (18px)
  /// - Use for: Hero sections, primary navigation, landing pages
  large,
}

/// 🎨 **Navbar Style Variants**
///
/// Defines the visual appearance and semantic meaning of navbar.
/// Each variant has specific color schemes and use cases.
///
/// **Variant Guidelines:**
/// - `primary`: Main navigation with brand colors
/// - `secondary`: Supporting navigation with neutral colors
/// - `transparent`: Overlay navigation with transparent background
/// - `glass`: Modern frosted glass effect
/// - `outlined`: Bordered navigation with subtle styling
///
/// **Usage:**
/// ```dart
/// OsmeaNavbar(
///   variant: NavbarVariant.primary, // Brand colored navbar
///   items: navigationItems,
/// )
/// ```
enum NavbarVariant {
  /// 🔵 **Primary** - Main navigation with brand colors
  /// - Background: Nordic Blue
  /// - Text: White
  /// - Use for: Main application navigation, brand presence
  primary,

  /// 🔘 **Secondary** - Supporting navigation with neutral colors
  /// - Background: Light gray
  /// - Text: Dark gray
  /// - Use for: Secondary navigation, sidebar menus
  secondary,

  /// 👻 **Transparent** - Overlay navigation with transparent background
  /// - Background: Transparent/Semi-transparent
  /// - Text: Adaptive based on background
  /// - Use for: Overlay navigation, hero sections
  transparent,

  /// 🪟 **Glass** - Modern frosted glass effect
  /// - Background: Frosted glass blur
  /// - Text: Adaptive contrast
  /// - Use for: Modern interfaces, overlay navigation
  glass,

  /// 📦 **Outlined** - Bordered navigation with subtle styling
  /// - Background: Transparent/Light
  /// - Border: Subtle border
  /// - Use for: Minimal navigation, clean interfaces
  outlined,
}

/// 📍 **Navbar Position Options**
///
/// Defines where the navbar can be positioned within the screen.
/// Affects layout behavior and styling.
///
/// **Position Guidelines:**
/// - `top`: Fixed at top of screen
/// - `bottom`: Fixed at bottom of screen
/// - `left`: Fixed at left side of screen
/// - `right`: Fixed at right side of screen
/// - `floating`: Floating above content
///
/// **Usage:**
/// ```dart
/// OsmeaNavbar(
///   position: NavbarPosition.top,
///   items: navigationItems,
/// )
/// ```
enum NavbarPosition {
  /// ⬆️ **Top** - Fixed at top of screen
  /// - Most common navbar position
  /// - Good for desktop and mobile
  /// - Standard navigation pattern
  top,

  /// ⬇️ **Bottom** - Fixed at bottom of screen
  /// - Common for mobile navigation
  /// - Tab bar style navigation
  /// - Easy thumb access on mobile
  bottom,

  /// ⬅️ **Left** - Fixed at left side of screen
  /// - Desktop sidebar navigation
  /// - Drawer-style navigation
  /// - Good for admin interfaces
  left,

  /// ➡️ **Right** - Fixed at right side of screen
  /// - Less common positioning
  /// - Special use cases
  /// - RTL language support
  right,

  /// 🎈 **Floating** - Floating above content
  /// - Modern design pattern
  /// - Overlay navigation
  /// - Contextual navigation
  floating,
}

enum NavbarItemState {
  /// ✅ **Active** - Currently selected item
  /// - Highlighted appearance
  /// - Indicates current location
  /// - Primary visual emphasis
  active,

  /// ⚪ **Inactive** - Available but not selected
  /// - Standard appearance
  /// - Interactive and clickable
  /// - Default state
  inactive,

  /// ⚫ **Disabled** - Not available for interaction
  /// - Reduced opacity
  /// - No interaction possible
  /// - Grayed out appearance
  disabled,

  /// 🔄 **Loading** - Processing state
  /// - Shows loading indicator
  /// - Disabled during process
  /// - Indicates ongoing operation
  loading,

  /// 🎯 **Focused** - Keyboard focus state
  /// - Focus ring or outline
  /// - Accessible via keyboard
  /// - Important for accessibility
  focused,

  /// 🖱️ **Hovered** - Mouse hover state
  /// - Subtle highlight
  /// - Interactive feedback
  /// - Desktop interaction
  hovered,
}

/// 🎬 **Navbar Item Animation Types**
///
/// Defines different animation types for navbar items.
/// Controls how items animate when their trigger value changes.
///
/// **Animation Guidelines:**
/// - `none`: No animation
/// - `scale`: Scale up/down animation
/// - `bounce`: Bouncing animation
/// - `pulse`: Pulsing animation
/// - `shake`: Shake animation
///
/// **Usage:**
/// ```dart
/// NavbarItem(
///   text: 'Saved',
///   icon: Icon(Icons.favorite),
///   animationType: NavbarItemAnimationType.scale,
///   animationTrigger: wishlistCount,
/// )
/// ```
enum NavbarItemAnimationType {
  /// ⏹️ **None** - No animation
  /// - No animation effect
  /// - Standard item behavior
  /// - Use for: Static items, performance optimization
  none,

  /// 📏 **Scale** - Scale up/down animation
  /// - Smooth scale transition
  /// - Elastic bounce effect
  /// - Use for: Favorite icons, notification badges
  scale,

  /// 🎾 **Bounce** - Bouncing animation
  /// - Bouncy spring effect
  /// - Attention-grabbing
  /// - Use for: Important updates, alerts
  bounce,

  /// 💓 **Pulse** - Pulsing animation
  /// - Gentle pulsing effect
  /// - Subtle attention
  /// - Use for: Status indicators, live updates
  pulse,

  /// 📳 **Shake** - Shake animation
  /// - Horizontal shake effect
  /// - Error/warning indication
  /// - Use for: Error states, validation feedback
  shake,
}
