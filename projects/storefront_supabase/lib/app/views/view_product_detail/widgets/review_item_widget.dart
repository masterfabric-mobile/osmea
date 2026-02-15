/*
 * Review Item Widget
 * ------------------
 * Widget for displaying individual product review items.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:intl/intl.dart';
import 'package:storefront_supabase/app/models/product_review.dart';

/// Widget for displaying a single product review
class ReviewItemWidget extends StatelessWidget {
  final ProductReview review;

  const ReviewItemWidget({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      margin: context.onlyBottomPaddingLow,
      padding: context.paddingLow,
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: context.borderRadiusNormal,
        border: Border.all(
          color: OsmeaColors.silver,
          width: context.width1,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Reviewer info and rating
          OsmeaComponents.row(
            children: [
              // Avatar placeholder
              Container(
                width: context.width40,
                height: context.height40,
                decoration: BoxDecoration(
                  color: OsmeaColors.grayMaterial[200],
                  borderRadius: BorderRadius.circular(context.spacing20),
                ),
                child: Icon(
                  Icons.person,
                  color: OsmeaColors.grayMaterial[400]!,
                  size: context.iconSizeSmall,
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing10),
              // Reviewer name and rating
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: context.crossStart,
                  children: [
                    OsmeaComponents.text(
                      review.authorName,
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                      ),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    OsmeaComponents.row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: OsmeaColors.black,
                            size: context.iconSizeExtraSmall,
                          );
                        }),
                        OsmeaComponents.sizedBox(width: context.spacing8),
                        OsmeaComponents.text(
                          '${review.rating}/5',
                          textStyle: OsmeaTextStyle.bodySmall(
                            context,
                          ).copyWith(color: OsmeaColors.grayMaterial[400]!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Verified badge
              if (review.isVerifiedPurchase)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing8,
                    vertical: context.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.spacing8),
                  ),
                  child: OsmeaComponents.text(
                    'Verified',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing6),
          // Review title
          if (review.title != null && review.title!.isNotEmpty)
             OsmeaComponents.text(
               review.title!,
               textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                 fontWeight: FontWeight.bold
               ),
             ),
          if (review.title != null && review.title!.isNotEmpty)
             OsmeaComponents.sizedBox(height: context.spacing4),
          // Review text
          if (review.comment != null && review.comment!.isNotEmpty)
            OsmeaComponents.text(review.comment!),
          // Review date
          OsmeaComponents.sizedBox(height: context.spacing6),
          OsmeaComponents.text(
            DateFormat.yMMMd().format(review.createdAt),
            textStyle: OsmeaTextStyle.bodySmall(
              context,
            ).copyWith(color: OsmeaColors.grayMaterial[400]!),
          ),
          
          // Delivery Review (black/white, no shadow)
          if (review.deliveryRating != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.divider(height: 1, color: OsmeaColors.silver),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.row(
              children: [
                Icon(Icons.local_shipping, size: 16, color: OsmeaColors.black),
                OsmeaComponents.sizedBox(width: context.spacing8),
                OsmeaComponents.text(
                  'Delivery: ${review.deliveryRating}/5',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.black,
                  ),
                ),
              ],
            ),
            if (review.deliveryComment != null && review.deliveryComment!.isNotEmpty) ...[
              OsmeaComponents.sizedBox(height: context.spacing4),
              OsmeaComponents.text(
                review.deliveryComment!,
                textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
