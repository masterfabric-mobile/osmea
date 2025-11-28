/*
 * Add to Cart Popup
 * -----------------
 * Popup widget shown after successfully adding a product to cart.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

/// Shows add to cart success popup with options
void showAddToCartSuccessPopup(BuildContext context, {String? cartToken}) {
  OsmeaComponents.showPopup(
    context: context,
    variant: PopupVariant.dialog,
    size: PopupSize.small,
    title: 'Product Added to Cart',
    child: OsmeaComponents.text(
      'Product successfully added to cart.',
      textAlign: TextAlign.center,
      textStyle: OsmeaTextStyle.bodyMedium(context),
      color: OsmeaColors.thunder,
    ),
    footer: OsmeaComponents.column(
      children: [
        OsmeaComponents.button(
          text: 'Check Cart',
          variant: ButtonVariant.primary,
          size: ButtonSize.medium,
          fullWidth: true,
          onPressed: () {
            Navigator.of(context).pop();
            // Navigate to cart page with cart token in arguments
            // Use context.go instead of push since cart is in ShellRoute (bottom nav)
            // This prevents duplicate key error in Navigator
            context.go('/cart', extra: {'cartToken': cartToken});
          },
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        OsmeaComponents.button(
          text: 'Continue Shopping',
          variant: ButtonVariant.outlined,
          size: ButtonSize.medium,
          fullWidth: true,
          onPressed: () {
            Navigator.of(context).pop();
            // Just close popup, stay on product detail page
          },
        ),
      ],
    ),
  );
}







