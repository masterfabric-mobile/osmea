/*
 * Coupon Section Widget
 * ---------------------
 * Widget for coupon section with applied coupons and input.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/applied_coupon_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/coupon_input_widget.dart';

/// Widget for coupon section
class CouponSectionWidget extends StatelessWidget {
  final CartViewModel viewModel;
  final CartLoadedState state;

  const CouponSectionWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        if (state.coupons.isNotEmpty) ...[
          ...state.coupons.map(
            (coupon) => AppliedCouponWidget(
              coupon: coupon,
              viewModel: viewModel,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
        ],
        CouponInputWidget(viewModel: viewModel),
      ],
    );
  }
}

