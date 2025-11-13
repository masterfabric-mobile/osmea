import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_item_price_widget.dart';

class WishlistItemWidget extends StatelessWidget {
  final WishlistItem item;
  final WishlistViewModel viewModel;

  const WishlistItemWidget({
    super.key,
    required this.item,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('wishlist_item_${item.id}'),
      direction: DismissDirection.endToStart,
      background: OsmeaComponents.container(
        alignment: centerRight,
        padding: EdgeInsets.only(right: context.spacing20),
        decoration: BoxDecoration(color: OsmeaColors.red),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete_outline, color: OsmeaColors.white, size: 24),
            SizedBox(width: context.spacing8),
            Text(
              'Remove',
              style: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog<bool>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text('Remove from favorites?'),
                  content: Text(
                    'Are you sure you want to remove this item from your favorites?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.of(dialogContext).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(dialogContext).pop(true),
                      style: TextButton.styleFrom(
                        foregroundColor: OsmeaColors.red,
                      ),
                      child: Text('Remove'),
                    ),
                  ],
                );
              },
            ) ??
            false;
      },
      onDismissed: (direction) {
        // Remove from wishlist
        viewModel.remove(item.id);
        // Show snackbar with Undo
        context.showSnackbar(
          title: 'Removed from favorites',
          message: 'Item was removed from your favorites',
          type: SnackbarType.error,
          style: SnackbarStyle.minimal,
          position: SnackbarPosition.bottom,
          animation: SnackbarAnimation.slide,
          actionLabel: 'Undo',
          onAction: () => viewModel.toggle(item),
        );
      },
      child: OsmeaComponents.container(
        padding: context.paddingLow,
        child: OsmeaComponents.row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            OsmeaComponents.image(
              imageUrl: item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(context.radiusLow),
              variant: ImageVariant.normal,
              errorWidget: Container(
                width: 80,
                height: 80,
                color: OsmeaColors.pewter.withOpacity(0.1),
                child: Icon(
                  Icons.image_outlined,
                  color: OsmeaColors.pewter,
                  size: 32,
                ),
              ),
              placeholder: Container(
                width: 80,
                height: 80,
                color: OsmeaColors.pewter.withOpacity(0.1),
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    OsmeaColors.nordicBlue,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.spacing12),

            // Title + price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OsmeaComponents.text(
                    item.name ?? 'Product',
                    textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                      color: OsmeaColors.thunder,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.spacing6),
                  WishlistItemPriceWidget(item: item),
                ],
              ),
            ),

            SizedBox(width: context.spacing8),

            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cart button
                OsmeaComponents.iconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: context.iconSizeSmall,
                    color: OsmeaColors.nordicBlue,
                  ),
                  variant: ButtonVariant.outlined,
                  size: ButtonSize.extraSmall,
                  backgroundColor: OsmeaColors.nordicBlue.withOpacity(0.1),
                  borderRadius: 4,
                  onPressed: () => viewModel.promptAddToCartOptions(item),
                ),
                CoreSpacer(CoreSpacerType.horizontal),
                // Favorite button
                OsmeaComponents.iconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: OsmeaColors.nordicBlue,
                    size: context.iconSizeSmall,
                  ),
                  size: ButtonSize.extraSmall,
                  borderRadius: 4,
                  variant: ButtonVariant.outlined,
                  onPressed: () {
                    viewModel.remove(item.id);
                    context.showSnackbar(
                      title: 'Removed from favorites',
                      message: 'Item was removed from your favorites',
                      type: SnackbarType.error,
                      style: SnackbarStyle.minimal,
                      position: SnackbarPosition.bottom,
                      animation: SnackbarAnimation.slide,
                      actionLabel: 'Undo',
                      onAction: () => viewModel.toggle(item),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




