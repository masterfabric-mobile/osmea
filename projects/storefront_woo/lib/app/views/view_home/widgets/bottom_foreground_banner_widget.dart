/*
 * BottomForegroundBannerWidget
 * ----------------------------
 * Dismissible bottom banner that works on foreground overlay.
 * Short height (~60px) banner with background image, title, description, and arrow icon.
 * Can be hidden by user and shows a small tail indicator that when clicked shows it again.
 * Configured via app_config.json
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'dart:async';

/// Bottom foreground banner widget
class BottomForegroundBannerWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;
  final Function(String) goRoute;

  const BottomForegroundBannerWidget({
    super.key,
    required this.configHelper,
    required this.goRoute,
  });

  @override
  State<BottomForegroundBannerWidget> createState() =>
      _BottomForegroundBannerWidgetState();
}

class _BottomForegroundBannerWidgetState
    extends State<BottomForegroundBannerWidget>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  bool _isVisibilityLoaded = false;
  final LocalStorageHelper _storageHelper = LocalStorageHelper();
  static const String _visibilityKey = 'bottom_foreground_banner_visible';
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Hidden below
      end: Offset.zero, // Visible
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    _loadSavedVisibility();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  /// Load bottom banner configuration
  Map<String, dynamic>? _loadBannerConfig() {
    try {
      return widget.configHelper.getObject('home_view.bottom_foreground_banner');
    } catch (e) {
      debugPrint('⚠️ Failed to load bottom_foreground_banner config: $e');
      return null;
    }
  }

  /// Check if bottom banner is enabled
  bool _isEnabled() {
    final config = _loadBannerConfig();
    return config?['enabled'] as bool? ?? false;
  }

  /// Load saved visibility state from storage
  Future<void> _loadSavedVisibility() async {
    try {
      await _storageHelper.init();
      final savedVisible = await _storageHelper.getItem(_visibilityKey);
      
      if (savedVisible != null) {
        setState(() {
          _isVisible = savedVisible.toString().toLowerCase() == 'true';
          _isVisibilityLoaded = true;
        });
        if (_isVisible) {
          _slideController.forward();
        } else {
          _slideController.reverse();
        }
      } else {
        // Default to visible if not saved
        setState(() {
          _isVisible = true;
          _isVisibilityLoaded = true;
        });
        _slideController.forward();
      }
    } catch (e) {
      debugPrint('⚠️ Error loading saved visibility: $e');
      setState(() {
        _isVisible = true;
        _isVisibilityLoaded = true;
      });
      _slideController.forward();
    }
  }

  /// Save visibility state to storage
  Future<void> _saveVisibility(bool visible) async {
    try {
      await _storageHelper.init();
      await _storageHelper.setItem(_visibilityKey, visible.toString());
      debugPrint('💾 Bottom foreground banner visibility saved: $visible');
    } catch (e) {
      debugPrint('⚠️ Error saving visibility: $e');
    }
  }

  /// Handle dismiss button tap with smooth animation
  void _handleDismiss() {
    // Start reverse animation (keep _isVisible true during animation)
    _slideController.reverse().then((_) {
      // Hide widget after animation completes
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
        _saveVisibility(false);
      }
    });
  }

  /// Handle tail indicator tap to show banner again
  void _handleShowBanner() {
    setState(() {
      _isVisible = true;
    });
    _slideController.forward();
    _saveVisibility(true);
  }

  /// Handle banner tap navigation
  void _handleBannerTap() {
    final config = _loadBannerConfig();
    if (config == null) return;

    // Get navigation options
    final route = config['route'] as String?;
    final categoryId = config['category_id'] as int?;
    final productId = config['product_id'] as int?;

    if (route != null && route.isNotEmpty) {
      widget.goRoute(route);
    } else if (categoryId != null) {
      widget.goRoute('/products?category_id=$categoryId');
    } else if (productId != null) {
      widget.goRoute('/product-detail/$productId');
    }
  }

  /// Parse hex color string to Color
  Color _parseColor(String? hexColor, Color defaultColor) {
    if (hexColor == null || hexColor.isEmpty) return defaultColor;
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return defaultColor;
    } catch (e) {
      debugPrint('⚠️ Error parsing color $hexColor: $e');
      return defaultColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled()) {
      return const SizedBox.shrink();
    }

    if (!_isVisibilityLoaded) {
      return const SizedBox.shrink();
    }

    final config = _loadBannerConfig();
    if (config == null) {
      return const SizedBox.shrink();
    }

    // Get configuration values
    final imageUrl = config['imageUrl'] as String?;
    final title = config['title'] as String? ?? '';
    final description = config['description'] as String? ?? '';
    final height = (config['height'] as num?)?.toDouble() ?? 60.0;
    final borderRadius = (config['border_radius'] as num?)?.toDouble() ?? 12.0;
    final imageOpacity = (config['image_opacity'] as num?)?.toDouble() ?? 0.4;
    final overlayColor = config['overlay_color'] as String? ?? '#000000';
    final overlayOpacity = (config['overlay_opacity'] as num?)?.toDouble() ?? 0.3;
    final backgroundColor = config['background_color'] as String?;
    final textColor = config['text_color'] as String? ?? '#000000';
    final arrowIconColor = config['arrow_icon_color'] as String? ?? '#000000';
    final tailHeight = (config['tail_height'] as num?)?.toDouble() ?? 8.0;
    final tailWidth = (config['tail_width'] as num?)?.toDouble() ?? 40.0;
    final tailBottomOffset = (config['tail_bottom_offset'] as num?)?.toDouble() ?? 56.0;
    final showDismissButton = config['show_dismiss_button'] as bool? ?? true;

    final bgColor = backgroundColor != null
        ? _parseColor(backgroundColor, OsmeaColors.white)
        : null;
    final overlayColorParsed = _parseColor(overlayColor, OsmeaColors.black);
    final textColorParsed = _parseColor(textColor, OsmeaColors.thunder);
    final arrowColorParsed = _parseColor(arrowIconColor, OsmeaColors.thunder);

    // Get screen size and navbar height
    final screenSize = MediaQuery.of(context).size;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    // Navbar is typically around 56-64px for medium size, position banner above it
    final navbarHeight = safeAreaBottom + tailBottomOffset; // Navbar height from config
    // Tail should sit right on top of navbar (configurable offset from bottom)
    final tailBottomPosition = safeAreaBottom + tailBottomOffset;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main banner (visible when _isVisible is true)
        if (_isVisible)
          Positioned(
            left: 0,
            right: 0,
            bottom: navbarHeight,
            child: SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onTap: _handleBannerTap,
                child: Container(
                  height: height,
                  margin: EdgeInsets.symmetric(horizontal: context.spacing16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: OsmeaColors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Stack(
                      children: [
                        // Background image with opacity
                        if (imageUrl != null && imageUrl.isNotEmpty)
                          Positioned.fill(
                            child: Opacity(
                              opacity: imageOpacity,
                              child: OsmeaComponents.image(
                                imageUrl: imageUrl,
                                width: double.infinity,
                                height: height,
                                fit: BoxFit.cover,
                                variant: ImageVariant.normal,
                                borderRadius: BorderRadius.zero,
                                showLoadingIndicator: true,
                                errorWidget: Container(
                                  color: bgColor ?? OsmeaColors.white,
                                ),
                              ),
                            ),
                          ),
                        // Configurable overlay container for better text readability
                        if (imageUrl != null && imageUrl.isNotEmpty)
                          Positioned.fill(
                            child: Container(
                              color: overlayColorParsed.withOpacity(overlayOpacity),
                            ),
                          ),
                        // Content row
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.spacing16,
                            vertical: context.spacing8,
                          ),
                          child: Row(
                            children: [
                              // Title and description column
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (title.isNotEmpty)
                                      OsmeaComponents.text(
                                        title,
                                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                                          color: textColorParsed,
                                          fontWeight: FontWeight.w700,
                                          fontSize: context.fontSizeSmall,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (description.isNotEmpty) ...[
                                      OsmeaComponents.sizedBox(height: context.spacing2),
                                      OsmeaComponents.text(
                                        description,
                                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                                          color: textColorParsed.withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                          fontSize: context.fontSizeExtraSmall,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              // Arrow icon
                              OsmeaComponents.sizedBox(width: context.spacing8),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: arrowColorParsed,
                              ),
                              // Dismiss button
                              if (showDismissButton) ...[
                                OsmeaComponents.sizedBox(width: context.spacing8),
                                GestureDetector(
                                  onTap: _handleDismiss,
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    padding: EdgeInsets.all(context.spacing4),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: textColorParsed.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        // Tail indicator (visible when banner is hidden) - positioned right above navbar
        if (!_isVisible)
          Positioned(
            left: (screenSize.width - tailWidth) / 2,
            bottom: tailBottomPosition, // Position right above navbar
            child: GestureDetector(
              onTap: _handleShowBanner,
              child: Container(
                width: tailWidth,
                height: tailHeight,
                decoration: BoxDecoration(
                  color: OsmeaColors.grayMaterial[400]?.withOpacity(0.6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: tailHeight * 0.6,
                    color: OsmeaColors.thunder.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

