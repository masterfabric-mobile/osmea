/*
 * Cart Content Widget
 * -------------------
 * Main content widget for cart view displaying cart items, coupons, and summary.
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_supabase/app/views/view_cart/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/cart_empty_widget.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/cart_item_swipe_widget.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/coupon_section_widget.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/product_count_widget.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/collapsible_order_summary_widget.dart';

/// Main content widget for cart view
class CartContentWidget extends StatefulWidget {
  final CartViewModel viewModel;
  final CartLoadedState state;

  const CartContentWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  State<CartContentWidget> createState() => _CartContentWidgetState();
}

class _CartContentWidgetState extends State<CartContentWidget> {
  final GlobalKey _bottomWidgetKey = GlobalKey();
  double _bottomWidgetHeight = 200; // Default fallback height
  bool _isSummaryExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureBottomWidget();
    });
  }

  void _measureBottomWidget() {
    final RenderBox? renderBox =
        _bottomWidgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        _bottomWidgetHeight = renderBox.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.cartItems.isEmpty) {
      return const CartEmptyWidget();
    }

    // Get navbar height from config (for padding calculation)
    final navbarHeight = _getNavbarHeight(context);
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    
    // Calculate responsive bottom padding
    final screenHeight = MediaQuery.of(context).size.height;
    // Use a percentage of screen height or measured height, whichever is larger
    // Account for navbar height and safe area in padding
    final responsiveBottomPadding = (_bottomWidgetHeight + navbarHeight + safeAreaBottom + context.spacing16)
        .clamp(200.0, screenHeight * 0.3);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            children: [
              // Scrollable content
              OsmeaComponents.singleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: OsmeaComponents.column(
                  children: [
                    OsmeaComponents.sizedBox(height: context.spacing12),
                    ..._buildCartItems(context),
                    OsmeaComponents.sizedBox(height: context.spacing12),
                    // Product count widget before coupon section
                    ProductCountWidget(state: widget.state),
                    OsmeaComponents.sizedBox(height: context.spacing12),
                    CouponSectionWidget(
                      viewModel: widget.viewModel,
                      state: widget.state,
                    ),
                    // Responsive bottom padding to account for fixed bottom summary
                    OsmeaComponents.sizedBox(height: responsiveBottomPadding),
                  ],
                ),
              ),
              // Blur overlay when summary is expanded
              if (_isSummaryExpanded)
                Positioned.fill(
                  child: IgnorePointer(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        color: _getBlurOverlayColor(context),
                      ),
                    ),
                  ),
                ),
              // Fixed bottom collapsible summary - positioned at bottom (above navbar)
              // Note: Scaffold's body already accounts for navbar, so bottom: 0 is correct
              Positioned(
                left: 0,
                right: 0,
                bottom: 0, // Position at bottom of body (which is above navbar)
                child: _BottomWidgetMeasurer(
                  key: _bottomWidgetKey,
                  onHeightChanged: _measureBottomWidget,
                  child: CollapsibleOrderSummaryWidget(
                    viewModel: widget.viewModel,
                    state: widget.state,
                    onExpandedChanged: (isExpanded) {
                      setState(() {
                        _isSummaryExpanded = isExpanded;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCartItems(BuildContext context) {
    return widget.state.cartItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return OsmeaComponents.column(
        children: [
          CartItemSwipeWidget(
            item: item,
            viewModel: widget.viewModel,
            state: widget.state,
          ),
          if (index < widget.state.cartItems.length - 1)
            OsmeaComponents.container(
              margin: EdgeInsets.symmetric(horizontal: context.spacing16),
              height: context.height1,
              color: _getSeparatorColor(context),
            ),
        ],
      );
    }).toList();
  }
}

/// Widget that measures its child's height and reports it
class _BottomWidgetMeasurer extends StatefulWidget {
  final Widget child;
  final VoidCallback onHeightChanged;

  const _BottomWidgetMeasurer({
    super.key,
    required this.child,
    required this.onHeightChanged,
  });

  @override
  State<_BottomWidgetMeasurer> createState() => _BottomWidgetMeasurerState();
}

class _BottomWidgetMeasurerState extends State<_BottomWidgetMeasurer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onHeightChanged();
    });
  }

  @override
  void didUpdateWidget(_BottomWidgetMeasurer oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onHeightChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Helper methods for cart content widget
extension _CartContentWidgetHelpers on _CartContentWidgetState {
  /// Gets navbar height from config
  double _getNavbarHeight(BuildContext context) {
    try {
      final configHelper = AssetConfigHelper();
      final navbarConfig = configHelper.getObject('navbar_configuration');
      final sizeString = navbarConfig?['size'] as String? ?? 'medium';
      
      // Map size string to NavbarSize and get height
      switch (sizeString.toLowerCase()) {
        case 'small':
          return 56.0;
        case 'medium':
          return 64.0;
        case 'large':
          return 72.0;
        default:
          return 64.0; // Default to medium
      }
    } catch (e) {
      debugPrint('⚠️ Error getting navbar height: $e');
      return 64.0; // Default to medium size
    }
  }

  /// Gets blur overlay color from config
  Color _getBlurOverlayColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final colorString = configHelper.getString(
      'cart_view_configuration.loading_overlay.background_color',
      '#FFFFFF',
    );
    return _parseColor(colorString).withValues(alpha: 0.3);
  }

  /// Gets separator color from config
  Color _getSeparatorColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.cart_items.separator_color',
        '#E5E5E5',
      ),
    );
  }

  /// Parses color string to Color
  Color _parseColor(String colorString) {
    try {
      // Remove # if present
      String hex = colorString.replaceAll('#', '');
      
      // Handle ARGB format (8 characters)
      if (hex.length == 8) {
        final alpha = int.parse(hex.substring(0, 2), radix: 16);
        final red = int.parse(hex.substring(2, 4), radix: 16);
        final green = int.parse(hex.substring(4, 6), radix: 16);
        final blue = int.parse(hex.substring(6, 8), radix: 16);
        return Color.fromARGB(alpha, red, green, blue);
      }
      
      // Handle RGB format (6 characters)
      if (hex.length == 6) {
        final red = int.parse(hex.substring(0, 2), radix: 16);
        final green = int.parse(hex.substring(2, 4), radix: 16);
        final blue = int.parse(hex.substring(4, 6), radix: 16);
        return Color.fromRGBO(red, green, blue, 1.0);
      }
      
      // Fallback to gray
      return OsmeaColors.grayMaterial[200] ?? OsmeaColors.pewter;
    } catch (e) {
      debugPrint('⚠️ Error parsing color: $colorString - $e');
      return OsmeaColors.grayMaterial[200] ?? OsmeaColors.pewter;
    }
  }
}
