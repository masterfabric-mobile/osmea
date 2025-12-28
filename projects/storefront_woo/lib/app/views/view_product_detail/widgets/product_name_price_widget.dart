/*
 * Product Name Price Widget
 * --------------------------
 * Widget for displaying product name and price.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart'
    as product_models;
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';

/// Widget for displaying product name and price
class ProductNamePriceWidget extends StatelessWidget {
  final ProductDetailLoadedState state;

  const ProductNamePriceWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing4,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Product name
          OsmeaComponents.text(
            state.product.name ?? 'Unknown Product',
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1.2,
              color: OsmeaColors.thunder,
            ),
          ),

          OsmeaComponents.sizedBox(height: context.spacing4),

          // Price
          OsmeaComponents.text(
            _formatPrice(state.product.prices),
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              color: OsmeaColors.nordicBlue,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  /// Formats price with currency symbol and handles sale prices
  String _formatPrice(product_models.Prices? prices) {
    if (prices == null) {
      debugPrint('❌ ProductNamePriceWidget: Prices is null');
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    debugPrint('💰 ProductNamePriceWidget: Price data: ${prices.toJson()}');

    // Determine which price to show
    String? priceString;
    if (prices.salePrice != null &&
        prices.salePrice!.isNotEmpty &&
        prices.regularPrice != null &&
        prices.regularPrice!.isNotEmpty) {
      priceString = prices.salePrice;
      debugPrint('💰 ProductNamePriceWidget: Using sale price: $priceString');
    } else {
      priceString = prices.regularPrice ?? prices.price ?? '0.00';
      debugPrint(
        '💰 ProductNamePriceWidget: Using regular/main price: $priceString',
      );
    }

    // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
    final parsedPrice = PriceInfoCurrencyHelper.parsePriceToDouble(
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

    debugPrint(
      '💰 ProductNamePriceWidget: Final formatted price: "$formattedPrice"',
    );
    return formattedPrice;
  }
}

