/*
 * Cart Content Widget
 * -------------------
 * Cart content widget for product detail view modal.
 * Uses OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/services/cart_service.dart';

/// Cart content widget for modal display
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
              textStyle: OsmeaTextStyle.titleMedium(context),
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
        // Cart items - Using OsmeaComponents.listItem would be better
        OsmeaComponents.expanded(
          child: OsmeaComponents.singleChildScrollView(
            padding: context.paddingNormal,
            child: OsmeaComponents.column(
              children: List.generate(cartService.itemCount, (index) {
                final item = cartService.items[index];
                return _buildCartItem(item, cartService, context);
              }),
            ),
          ),
        ),
        // Cart summary
        OsmeaComponents.basicCard(
          padding: context.paddingNormal,
          backgroundColor: OsmeaColors.white,
          customContent: OsmeaComponents.column(
            children: [
              OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OsmeaComponents.text(
                    'Total:',
                    textStyle: OsmeaTextStyle.titleLarge(context),
                  ),
                  OsmeaComponents.text(
                    PriceInfoCurrencyHelper.formatPrice(cartService.totalPrice),
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      color: OsmeaColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing16),
              OsmeaComponents.button(
                onPressed: () {
                  // TODO: Implement checkout functionality
                  Navigator.of(context).pop();
                },
                backgroundColor: OsmeaColors.blue,
                textColor: OsmeaColors.white,
                padding: EdgeInsets.symmetric(vertical: context.spacing16),
                borderRadius: context.radiusNormal,
                text: 'Checkout',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a cart item using OsmeaComponents.listItem
  Widget _buildCartItem(
    CartItem item,
    CartService cartService,
    BuildContext context,
  ) {
    return OsmeaComponents.basicCard(
      margin: EdgeInsets.only(bottom: context.spacing8),
      customContent: OsmeaComponents.padding(
        padding: context.paddingNormal,
        child: OsmeaComponents.row(
          children: [
            // Product image - Using OsmeaComponents.image
            OsmeaComponents.image(
              imageUrl: item.imageUrl ?? '',
              width: context.dynamicWidth(0.15),
              height: context.dynamicWidth(0.15),
              borderRadius: BorderRadius.circular(context.radiusNormal - 5),
              fit: BoxFit.cover,
              placeholder: Icon(
                Icons.image,
                size: context.iconSizeNormal,
                color: OsmeaColors.pewter,
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing16),
            // Product info
            OsmeaComponents.expanded(
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  OsmeaComponents.text(
                    item.productName,
                    textStyle: OsmeaTextStyle.titleMedium(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing4),
                  OsmeaComponents.text(
                    PriceInfoCurrencyHelper.formatPrice(item.price),
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: OsmeaColors.nordicBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            // Quantity controls - Using OsmeaComponents.iconButton
            OsmeaComponents.row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OsmeaComponents.iconButton(
                  icon: const Icon(Icons.remove),
                  size: ButtonSize.small,
                  variant: ButtonVariant.ghost,
                  backgroundColor: OsmeaColors.grayMaterial[200],
                  onPressed: item.quantity > 1
                      ? () => cartService.updateQuantity(
                          item.productId,
                          item.quantity - 1,
                        )
                      : null,
                ),
                OsmeaComponents.sizedBox(width: context.spacing8),
                OsmeaComponents.text(
                  '${item.quantity}',
                  textStyle: OsmeaTextStyle.titleMedium(context),
                ),
                OsmeaComponents.sizedBox(width: context.spacing8),
                OsmeaComponents.iconButton(
                  icon: const Icon(Icons.add),
                  size: ButtonSize.small,
                  variant: ButtonVariant.ghost,
                  backgroundColor: OsmeaColors.grayMaterial[200],
                  onPressed: () => cartService.updateQuantity(
                    item.productId,
                    item.quantity + 1,
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            // Remove button
            OsmeaComponents.iconButton(
              icon: Icon(Icons.delete_outline, color: OsmeaColors.red),
              size: ButtonSize.small,
              variant: ButtonVariant.ghost,
              onPressed: () => cartService.removeItem(item.productId),
            ),
          ],
        ),
      ),
    );
  }
}
