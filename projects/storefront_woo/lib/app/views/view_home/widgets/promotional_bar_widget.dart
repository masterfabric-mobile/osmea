/*
 * PromotionalBarWidget
 * --------------------
 * Promotional bar widget for home view.
 * Displays 2 short height promotional banners side by side in a row.
 * Configured via app_config.json with title, subtitle, colors, and navigation options.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

/// Promotional bar item model from config
class PromotionalBarItem {
  final String? title;
  final String? subtitle;
  final String? backgroundColor;
  final String? textColor;
  final String? accentColor;
  final String? imageUrl;
  final String? route;
  final int? categoryId;
  final int? productId;
  final String? icon;

  PromotionalBarItem({
    this.title,
    this.subtitle,
    this.backgroundColor,
    this.textColor,
    this.accentColor,
    this.imageUrl,
    this.route,
    this.categoryId,
    this.productId,
    this.icon,
  });

  factory PromotionalBarItem.fromConfig(Map<String, dynamic> config) {
    return PromotionalBarItem(
      title: config['title'] as String?,
      subtitle: config['subtitle'] as String?,
      backgroundColor: config['background_color'] as String?,
      textColor: config['text_color'] as String?,
      accentColor: config['accent_color'] as String?,
      imageUrl: config['imageUrl'] as String?,
      route: config['route'] as String?,
      categoryId: config['category_id'] as int?,
      productId: config['product_id'] as int?,
      icon: config['icon'] as String?,
    );
  }
}

/// Promotional bar widget
class PromotionalBarWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;

  const PromotionalBarWidget({
    super.key,
    required this.configHelper,
  });

  /// Loads promotional bar configuration
  Map<String, dynamic>? _loadPromotionalConfig() {
    try {
      return configHelper.getObject('home_view.promotional_bar');
    } catch (e) {
      debugPrint('⚠️ Failed to load promotional bar config: $e');
      return null;
    }
  }

  /// Loads promotional bar items from config
  List<PromotionalBarItem> _loadPromotionalItems() {
    try {
      final config = _loadPromotionalConfig();
      if (config == null) return [];

      final List<dynamic>? itemsList = config['items'] as List<dynamic>?;
      if (itemsList == null || itemsList.isEmpty) return [];

      return itemsList
          .map((item) => PromotionalBarItem.fromConfig(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('⚠️ Failed to load promotional bar items: $e');
      return [];
    }
  }

  /// Parses color from hex string
  Color _parseColor(String? colorHex, Color defaultColor) {
    if (colorHex == null || colorHex.isEmpty) return defaultColor;
    try {
      // Remove # if present
      final hex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      debugPrint('⚠️ Failed to parse color $colorHex: $e');
      return defaultColor;
    }
  }

  /// Handles promotional bar item tap navigation
  void _handleItemTap(BuildContext context, PromotionalBarItem item) {
    if (item.route != null && item.route!.isNotEmpty) {
      context.push(item.route!);
    } else if (item.categoryId != null) {
      context.push('/products?category_id=${item.categoryId}');
    } else if (item.productId != null) {
      context.push('/product-detail/${item.productId}');
    }
  }

  /// Gets border radius from config or uses default
  double _getBorderRadius(BuildContext context) {
    try {
      final config = _loadPromotionalConfig();
      final borderRadius = config?['border_radius'] as num?;
      if (borderRadius != null) {
        return borderRadius.toDouble();
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load border_radius from config: $e');
    }
    return context.radiusMedium;
  }

  /// Gets height from config: "short", "medium", or "tall"
  double _getHeight(BuildContext context) {
    try {
      final config = _loadPromotionalConfig();
      final heightStr = config?['height'] as String? ?? 'medium';
      
      switch (heightStr.toLowerCase()) {
        case 'short':
          return 60.0; // Short
        case 'medium':
          return 100.0; // Medium
        case 'tall':
          return 120.0; // Tall
        default:
          return 100.0; // Default: medium
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load height from config: $e');
      return 100.0; // Default: medium
    }
  }

  /// Builds a single promotional bar item
  Widget _buildPromotionalItem(
    BuildContext context,
    PromotionalBarItem item,
    bool isFirst,
    bool isLast,
  ) {
    final bgColor = _parseColor(item.backgroundColor, OsmeaColors.white);
    final textColor = _parseColor(item.textColor, OsmeaColors.thunder);
    final accentColor = _parseColor(item.accentColor, OsmeaColors.nordicBlue);
    final borderRadius = _getBorderRadius(context);
    final height = _getHeight(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleItemTap(context, item),
        child: Container(
          height: height,
          margin: EdgeInsets.only(
            left: isFirst ? 0 : context.spacing8,
            right: isLast ? 0 : context.spacing8,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: OsmeaColors.silver.withOpacity(0.3),
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(context.spacing12),
          child: OsmeaComponents.row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title and subtitle section
              Expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.title != null && item.title!.isNotEmpty)
                      OsmeaComponents.text(
                        item.title!,
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          fontSize: context.fontSizeSmall * context.textScaleFactor,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                      OsmeaComponents.sizedBox(height: context.spacing4),
                      OsmeaComponents.text(
                        item.subtitle!,
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Arrow icon at end (right side)
              OsmeaComponents.sizedBox(width: context.spacing8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadPromotionalConfig();
    final showPromotionalBar = config?['enabled'] as bool? ?? true;

    if (!showPromotionalBar) return const SizedBox.shrink();

    final items = _loadPromotionalItems();
    if (items.isEmpty || items.length < 2) return const SizedBox.shrink();

    // Take only first 2 items
    final displayItems = items.take(2).toList();

    return OsmeaComponents.padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing20,
        context.spacing16,
        context.spacing20,
        context.spacing16,
      ),
      child: OsmeaComponents.row(
        children: displayItems
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildPromotionalItem(
                context,
                item,
                index == 0,
                index == displayItems.length - 1,
              );
            })
            .toList(),
      ),
    );
  }
}

