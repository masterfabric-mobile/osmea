/*
 * Order Summary Widget
 * --------------------
 * Widget for displaying order summary with totals.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// Widget for order summary
class OrderSummaryWidget extends StatelessWidget {
  final CartLoadedState state;

  const OrderSummaryWidget({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: context.borderRadiusNormal,
      ),
      child: OsmeaComponents.padding(
        padding: context.paddingNormal,
        child: OsmeaComponents.column(
          crossAxisAlignment: context.crossStart,
          children: [
            _buildHeader(context),
            OsmeaComponents.sizedBox(height: context.spacing12),
            _buildSummaryItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return OsmeaComponents.text(
      context.t.cartView.widgets.orderSummary.title,
      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
        fontWeight: FontWeight.w700,
        color: OsmeaColors.thunder,
      ),
    );
  }

  Widget _buildSummaryItems(BuildContext context) {
    return OsmeaComponents.column(
      children: [
        _SummaryRowWidget(
          label: context.t.cartView.widgets.orderSummary.subtotal,
          value: PriceInfoCurrencyHelper.formatPrice(
            state.totalPrice + state.totalDiscount,
            currencyCode: state.currencyCode,
            currencyDecimalSeparator: state.currencyDecimalSeparator,
            currencyThousandSeparator: state.currencyThousandSeparator,
            decimalPlaces: state.currencyMinorUnit ?? context.spacing2.toInt(),
            removeTrailingZeros: true,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing10),
        if (state.totalDiscount > 0) ...[
          _SummaryRowWidget(
            label: context.t.cartView.widgets.orderSummary.discount,
            value:
                '-${PriceInfoCurrencyHelper.formatPrice(state.totalDiscount, currencyCode: state.currencyCode, currencyDecimalSeparator: state.currencyDecimalSeparator, currencyThousandSeparator: state.currencyThousandSeparator, decimalPlaces: state.currencyMinorUnit ?? 2, removeTrailingZeros: true)}',
            isDiscount: true,
          ),
          OsmeaComponents.sizedBox(height: context.spacing10),
        ],
        _SummaryRowWidget(
          label: context.t.cartView.widgets.orderSummary.shipping,
          value: context.t.cartView.widgets.orderSummary.shippingCalculated,
          isSecondary: true,
        ),
        OsmeaComponents.sizedBox(height: context.spacing10),
        _SummaryRowWidget(
          label: context.t.cartView.widgets.orderSummary.tax,
          value: context.t.cartView.widgets.orderSummary.taxCalculated,
          isSecondary: true,
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        OsmeaComponents.divider(),
        OsmeaComponents.sizedBox(height: context.spacing12),
        _SummaryRowWidget(
          label: context.t.cartView.widgets.orderSummary.total,
          value: PriceInfoCurrencyHelper.formatPrice(
            state.totalPrice,
            currencyCode: state.currencyCode,
            currencyDecimalSeparator: state.currencyDecimalSeparator,
            currencyThousandSeparator: state.currencyThousandSeparator,
            decimalPlaces: state.currencyMinorUnit ?? context.spacing2.toInt(),
          ),
          isPrimary: true,
        ),
      ],
    );
  }
}

/// Helper widget for summary row
class _SummaryRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isPrimary;
  final bool isDiscount;
  final bool isSecondary;

  const _SummaryRowWidget({
    required this.label,
    required this.value,
    this.isPrimary = false,
    this.isDiscount = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final discountColor = _getDiscountColor(context);
    final totalAmountColor = _getTotalAmountColor(context);
    
    return OsmeaComponents.row(
      mainAxisAlignment: context.spaceBetween,
      crossAxisAlignment: context.crossCenter,
      children: [
        OsmeaComponents.text(
          label,
          textStyle: isPrimary
              ? OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: OsmeaColors.thunder,
                )
              : OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w500,
                  color: isDiscount
                      ? discountColor
                      : isSecondary
                          ? OsmeaColors.pewter
                          : OsmeaColors.thunder,
                ),
        ),
        OsmeaComponents.text(
          value,
          textStyle: isPrimary
              ? OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w700,
                  color: totalAmountColor,
                )
              : isDiscount
                  ? OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w700,
                      color: discountColor,
                    )
                  : OsmeaTextStyle.bodySmall(context).copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSecondary
                          ? OsmeaColors.pewter
                          : OsmeaColors.thunder,
                      fontStyle:
                          isSecondary ? FontStyle.italic : FontStyle.normal,
                    ),
        ),
      ],
    );
  }

  /// Gets discount color from config
  Color _getDiscountColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.order_summary.discount_color',
        '#000000',
      ),
    );
  }

  /// Gets total amount color from config
  Color _getTotalAmountColor(BuildContext context) {
    final configHelper = AssetConfigHelper();
    return _parseColor(
      configHelper.getString(
        'cart_view_configuration.order_summary.total_amount_color',
        '#000000',
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

