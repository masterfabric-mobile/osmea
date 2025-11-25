/*
 * Review Item Widget
 * ------------------
 * Widget for displaying individual product review items.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/freezed_model/response/list_product_reviews_response_model.dart';

/// Widget for displaying a single product review
class ReviewItemWidget extends StatelessWidget {
  final ListProductReviewsResponseModel review;

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
          color: OsmeaColors.grayMaterial[200]!,
          width: context.width1,
        ),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Reviewer info and rating
          OsmeaComponents.row(
            children: [
              // Avatar
              if (review.reviewerAvatarUrls?.the48 != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(context.spacing20),
                  child: Image.network(
                    review.reviewerAvatarUrls!.the48!,
                    width: context.width40,
                    height: context.height40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: context.width40,
                        height: context.height40,
                        decoration: BoxDecoration(
                          color: OsmeaColors.grayMaterial[200],
                          borderRadius: BorderRadius.circular(
                            context.spacing20,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: OsmeaColors.pewter,
                          size: context.iconSizeSmall,
                        ),
                      );
                    },
                  ),
                )
              else
                Container(
                  width: context.width40,
                  height: context.height40,
                  decoration: BoxDecoration(
                    color: OsmeaColors.grayMaterial[200],
                    borderRadius: BorderRadius.circular(context.spacing20),
                  ),
                  child: Icon(
                    Icons.person,
                    color: OsmeaColors.pewter,
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
                      review.reviewer ?? 'Anonymous',
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    if (review.rating != null) ...[
                      OsmeaComponents.sizedBox(height: context.spacing4),
                      OsmeaComponents.row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < (review.rating ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: OsmeaColors.nordicBlue,
                              size: context.iconSizeExtraSmall,
                            );
                          }),
                          OsmeaComponents.sizedBox(width: context.spacing8),
                          OsmeaComponents.text(
                            '${review.rating}/5',
                            textStyle: OsmeaTextStyle.bodySmall(
                              context,
                            ).copyWith(color: OsmeaColors.pewter),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Verified badge
              if (review.verified == true)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing8,
                    vertical: context.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.nordicBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.spacing8),
                  ),
                  child: OsmeaComponents.text(
                    'Verified',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.nordicBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing6),
          // Review text (HTML formatted)
          if (review.review != null && review.review!.isNotEmpty)
            WebViewerHelper.html(review.review!),
          // Review date
          if (review.formattedDateCreated != null ||
              review.dateCreated != null) ...[
            OsmeaComponents.sizedBox(height: context.spacing6),
            OsmeaComponents.text(
              review.formattedDateCreated ?? review.dateCreated ?? '',
              textStyle: OsmeaTextStyle.bodySmall(
                context,
              ).copyWith(color: OsmeaColors.pewter),
            ),
          ],
        ],
      ),
    );
  }
}

