import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';

class WishlistItemPriceWidget extends StatelessWidget {
  final WishlistItem item;

  const WishlistItemPriceWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final hasSale =
        item.onSale &&
        item.salePrice != null &&
        item.salePrice!.isNotEmpty &&
        item.regularPrice != null &&
        item.regularPrice!.isNotEmpty &&
        item.salePrice != item.regularPrice;

    // For products on sale: show sale price + regular price (strikethrough)
    if (hasSale) {
      return OsmeaComponents.row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OsmeaComponents.text(
            _formatPrice(item.salePrice, item.currencyCode),
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.nordicBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          OsmeaComponents.sizedBox(width: context.spacing6),
          OsmeaComponents.text(
            _formatPrice(item.regularPrice, item.currencyCode),
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    }

    // For products not on sale: show only regular price
    final regularPrice = item.regularPrice;
    if (regularPrice != null && regularPrice.isNotEmpty) {
      return OsmeaComponents.text(
        _formatPrice(regularPrice, item.currencyCode),
        textStyle: OsmeaTextStyle.bodyMedium(
          context,
        ).copyWith(color: OsmeaColors.nordicBlue, fontWeight: FontWeight.w600),
      );
    }

    // If no price, show default price
    return OsmeaComponents.text(
      PriceInfoCurrencyHelper.getDefaultPrice(),
      textStyle: OsmeaTextStyle.bodyMedium(
        context,
      ).copyWith(color: OsmeaColors.pewter, fontWeight: FontWeight.w400),
    );
  }

  /// Formats price using PriceInfoCurrencyHelper
  String _formatPrice(String? priceString, String? currencyCode) {
    if (priceString == null || priceString.isEmpty) {
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
    // Use API-provided separators and minor_unit to correctly parse the price format
    final parsedPrice =
        PriceInfoCurrencyHelper.parsePriceToDouble(
          priceString,
          currencyCode: currencyCode,
          currencyDecimalSeparator: item.currencyDecimalSeparator,
          currencyThousandSeparator: item.currencyThousandSeparator,
          currencyMinorUnit: item.currencyMinorUnit,
        ) ??
        0.0;

    // Use API-provided separators to correctly format the price
    return PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: currencyCode,
      currencyDecimalSeparator: item.currencyDecimalSeparator,
      currencyThousandSeparator: item.currencyThousandSeparator,
      decimalPlaces: item.currencyMinorUnit ?? 2,
      removeTrailingZeros: true,
    );
  }
}
