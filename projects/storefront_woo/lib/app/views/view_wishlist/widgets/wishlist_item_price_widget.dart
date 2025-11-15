import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';

class WishlistItemPriceWidget extends StatelessWidget {
  final WishlistItem item;

  const WishlistItemPriceWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final hasSale =
        item.onSale &&
        item.salePrice != null &&
        item.salePrice!.isNotEmpty &&
        item.regularPrice != null &&
        item.regularPrice!.isNotEmpty &&
        item.salePrice != item.regularPrice;

    // İndirimli ürünlerde: sale price + regular price (strikethrough)
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
          SizedBox(width: context.spacing6),
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

    // İndirimli olmayan ürünlerde: sadece regular price göster
    final regularPrice = item.regularPrice;
    if (regularPrice != null && regularPrice.isNotEmpty) {
      return OsmeaComponents.text(
        _formatPrice(regularPrice, item.currencyCode),
        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.nordicBlue,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    // Fiyat yoksa default price göster
    return OsmeaComponents.text(
      PriceInfoCurrencyHelper.getDefaultPrice(),
      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
        color: OsmeaColors.pewter,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Formats price using PriceInfoCurrencyHelper
  String _formatPrice(String? priceString, String? currencyCode) {
    if (priceString == null || priceString.isEmpty) {
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    // Clean price string (remove currency symbols, spaces, etc.)
    final cleanPrice = priceString.replaceAll(RegExp(r'[^\d.,]'), '');
    final parsedPrice = double.tryParse(cleanPrice) ?? 0.0;

    return PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: currencyCode,
      decimalPlaces: 2,
      removeTrailingZeros: true,
    );
  }
}




