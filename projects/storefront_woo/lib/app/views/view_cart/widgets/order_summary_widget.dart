/*
 * Order Summary Widget
 * --------------------
 * Widget for displaying order summary with totals.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';

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
        padding: EdgeInsets.all(context.spacing16),
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
      'Order Summary',
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
          label: 'Subtotal',
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
            label: 'Discount',
            value:
                '-${PriceInfoCurrencyHelper.formatPrice(state.totalDiscount, currencyCode: state.currencyCode, currencyDecimalSeparator: state.currencyDecimalSeparator, currencyThousandSeparator: state.currencyThousandSeparator, decimalPlaces: state.currencyMinorUnit ?? 2, removeTrailingZeros: true)}',
            isDiscount: true,
          ),
          OsmeaComponents.sizedBox(height: context.spacing10),
        ],
        _SummaryRowWidget(
          label: 'Shipping',
          value: 'Calculated at checkout',
          isSecondary: true,
        ),
        OsmeaComponents.sizedBox(height: context.spacing10),
        _SummaryRowWidget(
          label: 'Tax',
          value: 'Calculated at checkout',
          isSecondary: true,
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        OsmeaComponents.divider(),
        OsmeaComponents.sizedBox(height: context.spacing12),
        _SummaryRowWidget(
          label: 'Total',
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
                      ? OsmeaColors.nordicBlue
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
                  color: OsmeaColors.nordicBlue,
                )
              : isDiscount
                  ? OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w700,
                      color: OsmeaColors.nordicBlue,
                    )
                  : OsmeaTextStyle.bodySmall(context).copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSecondary
                          ? OsmeaColors.pewter.withValues(alpha: context.alpha80)
                          : OsmeaColors.thunder,
                      fontStyle:
                          isSecondary ? FontStyle.italic : FontStyle.normal,
                    ),
        ),
      ],
    );
  }
}

