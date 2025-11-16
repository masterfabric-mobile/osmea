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
        children: [
          // Image container
          OsmeaComponents.container(
            height: 170,
            decoration: BoxDecoration(
              color: OsmeaColors.pewter.withOpacity(0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: product.images?.isNotEmpty == true
                      ? FlutterMaterial.Image.network(
                          product.images!.first.src ?? '',
                          width: double.infinity,
                          height: 170,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return OsmeaComponents.container(
                              width: double.infinity,
                              height: 170,
                              color: OsmeaColors.pewter.withOpacity(0.1),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_outlined,
                                color: OsmeaColors.pewter,
                                size: 40,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return OsmeaComponents.container(
                              width: double.infinity,
                              height: 170,
                              color: OsmeaColors.pewter.withOpacity(0.1),
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  OsmeaColors.nordicBlue,
                                ),
                              ),
                            );
                          },
                        )
                      : OsmeaComponents.container(
                          width: double.infinity,
                          height: 170,
                          color: OsmeaColors.pewter.withOpacity(0.1),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_outlined,
                            color: OsmeaColors.pewter,
                            size: 40,
                          ),
                        ),
                ),
                // Discount badge - top left (only when API marks onSale)
                if (product.onSale == true && discountPct != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: OsmeaComponents.container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: OsmeaColors.nordicBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: OsmeaComponents.text(
                        '$discountPct% OFF',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Wishlist button - top right
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: OsmeaComponents.container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: OsmeaColors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: OsmeaColors.thunder.withOpacity(0.1),
                          width: 0.1,
                        ),
                      ),
                      child: Icon(
                        isSaved ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                        color: isSaved
                            ? OsmeaColors.nordicBlue
                            : OsmeaColors.thunder,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          OsmeaComponents.sizedBox(height: 8),
          // Product info
          OsmeaComponents.padding(
            padding: const EdgeInsets.only(left: 8),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: OsmeaColors.nordicBlue,
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: 6),
                      OsmeaComponents.text(
                        _formatPrice(
                          prices?.regularPrice,
                          currencyCode: prices?.currencyCode,
                          currencyDecimalSeparator: prices?.currencyDecimalSeparator,
                          currencyThousandSeparator: prices?.currencyThousandSeparator,
                          currencyMinorUnit: prices?.currencyMinorUnit,
                        ),
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          fontSize: 12,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: OsmeaColors.thunder,
                    ),
                  ),
                ],
                OsmeaComponents.sizedBox(height: 4),
                // Product name
                OsmeaComponents.text(
                  product.name ?? 'Product',
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.14,
                    color: OsmeaColors.thunder,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                OsmeaComponents.sizedBox(height: 2),
                // Description
                if (product.shortDescription != null &&
                    product.shortDescription!.isNotEmpty)
                  OsmeaComponents.text(
                    _stripHtml(product.shortDescription!),
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: OsmeaColors.pewter,
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
}
