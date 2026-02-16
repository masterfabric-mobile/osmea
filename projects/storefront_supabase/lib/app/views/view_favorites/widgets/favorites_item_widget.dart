import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/favorites_view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/widgets/favorites_item_price_widget.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

/// Woo-style favorite list item: image, title, price, cart + favorite buttons.
class FavoritesItemWidget extends StatelessWidget {
  final Product product;
  final FavoritesViewModel viewModel;
  final void Function(String path) goRoute;

  const FavoritesItemWidget({
    super.key,
    required this.product,
    required this.viewModel,
    required this.goRoute,
  });

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    // Custom row with constrained middle so trailing does not overflow; tap opens product detail
    return Material(
      color: OsmeaColors.white,
      child: InkWell(
        onTap: () => goRoute('/product-detail/${product.id}'),
        child: Padding(
          padding: context.paddingLow,
          child: ClipRect(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.radiusLow),
                child: OsmeaComponents.image(
                  imageUrl: product.imageUrl,
                  width: context.width64,
                  height: context.width64,
                  fit: BoxFit.cover,
                  variant: ImageVariant.normal,
                  errorWidget: OsmeaComponents.container(
                    width: context.width64,
                    height: context.width64,
                    color: OsmeaColors.grayMaterial[50]!,
                    child: Icon(
                      Icons.image_outlined,
                      color: OsmeaColors.grayMaterial[400]!,
                      size: context.iconSizeNormal,
                    ),
                  ),
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.text(
                      product.name,
                      color: OsmeaColors.black,
                      textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing4),
                    FavoritesItemPriceWidget(product: product),
                  ],
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OsmeaComponents.iconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      size: context.iconSizeSmall,
                      color: OsmeaColors.black,
                    ),
                    variant: ButtonVariant.outlined,
                    size: ButtonSize.extraSmall,
                    backgroundColor: OsmeaColors.white,
                    borderColor: OsmeaColors.silver,
                    borderRadius: context.spacing4,
                    onPressed: () => _showAddToCartDialog(context),
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing4),
                  OsmeaComponents.iconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: OsmeaColors.black,
                      size: context.iconSizeSmall,
                    ),
                    size: ButtonSize.extraSmall,
                    variant: ButtonVariant.ghost,
                    onPressed: () async {
                      if (!context.mounted) return;
                      context.snackbarWarning(
                        resources.removedFromFavorites,
                        style: SnackbarStyle.minimal,
                        position: SnackbarPosition.bottom,
                        duration: context.durationLong,
                      );
                      await viewModel.removeFavorite(product.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Future<void> _showAddToCartDialog(BuildContext context) async {
    final resources = context.resources;
    final result = await OsmeaComponents.showPopup<String>(
      context: context,
      variant: PopupVariant.dialog,
      title: resources.addToCart,
      subtitle: '${resources.addToCart} and keep in favorites, or add and remove from favorites?',
      padding: context.paddingNormal,
      backgroundColor: OsmeaColors.white,
      child: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: resources.addToCart,
                  variant: ButtonVariant.primary,
                  backgroundColor: OsmeaColors.black,
                  textColor: OsmeaColors.white,
                  onPressed: () => Navigator.of(context).pop('add_keep'),
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing8),
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  text: '${resources.addToCart} and remove from favorites',
                  variant: ButtonVariant.outlined,
                  borderColor: OsmeaColors.black,
                  textColor: OsmeaColors.black,
                  onPressed: () => Navigator.of(context).pop('add_remove'),
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          OsmeaComponents.button(
            text: resources.cancel,
            variant: ButtonVariant.ghost,
            textColor: OsmeaColors.black,
            onPressed: () => Navigator.of(context).pop('cancel'),
          ),
        ],
      ),
    );

    if (result == 'add_keep') {
      final success = await viewModel.addToCart(product.id);
      if (!context.mounted) return;
      if (success) {
        context.snackbarSuccess(resources.productAddedToCart);
      } else {
        context.snackbarWarning(resources.failedToAddCart);
      }
    } else if (result == 'add_remove') {
      final cartSuccess = await viewModel.addToCart(product.id);
      if (!context.mounted) return;
      if (cartSuccess) {
        await viewModel.removeFavorite(product.id);
        if (context.mounted) {
          context.snackbarSuccess(resources.productAddedToCart);
        }
      } else {
        context.snackbarWarning(resources.failedToAddCart);
      }
    }
  }
}
