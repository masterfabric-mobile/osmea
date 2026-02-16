/*
 * Product Reviews With Form Widget
 * --------------------------------
 * Same UI as before: Reviews list first. Below, a compact "Add review" box (when logged in).
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/product_reviews_section_widget.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class ProductReviewsWithFormWidget extends StatefulWidget {
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;

  const ProductReviewsWithFormWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  State<ProductReviewsWithFormWidget> createState() => _ProductReviewsWithFormWidgetState();
}

class _ProductReviewsWithFormWidgetState extends State<ProductReviewsWithFormWidget> {
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    final productId = widget.state.product.id;
    if (widget.viewModel.reviewCommentController.text.trim().isEmpty) {
      if (mounted) context.snackbarWarning(context.resources.fillRequiredFields);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final ok = await widget.viewModel.submitReview(productId);
      if (!mounted) return;
      if (ok) {
        context.showSnackbar(
          message: context.resources.reviewSubmitted,
          type: SnackbarType.success,
        );
        setState(() {});
      } else {
        context.snackbarWarning(context.resources.failedSubmitReview);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;

    // Same padding as original ProductReviewsWidget – UI unchanged for the list
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing4,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // 1. Existing reviews section (unchanged)
          ProductReviewsSectionWidget(state: widget.state),
          OsmeaComponents.sizedBox(height: context.spacing16),
          // 2. Add review – compact box, same style as empty state
          if (isLoggedIn)
            OsmeaComponents.container(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing12,
                vertical: context.spacing16,
              ),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: context.borderRadiusNormal,
                border: Border.all(color: OsmeaColors.silver, width: 1),
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: context.crossStart,
                children: [
                  OsmeaComponents.text(
                    resources.writeReview,
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.black,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  OsmeaComponents.text(
                    resources.rating,
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.black),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing4),
                  Row(
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      return GestureDetector(
                        onTap: () => widget.viewModel.setRating(star.toDouble()),
                        child: Padding(
                          padding: EdgeInsets.only(right: context.spacing4),
                          child: Icon(
                            star <= widget.viewModel.currentRating.toInt() ? Icons.star : Icons.star_border,
                            color: OsmeaColors.black,
                            size: 24,
                          ),
                        ),
                      );
                    }),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  OsmeaComponents.textField(
                    controller: widget.viewModel.reviewTitleController,
                    label: resources.reviewTitle,
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    type: TextFieldType.text,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: widget.viewModel.reviewCommentController,
                    label: 'Comment',
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    type: TextFieldType.multiline,
                    maxLines: 2,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing16),
                  OsmeaComponents.text(
                    'Delivery',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.black,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing4),
                  Row(
                    children: List.generate(5, (i) {
                      final star = i + 1;
                      return GestureDetector(
                        onTap: () => widget.viewModel.setDeliveryRating(star.toDouble()),
                        child: Padding(
                          padding: EdgeInsets.only(right: context.spacing4),
                          child: Icon(
                            star <= widget.viewModel.currentDeliveryRating.toInt() ? Icons.star : Icons.star_border,
                            color: OsmeaColors.black,
                            size: 24,
                          ),
                        ),
                      );
                    }),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  OsmeaComponents.textField(
                    controller: widget.viewModel.deliveryReviewCommentController,
                    label: 'Delivery comment (optional)',
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    type: TextFieldType.multiline,
                    maxLines: 2,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing16),
                  OsmeaComponents.button(
                    text: resources.submitReview,
                    variant: ButtonVariant.primary,
                    backgroundColor: OsmeaColors.black,
                    textColor: OsmeaColors.white,
                    onPressed: _isSubmitting ? null : _submitReview,
                  ),
                ],
              ),
            )
          else
            OsmeaComponents.text(
              'Log in to add a review.',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.grayMaterial[400]!),
            ),
        ],
      ),
    );
  }
}
