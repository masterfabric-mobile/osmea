/*
 * Applied Coupon Widget
 * ---------------------
 * Widget for displaying applied coupon with remove option.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/gen/translations.g.dart';

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
        vertical: context.spacing8,
      ),
      decoration: BoxDecoration(
        color: OsmeaColors.snow,
        borderRadius: context.borderRadiusNormal,
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: OsmeaComponents.padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing12,
          vertical: context.spacing10,
        ),
        child: OsmeaComponents.row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OsmeaComponents.row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: OsmeaColors.forestHeart,
                  size: context.iconSizeSmall,
                ),
                OsmeaComponents.sizedBox(width: context.spacing8),
                OsmeaComponents.text(
                  couponCode.toUpperCase(),
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w500,
                    color: OsmeaColors.thunder,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            OsmeaComponents.iconButton(
              onPressed: () => viewModel.removeCoupon(couponCode),
              icon: Icon(
                Icons.close_rounded,
                color: OsmeaColors.pewter,
                size: context.iconSizeSmall,
              ),
              backgroundColor: Colors.transparent,
              tooltip: context.t.cartView.widgets.coupon.removeTooltip,
            ),
          ],
        ),
      ),
    );
  }
}
