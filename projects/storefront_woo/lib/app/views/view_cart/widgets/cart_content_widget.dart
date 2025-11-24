/*
 * Cart Content Widget
 * -------------------
 * Main content widget for cart view displaying cart items, coupons, and summary.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_empty_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_item_swipe_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/coupon_section_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/order_summary_widget.dart';

/// Main content widget for cart view
class CartContentWidget extends StatelessWidget {
  final CartViewModel viewModel;
  final CartLoadedState state;

  const CartContentWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.cartItems.isEmpty) {
      return const CartEmptyWidget();
    }

    return OsmeaComponents.singleChildScrollView(
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.sizedBox(height: context.spacing12),
          ..._buildCartItems(context),
          OsmeaComponents.sizedBox(height: context.spacing12),
          CouponSectionWidget(
            viewModel: viewModel,
            state: state,
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          OrderSummaryWidget(state: state),
          OsmeaComponents.sizedBox(height: context.spacing12),
        ],
      ),
    );
  }

  List<Widget> _buildCartItems(BuildContext context) {
    return state.cartItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return OsmeaComponents.column(
        children: [
          CartItemSwipeWidget(
            item: item,
            viewModel: viewModel,
            state: state,
          ),
          if (index < state.cartItems.length - 1)
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

