/*
 * Cart Item Swipe Widget
 * ----------------------
 * Cart item with swipe-to-delete functionality.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_cart/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_cart/models/states.dart';
import 'package:storefront_supabase/app/views/view_cart/widgets/cart_item_widget.dart';

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
      key: Key('cart_item_${item.id}'),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(context),
      confirmDismiss: (direction) => _confirmAndRemove(context),
      child: CartItemWidget(item: item, viewModel: viewModel, state: state),
    );
  }

  /// Confirm dialog and remove item - returns false to prevent Dismissible animation
  /// The actual removal is handled by viewModel and state update will remove the item from list
  Future<bool> _confirmAndRemove(BuildContext context) async {
    final confirmed = await _showConfirmDialog(context);
    if (confirmed) {
      // Remove item via viewModel
      viewModel.removeItemFromCart(item.id);
      
      // Show undo snackbar (optional implementation)
    }
    // Always return false - we handle removal through state update, not through Dismissible
    return false;
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

  /// Get dialog color from config
  Color _getDialogColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString(
        'dialog_popup_configuration.$key',
      );
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load dialog color $key: $e');
    }
    return fallback;
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    // Get colors from config
    final dialogTitleColor = _getDialogColorFromConfig(
      'dialog.titleColor',
      const Color(0xFF1976D2),
    );
    final dialogSubtitleColor = _getDialogColorFromConfig(
      'dialog.subtitleColor',
      OsmeaColors.grayMaterial[400]!,
    );
    final cancelButtonColor = _getDialogColorFromConfig(
      'buttons.cancel.textColor',
      OsmeaColors.grayMaterial[500]!,
    );

    return await OsmeaComponents.showPopup<bool>(
          context: context,
          variant: PopupVariant.dialog,
          size: PopupSize.medium,
          title: 'Remove Item',
          titleStyle: OsmeaTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.w600, color: dialogTitleColor),
          child: OsmeaComponents.text(
            'Are you sure you want to remove "${item.product.name}" from your cart?',
            textStyle: OsmeaTextStyle.bodyMedium(
              context,
            ).copyWith(color: dialogSubtitleColor),
          ),
          footer: OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            children: [
              OsmeaComponents.button(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(false),
                variant: ButtonVariant.ghost,
                textColor: cancelButtonColor,
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

}
