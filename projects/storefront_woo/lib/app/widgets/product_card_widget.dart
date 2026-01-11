/*
 * ProductCardWidget
 * -----------------
 * Reusable product card widget for displaying products.
 * Uses the same design as home recommended section cards.
 * Used in home view, search view, and other product listings.
 */

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/material.dart' as FlutterMaterial show Image;
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart'
    hide Image;
import 'package:core/core.dart';

/// Product card widget - matches home recommended section design
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
    final bool hasSale =
        product.onSale == true &&
        prices?.salePrice != null &&
        (prices?.salePrice?.isNotEmpty ?? false) &&
        prices?.salePrice != prices?.regularPrice;

    int? discountPct;
    if (hasSale) {
      // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
      // Use API-provided separators and minor_unit to correctly parse the price format
      final rp = PriceInfoCurrencyHelper.parsePriceToDouble(
        prices!.regularPrice,
        currencyCode: prices.currencyCode,
        currencyDecimalSeparator: prices.currencyDecimalSeparator,
        currencyThousandSeparator: prices.currencyThousandSeparator,
        currencyMinorUnit: prices.currencyMinorUnit,
      );
      final sp = PriceInfoCurrencyHelper.parsePriceToDouble(
        prices.salePrice,
        currencyCode: prices.currencyCode,
        currencyDecimalSeparator: prices.currencyDecimalSeparator,
        currencyThousandSeparator: prices.currencyThousandSeparator,
        currencyMinorUnit: prices.currencyMinorUnit,
      );
      if (rp != null && sp != null && rp > 0 && sp < rp) {
        discountPct = (((rp - sp) / rp) * 100).round();
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image container
          Container(
            height: context.height160 + context.spacing10,
            decoration: BoxDecoration(
              color: OsmeaColors.grayMaterial[50],
              borderRadius: context.borderRadiusNormal,
            ),
            child: Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: context.borderRadiusNormal,
                  child: product.images?.isNotEmpty == true
                      ? FlutterMaterial.Image.network(
                          product.images!.first.src ?? '',
                          width: double.infinity,
                          height: context.height160 + context.spacing10,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: context.height160 + context.spacing10,
                              color: OsmeaColors.grayMaterial[50],
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_outlined,
                                color: OsmeaColors.grayMaterial[400],
                                size: context.iconSizeExtraHigh,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: double.infinity,
                              height: context.height160 + context.spacing10,
                              color: OsmeaColors.grayMaterial[50],
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                strokeWidth: context.width2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getLoadingIndicatorColor(context),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          height: context.height160 + context.spacing10,
                          color: OsmeaColors.grayMaterial[50],
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_outlined,
                            color: OsmeaColors.grayMaterial[400],
                            size: context.iconSizeExtraHigh,
                          ),
                        ),
                ),
                // Discount badge - top left (only when API marks onSale)
                if (product.onSale == true && discountPct != null)
                  Positioned(
                    top: context.spacing8,
                    left: context.spacing8,
                    child: OsmeaComponents.container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.spacing6,
                        vertical: context.spacing2,
                      ),
                      decoration: BoxDecoration(
                        color: _getDiscountBadgeBackgroundColor(context),
                        borderRadius: BorderRadius.circular(context.spacing6),
                      ),
                      child: OsmeaComponents.text(
                        '$discountPct% OFF',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: _getDiscountBadgeTextColor(context),
                          fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                // Wishlist button - top right
                Positioned(
                  top: context.spacing8,
                  right: context.spacing8,
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: OsmeaComponents.container(
                      width: context.iconSizeNormal * 1.25,
                      height: context.iconSizeNormal * 1.25,
                      decoration: BoxDecoration(
                        color: OsmeaColors.white,
                        borderRadius: BorderRadius.circular(context.spacing24),
                        border: Border.all(
                          color: OsmeaColors.silver,
                          width: context.borderWidth,
                        ),
                      ),
                      child: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        size: context.iconSizeExtraSmall,
                        color: isSaved
                            ? _getWishlistIconSavedColor(context)
                            : _getWishlistIconUnsavedColor(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          // Product info
          OsmeaComponents.padding(
            padding: context.onlyLeftPaddingLow,
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price
                if (hasSale) ...[
                  OsmeaComponents.row(
                    children: [
                      OsmeaComponents.text(
                        _formatPrice(
                          prices?.salePrice,
                          currencyCode: prices?.currencyCode,
                          currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                          currencyThousandSeparator: prices?.currencyThousandSeparator,
                          currencyMinorUnit: prices?.currencyMinorUnit,
                        ),
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
                          fontWeight: FontWeight.w700,
                          color: _getSalePriceColor(context),
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing6),
                      OsmeaComponents.text(
                        _formatPrice(
                          prices?.regularPrice,
                          currencyCode: prices?.currencyCode,
                          currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                          currencyThousandSeparator: prices?.currencyThousandSeparator,
                          currencyMinorUnit: prices?.currencyMinorUnit,
                        ),
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontSize: context.fontSizeSmall * context.textScaleFactor,
                          color: OsmeaColors.pewter,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  OsmeaComponents.text(
                    _formatPrice(
                      prices?.regularPrice,
                      currencyCode: prices?.currencyCode,
                      currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                      currencyThousandSeparator: prices?.currencyThousandSeparator,
                      currencyMinorUnit: prices?.currencyMinorUnit,
                    ),
                    textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                      fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
                      fontWeight: FontWeight.w700,
                      color: _getRegularPriceColor(context),
                    ),
                  ),
                ],
                OsmeaComponents.sizedBox(height: context.spacing4),
                // Product name
                OsmeaComponents.text(
                  product.name ?? 'Product',
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontSize: context.fontSizeExtraSmallMedium * context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    height: 1.14,
                    color: _getProductNameColor(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                OsmeaComponents.sizedBox(height: context.spacing2),
                // Description
                if (product.shortDescription != null &&
                    product.shortDescription!.isNotEmpty)
                  OsmeaComponents.text(
                    _stripHtml(product.shortDescription!),
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontSize: context.fontSizeExtraSmall * context.textScaleFactor,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: _getDescriptionColor(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Formats price using PriceInfoCurrencyHelper from core package
  String _formatPrice(
    String? priceString, {
    String? currencyCode,
    String? currencyDecimalSeparator,
    String? currencyThousandSeparator,
    int? currencyMinorUnit,
  }) {
    if (priceString == null || priceString.isEmpty) {
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
    // Use API-provided separators and minor_unit to correctly parse the price format
    final parsedPrice = PriceInfoCurrencyHelper.parsePriceToDouble(
      priceString,
      currencyCode: currencyCode,
      currencyDecimalSeparator: currencyDecimalSeparator,
      currencyThousandSeparator: currencyThousandSeparator,
      currencyMinorUnit: currencyMinorUnit,
    ) ?? 0.0;

    // Use API-provided separators to correctly format the price
    return PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: currencyCode,
      currencyDecimalSeparator: currencyDecimalSeparator,
      currencyThousandSeparator: currencyThousandSeparator,
      decimalPlaces: currencyMinorUnit ?? 2,
      removeTrailingZeros: true,
    );
  }

  /// Strips HTML tags from description
  String _stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Gets loading indicator color from config
  Color _getLoadingIndicatorColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.loading_indicator_color',
        '#000000',
      ),
    );
  }

  /// Gets discount badge background color from config
  Color _getDiscountBadgeBackgroundColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.discount_badge_background',
        '#000000',
      ),
    );
  }

  /// Gets discount badge text color from config
  Color _getDiscountBadgeTextColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.discount_badge_text_color',
        '#FFFFFF',
      ),
    );
  }

  /// Gets wishlist icon saved color from config
  Color _getWishlistIconSavedColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.wishlist_icon_saved_color',
        '#000000',
      ),
    );
  }

  /// Gets wishlist icon unsaved color from config
  Color _getWishlistIconUnsavedColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.wishlist_icon_unsaved_color',
        '#000000',
      ),
    );
  }

  /// Gets sale price color from config
  Color _getSalePriceColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.sale_price_color',
        '#000000',
      ),
    );
  }

  /// Gets regular price color from config
  Color _getRegularPriceColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.regular_price_color',
        '#000000',
      ),
    );
  }

  /// Gets product name color from config
  Color _getProductNameColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.product_name_color',
        '#000000',
      ),
    );
  }

  /// Gets description color from config
  Color _getDescriptionColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'product_list_view.product_card.description_color',
        '#666666',
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
