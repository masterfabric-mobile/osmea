/*
 * Cart Item Widget
 * ----------------
 * Individual cart item widget with product info and quantity controls.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_supabase/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_supabase/app/views/view_cart/models/module/states.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';

/// Individual cart item widget
class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final CartViewModel viewModel;
  final CartLoadedState state;
  final bool isInBottomSheet;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.viewModel,
    required this.state,
    this.isInBottomSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(
        left: context.spacing16,
        right: context.spacing16,
      ),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        border: Border(
          bottom: BorderSide(
            color: OsmeaColors.grayMaterial[200]!,
            width: context.borderWidth,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          context.push(
            '/product-detail/${item.product.id}',
          );
        },
        child: OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing10,
          ),
          child: OsmeaComponents.row(
            crossAxisAlignment: context.crossStart,
            children: [
              _buildProductImage(context),
              OsmeaComponents.sizedBox(width: context.spacing10),
              _buildProductInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    final imageWidth = context.width64;
    final imageHeight = context.height80;
    
    // Get first image if available
    String? imageUrl;
    if (item.product.imageUrls.isNotEmpty) {
      imageUrl = item.product.imageUrls.first;
    }

    return OsmeaComponents.container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusNormal,
        color: OsmeaColors.grayMaterial[50],
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? OsmeaComponents.image(
              imageUrl: imageUrl,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
              borderRadius: context.borderRadiusNormal,
              variant: ImageVariant.normal,
              cacheWidth: 200, // Limit image size for performance
              showLoadingIndicator: true,
              errorWidget: _buildImagePlaceholder(context),
            )
          : _buildImagePlaceholder(context),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return OsmeaComponents.center(
      child: Icon(
        Icons.image_outlined,
        color: OsmeaColors.grayMaterial[400],
        size: context.iconSizeMedium,
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return OsmeaComponents.expanded(
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        mainAxisSize: context.min,
        children: [
          _buildProductName(context),
          // TODO: Add variations support if needed for Supabase
          // _buildVariations(context),
          OsmeaComponents.sizedBox(height: context.spacing6),
          _buildPrice(context),
          OsmeaComponents.sizedBox(height: context.spacing6),
          _buildQuantityControls(context),
        ],
      ),
    );
  }

  Widget _buildProductName(BuildContext context) {
    return OsmeaComponents.text(
      item.product.name,
      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
        fontWeight: FontWeight.w500,
        color: OsmeaColors.thunder,
        height: context.lineHeightSnug,
        fontSize: context.fontSizeSmall * context.textScaleFactor,
      ),
      maxLines: context.maxLineTwo,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPrice(BuildContext context) {
    return OsmeaComponents.text(
      PriceHelper.format(
        item.product.effectivePrice,
        state.currencyCode ?? 'USD',
        Localizations.localeOf(context).toString(),
      ),
      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
        color: _getPriceColor(context),
        fontWeight: FontWeight.w600,
        fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return OsmeaComponents.row(
      mainAxisAlignment: context.spaceBetween,
      crossAxisAlignment: context.crossCenter,
      children: [_buildQuantitySelector(context), _buildRemoveButton(context)],
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    // Check if this item is being updated (Supabase ID might be int or string, simulating int logic from woo)
    final isUpdating = state.updatingProductId == item.product.id.hashCode;
    
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[50],
        borderRadius: context.borderRadiusLow,
      ),
      child: OsmeaComponents.row(
        mainAxisSize: context.min,
        children: [
          OsmeaComponents.iconButton(
            onPressed: (item.quantity > 1 && !isUpdating)
                ? () => viewModel.updateItemQuantity(
                    item.id,
                    item.quantity - 1,
                  )
                : null,
            icon: Icon(
              Icons.remove_rounded,
              color: (item.quantity > 1 && !isUpdating)
                  ? OsmeaColors.thunder
                  : OsmeaColors.pewter,
              size: context.iconSizeExtraSmall,
            ),
            backgroundColor: Colors.transparent,
            size: ButtonSize.extraSmall,
          ),
          OsmeaComponents.padding(
            padding: context.horizontalPaddingLow,
            child: isUpdating
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: OsmeaColors.thunder,
                    ),
                  )
                : OsmeaComponents.text(
                    '${item.quantity}',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.thunder,
                      fontSize: context.fontSizeSmall * context.textScaleFactor,
                    ),
                  ),
          ),
          OsmeaComponents.iconButton(
            onPressed: !isUpdating
                ? () => viewModel.updateItemQuantity(item.id, item.quantity + 1)
                : null,
            icon: Icon(
              Icons.add_rounded,
              color: !isUpdating ? _getQuantityIconColor(context) : OsmeaColors.pewter,
              size: context.iconSizeExtraSmall,
            ),
            backgroundColor: Colors.transparent,
            size: ButtonSize.extraSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    // Get remove button color from config
    final configHelper = AssetConfigHelper();
    final removeButtonColor = _parseColor(
      configHelper.getString(
        'cart_view_configuration.cart_items.remove_button_color',
        '#000000',
      ),
    );
    
    return OsmeaComponents.iconButton(
      onPressed: () =>
          viewModel.removeItemFromCart(item.id, context: context),
      icon: Icon(
        Icons.delete_outline_rounded,
        color: removeButtonColor,
        size: context.iconSizeSmall,
      ),
      backgroundColor: Colors.transparent,
      size: ButtonSize.extraSmall,
      tooltip: 'Remove item',
    );
  }

  /// Gets price color from config
  Color _getPriceColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.cart_items.price_color',
        '#000000',
      ),
    );
  }

  /// Gets quantity icon color from config
  Color _getQuantityIconColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.cart_items.quantity_selector_icon_color',
        '#000000',
      ),
    );
  }

  /// Parses color string to Color
  Color _parseColor(String colorString) {
    try {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 8) {
        final alpha = int.parse(hex.substring(0, 2), radix: 16);
        final red = int.parse(hex.substring(2, 4), radix: 16);
        final green = int.parse(hex.substring(4, 6), radix: 16);
        final blue = int.parse(hex.substring(6, 8), radix: 16);
        return Color.fromARGB(alpha, red, green, blue);
      }
      if (hex.length == 6) {
        final red = int.parse(hex.substring(0, 2), radix: 16);
        final green = int.parse(hex.substring(2, 4), radix: 16);
        final blue = int.parse(hex.substring(4, 6), radix: 16);
        return Color.fromRGBO(red, green, blue, 1.0);
      }
      return OsmeaColors.black;
    } catch (e) {
      debugPrint('⚠️ Error parsing color: $colorString - $e');
      return OsmeaColors.black;
    }
  }
}
