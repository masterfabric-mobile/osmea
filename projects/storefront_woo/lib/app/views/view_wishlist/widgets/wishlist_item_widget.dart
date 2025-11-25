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
        decoration: BoxDecoration(color: OsmeaColors.amberFlame),
        child: OsmeaComponents.row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.delete_outline,
              color: OsmeaColors.white,
              size: context.iconSizeNormal,
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            OsmeaComponents.text(
              'Remove',
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await OsmeaComponents.showPopup<bool>(
              context: context,
              variant: PopupVariant.dialog,
              title: 'Remove from favorites?',
              subtitle:
                  'Are you sure you want to remove this item from your favorites?',
              padding: EdgeInsets.all(context.spacing16),
              child: OsmeaComponents.column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OsmeaComponents.row(
                    children: [
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.button(
                          text: 'Cancel',
                          variant: ButtonVariant.outlined,
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing8),
                      OsmeaComponents.expanded(
                        child: OsmeaComponents.button(
                          text: 'Remove',
                          variant: ButtonVariant.primary,
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
      child: OsmeaComponents.listItem(
        variant: ListItemVariant.standard,
        size: ListItemSize.medium,
        title: OsmeaComponents.text(
          item.name ?? 'Product',
          textStyle: OsmeaTextStyle.titleSmall(
            context,
          ).copyWith(color: OsmeaColors.thunder, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: WishlistItemPriceWidget(item: item),
        leading: OsmeaComponents.image(
          imageUrl: item.imageUrl,
          width: context.width64,
          height: context.height64,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(context.radiusLow),
          variant: ImageVariant.normal,
          errorWidget: OsmeaComponents.container(
            width: context.width64,
            height: context.height64,
            color: OsmeaColors.pewter.withOpacity(0.1),
            child: Icon(
              Icons.image_outlined,
              color: OsmeaColors.pewter,
              size: context.iconSizeNormal,
            ),
          ),
          placeholder: OsmeaComponents.container(
            width: context.width64,
            height: context.height64,
            color: OsmeaColors.pewter.withOpacity(0.1),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: context.width2,
              valueColor: AlwaysStoppedAnimation<Color>(OsmeaColors.nordicBlue),
            ),
          ),
        ),
        trailing: OsmeaComponents.row(
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
              borderRadius: context.spacing4,
              onPressed: () => viewModel.promptAddToCartOptions(item),
            ),
            OsmeaComponents.sizedBox(width: context.spacing4),
            // Favorite button
            OsmeaComponents.iconButton(
              icon: Icon(
                Icons.favorite,
                color: OsmeaColors.nordicBlue,
                size: context.iconSizeSmall,
              ),
              size: ButtonSize.extraSmall,
              borderRadius: context.spacing4,
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
        padding: context.paddingLow,
        margin: EdgeInsets.zero,
      ),
    );
  }
}
