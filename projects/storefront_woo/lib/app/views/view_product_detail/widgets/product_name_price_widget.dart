/*
 * Product Name Price Widget
 * --------------------------
 * Widget for displaying product name and price.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Widget for displaying product name and price
class ProductNamePriceWidget extends StatelessWidget {
  final ProductDetailLoadedState state;

  const ProductNamePriceWidget({
    super.key,
    required this.state,
  });

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final configHelper = AssetConfigHelper();
      final colorString = configHelper.getString('product_detail_view.name_and_price.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load name_and_price color $key: $e');
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final nameColor = _getColorFromConfig('nameColor', OsmeaColors.black);
    
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing12,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          // Product name only - price is shown in footer
          OsmeaComponents.text(
            state.product.name ?? context.t.productDetailView.unknownProduct,
            textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              height: 1.3,
              color: nameColor,
            ),
          ),
        ],
      ),
    );
  }
}

