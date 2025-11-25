/*
 * Applied Coupon Widget
 * ---------------------
 * Widget for displaying applied coupon with remove option.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';

/// Widget for displaying applied coupon
class AppliedCouponWidget extends StatelessWidget {
  final dynamic coupon;
  final CartViewModel viewModel;

  const AppliedCouponWidget({
    super.key,
    required this.coupon,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final couponCode = coupon.code ?? '';

    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing4,
      ),
      decoration: BoxDecoration(
        color: OsmeaColors.nordicBlue,
        borderRadius: context.borderRadiusNormal,
      ),
      child: OsmeaComponents.padding(
        padding: context.paddingLow,
        child: OsmeaComponents.row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: OsmeaColors.nordicBlue,
              size: context.iconSizeSmall,
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            OsmeaComponents.expanded(
              child: OsmeaComponents.text(
                couponCode.toUpperCase(),
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.nordicBlue,
                ),
              ),
            ),
            OsmeaComponents.iconButton(
              onPressed: () => viewModel.removeCoupon(couponCode),
              icon: Icon(
                Icons.close_rounded,
                color: OsmeaColors.pewter,
                size: context.iconSizeExtraSmall,
              ),
              backgroundColor: Colors.transparent,
              tooltip: 'Remove coupon',
            ),
          ],
        ),
      ),
    );
  }
}

