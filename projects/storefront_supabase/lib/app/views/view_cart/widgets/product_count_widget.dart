/*
 * Product Count Widget
 * --------------------
 * Widget displaying total product count in cart.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_cart/models/module/states.dart';

/// Widget displaying product count
class ProductCountWidget extends StatelessWidget {
  final CartLoadedState state;

  const ProductCountWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = state.totalItems;
    
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      padding: context.paddingNormal,
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: context.borderRadiusNormal,
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: OsmeaTextStyle.bodyMedium(context).copyWith(
            color: OsmeaColors.thunder,
          ),
          children: [
            TextSpan(text: 'Your shopping cart contains a total of '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing8,
                  vertical: context.spacing2,
                ),
                margin: EdgeInsets.symmetric(horizontal: context.spacing4),
                decoration: BoxDecoration(
                  color: OsmeaColors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(context.borderRadiusLow.topLeft.x),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: totalItems.toString(),
                        style: OsmeaTextStyle.bodyMedium(context).copyWith(
                          color: OsmeaColors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' ${totalItems == 1 ? 'product' : 'products'}',
                        style: OsmeaTextStyle.bodyMedium(context).copyWith(
                          color: OsmeaColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            TextSpan(text: ' in this order'),
          ],
        ),
      ),
    );
  }
}
