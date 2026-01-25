/*
 * Review Item Widget
 * ------------------
 * Widget for displaying individual product review items.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/freezed_model/response/list_product_reviews_response_model.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Widget for displaying a single product review
class ReviewItemWidget extends StatelessWidget {
  final ListProductReviewsResponseModel review;

  const ReviewItemWidget({
    super.key,
    required this.review,
  });

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString('product_detail_view.reviews.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load reviews color $key: $e');
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getColorFromConfig('backgroundColor', OsmeaColors.white);
    final borderColor = _getColorFromConfig('borderColor', OsmeaColors.silver);
    final starColor = _getColorFromConfig('starColor', OsmeaColors.black);
    final textColor = _getColorFromConfig('textColor', OsmeaColors.black);
    final nameColor = _getColorFromConfig('nameColor', OsmeaColors.black);
    final dateColor = _getColorFromConfig('dateColor', OsmeaColors.grayMaterial[400]!);
    final verifiedBadgeColor = _getColorFromConfig('verifiedBadgeColor', OsmeaColors.black);
    final verifiedBadgeTextColor = _getColorFromConfig('verifiedBadgeTextColor', OsmeaColors.white);
    
    return OsmeaComponents.container(
      margin: context.onlyBottomPaddingLow,
      padding: context.paddingLow,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: context.borderRadiusNormal,
        border: Border.all(
          color: borderColor,
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
                OsmeaComponents.image(
                  imageUrl: review.reviewerAvatarUrls!.the48,
                  width: context.width40,
                  height: context.height40,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(context.spacing20),
                  variant: ImageVariant.normal,
                  cacheWidth: 80, // Limit image size for performance
                  showLoadingIndicator: true,
                  errorWidget: Container(
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
                      color: textColor.withOpacity(0.5),
                      size: context.iconSizeSmall,
                    ),
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
                      review.reviewer ?? context.t.productDetailView.reviews.anonymous,
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                        color: nameColor,
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
                              color: starColor,
                              size: context.iconSizeExtraSmall,
                            );
                          }),
                          OsmeaComponents.sizedBox(width: context.spacing8),
                          OsmeaComponents.text(
                            '${review.rating}/5',
                            textStyle: OsmeaTextStyle.bodySmall(
                              context,
                            ).copyWith(color: dateColor),
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
                    color: verifiedBadgeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(context.spacing8),
                  ),
                  child: OsmeaComponents.text(
                    context.t.productDetailView.reviews.verified,
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: verifiedBadgeTextColor,
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
              ).copyWith(color: OsmeaColors.grayMaterial[400]!),
            ),
          ],
        ],
      ),
    );
  }
}

