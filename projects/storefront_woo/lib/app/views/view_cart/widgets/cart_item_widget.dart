/*
 * Cart Item Widget
 * ----------------
 * Individual cart item widget with product info and quantity controls.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/variations_text_widget.dart';

/// Individual cart item widget
class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final CartViewModel viewModel;
  final CartLoadedState state;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final cartToken = viewModel.arguments['cartToken'] as String?;

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
            '/product-detail/${item.productId}',
            extra: cartToken != null ? {'cartToken': cartToken} : null,
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
    return OsmeaComponents.container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusNormal,
        color: OsmeaColors.grayMaterial[50],
      ),
      child: OsmeaComponents.image(
        imageUrl: item.imageUrl,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
        borderRadius: context.borderRadiusNormal,
        variant: ImageVariant.normal,
        cacheWidth: 200, // Limit image size for performance
        showLoadingIndicator: true,
        errorWidget: _buildImagePlaceholder(context),
      ),
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
          _buildVariations(context),
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
      item.productName,
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

  Widget _buildVariations(BuildContext context) {
    return OsmeaComponents.container(
      height: context.height32,
      child: item.formattedVariations.isNotEmpty
          ? OsmeaComponents.column(
              crossAxisAlignment: context.crossStart,
              mainAxisAlignment: context.centerMain,
              children: [
                VariationsTextWidget(variations: item.formattedVariations),
              ],
            )
          : context.emptySizedBox,
    );
  }

  Widget _buildPrice(BuildContext context) {
    return OsmeaComponents.text(
      PriceInfoCurrencyHelper.formatPrice(
        item.price,
        currencyCode: state.currencyCode,
        currencyDecimalSeparator: state.currencyDecimalSeparator,
        currencyThousandSeparator: state.currencyThousandSeparator,
        decimalPlaces: state.currencyMinorUnit ?? context.spacing2.toInt(),
        removeTrailingZeros: true,
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
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[50],
        borderRadius: context.borderRadiusLow,
      ),
      child: OsmeaComponents.row(
        mainAxisSize: context.min,
        children: [
          OsmeaComponents.iconButton(
            onPressed: item.quantity > 1
                ? () => viewModel.updateItemQuantity(
                    item.productId,
                    item.quantity - 1,
                  )
                : null,
            icon: Icon(
              Icons.remove_rounded,
              color: item.quantity > 1
                  ? OsmeaColors.thunder
                  : OsmeaColors.pewter,
              size: context.iconSizeExtraSmall,
            ),
            backgroundColor: Colors.transparent,
            size: ButtonSize.extraSmall,
          ),
          OsmeaComponents.padding(
            padding: context.horizontalPaddingLow,
            child: OsmeaComponents.text(
              '${item.quantity}',
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                fontWeight: FontWeight.w600,
                color: OsmeaColors.thunder,
                fontSize: context.fontSizeSmall * context.textScaleFactor,
              ),
            ),
          ),
          OsmeaComponents.iconButton(
            onPressed: () =>
                viewModel.updateItemQuantity(item.productId, item.quantity + 1),
            icon: Icon(
              Icons.add_rounded,
              color: _getQuantityIconColor(context),
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
    return OsmeaComponents.iconButton(
      onPressed: () => viewModel.removeItemFromCart(item.productId),
      icon: Icon(
        Icons.delete_outline_rounded,
        color: OsmeaColors.amberFlame,
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
