/*
 * Product Reviews Section Widget
 * ------------------------------
 * Widget for displaying product reviews section with empty state.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/review_item_widget.dart';

/// Widget for displaying product reviews section
class ProductReviewsSectionWidget extends StatelessWidget {
  final ProductDetailLoadedState state;

  const ProductReviewsSectionWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Filter reviews to ensure they belong to the current product
    final currentProductId = state.product.id;
    final validReviews = state.reviews.where((review) {
      if (currentProductId == null) return false;
      final reviewProductId = review.productId;
      if (reviewProductId == null) {
        debugPrint('⚠️ Widget: Review has null productId, excluding it');
        return false;
      }
      if (reviewProductId != currentProductId) {
        debugPrint(
          '⚠️ Widget: Review productId mismatch! Review productId: $reviewProductId, Current product ID: $currentProductId - EXCLUDING this review',
        );
        return false;
      }
      return true;
    }).toList();

    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        OsmeaComponents.text(
          validReviews.isEmpty ? 'Reviews' : 'Reviews (${validReviews.length})',
          textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: OsmeaColors.black,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing6),
        if (validReviews.isEmpty)
          _EmptyReviewsWidget()
        else ...[
          ...validReviews.map((review) => ReviewItemWidget(review: review)),
          OsmeaComponents.sizedBox(height: context.spacing12),
        ],
      ],
    );
  }
}

/// Widget for displaying empty reviews state
class _EmptyReviewsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      margin: context.onlyBottomPaddingNormal,
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing16,
      ),
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[50],
        borderRadius: context.borderRadiusNormal,
        border: Border.all(
          color: OsmeaColors.grayMaterial[200]!,
          width: context.width1,
        ),
      ),
      child: OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: context.crossCenter,
          children: [
            Icon(
              Icons.reviews_outlined,
              size: context.iconSizeHigh,
              color: OsmeaColors.grayMaterial[400]!,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              'No reviews yet',
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w500,
                color: OsmeaColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing2),
            OsmeaComponents.text(
              'No reviews have been made for this product yet.',
              textStyle: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(color: OsmeaColors.grayMaterial[400]!),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

