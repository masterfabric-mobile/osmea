/*
 * Cart Content Widget
 * -------------------
 * Main content widget for cart view displaying cart items, coupons, and summary.
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_empty_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_item_swipe_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/coupon_section_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/product_count_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/collapsible_order_summary_widget.dart';

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
        _bottomWidgetHeight = renderBox.size.height + MediaQuery.of(context).padding.bottom;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.cartItems.isEmpty) {
      return const CartEmptyWidget();
    }

    // Calculate responsive bottom padding
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    // Use a percentage of screen height or measured height, whichever is larger
    final responsiveBottomPadding = (_bottomWidgetHeight + safeAreaBottom + context.spacing16)
        .clamp(200.0, screenHeight * 0.3);

    return Stack(
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
                  color: OsmeaColors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        // Fixed bottom collapsible summary
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
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
              color: OsmeaColors.grayMaterial[200],
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

