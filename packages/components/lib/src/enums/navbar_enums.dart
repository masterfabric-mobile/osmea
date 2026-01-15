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
/// * 🎭 NavbarStyle - Design style patterns for navbar
/// * 🎯 NavbarIndicatorStyle - Indicator styles for active items
/// * 📍 NavbarPosition - Position options for navbar
/// * 🔄 NavbarItemState - State variants for navbar items
/// * 🎬 NavbarItemAnimationType - Animation types for navbar items
///
/// ```dart
/// OsmeaNavbar(
///   size: NavbarSize.medium,
///   variant: NavbarVariant.retailMain,
///   style: NavbarStyle.iconWithText,
///   indicatorStyle: NavbarIndicatorStyle.line,
///   position: NavbarPosition.bottom,
///   items: navigationItems,
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
/// Each variant has specific color schemes optimized for different sectors and use cases.
///
/// **Sector-Based Variants:**
/// - `retailMain`: E-commerce/Retail main navigation with brand colors
/// - `retailSidebar`: E-commerce/Retail sidebar navigation with neutral colors
/// - `healthcareMinimal`: Healthcare minimal navigation with clean borders
/// - `financeBordered`: Finance/Banking professional navigation with borders
/// - `mediaOverlay`: Media/Entertainment floating overlay navigation
/// - `socialGlass`: Social Media frosted glass effect navigation
/// - `enterpriseMain`: Enterprise/B2B main navigation with brand colors
/// - `enterpriseSidebar`: Enterprise/B2B sidebar navigation
///
/// **Usage:**
/// ```dart
/// // E-commerce main navigation
/// OsmeaNavbar(
///   variant: NavbarVariant.retailMain,
///   items: navigationItems,
/// )
///
/// // Healthcare sidebar
/// OsmeaNavbar(
///   variant: NavbarVariant.healthcareMinimal,
///   items: navigationItems,
/// )
/// ```
enum NavbarVariant {
  /// 🛒 **Retail Main** - E-commerce/Retail main navigation with primary brand colors
  /// - Background: Nordic Blue (brand primary)
  /// - Text: White
  /// - Border: None (solid brand background)
  /// - Use for: E-commerce main nav, Retail apps, Shopping apps, Product navigation
  /// - Sectors: E-commerce, Retail, Shopping, Marketplace
  retailMain,

  /// 🏪 **Retail Sidebar** - E-commerce/Retail sidebar navigation with neutral colors
  /// - Background: Light gray (neutral)
  /// - Text: Dark gray
  /// - Border: None (subtle background)
  /// - Use for: Category sidebar, Filter sidebar, Product filters, Settings
  /// - Sectors: E-commerce, Retail, Shopping
  retailSidebar,

  /// 🏥 **Healthcare Minimal** - Healthcare minimal navigation with clean borders
  /// - Background: White/Light (clean, medical)
  /// - Text: Dark gray
  /// - Border: Subtle border (1px, clean separation)
  /// - Use for: Patient navigation, Medical records, Clinic apps, Health tracking
  /// - Sectors: Healthcare, Medical, Hospital, Clinic, Health & Wellness
  healthcareMinimal,

  /// 💼 **Finance Bordered** - Finance/Banking professional navigation with borders
  /// - Background: White (professional, trustworthy)
  /// - Text: Dark gray
  /// - Border: Subtle border (1px, professional separation)
  /// - Use for: Banking apps, Financial dashboards, Investment apps, Payment apps
  /// - Sectors: Finance, Banking, Investment, FinTech, Payment
  financeBordered,

  /// 🎬 **Media Overlay** - Media/Entertainment floating overlay navigation
  /// - Background: Transparent/Semi-transparent
  /// - Text: Adaptive based on background (high contrast)
  /// - Border: None (floating effect)
  /// - Use for: Video players, Music apps, Streaming apps, Hero sections, Landing pages
  /// - Sectors: Media, Entertainment, Video, Music, Streaming, Marketing
  mediaOverlay,

  /// 📱 **Social Glass** - Social Media frosted glass effect navigation
  /// - Background: Frosted glass blur (semi-transparent white)
  /// - Text: Adaptive contrast (dark on light)
  /// - Border: Subtle border (optional, modern look)
  /// - Use for: Social media apps, Messaging apps, Community apps, Modern mobile apps
  /// - Sectors: Social Media, Messaging, Community, Lifestyle, Creative
  socialGlass,

  /// 🏢 **Enterprise Main** - Enterprise/B2B main navigation with brand colors
  /// - Background: Nordic Blue (brand primary, professional)
  /// - Text: White
  /// - Border: None (solid brand background)
  /// - Use for: Enterprise dashboards, B2B apps, SaaS platforms, Admin panels
  /// - Sectors: Enterprise, B2B, SaaS, Business, Professional Services
  enterpriseMain,

  /// 🏛️ **Enterprise Sidebar** - Enterprise/B2B sidebar navigation
  /// - Background: Light gray (neutral, professional)
  /// - Text: Dark gray
  /// - Border: None (subtle background)
  /// - Use for: Admin sidebars, Settings navigation, Configuration menus, Secondary navigation
  /// - Sectors: Enterprise, B2B, SaaS, Business, All sectors (secondary navigation)
  enterpriseSidebar,
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

/// 🔄 **Navbar Item State**
///
/// Defines the current state of a navbar item.
/// Controls appearance, interactivity, and visual feedback.
///
/// **State Guidelines:**
/// - `active`: Currently selected item
/// - `inactive`: Available but not selected
/// - `disabled`: Not available for interaction
/// - `loading`: Processing state
/// - `focused`: Keyboard focus state
/// - `hovered`: Mouse hover state
///
/// **Usage:**
/// ```dart
/// NavbarItem(
///   text: 'Home',
///   icon: Icon(Icons.home),
///   state: NavbarItemState.active,
/// )
/// ```
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

/// 🎨 **Navbar Design Style**
///
/// Defines the visual design pattern and layout of navbar items.
/// Each style determines how icons, text, and subtext are displayed.
///
/// **Style Guidelines:**
/// - `iconOnly`: Only icons, no text (compact mobile navigation)
/// - `iconWithText`: Icon above text (standard bottom navigation)
/// - `iconWithSubtext`: Icon with main text and subtext (detailed navigation)
/// - `textOnly`: Only text labels, no icons (minimal navigation)
/// - `iconAndTextHorizontal`: Icon and text side by side (desktop navigation)
/// - `appBar`: Mobile app bar with hamburger menu, title, and actions
/// - `appBarWithSearch`: App bar with integrated search bar
/// - `drawerTrigger`: Hamburger menu button for drawer navigation
/// - `topTabBar`: Top tab bar navigation (Material Design tabs)
///
/// **Usage:**
/// ```dart
/// OsmeaNavbar(
///   style: NavbarStyle.iconWithText,
///   items: navigationItems,
/// )
/// ```
enum NavbarStyle {
  /// 🎯 **Icon Only** - Compact navigation with icons only
  /// - No text labels
  /// - Minimal space usage
  /// - Use for: Mobile bottom navigation, compact interfaces
  iconOnly,

  /// 📱 **Icon with Text** - Standard icon above text layout
  /// - Icon on top, text below
  /// - Most common mobile pattern
  /// - Use for: Bottom navigation bars, tab bars
  iconWithText,

  /// 📋 **Icon with Subtext** - Detailed navigation with main text and subtext
  /// - Icon on top
  /// - Main text and optional subtext below
  /// - Use for: Rich navigation, desktop sidebars
  iconWithSubtext,

  /// 📝 **Text Only** - Minimal text-only navigation
  /// - No icons
  /// - Clean, minimal design
  /// - Use for: Top navigation bars, menu items
  textOnly,

  /// ↔️ **Icon and Text Horizontal** - Icon and text side by side
  /// - Icon on left, text on right
  /// - Desktop-friendly layout
  /// - Use for: Desktop navigation, sidebar menus
  iconAndTextHorizontal,

  /// 📱 **App Bar** - Mobile app bar with hamburger menu, title, and actions
  /// - Leading: Hamburger menu or back button
  /// - Center: Title text
  /// - Trailing: Action buttons (search, notifications, etc.)
  /// - Use for: Top app bars, Material Design app bars
  appBar,

  /// 🔍 **App Bar with Search** - App bar with integrated search functionality
  /// - Leading: Hamburger menu
  /// - Center: Search bar (expandable/collapsible)
  /// - Trailing: Action buttons
  /// - Use for: Apps with search functionality, e-commerce apps
  appBarWithSearch,

  /// 🍔 **Drawer Trigger** - Hamburger menu button for drawer navigation
  /// - Single hamburger menu icon
  /// - Opens drawer when tapped
  /// - Use for: Drawer navigation pattern, sidebar triggers
  drawerTrigger,

  /// 📑 **Top Tab Bar** - Top tab bar navigation (Material Design style)
  /// - Horizontal scrolling tabs at top
  /// - Icon + text or text only
  /// - Use for: Tab navigation, category navigation, segmented content
  topTabBar,
}

/// 🎯 **Navbar Indicator Style**
///
/// Defines how the active state indicator is displayed for navbar items.
/// Each style provides different visual feedback for the selected item.
///
/// **Indicator Guidelines:**
/// - `none`: No visual indicator (rely on color/text changes)
/// - `line`: Horizontal/vertical line indicator
/// - `dot`: Small dot indicator
/// - `fill`: Filled background indicator
/// - `border`: Border highlight indicator
/// - `underline`: Underline indicator
///
/// **Usage:**
/// ```dart
/// OsmeaNavbar(
///   indicatorStyle: NavbarIndicatorStyle.line,
///   indicatorColor: OsmeaColors.nordicBlue,
///   items: navigationItems,
/// )
/// ```
enum NavbarIndicatorStyle {
  /// ⏹️ **None** - No visual indicator
  /// - Only color/text changes indicate active state
  /// - Minimal design approach
  /// - Use for: Subtle navigation, minimal interfaces
  none,

  /// 📏 **Line** - Line indicator (horizontal or vertical)
  /// - Thin line at edge of item
  /// - Clean, modern look
  /// - Use for: Bottom navigation, tab bars
  line,

  /// 🔵 **Dot** - Small dot indicator
  /// - Circular dot above/below item
  /// - Subtle but clear
  /// - Use for: Icon-only navigation, compact designs
  dot,

  /// 🎨 **Fill** - Filled background indicator
  /// - Background color change for active item
  /// - Strong visual emphasis
  /// - Use for: Primary navigation, important sections
  fill,

  /// 🔲 **Border** - Border highlight indicator
  /// - Border around active item
  /// - Clear but not overwhelming
  /// - Use for: Outlined navigation, card-style items
  border,

  /// ➖ **Underline** - Underline indicator
  /// - Line under text/icon
  /// - Classic navigation pattern
  /// - Use for: Top navigation bars, menu items
  underline,
}
