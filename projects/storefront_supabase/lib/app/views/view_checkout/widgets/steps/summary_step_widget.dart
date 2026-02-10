/*
 * SummaryStepWidget
 * -----------------
 * Step 4: Order summary and Place Order button.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/views/view_checkout/models/states.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class SummaryStepWidget extends StatelessWidget {
  final Map<String, dynamic>? billingAddress;
  final Map<String, dynamic>? shippingAddress;
  final String? billingEmail;
  final ShippingMethod? selectedShippingMethod;
  final PaymentMethod? selectedPaymentMethod;
  final double subtotal;
  final double shippingCost;
  final String? currencyCode;
  final List<CheckoutLineItem> lineItems;
  final bool isProcessing;
  final VoidCallback onPlaceOrder;
  final VoidCallback onBack;

  const SummaryStepWidget({
    super.key,
    this.billingAddress,
    this.shippingAddress,
    this.billingEmail,
    this.selectedShippingMethod,
    this.selectedPaymentMethod,
    required this.subtotal,
    required this.shippingCost,
    this.currencyCode,
    this.lineItems = const [],
    this.isProcessing = false,
    required this.onPlaceOrder,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final total = subtotal + shippingCost;
    final code = currencyCode ?? 'USD';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (billingAddress != null) _Section(title: context.resources.stepAddress, content: _formatAddress(billingAddress!), context: context),
                OsmeaComponents.sizedBox(height: context.spacing16),
                if (selectedShippingMethod != null)
                  _Section(
                    title: context.resources.stepShipping,
                    content: '${selectedShippingMethod!.title} - ${PriceHelper.format(selectedShippingMethod!.cost, code, locale)}',
                    context: context,
                  ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                if (selectedPaymentMethod != null)
                  _Section(title: context.resources.stepPayment, content: selectedPaymentMethod!.title, context: context),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.text(
                  context.resources.products,
                  textStyle: OsmeaTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600),
                ),
                OsmeaComponents.sizedBox(height: context.spacing8),
                for (final item in lineItems)
                  Padding(
                    padding: EdgeInsets.only(bottom: context.spacing8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: OsmeaComponents.text(
                            '${item.name ?? "Product"} x ${item.quantity}',
                            textStyle: OsmeaTextStyle.bodySmall(context),
                          ),
                        ),
                        OsmeaComponents.text(
                          PriceHelper.format(item.subtotal, code, locale),
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OsmeaComponents.text(context.resources.total, textStyle: OsmeaTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w700)),
                    OsmeaComponents.text(
                      PriceHelper.format(total, code, locale),
                      textStyle: OsmeaTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(context.spacing16),
          child: Row(
            children: [
              Expanded(
                child: OsmeaComponents.button(
                  onPressed: isProcessing ? null : onBack,
                  backgroundColor: OsmeaColors.white,
                  textColor: OsmeaColors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  text: context.resources.backButton,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing12),
              Expanded(
                flex: 2,
                child: OsmeaComponents.button(
                  onPressed: isProcessing ? null : onPlaceOrder,
                  backgroundColor: OsmeaColors.black,
                  textColor: OsmeaColors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  text: isProcessing ? '...' : context.resources.placeOrder,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: OsmeaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatAddress(Map<String, dynamic> a) {
    final parts = <String>[];
    if (a['first_name'] != null && (a['first_name'] as String).isNotEmpty) parts.add(a['first_name'] as String);
    if (a['last_name'] != null && (a['last_name'] as String).isNotEmpty) parts.add(a['last_name'] as String);
    if (a['address_1'] != null && (a['address_1'] as String).isNotEmpty) parts.add(a['address_1'] as String);
    if (a['city'] != null && (a['city'] as String).isNotEmpty) parts.add(a['city'] as String);
    if (a['country'] != null && (a['country'] as String).isNotEmpty) parts.add(a['country'] as String);
    if (a['phone'] != null && (a['phone'] as String).isNotEmpty) parts.add(a['phone'] as String);
    return parts.join(', ');
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;
  final BuildContext context;

  const _Section({required this.title, required this.content, required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          title,
          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter, fontWeight: FontWeight.w600),
        ),
        OsmeaComponents.sizedBox(height: 4),
        OsmeaComponents.text(
          content,
          textStyle: OsmeaTextStyle.bodyMedium(context),
        ),
      ],
    );
  }
}
