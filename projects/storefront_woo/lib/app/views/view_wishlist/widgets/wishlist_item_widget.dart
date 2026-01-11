import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_item_price_widget.dart';

class WishlistItemWidget extends StatelessWidget {
  final WishlistItem item;
  final WishlistViewModel viewModel;
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  WishlistItemWidget({
    super.key,
    required this.item,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('wishlist_item_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Builder(
        builder: (context) {
          final dismissBgColor = _configHelper.getColor(
            'wishlist_view.dismissible.backgroundColor',
            OsmeaColors.black,
          );
          final dismissTextColor = _configHelper.getColor(
            'wishlist_view.dismissible.textColor',
            OsmeaColors.white,
          );
          final dismissIconColor = _configHelper.getColor(
            'wishlist_view.dismissible.iconColor',
            OsmeaColors.white,
          );
          final dismissTextWeight = _configHelper.getInt(
            'wishlist_view.dismissible.textFontWeight',
            600,
          );

          return OsmeaComponents.container(
            alignment: context.centerRight,
            padding: context.onlyRightPaddingNormal,
            decoration: BoxDecoration(color: dismissBgColor),
            child: OsmeaComponents.row(
              mainAxisAlignment: context.end,
              children: [
                Icon(
                  Icons.delete_outline,
                  color: dismissIconColor,
                  size: context.iconSizeNormal,
                ),
                OsmeaComponents.sizedBox(width: context.spacing8),
                OsmeaComponents.text(
                  'Remove',
                  textStyle: OsmeaTextStyle.bodyMedium(
                    context,
                  ).copyWith(
                    color: dismissTextColor,
                    fontWeight: FontWeight.values.firstWhere(
                      (w) => w.value == dismissTextWeight,
                      orElse: () => FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await OsmeaComponents.showPopup<bool>(
              context: context,
              variant: PopupVariant.dialog,
              title: 'Remove from favorites?',
              subtitle:
                  'Are you sure you want to remove this item from your favorites?',
              padding: context.paddingNormal,
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
        final snackbarTitle = _configHelper.getString(
          'wishlist_view.snackbar.title',
          'Removed from favorites',
        );
        final snackbarMessage = _configHelper.getString(
          'wishlist_view.snackbar.message',
          'Item was removed from your favorites',
        );
        final snackbarActionLabel = _configHelper.getString(
          'wishlist_view.snackbar.actionLabel',
          'Undo',
        );
        context.showSnackbar(
          title: snackbarTitle,
          message: snackbarMessage,
          type: SnackbarType.error,
          style: SnackbarStyle.minimal,
          position: SnackbarPosition.bottom,
          animation: SnackbarAnimation.slide,
          actionLabel: snackbarActionLabel,
          onAction: () => viewModel.toggle(item),
        );
      },
      child: OsmeaComponents.listItem(
        variant: ListItemVariant.standard,
        size: ListItemSize.medium,
        title: Builder(
          builder: (context) {
            final titleColor = _configHelper.getColor(
              'wishlist_view.list_item.titleColor',
              OsmeaColors.black,
            );
            final titleWeight = _configHelper.getInt(
              'wishlist_view.list_item.titleFontWeight',
              600,
            );

            return OsmeaComponents.text(
              item.name ?? 'Product',
              color: titleColor,
              textStyle: OsmeaTextStyle.titleSmall(
                context,
              ).copyWith(
                fontWeight: FontWeight.values.firstWhere(
                  (w) => w.value == titleWeight,
                  orElse: () => FontWeight.w600,
                ),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        subtitle: WishlistItemPriceWidget(item: item),
        leading: Builder(
          builder: (context) {
            final imageSize = _configHelper.getDouble(
              'wishlist_view.list_item.imageSize',
              context.width64,
            );
            final imageBorderRadius = _configHelper.getDouble(
              'wishlist_view.list_item.imageBorderRadius',
              context.radiusLow,
            );
            final placeholderBgColor = _configHelper.getColor(
              'wishlist_view.list_item.placeholderBackgroundColor',
              OsmeaColors.grayMaterial[50]!,
            );
            final placeholderIconColor = _configHelper.getColor(
              'wishlist_view.list_item.placeholderIconColor',
              OsmeaColors.grayMaterial[400]!,
            );
            final loadingIndicatorColor = _configHelper.getColor(
              'wishlist_view.list_item.loadingIndicatorColor',
              OsmeaColors.black,
            );

            return OsmeaComponents.image(
              imageUrl: item.imageUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(imageBorderRadius),
              variant: ImageVariant.normal,
              errorWidget: OsmeaComponents.container(
                width: imageSize,
                height: imageSize,
                color: placeholderBgColor,
                child: Icon(
                  Icons.image_outlined,
                  color: placeholderIconColor,
                  size: context.iconSizeNormal,
                ),
              ),
              placeholder: OsmeaComponents.container(
                width: imageSize,
                height: imageSize,
                color: placeholderBgColor,
                alignment: context.center,
                child: CircularProgressIndicator(
                  strokeWidth: context.width2,
                  valueColor: AlwaysStoppedAnimation<Color>(loadingIndicatorColor),
                ),
              ),
            );
          },
        ),
        trailing: Builder(
          builder: (context) {
            final cartIconColor = _configHelper.getColor(
              'wishlist_view.action_buttons.cartButton.iconColor',
              OsmeaColors.black,
            );
            final cartBgColor = _configHelper.getColor(
              'wishlist_view.action_buttons.cartButton.backgroundColor',
              OsmeaColors.white,
            );
            final cartBorderColor = _configHelper.getColor(
              'wishlist_view.action_buttons.cartButton.borderColor',
              OsmeaColors.silver,
            );
            final cartBorderRadius = _configHelper.getDouble(
              'wishlist_view.action_buttons.cartButton.borderRadius',
              context.spacing4,
            );
            final favoriteIconColor = _configHelper.getColor(
              'wishlist_view.action_buttons.favoriteButton.iconColor',
              OsmeaColors.black,
            );
            final buttonSpacing = _configHelper.getDouble(
              'wishlist_view.action_buttons.spacing',
              context.spacing4,
            );
            final snackbarTitle = _configHelper.getString(
              'wishlist_view.snackbar.title',
              'Removed from favorites',
            );
            final snackbarMessage = _configHelper.getString(
              'wishlist_view.snackbar.message',
              'Item was removed from your favorites',
            );
            final snackbarActionLabel = _configHelper.getString(
              'wishlist_view.snackbar.actionLabel',
              'Undo',
            );

            return OsmeaComponents.row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cart button
                OsmeaComponents.iconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    size: context.iconSizeSmall,
                    color: cartIconColor,
                  ),
                  variant: ButtonVariant.outlined,
                  size: ButtonSize.extraSmall,
                  backgroundColor: cartBgColor,
                  borderColor: cartBorderColor,
                  borderRadius: cartBorderRadius,
                  onPressed: () => viewModel.promptAddToCartOptions(item),
                ),
                OsmeaComponents.sizedBox(width: buttonSpacing),
                // Favorite button
                OsmeaComponents.iconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: favoriteIconColor,
                    size: context.iconSizeSmall,
                  ),
                  size: ButtonSize.extraSmall,
                  variant: ButtonVariant.ghost,
                  onPressed: () {
                    viewModel.remove(item.id);
                    context.showSnackbar(
                      title: snackbarTitle,
                      message: snackbarMessage,
                      type: SnackbarType.error,
                      style: SnackbarStyle.minimal,
                      position: SnackbarPosition.bottom,
                      animation: SnackbarAnimation.slide,
                      actionLabel: snackbarActionLabel,
                      onAction: () => viewModel.toggle(item),
                    );
                  },
                ),
              ],
            );
          },
        ),
        padding: context.paddingLow,
        margin: context.paddingZero,
      ),
    );
  }
}
