/*
 * CampaignPopupButtonWidget
 * -------------------------
 * Floating circular campaign button with close icon.
 * Displays promotional offers (e.g., "100 TL KUPON") and navigates to categories/products.
 * Configured via app_config.json
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'dart:async';

/// Floating circular campaign button widget
class CampaignPopupButtonWidget extends StatefulWidget {
  final AssetConfigHelper configHelper;
  final Function(String) goRoute;

  const CampaignPopupButtonWidget({
    super.key,
    required this.configHelper,
    required this.goRoute,
  });

  @override
  State<CampaignPopupButtonWidget> createState() =>
      _CampaignPopupButtonWidgetState();
}

class _CampaignPopupButtonWidgetState
    extends State<CampaignPopupButtonWidget> {
  bool _isVisible = true;
  Offset _position = Offset.zero;
  bool _isPositionLoaded = false;
  bool _isVisibilityLoaded = false;
  final LocalStorageHelper _storageHelper = LocalStorageHelper();
  static const String _positionKey = 'campaign_popup_button_position';
  static const String _visibilityKey = 'campaign_popup_button_visible';

  /// Load campaign popup configuration
  Map<String, dynamic>? _loadCampaignPopupConfig() {
    try {
      return widget.configHelper.getObject('home_view.campaign_popup_button');
    } catch (e) {
      debugPrint('⚠️ Failed to load campaign_popup_button config: $e');
      return null;
    }
  }

  /// Check if campaign popup is enabled
  bool _isEnabled() {
    final config = _loadCampaignPopupConfig();
    return config?['enabled'] as bool? ?? false;
  }

  @override
  void initState() {
    super.initState();
    _loadSavedVisibility();
    // Always reset position on app restart - don't load saved position
    _setDefaultPosition();
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
      } else {
        // Default to visible if not saved
        setState(() {
          _isVisible = true;
          _isVisibilityLoaded = true;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Error loading saved visibility: $e');
      setState(() {
        _isVisible = true;
        _isVisibilityLoaded = true;
      });
    }
  }

  /// Set default position based on config
  void _setDefaultPosition() {
    // Reset position to zero - will be set in build() based on config
    setState(() {
      _position = Offset.zero;
      _isPositionLoaded = true;
    });
  }

  /// Save position to storage
  Future<void> _savePosition(Offset position) async {
    try {
      await _storageHelper.init();
      await _storageHelper.setItem('${_positionKey}_x', position.dx.toString());
      await _storageHelper.setItem('${_positionKey}_y', position.dy.toString());
    } catch (e) {
      debugPrint('⚠️ Error saving position: $e');
    }
  }

  /// Handle drag update
  void _handleDragUpdate(DragUpdateDetails details, Size screenSize, double buttonSize) {
    setState(() {
      // Calculate new position
      double newX = _position.dx + details.delta.dx;
      double newY = _position.dy + details.delta.dy;

      // Keep button within screen bounds
      // Clamp X: from left edge to right edge
      newX = newX.clamp(0, screenSize.width - buttonSize);
      // Clamp Y: from top (below app bar) to bottom (above navbar)
      newY = newY.clamp(80, screenSize.height - buttonSize - 100);

      _position = Offset(newX, newY);
    });
  }

  /// Handle drag end - save position
  void _handleDragEnd(DragEndDetails details) {
    _savePosition(_position);
  }

  /// Handle close button tap
  void _handleClose() {
    setState(() {
      _isVisible = false;
    });
    // Save visibility state to storage
    _saveVisibility(false);
  }

  /// Save visibility state to storage
  Future<void> _saveVisibility(bool visible) async {
    try {
      await _storageHelper.init();
      await _storageHelper.setItem(_visibilityKey, visible.toString());
      debugPrint('💾 Campaign popup button visibility saved: $visible');
    } catch (e) {
      debugPrint('⚠️ Error saving visibility: $e');
    }
  }

  /// Handle campaign button tap
  void _handleCampaignTap() {
    final config = _loadCampaignPopupConfig();
    if (config == null) return;

    // Get navigation route
    final route = config['route'] as String?;
    final categoryId = config['category_id'] as int?;
    final productId = config['product_id'] as int?;

    if (route != null && route.isNotEmpty) {
      widget.goRoute(route);
    } else if (categoryId != null) {
      widget.goRoute('/products?category_id=$categoryId');
    } else if (productId != null) {
      widget.goRoute('/product-detail/$productId');
    } else {
      // Default to products page
      widget.goRoute('/products');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEnabled()) {
      debugPrint('⚠️ Campaign popup button is disabled in config');
      return const SizedBox.shrink();
    }

    if (!_isVisible) {
      debugPrint('⚠️ Campaign popup button is hidden (closed by user)');
      return const SizedBox.shrink();
    }

    final config = _loadCampaignPopupConfig();
    if (config == null) {
      debugPrint('⚠️ Campaign popup button config is null');
      return const SizedBox.shrink();
    }

    // Wait for position and visibility to load before showing
    if (!_isPositionLoaded || !_isVisibilityLoaded) {
      debugPrint('⏳ Campaign popup button not ready yet (position: $_isPositionLoaded, visibility: $_isVisibilityLoaded)');
      return const SizedBox.shrink();
    }

    // Get configuration values
    final text = config['text'] as String? ?? 'KUPON';
    final amount = config['amount'] as String?;
    final imageUrl = config['imageUrl'] as String?;
    final backgroundColor = config['backgroundColor'] as String? ?? '#2563EB';
    final borderColor = config['borderColor'] as String? ?? '#FFFFFF';
    final textColor = config['textColor'] as String? ?? '#FFFFFF';
    final sizeInt = config['size'] as int? ?? 100;
    double size = sizeInt.toDouble();
    final showCloseButton = config['showCloseButton'] as bool? ?? true;

    // If imageUrl is provided, adjust size to accommodate image
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final String? finalImageUrl = hasImage ? imageUrl : null;
    if (hasImage) {
      // Scale size based on image - ensure it's reasonable for images
      // The size from config will be used, but we ensure minimum visibility
      size = size.clamp(80.0, 200.0); // Min 80, max 200 for images
    }

    // Parse colors
    final bgColor = _parseColor(backgroundColor);
    final borderColorParsed = _parseColor(borderColor);
    final textColorParsed = _parseColor(textColor);

    // Get screen size for bounds checking
    final screenSize = MediaQuery.of(context).size;

    // Always use default position on app start (position resets on restart)
    // Only use saved position during the same session after dragging
    Offset finalPosition = _position;
    if (_position.dx == 0 && _position.dy == 0) {
      // Set default position from config
      final position = config['position'] as String? ?? 'right';
      final isRight = position == 'right';
      finalPosition = Offset(
        isRight ? screenSize.width - size - 16 : 16,
        120.0,
      );
      _position = finalPosition;
      debugPrint('📍 Campaign popup button default position: $finalPosition (screen: $screenSize, size: $size)');
    } else {
      // Use current position (from drag during this session)
      debugPrint('📍 Campaign popup button using current position: $finalPosition');
    }

    // Ensure position is within bounds
    finalPosition = Offset(
      finalPosition.dx.clamp(0, screenSize.width - size),
      finalPosition.dy.clamp(80, screenSize.height - size - 100),
    );

    debugPrint('✅ Campaign popup button rendering at: $finalPosition');

    return Positioned(
      left: finalPosition.dx,
      top: finalPosition.dy,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Campaign button (draggable)
          GestureDetector(
            onPanUpdate: (details) => _handleDragUpdate(details, screenSize, size),
            onPanEnd: _handleDragEnd,
            onTap: _handleCampaignTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: hasImage ? Colors.transparent : bgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColorParsed,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: hasImage && finalImageUrl != null
                    ? _buildImageContent(finalImageUrl, size)
                    : _buildTextContent(context, text, amount, textColorParsed),
              ),
            ),
          ),
          // Close button (top left) - separate GestureDetector to handle taps independently
          if (showCloseButton)
            Positioned(
              top: -8,
              left: -8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleClose,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: OsmeaColors.grayMaterial[600],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: OsmeaColors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: OsmeaColors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build image content when imageUrl is provided
  Widget _buildImageContent(String imageUrl, double size) {
    return OsmeaComponents.image(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      variant: ImageVariant.normal,
      borderRadius: BorderRadius.zero,
      showLoadingIndicator: true,
      errorWidget: _buildImagePlaceholder(size),
    );
  }

  /// Build placeholder widget for campaign images
  Widget _buildImagePlaceholder(double size) {
    final config = _loadCampaignPopupConfig();
    final backgroundColor = config?['backgroundColor'] as String? ?? '#2563EB';
    final textColor = config?['textColor'] as String? ?? '#FFFFFF';
    final text = config?['text'] as String? ?? 'KUPON';
    final amount = config?['amount'] as String?;
    final bgColor = _parseColor(backgroundColor);
    final textColorParsed = _parseColor(textColor);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bgColor,
            bgColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Campaign icon
          Icon(
            Icons.local_offer,
            color: textColorParsed.withOpacity(0.9),
            size: size * 0.35,
          ),
          SizedBox(height: size * 0.05),
          // Amount if available
          if (amount != null)
            OsmeaComponents.text(
              amount,
              textStyle: TextStyle(
                color: textColorParsed,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.15,
              ),
            ),
          // Text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.1),
            child: OsmeaComponents.text(
              text,
              textStyle: TextStyle(
                color: textColorParsed,
                fontWeight: FontWeight.w600,
                fontSize: size * 0.12,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Build text content when no imageUrl (default design)
  Widget _buildTextContent(
    BuildContext context,
    String text,
    String? amount,
    Color textColorParsed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: _parseColor(widget.configHelper.getString(
          'home_view.campaign_popup_button.backgroundColor',
          '#2563EB',
        )),
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Percentage signs (two % symbols)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OsmeaComponents.text(
                  '%',
                  textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                    color: textColorParsed,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                OsmeaComponents.sizedBox(width: 2),
                OsmeaComponents.text(
                  '%',
                  textStyle: OsmeaTextStyle.headlineSmall(context).copyWith(
                    color: textColorParsed,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: 2),
            // Amount text
            if (amount != null)
              OsmeaComponents.text(
                amount,
                textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                  color: textColorParsed,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            OsmeaComponents.sizedBox(height: 2),
            // Main text
            OsmeaComponents.text(
              text,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: textColorParsed,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Parse hex color string to Color
  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
      return OsmeaColors.nordicBlue; // Fallback
    } catch (e) {
      debugPrint('⚠️ Error parsing color $hexColor: $e');
      return OsmeaColors.nordicBlue;
    }
  }
}

