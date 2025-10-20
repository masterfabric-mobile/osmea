import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/services/cart_service.dart';

class CartContentWidget extends StatelessWidget {
  final CartService cartService;

  const CartContentWidget({super.key, required this.cartService});

  @override
  Widget build(BuildContext context) {
    if (cartService.itemCount == 0) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: context.iconSizeExtraHigh,
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              'Your cart is empty',
              textStyle: OsmeaTextStyle.titleLarge(context),
              color: OsmeaColors.thunder,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              'Add some products to get started',
              textStyle: OsmeaTextStyle.bodyMedium(context),
              color: OsmeaColors.pewter,
            ),
          ],
        ),
      );
    }

    return OsmeaComponents.column(
      children: [
        // Cart items
        OsmeaComponents.expanded(
          child: OsmeaComponents.singleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: OsmeaComponents.column(
              children: List.generate(cartService.itemCount, (index) {
                final item = cartService.items[index];
                return _buildCartItem(item, cartService, context);
              }),
            ),
          ),
        ),
        // Cart summary using action card
        OsmeaComponents.actionCard(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          backgroundColor: OsmeaColors.paperWhite,
          borderRadius: BorderRadius.circular(12),
          variant: ComponentAppearance.filled,
          size: ComponentSize.medium,
          customContent: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.text(
                'Total:',
                textStyle: OsmeaTextStyle.titleLarge(context),
                color: OsmeaColors.thunder,
              ),
              OsmeaComponents.fittedBox(
                fit: BoxFit.scaleDown,
                child: OsmeaComponents.text(
                  PriceInfoCurrencyHelper.formatPrice(cartService.totalPrice),
                  textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                    color: OsmeaColors.nordicBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          primaryAction: 'Checkout',
          onPrimaryPressed: () {
            // TODO: Implement checkout functionality
            Navigator.of(context).pop();
          },
          primaryVariant: ButtonVariant.primary,
          primarySize: ButtonSize.large,
          buttonLayout: ComponentOrientation.horizontal,
        ),
      ],
    );
  }

  /// Builds a cart item widget following OSMEA standards
  Widget _buildCartItem(
    CartItem item,
    CartService cartService,
    BuildContext context,
  ) {
    return OsmeaComponents.listItem(
      margin: const EdgeInsets.only(bottom: 8.0),
      title: OsmeaComponents.text(
        item.productName,
        textStyle: OsmeaTextStyle.titleMedium(context),
        color: OsmeaColors.thunder,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: OsmeaComponents.text(
        PriceInfoCurrencyHelper.formatPrice(item.price),
        textStyle: OsmeaTextStyle.bodyMedium(context),
        color: OsmeaColors.nordicBlue,
      ),
      leading: OsmeaComponents.container(
        width: 60,
        height: 60,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: OsmeaComponents.image(
          imageUrl: item.imageUrl,
          fit: BoxFit.cover,
          placeholder: Icon(Icons.image, color: OsmeaColors.pewter),
        ),
      ),
      trailing: OsmeaComponents.row(
        children: [
          // Quantity controls
          OsmeaComponents.row(
            children: [
              OsmeaComponents.iconButton(
                onPressed: item.quantity > 1
                    ? () => cartService.updateQuantity(
                        item.productId,
                        item.quantity - 1,
                      )
                    : null,
                icon: Icon(Icons.remove, color: OsmeaColors.white),
                backgroundColor: OsmeaColors.nordicBlue,
                tooltip: 'Decrease quantity',
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.text(
                '${item.quantity}',
                textStyle: OsmeaTextStyle.titleMedium(context),
                color: OsmeaColors.thunder,
              ),
              OsmeaComponents.sizedBox(width: 8),
              OsmeaComponents.iconButton(
                onPressed: () => cartService.updateQuantity(
                  item.productId,
                  item.quantity + 1,
                ),
                icon: Icon(Icons.add, color: OsmeaColors.white),
                backgroundColor: OsmeaColors.nordicBlue,
                tooltip: 'Increase quantity',
              ),
            ],
          ),
          OsmeaComponents.sizedBox(width: 16),
          // Remove button
          OsmeaComponents.iconButton(
            onPressed: () => cartService.removeItem(item.productId),
            icon: Icon(Icons.delete_outline, color: OsmeaColors.white),
            backgroundColor: OsmeaColors.red,
            tooltip: 'Remove item',
          ),
        ],
      ),
      backgroundColor: OsmeaColors.paperWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12.0),
      variant: ListItemVariant.standard,
      size: ListItemSize.medium,
    );
  }
}
