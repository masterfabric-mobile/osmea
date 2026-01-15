import 'package:flutter/material.dart';
import 'package:osmea_components/src/enums/navbar_enums.dart';
import 'package:osmea_components/src/utils/sizer_extensions.dart';
import 'package:osmea_components/src/utils/text_extensions.dart';

/// 🧭 **OSMEA Navbar Extensions**
///
/// Comprehensive extension methods for navbar configurations.
/// Provides consistent sizing, positioning, and behavior configurations
/// across all navbar components in the OSMEA design system.
///
/// **Features:**
/// * 📏 Size-specific dimensions and spacing
/// * 🔲 Responsive padding and margins
/// * 🎨 Typography scaling
/// * 📍 Position and alignment utilities
/// * � Type and behavior configurations
/// * �📱 Mobile-responsive breakpoints
///
/// **Usage:**
/// ```dart
/// final sizeConfig = NavbarSize.medium.config(context);
/// final isHorizontal = NavbarPosition.top.isHorizontal;
/// final isIconOnly = NavbarStyle.iconOnly.isIconOnly;
/// final hasIndicator = NavbarIndicatorStyle.line.hasVisualIndicator;
/// ```
///
/// @category Utils
/// @subcategory Extensions

/// Configuration class for navbar sizing
class NavbarSizeConfig {
  const NavbarSizeConfig({
    required this.height,
    required this.padding,
    required this.itemPadding,
    required this.iconSize,
    required this.fontSize,
    required this.borderRadius,
    required this.elevation,
    required this.itemSpacing,
  });

  /// 📏 Total height of the navbar
  final double height;

  /// 🔲 Internal padding of the navbar
  final EdgeInsetsGeometry padding;

  /// 🎯 Padding for individual navbar items
  final EdgeInsetsGeometry itemPadding;

  /// 🎨 Size of icons in navbar items
  final double iconSize;

  /// 📝 Font size for navbar text
  final double fontSize;

  /// ⭕ Border radius for navbar corners
  final BorderRadius borderRadius;

  /// ✨ Elevation/shadow depth
  final double elevation;

  /// ↔️ Spacing between navbar items
  final double itemSpacing;
}

/// Extension on NavbarSize enum to provide size configurations
extension NavbarSizeExtension on NavbarSize {
  /// 📐 Get complete size configuration for this navbar size
  ///
  /// Returns a [NavbarSizeConfig] with all sizing properties
  /// appropriate for the current size variant.
  ///
  /// **Example:**
  /// ```dart
  /// final config = NavbarSize.medium.config(context);
  /// Container(
  ///   height: config.height,
  ///   padding: config.padding,
  ///   child: navbar,
  /// )
  /// ```
  NavbarSizeConfig config(BuildContext context) {
    switch (this) {
      case NavbarSize.small:
        return NavbarSizeConfig(
          height:
              context.highValue * 0.75, // Increased for better text visibility
          padding: EdgeInsets.symmetric(
            horizontal: context.lowValue,
            vertical: context.lowValue * 0.5,
          ),
          itemPadding: EdgeInsets.symmetric(
            horizontal: context.lowValue * 0.75,
            vertical: context.lowValue * 0.25,
          ),
          iconSize: context.iconSizeSmall, // Using sizer extension
          fontSize: context.fontSizeSmall, // Using sizer extension
          borderRadius: context.borderRadiusZero, // No radius by default
          elevation: 0.0, // No shadow by default
          itemSpacing: context.lowValue,
        );

      case NavbarSize.medium:
        return NavbarSizeConfig(
          height:
              context.highValue * 0.85, // Increased for better text visibility
          padding: EdgeInsets.symmetric(
            horizontal: context.normalValue * 0.75,
            vertical: context.lowValue * 0.75,
          ),
          itemPadding: EdgeInsets.symmetric(
            horizontal: context.normalValue * 0.5,
            vertical: context.lowValue * 0.5,
          ),
          iconSize: context.iconSizeNormal, // Using sizer extension
          fontSize: context.fontSizeNormal, // Using sizer extension
          borderRadius: context.borderRadiusZero, // No radius by default
          elevation: 0.0, // No shadow by default
          itemSpacing: context.normalValue * 0.5,
        );

      case NavbarSize.large:
        return NavbarSizeConfig(
          height:
              context.highValue, // Increased height for better text visibility
          padding: EdgeInsets.symmetric(
            horizontal: context.normalValue, // Adequate padding
            vertical: context.normalValue * 0.25,
          ),
          itemPadding: EdgeInsets.symmetric(
            horizontal: context.normalValue * 0.75,
            vertical: context.normalValue * 0.25,
          ),
          iconSize: context.normalValue * 1.5, // Using sizer extension
          fontSize: context.fontSizeNormal, // Using sizer extension
          borderRadius: context.borderRadiusZero, // No radius by default
          elevation: 0.0, // No shadow by default
          itemSpacing: context.normalValue * 0.75,
        );
    }
  }

  /// 📱 Check if current size is appropriate for mobile
  bool get isMobile => this == NavbarSize.small;

  /// 🖥️ Check if current size is appropriate for desktop
  bool get isDesktop => this == NavbarSize.large;

  /// 📊 Get relative size factor (0.0 to 1.0)
  double get sizeFactor {
    switch (this) {
      case NavbarSize.small:
        return 0.0;
      case NavbarSize.medium:
        return 0.5;
      case NavbarSize.large:
        return 1.0;
    }
  }

  /// 📏 Get minimum width required for this navbar size
  double get minWidth {
    switch (this) {
      case NavbarSize.small:
        return 200.0;
      case NavbarSize.medium:
        return 300.0;
      case NavbarSize.large:
        return 400.0;
    }
  }

  /// 🎯 Get maximum number of items that fit comfortably
  int get maxItems {
    switch (this) {
      case NavbarSize.small:
        return 4;
      case NavbarSize.medium:
        return 6;
      case NavbarSize.large:
        return 8;
    }
  }
}

/// Extension for navbar positioning utilities
extension NavbarPositionExtension on NavbarPosition {
  /// 📍 Check if navbar is horizontal
  bool get isHorizontal =>
      this == NavbarPosition.top || this == NavbarPosition.bottom;

  /// 📍 Check if navbar is vertical
  bool get isVertical =>
      this == NavbarPosition.left || this == NavbarPosition.right;

  /// 📍 Check if navbar is at top
  bool get isTop => this == NavbarPosition.top;

  /// 📍 Check if navbar is at bottom
  bool get isBottom => this == NavbarPosition.bottom;

  /// 📍 Check if navbar is floating
  bool get isFloating => this == NavbarPosition.floating;

  /// 🎯 Get main axis for layout direction
  Axis get mainAxis {
    if (isHorizontal) return horizontal;
    return vertical;
  }

  /// 🎯 Get cross axis for layout direction
  Axis get crossAxis {
    if (isHorizontal) return vertical;
    return horizontal;
  }

  /// 🎯 Get alignment for positioning
  Alignment get alignment {
    switch (this) {
      case NavbarPosition.top:
        return Alignment.topCenter;
      case NavbarPosition.bottom:
        return Alignment.bottomCenter;
      case NavbarPosition.left:
        return Alignment.centerLeft;
      case NavbarPosition.right:
        return Alignment.centerRight;
      case NavbarPosition.floating:
        return Alignment.center;
    }
  }
}

/// Extension for navbar variant utilities
extension NavbarVariantExtension on NavbarVariant {
  /// 🛒 Check if variant is retail main
  bool get isRetailMain => this == NavbarVariant.retailMain;

  /// 🏪 Check if variant is retail sidebar
  bool get isRetailSidebar => this == NavbarVariant.retailSidebar;

  /// 🏥 Check if variant is healthcare minimal
  bool get isHealthcareMinimal => this == NavbarVariant.healthcareMinimal;

  /// 💼 Check if variant is finance bordered
  bool get isFinanceBordered => this == NavbarVariant.financeBordered;

  /// 🎬 Check if variant is media overlay
  bool get isMediaOverlay => this == NavbarVariant.mediaOverlay;

  /// 📱 Check if variant is social glass
  bool get isSocialGlass => this == NavbarVariant.socialGlass;

  /// 🏢 Check if variant is enterprise main
  bool get isEnterpriseMain => this == NavbarVariant.enterpriseMain;

  /// 🏛️ Check if variant is enterprise sidebar
  bool get isEnterpriseSidebar => this == NavbarVariant.enterpriseSidebar;

  /// 🎯 Check if variant has transparent background
  bool get hasTransparentBackground => isMediaOverlay || isSocialGlass;

  /// 🎯 Check if variant needs backdrop blur
  bool get needsBackdropBlur => isSocialGlass;

  /// 🎯 Check if variant needs border
  bool get needsBorder => isHealthcareMinimal || isFinanceBordered;

  /// 🎯 Check if variant is for e-commerce/retail sector
  bool get isForRetail => isRetailMain || isRetailSidebar;

  /// 🎯 Check if variant is for healthcare sector
  bool get isForHealthcare => isHealthcareMinimal;

  /// 🎯 Check if variant is for finance sector
  bool get isForFinance => isFinanceBordered;

  /// 🎯 Check if variant is for media/entertainment sector
  bool get isForMedia => isMediaOverlay;

  /// 🎯 Check if variant is for social media sector
  bool get isForSocial => isSocialGlass;

  /// 🎯 Check if variant is for enterprise sector
  bool get isForEnterprise => isEnterpriseMain || isEnterpriseSidebar;

  /// 🎯 Get relative opacity level (0.0 to 1.0)
  double get opacity {
    switch (this) {
      case NavbarVariant.retailMain:
      case NavbarVariant.retailSidebar:
      case NavbarVariant.healthcareMinimal:
      case NavbarVariant.financeBordered:
      case NavbarVariant.enterpriseMain:
      case NavbarVariant.enterpriseSidebar:
        return 1.0;
      case NavbarVariant.socialGlass:
        return 0.8;
      case NavbarVariant.mediaOverlay:
        return 0.0;
    }
  }
}

/// Extension for navbar style utilities
extension NavbarStyleExtension on NavbarStyle {
  /// 🎭 Check if style is icon-only
  bool get isIconOnly => this == NavbarStyle.iconOnly;

  /// 📱 Check if style shows text
  bool get showsText =>
      this == NavbarStyle.iconWithText ||
      this == NavbarStyle.iconWithSubtext ||
      this == NavbarStyle.textOnly ||
      this == NavbarStyle.iconAndTextHorizontal;

  /// 📋 Check if style shows subtext
  bool get showsSubtext => this == NavbarStyle.iconWithSubtext;

  /// 🎯 Check if style is horizontal layout
  bool get isHorizontalLayout =>
      this == NavbarStyle.iconAndTextHorizontal || this == NavbarStyle.textOnly;

  /// 🎯 Check if style is vertical layout
  bool get isVerticalLayout =>
      this == NavbarStyle.iconWithText ||
      this == NavbarStyle.iconWithSubtext ||
      this == NavbarStyle.iconOnly;

  /// 🎯 Check if style requires icon
  bool get requiresIcon =>
      this != NavbarStyle.textOnly && this != NavbarStyle.iconAndTextHorizontal;

  /// 🎯 Check if style requires text
  bool get requiresText => this != NavbarStyle.iconOnly;

  /// 📱 Check if style is app bar pattern
  bool get isAppBar =>
      this == NavbarStyle.appBar || this == NavbarStyle.appBarWithSearch;

  /// 🍔 Check if style is drawer trigger
  bool get isDrawerTrigger => this == NavbarStyle.drawerTrigger;

  /// 📑 Check if style is tab bar
  bool get isTabBar => this == NavbarStyle.topTabBar;

  /// 🎯 Check if style is mobile-specific
  bool get isMobileSpecific =>
      isAppBar || isDrawerTrigger || isTabBar || this == NavbarStyle.iconWithText;
}

/// Extension for navbar indicator style utilities
extension NavbarIndicatorStyleExtension on NavbarIndicatorStyle {
  /// 🎯 Check if indicator has visual element
  bool get hasVisualIndicator => this != NavbarIndicatorStyle.none;

  /// 🎯 Check if indicator is line-based
  bool get isLineBased =>
      this == NavbarIndicatorStyle.line ||
      this == NavbarIndicatorStyle.underline;

  /// 🎯 Check if indicator is shape-based
  bool get isShapeBased =>
      this == NavbarIndicatorStyle.dot ||
      this == NavbarIndicatorStyle.fill ||
      this == NavbarIndicatorStyle.border;

  /// 🎯 Check if indicator affects background
  bool get affectsBackground => this == NavbarIndicatorStyle.fill;

  /// 🎯 Check if indicator affects border
  bool get affectsBorder =>
      this == NavbarIndicatorStyle.border ||
      this == NavbarIndicatorStyle.line;

  /// 🎯 Get indicator thickness (for line/underline)
  double get thickness {
    switch (this) {
      case NavbarIndicatorStyle.line:
      case NavbarIndicatorStyle.underline:
        return 3.0;
      case NavbarIndicatorStyle.border:
        return 2.0;
      default:
        return 0.0;
    }
  }
}
