import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';

class WishlistErrorWidget extends StatelessWidget {
  final String message;
  final WishlistViewModel viewModel;

  const WishlistErrorWidget({
    super.key,
    required this.message,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: OsmeaColors.pewter.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline,
              size: 44,
              color: OsmeaColors.pewter,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            'Unable to Load Saved Items',
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.w700,
              color: OsmeaColors.thunder,
            ),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          OsmeaComponents.text(
            message,
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: OsmeaColors.pewter),
            textAlign: TextAlign.center,
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.button(
            text: 'Try Again',
            variant: ButtonVariant.primary,
            onPressed: () => viewModel.syncFromServer(),
          ),
        ],
      ),
    );
  }
}




