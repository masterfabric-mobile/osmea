/*
 * ProductCardWidget
 * -----------------
 * Product card widget for home view.
 * Displays product information with image, price, and actions.
 */

import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart'
    hide Image;
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:get_it/get_it.dart';

/// Product card widget
class ProductCardWidget extends StatelessWidget {
  final ListAllProductsResponseModel product;
  final VoidCallback onWishlistTap;
  final VoidCallback onTap;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onWishlistTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final prices = product.prices;
    final discount = _calculateDiscountPercentage(
      prices?.regularPrice,
      prices?.salePrice,
    );

    return GestureDetector(
      onTap: onTap,
      child: OsmeaComponents.imageCard(
        // Image configuration
        imageUrl: product.images?.isNotEmpty == true
            ? product.images!.first.src
            : null,
        imageHeight: context.dynamicHeight(0.20),
        imageFit: BoxFit.cover,
        imageAlignment: Alignment.center,

        // Card appearance
        variant: ComponentAppearance.outlined,
        size: ComponentSize.medium,
        backgroundColor: OsmeaColors.white,
        borderColor: OsmeaColors.silver,
        borderRadius: BorderRadius.circular(context.radiusNormal),

        // Content
        title: _formatProductName(product.name ?? 'Product'),
        subtitle: product.categories?.isNotEmpty ?? false
            ? _formatProductName(product.categories!.first.name ?? '')
            : null,

        // Text styling
        titleStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w400,
          height: 1.25,
          fontSize: context.fontSizeSmall,
          letterSpacing: -0.15,
        ),
        subtitleStyle: OsmeaTextStyle.bodySmall(context).copyWith(
          fontWeight: FontWeight.w300,
          height: 1.15,
          fontSize: context.fontSizeExtraSmall,
        ),

        // Text overflow control
        titleMaxLines: 2,
        subtitleMaxLines: 1,
        textOverflow: TextOverflow.ellipsis,
        // Spacing
        spacing: context.spacing8,
        badge: (product.onSale == true && discount != null)
            ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing6,
                  vertical: context.spacing2,
                ),
                decoration: BoxDecoration(
                  color: OsmeaColors.white,
                  borderRadius: context.borderRadiusLow,
                  border: Border.all(
                    color: OsmeaColors.nordicBlue,
                    width: context.borderWidth,
                  ),
                ),
                child: OsmeaComponents.text(
                  '$discount% OFF',
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.nordicBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: context.fontSizeExtraSmall,
                  ),
                ),
              )
            : null,
        badgePosition: BadgePosition.topLeft,

        // Custom child for price section
        child: _buildPriceSection(context, prices),

        // Custom image widget with wishlist overlay
        imageWidget: _buildImageWithWishlist(context),
      ),
    );
  }

  /// Builds image with wishlist button overlay
  Widget? _buildImageWithWishlist(BuildContext context) {
    if (product.images?.isEmpty ?? true) {
      return Container(
        height: context.dynamicHeight(0.20),
        color: OsmeaColors.ash,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.image_outlined,
                color: OsmeaColors.pewter,
                size: context.iconSizeHigh,
              ),
            ),
            Positioned(
              right: context.spacing8,
              top: context.spacing8,
              child: _buildWishlistButton(context),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Image.network(
          product.images!.first.src ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
          height: context.dynamicHeight(0.20),
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: context.dynamicHeight(0.20),
              color: OsmeaColors.ash,
              alignment: Alignment.center,
              child: Icon(
                Icons.image_outlined,
                color: OsmeaColors.pewter,
                size: context.iconSizeHigh,
              ),
            );
          },
        ),
        Positioned(
          right: context.spacing8,
          top: context.spacing8,
          child: _buildWishlistButton(context),
        ),
      ],
    );
  }

  /// Builds wishlist button widget
  Widget _buildWishlistButton(BuildContext context) {
    return OsmeaComponents.iconButton(
      icon: Icon(
        GetIt.I<HomeViewModel>().isProductSaved(product.id ?? 0)
            ? Icons.favorite
            : Icons.favorite_border,
        size: context.iconSizeExtraSmall,
        color: GetIt.I<HomeViewModel>().isProductSaved(product.id ?? 0)
            ? OsmeaColors.nordicBlue
            : OsmeaColors.pewter,
      ),
      size: ButtonSize.small,
      variant: ButtonVariant.ghost,
      backgroundColor: OsmeaColors.white,
      borderRadius: context.width20,
      onPressed: onWishlistTap,
    );
  }

  /// Builds price section widget
  Widget _buildPriceSection(BuildContext context, dynamic prices) {
    if (prices != null &&
        prices.salePrice != null &&
        prices.salePrice!.isNotEmpty &&
        prices.salePrice != prices.regularPrice) {
      return OsmeaComponents.row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: OsmeaComponents.text(
              _formatPrice(prices.salePrice, prices.currencyCode),
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.nordicBlue,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
                fontSize: context.fontSizeSmall,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          OsmeaComponents.sizedBox(width: context.spacing4),
          Flexible(
            child: OsmeaComponents.text(
              _formatPrice(prices.regularPrice, prices.currencyCode),
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                decoration: TextDecoration.lineThrough,
                fontWeight: FontWeight.w300,
                fontSize: context.fontSizeExtraSmall,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      return OsmeaComponents.text(
        _formatPrice(prices?.regularPrice, prices?.currencyCode ?? 'GBP'),
        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
          fontSize: context.fontSizeSmall,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  /// Formats price using PriceInfoCurrencyHelper from core package
  String _formatPrice(String? priceString, String? currencyCode) {
    if (priceString == null || priceString.isEmpty) {
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    final cleanPrice = priceString.replaceAll(RegExp(r'[^\d.,]'), '');
    final parsedPrice = double.tryParse(cleanPrice) ?? 0.0;

    return PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: currencyCode,
      decimalPlaces: 2,
    );
  }

  /// Calculates discount percentage from regular and sale price
  int? _calculateDiscountPercentage(String? regularPrice, String? salePrice) {
    if (regularPrice == null || salePrice == null) return null;
    final rp = double.tryParse(regularPrice.replaceAll(RegExp(r'[^\d.,]'), ''));
    final sp = double.tryParse(salePrice.replaceAll(RegExp(r'[^\d.,]'), ''));
    if (rp == null || sp == null || rp <= 0 || sp >= rp) return null;
    final pct = ((rp - sp) / rp * 100).round();
    return pct > 0 ? pct : null;
  }

  /// Formats product name to title case (capitalizes first letter of each word)
  String _formatProductName(String name) {
    if (name.isEmpty) return name;

    // Split by spaces and capitalize first letter of each word
    return name
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : word[0].toUpperCase() +
                    (word.length > 1 ? word.substring(1).toLowerCase() : ''),
        )
        .join(' ');
  }
}
