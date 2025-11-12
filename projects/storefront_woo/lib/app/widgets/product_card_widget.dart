/*
 * ProductCardWidget
 * -----------------
 * Reusable product card widget for displaying products.
 * Used in home view, search view, and other product listings.
 */

import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart'
    hide Image;
import 'package:core/core.dart';

/// Product card widget
class ProductCardWidget extends StatelessWidget {
  final ListAllProductsResponseModel product;
  final VoidCallback onWishlistTap;
  final VoidCallback onTap;
  final bool isSaved; // Wishlist status passed from parent

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onWishlistTap,
    required this.onTap,
    this.isSaved = false,
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
        subtitle: product.categories?.isNotEmpty == true
            ? _formatProductName(product.categories!.first.name ?? '')
            : null,
        // Price will be shown in child widget below
        subtitle2: null,

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
        subtitle2Style: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.nordicBlue,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
          fontSize: context.fontSizeSmall,
        ),

        // Text overflow control
        titleMaxLines: 2,
        subtitleMaxLines: 1,
        subtitle2MaxLines: 2, // Allow 2 lines for price to prevent overflow
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

        // Custom image widget with wishlist overlay
        // Note: imageWidget will override imageUrl, so we need to include the image in the widget
        imageWidget: _buildImageWithWishlist(context),

        // Price widget - shows sale price and regular price (strikethrough) like home view
        child: _buildPriceWidget(context, prices),
      ),
    );
  }

  /// Builds image with wishlist button overlay
  Widget? _buildImageWithWishlist(BuildContext context) {
    final imageHeight = context.dynamicHeight(0.20);
    final imageUrl = product.images?.isNotEmpty == true
        ? product.images!.first.src
        : null;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: imageHeight,
        color: OsmeaColors.ash,
        alignment: Alignment.center,
        child: Stack(
          clipBehavior: Clip.none,
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

    // Build image with wishlist overlay - Stack is required for Positioned
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Product image
        ClipRRect(
          borderRadius: BorderRadius.circular(context.radiusNormal),
          child: Image.network(
            imageUrl,
            height: imageHeight,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: imageHeight,
                width: double.infinity,
                color: OsmeaColors.ash,
                alignment: Alignment.center,
                child: Icon(
                  Icons.image_outlined,
                  color: OsmeaColors.pewter,
                  size: context.iconSizeHigh,
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: imageHeight,
                width: double.infinity,
                color: OsmeaColors.ash,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    OsmeaColors.nordicBlue,
                  ),
                ),
              );
            },
          ),
        ),
        // Wishlist button overlay
        Positioned(
          right: context.spacing8,
          top: context.spacing8,
          child: _buildWishlistButton(context),
        ),
      ],
    );
  }

  /// Builds wishlist button widget - uses isSaved prop from parent
  Widget _buildWishlistButton(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OsmeaColors.thunder.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          isSaved ? Icons.favorite : Icons.favorite_border,
          size: 16,
          color: isSaved ? OsmeaColors.nordicBlue : OsmeaColors.thunder,
        ),
        onPressed: onWishlistTap,
      ),
    );
  }

  /// Builds price widget showing sale price and regular price (strikethrough)
  /// Same format as recommended section widget
  Widget _buildPriceWidget(BuildContext context, dynamic prices) {
    final hasSale =
        prices != null &&
        prices.salePrice != null &&
        prices.salePrice!.isNotEmpty &&
        prices.regularPrice != null &&
        prices.regularPrice!.isNotEmpty &&
        prices.salePrice != prices.regularPrice;

    if (hasSale) {
      // Show sale price and regular price (strikethrough) side by side
      final salePrice = _formatPrice(prices.salePrice, prices.currencyCode);
      final regularPrice = _formatPrice(
        prices.regularPrice,
        prices.currencyCode,
      );

      return Padding(
        padding: EdgeInsets.only(top: context.spacing8),
        child: OsmeaComponents.row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OsmeaComponents.text(
              salePrice,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.nordicBlue,
                fontWeight: FontWeight.w600,
                fontSize: context.fontSizeSmall,
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing6),
            OsmeaComponents.text(
              regularPrice,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                color: OsmeaColors.pewter,
                decoration: TextDecoration.lineThrough,
                fontSize: context.fontSizeExtraSmall,
              ),
            ),
          ],
        ),
      );
    } else {
      // Show just the regular price
      return Padding(
        padding: EdgeInsets.only(top: context.spacing8),
        child: OsmeaComponents.text(
          _formatPrice(prices?.regularPrice, prices?.currencyCode ?? 'GBP'),
          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
            color: OsmeaColors.nordicBlue,
            fontWeight: FontWeight.w600,
            fontSize: context.fontSizeSmall,
          ),
        ),
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
