/*
 * Product Info Section Widget
 * ---------------------------
 * Widget for displaying product name, price, attributes, description, and reviews.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/retrieve_product_response_model.dart'
    as product_models;
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/description_section.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_attributes_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_reviews_section_widget.dart';

/// Widget for displaying product information section
class ProductInfoSectionWidget extends StatelessWidget {
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;

  const ProductInfoSectionWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        OsmeaComponents.padding(
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
                  color: OsmeaColors.black,
                ),
              ),

              OsmeaComponents.sizedBox(height: context.spacing4),

              // Price
              OsmeaComponents.text(
                _formatPrice(state.product.prices),
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  color: OsmeaColors.black,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                  height: 1.1,
                ),
              ),

              OsmeaComponents.sizedBox(height: context.spacing8),
            ],
          ),
        ),

        // Attributes - collapse extends edge to edge
        if (state.product.attributes != null &&
            state.product.attributes!.isNotEmpty)
          ProductAttributesWidget(
            viewModel: viewModel,
            state: state,
          ),

        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing16,
            vertical: context.spacing4,
          ),
          child: OsmeaComponents.column(
            crossAxisAlignment: context.crossStart,
            children: [
              OsmeaComponents.sizedBox(height: context.spacing8),

              // Description
              if (state.product.description?.isNotEmpty == true) ...[
                OsmeaComponents.text(
                  'Details',
                  textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                    color: OsmeaColors.black,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing4),
                DescriptionSection(
                  description: state.product.description!,
                  viewModel: viewModel,
                  state: state,
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
              ],

              // Reviews Section
              ProductReviewsSectionWidget(state: state),
            ],
          ),
        ),
      ],
    );
  }

  /// Formats price with currency symbol and handles sale prices
  String _formatPrice(product_models.Prices? prices) {
    if (prices == null) {
      debugPrint('❌ ProductInfoSection: Prices is null');
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    debugPrint('💰 ProductInfoSection: Price data: ${prices.toJson()}');

    // Determine which price to show
    String? priceString;
    if (prices.salePrice != null &&
        prices.salePrice!.isNotEmpty &&
        prices.regularPrice != null &&
        prices.regularPrice!.isNotEmpty) {
      priceString = prices.salePrice;
      debugPrint('💰 ProductInfoSection: Using sale price: $priceString');
    } else {
      priceString = prices.regularPrice ?? prices.price ?? '0.00';
      debugPrint(
        '💰 ProductInfoSection: Using regular/main price: $priceString',
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
      '💰 ProductInfoSection: Final formatted price: "$formattedPrice"',
    );
    return formattedPrice;
  }
}

