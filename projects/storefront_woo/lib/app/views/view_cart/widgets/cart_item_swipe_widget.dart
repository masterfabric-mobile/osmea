/*
 * Cart Item Swipe Widget
 * ----------------------
 * Cart item with swipe-to-delete functionality.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_item_widget.dart';

/// Cart item with swipe-to-delete functionality
class CartItemSwipeWidget extends StatelessWidget {
  final CartItem item;
  final CartViewModel viewModel;
  final CartLoadedState state;

  const CartItemSwipeWidget({
    super.key,
    required this.item,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('cart_item_${item.key}'),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(context),
      confirmDismiss: (direction) => _showConfirmDialog(context),
      onDismissed: (direction) => _handleDismiss(context),
      child: CartItemWidget(item: item, viewModel: viewModel, state: state),
    );
  }

  Widget _buildSwipeBackground(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(
        bottom: context.spacing8,
        left: context.spacing16,
        right: context.spacing16,
      ),
      alignment: context.centerRight,
      padding: context.onlyRightPaddingNormal,
      decoration: BoxDecoration(
        color: OsmeaColors.amberFlame,
        borderRadius: context.borderRadiusNormal,
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: context.end,
        children: [
          Icon(
            Icons.delete_outline_rounded,
            color: OsmeaColors.white,
            size: context.iconSizeMedium,
          ),
          OsmeaComponents.sizedBox(width: context.spacing12),
          OsmeaComponents.text(
            'Remove',
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(color: OsmeaColors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return await OsmeaComponents.showPopup<bool>(
          context: context,
          variant: PopupVariant.dialog,
          size: PopupSize.medium,
          title: 'Remove item?',
          titleStyle: OsmeaTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.w600),
          child: OsmeaComponents.text(
            'Are you sure you want to remove "${item.productName}" from your cart?',
            textStyle: OsmeaTextStyle.bodyMedium(context),
          ),
          footer: OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            children: [
              OsmeaComponents.button(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(false),
                variant: ButtonVariant.ghost,
                textColor: OsmeaColors.pewter,
                size: ButtonSize.medium,
              ),
              OsmeaComponents.button(
                text: 'Remove',
                onPressed: () => Navigator.of(context).pop(true),
                variant: ButtonVariant.danger,
                size: ButtonSize.medium,
              ),
            ],
          ),
          isDismissible: true,
        ) ??
        false;
  }

  void _handleDismiss(BuildContext context) {
    viewModel.removeItemFromCart(item.productId);
    context.snackbarInfo(
      'Item removed from cart',
      duration: context.durationVeryLong,
      actionLabel: 'Undo',
      onAction: () {
        viewModel.addItemToCart(item.productId, quantity: item.quantity);
      },
    );
  }
}
