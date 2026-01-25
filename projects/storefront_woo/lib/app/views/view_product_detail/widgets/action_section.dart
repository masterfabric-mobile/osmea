import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/gen/translations.g.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart'
    as product_models;

// Replaced custom quantity selector with OsmeaCounter

class ActionSection extends StatelessWidget {
  final bool isInWishlist;
  final VoidCallback onToggleWishlist;

  final bool isInCart;
  final Future<void> Function() onAddToCart;

  final VoidCallback? onShare;
  final VoidCallback? onAddSuccessNavigateToCart; // optional override
  final bool showWishlistAndShare;
  final product_models.Prices? prices;

  const ActionSection({
    super.key,
    required this.isInWishlist,
    required this.onToggleWishlist,
    required this.isInCart,
    required this.onAddToCart,
    this.onShare,
    this.onAddSuccessNavigateToCart,
    this.showWishlistAndShare = true,
    this.prices,
  });

  @override
  Widget build(BuildContext context) {
    // Check if there's a valid sale price that's different from regular price
    final hasSalePrice =
        prices != null &&
        prices!.salePrice != null &&
        prices!.salePrice!.isNotEmpty &&
        prices!.regularPrice != null &&
        prices!.regularPrice!.isNotEmpty &&
        prices!.salePrice != prices!.regularPrice;

    return OsmeaComponents.row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Price display - left side
        if (prices != null)
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: context.crossStart,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasSalePrice) ...[
                  // Sale price - prominent
                  OsmeaComponents.text(
                    _formatPrice(prices, isSalePrice: true),
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      color: OsmeaColors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing2),
                  // Original price (strikethrough)
                  OsmeaComponents.text(
                    _formatPrice(prices, isRegularPrice: true),
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.grayMaterial[400]!,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: OsmeaColors.grayMaterial[400]!,
                      decorationThickness: 1.5,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing2),
                  // Discount percentage
                  OsmeaComponents.text(
                    _calculateDiscountPercentage(context, prices),
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ] else ...[
                  // Regular price only - single price display
                  OsmeaComponents.text(
                    _formatPrice(prices),
                    textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                      color: OsmeaColors.black,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        // Add to Cart button - right side
        OsmeaComponents.expanded(
          child: Material(
            color: OsmeaColors.black,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () async {
                await onAddToCart();
                if (onAddSuccessNavigateToCart != null) {
                  onAddSuccessNavigateToCart!();
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: OsmeaComponents.container(
                height: 50,
                child: OsmeaComponents.center(
                  child: OsmeaComponents.text(
                    isInCart
                        ? 'In Cart'
                        : context.t.productDetailView.addToCart.button,
                    textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Formats price with currency symbol and handles sale prices
  String _formatPrice(
    product_models.Prices? prices, {
    bool isSalePrice = false,
    bool isRegularPrice = false,
  }) {
    if (prices == null) {
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    // Determine which price to show
    String? priceString;
    if (isSalePrice) {
      priceString = prices.salePrice ?? prices.price ?? '0.00';
    } else if (isRegularPrice) {
      priceString = prices.regularPrice ?? prices.price ?? '0.00';
    } else {
      // Default: prefer sale price if available
      if (prices.salePrice != null &&
          prices.salePrice!.isNotEmpty &&
          prices.regularPrice != null &&
          prices.regularPrice!.isNotEmpty) {
        priceString = prices.salePrice;
      } else {
        priceString = prices.regularPrice ?? prices.price ?? '0.00';
      }
    }

    // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
    final parsedPrice =
        PriceInfoCurrencyHelper.parsePriceToDouble(
          priceString!,
          currencyCode: prices.currencyCode,
          currencyDecimalSeparator: prices.currencyDecimalSeparator,
          currencyThousandSeparator: prices.currencyThousandSeparator,
          currencyMinorUnit: prices.currencyMinorUnit,
        ) ??
        0.0;

    // Use PriceInfoCurrencyHelper for proper formatting
    final formattedPrice = PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: prices.currencyCode,
      currencyDecimalSeparator: prices.currencyDecimalSeparator,
      currencyThousandSeparator: prices.currencyThousandSeparator,
      decimalPlaces: prices.currencyMinorUnit ?? 2,
      removeTrailingZeros: true,
    );

    return formattedPrice;
  }

  /// Calculates discount percentage
  String _calculateDiscountPercentage(
    BuildContext context,
    product_models.Prices? prices,
  ) {
    if (prices == null) return '';
    try {
      final regularPrice =
          PriceInfoCurrencyHelper.parsePriceToDouble(
            prices.regularPrice ?? '0',
            currencyCode: prices.currencyCode,
            currencyDecimalSeparator: prices.currencyDecimalSeparator,
            currencyThousandSeparator: prices.currencyThousandSeparator,
            currencyMinorUnit: prices.currencyMinorUnit,
          ) ??
          0.0;

      final salePrice =
          PriceInfoCurrencyHelper.parsePriceToDouble(
            prices.salePrice ?? '0',
            currencyCode: prices.currencyCode,
            currencyDecimalSeparator: prices.currencyDecimalSeparator,
            currencyThousandSeparator: prices.currencyThousandSeparator,
            currencyMinorUnit: prices.currencyMinorUnit,
          ) ??
          0.0;

      if (regularPrice > 0 && salePrice < regularPrice) {
        final discount = ((regularPrice - salePrice) / regularPrice * 100)
            .round();
        return context.t.productDetailView.discount.replaceAll(
          '{percentage}',
          discount.toString(),
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error calculating discount: $e');
    }
    return '';
  }
}
