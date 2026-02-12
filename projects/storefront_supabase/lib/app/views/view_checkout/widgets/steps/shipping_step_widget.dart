/*
 * ShippingStepWidget
 * ------------------
 * Step 2: Select shipping method.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/views/view_checkout/models/states.dart';
import 'package:storefront_supabase/app/utils/price_helper.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class ShippingStepWidget extends StatelessWidget {
  final List<ShippingMethod> shippingMethods;
  final String? selectedMethodId;
  final double subtotal;
  final String? currencyCode;
  final ValueChanged<String> onMethodSelected;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const ShippingStepWidget({
    super.key,
    required this.shippingMethods,
    required this.selectedMethodId,
    required this.subtotal,
    this.currencyCode,
    required this.onMethodSelected,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OsmeaComponents.expanded(
          child: OsmeaComponents.singleChildScrollView(
            padding: EdgeInsets.all(context.spacing16),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final method in shippingMethods) ...[
                  _ShippingTile(
                    method: method,
                    isSelected: selectedMethodId == method.id,
                    currencyCode: currencyCode ?? 'USD',
                    locale: locale,
                    onTap: () => onMethodSelected(method.id),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                ],
              ],
            ),
          ),
        ),
        OsmeaComponents.padding(
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.row(
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  onPressed: onBack,
                  backgroundColor: OsmeaColors.white,
                  textColor: OsmeaColors.black,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  text: context.resources.backButton,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing12),
              OsmeaComponents.expanded(
                child: OsmeaComponents.button(
                  onPressed: selectedMethodId != null ? onContinue : null,
                  backgroundColor: OsmeaColors.black,
                  textColor: OsmeaColors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  text: context.resources.continueButton,
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
}

class _ShippingTile extends StatelessWidget {
  final ShippingMethod method;
  final bool isSelected;
  final String currencyCode;
  final String locale;
  final VoidCallback onTap;

  const _ShippingTile({
    required this.method,
    required this.isSelected,
    required this.currencyCode,
    required this.locale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? OsmeaColors.black : OsmeaColors.pewter.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(context.spacing16),
      onTap: onTap,
      child: OsmeaComponents.row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? OsmeaColors.black : OsmeaColors.pewter,
            size: 24,
          ),
          OsmeaComponents.sizedBox(width: context.spacing12),
          OsmeaComponents.expanded(
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OsmeaComponents.text(
                  method.title,
                  textStyle: OsmeaTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600),
                ),
                if (method.description != null) ...[
                  OsmeaComponents.sizedBox(height: 4),
                  OsmeaComponents.text(
                    method.description!,
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
                  ),
                ],
                if (method.deliveryTime != null) ...[
                  OsmeaComponents.sizedBox(height: 4),
                  OsmeaComponents.text(
                    method.deliveryTime!,
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
                  ),
                ],
              ],
            ),
          ),
          OsmeaComponents.text(
            method.cost == 0 ? 'Free' : PriceHelper.format(method.cost, currencyCode, locale),
            textStyle: OsmeaTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
