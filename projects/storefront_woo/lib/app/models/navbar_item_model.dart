/*
 * NavbarItemModel
 * ---------------
 * Model class representing navbar items from app_config.json
 */

/// Model for navbar items loaded from configuration
class NavbarItemModel {
  final String id;
  final int orderId;
  final String text;
  final String iconName;
  final String route;
  final String? tooltip;

  // Optional fields for animated icons
  final String? filledIconName;
  final bool isAnimated;
  final String? animationType;
  final String? animationTrigger;

  // Optional fields for conditional items (auth/guest)
  final bool isConditional;
  final String? authIconName;
  final String? guestIconName;
  final String? authRoute;
  final String? guestRoute;
  final String? authText;
  final String? guestText;

  NavbarItemModel({
    required this.id,
    required this.orderId,
    required this.text,
    required this.iconName,
    required this.route,
    this.tooltip,
    this.filledIconName,
    this.isAnimated = false,
    this.animationType,
    this.animationTrigger,
    this.isConditional = false,
    this.authIconName,
    this.guestIconName,
    this.authRoute,
    this.guestRoute,
    this.authText,
    this.guestText,
  });

  /// Create NavbarItemModel from config map
  factory NavbarItemModel.fromConfig(Map<String, dynamic> config) {
    return NavbarItemModel(
      id: config['id'] as String? ?? '',
      orderId: config['order_id'] as int? ?? 0,
      text: config['text'] as String? ?? '',
      iconName: config['iconName'] as String? ?? '',
      route: config['route'] as String? ?? '',
      tooltip: config['tooltip'] as String?,
      filledIconName: config['filledIconName'] as String?,
      isAnimated: config['isAnimated'] as bool? ?? false,
      animationType: config['animationType'] as String?,
      animationTrigger: config['animationTrigger'] as String?,
      isConditional: config['isConditional'] as bool? ?? false,
      authIconName: config['authIconName'] as String?,
      guestIconName: config['guestIconName'] as String?,
      authRoute: config['authRoute'] as String?,
      guestRoute: config['guestRoute'] as String?,
      authText: config['authText'] as String?,
      guestText: config['guestText'] as String?,
    );
  }

  /// Get icon name based on authentication state
  String getIconName(bool isAuthenticated) {
    if (isConditional) {
      return isAuthenticated
          ? (authIconName ?? iconName)
          : (guestIconName ?? iconName);
    }
    return iconName;
  }

  /// Get route based on authentication state
  String getRoute(bool isAuthenticated) {
    if (isConditional) {
      return isAuthenticated
          ? (authRoute ?? route)
          : (guestRoute ?? route);
    }
    return route;
  }

  /// Get text based on authentication state
  String getText(bool isAuthenticated) {
    if (isConditional) {
      return isAuthenticated
          ? (authText ?? text)
          : (guestText ?? text);
    }
    return text;
  }
}

