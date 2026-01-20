/*
 * ShippingStepWidget
 * ------------------
 * Step 2: Shipping Method Selection
 * Shows available shipping options with prices and delivery times
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

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
    this.selectedMethodId,
    required this.subtotal,
    this.currencyCode,
    required this.onMethodSelected,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();
    
    return Column(
      children: [
        // Content area
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.spacing16),
                
                // Section header
                _buildSectionHeader(context, configHelper),
                
                SizedBox(height: context.spacing16),
                
                // Shipping methods list
                if (shippingMethods.isEmpty)
                  _buildEmptyState(context, configHelper)
                else
                  ...shippingMethods.map((method) => Padding(
                    padding: EdgeInsets.only(bottom: context.spacing12),
                    child: _buildShippingMethodCard(context, configHelper, method),
                  )),
                
                SizedBox(height: context.spacing16),
                
                // Order summary
                _buildOrderSummary(context, configHelper),
                
                SizedBox(height: context.spacing24),
              ],
            ),
          ),
        ),
        
        // Bottom buttons
        _buildBottomButtons(context, configHelper),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, AssetConfigHelper configHelper) {
    final iconBgColor = _getColorFromConfig(
      configHelper,
      'section_header.icon_background_color',
      OsmeaColors.black,
    ).withOpacity(0.1);
    final iconColor = _getColorFromConfig(
      configHelper,
      'section_header.icon_color',
      OsmeaColors.black,
    );
    final titleColor = _getColorFromConfig(
      configHelper,
      'section_header.title_color',
      OsmeaColors.black,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.local_shipping_outlined, color: iconColor, size: 20),
            ),
            SizedBox(width: context.spacing12),
            Text(
              context.t.checkoutView.steps.selectShipping,
              style: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing8),
        Text(
          context.t.checkoutView.steps.shippingDescription,
          style: OsmeaTextStyle.bodySmall(context).copyWith(
            color: OsmeaColors.grayMaterial[500],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AssetConfigHelper configHelper) {
    return Container(
      padding: EdgeInsets.all(context.spacing24),
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.grayMaterial[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 48,
            color: OsmeaColors.grayMaterial[400],
          ),
          SizedBox(height: context.spacing12),
          Text(
            context.t.checkoutView.shipping.noMethodsAvailable,
            style: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.grayMaterial[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.spacing4),
          Text(
            context.t.checkoutView.shipping.contactSupport,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.grayMaterial[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShippingMethodCard(
    BuildContext context,
    AssetConfigHelper configHelper,
    ShippingMethod method,
  ) {
    final isSelected = method.id == selectedMethodId;
    final activeColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_focused_border_color',
      OsmeaColors.black,
    );
    final borderColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_border_color',
      OsmeaColors.silver,
    );

    final formattedPrice = PriceInfoCurrencyHelper.formatPrice(
      method.cost,
      currencyCode: currencyCode,
    );

    return GestureDetector(
      onTap: () => onMethodSelected(method.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(context.spacing16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.05) : OsmeaColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : borderColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? activeColor : borderColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeColor,
                        ),
                      ),
                    )
                  : null,
            ),
            
            SizedBox(width: context.spacing12),
            
            // Method details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: OsmeaTextStyle.bodyMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (method.description != null) ...[
                    SizedBox(height: context.spacing2),
                    Text(
                      method.description!,
                      style: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.grayMaterial[500],
                      ),
                    ),
                  ],
                  if (method.deliveryTime != null) ...[
                    SizedBox(height: context.spacing4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: OsmeaColors.grayMaterial[500],
                        ),
                        SizedBox(width: context.spacing4),
                        Text(
                          method.deliveryTime!,
                          style: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.grayMaterial[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            // Price
            Text(
              method.cost == 0 
                  ? context.t.checkoutView.shipping.free 
                  : formattedPrice,
              style: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: method.cost == 0 
                    ? OsmeaColors.greenMaterial[600] 
                    : OsmeaColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, AssetConfigHelper configHelper) {
    final selectedMethod = shippingMethods
        .where((m) => m.id == selectedMethodId)
        .firstOrNull;
    
    final shippingCost = selectedMethod?.cost ?? 0.0;
    final total = subtotal + shippingCost;
    
    final formattedSubtotal = PriceInfoCurrencyHelper.formatPrice(
      subtotal,
      currencyCode: currencyCode,
    );
    final formattedShipping = shippingCost == 0
        ? context.t.checkoutView.shipping.free
        : PriceInfoCurrencyHelper.formatPrice(shippingCost, currencyCode: currencyCode);
    final formattedTotal = PriceInfoCurrencyHelper.formatPrice(
      total,
      currencyCode: currencyCode,
    );

    return Container(
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.grayMaterial[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            context,
            label: context.t.checkoutView.orderSummary.subtotal,
            value: formattedSubtotal,
          ),
          SizedBox(height: context.spacing8),
          _buildSummaryRow(
            context,
            label: context.t.checkoutView.orderSummary.shipping,
            value: formattedShipping,
            valueColor: shippingCost == 0 ? OsmeaColors.greenMaterial[600] : null,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.spacing8),
            child: Divider(color: OsmeaColors.grayMaterial[300], height: 1),
          ),
          _buildSummaryRow(
            context,
            label: context.t.checkoutView.orderSummary.total,
            value: formattedTotal,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: OsmeaTextStyle.bodyMedium(context).copyWith(
            color: OsmeaColors.grayMaterial[600],
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: OsmeaTextStyle.bodyMedium(context).copyWith(
            color: valueColor ?? OsmeaColors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(BuildContext context, AssetConfigHelper configHelper) {
    final buttonBgColor = _getColorFromConfig(
      configHelper,
      'order_summary.button_background_color',
      OsmeaColors.black,
    );
    final buttonTextColor = _getColorFromConfig(
      configHelper,
      'order_summary.button_text_color',
      OsmeaColors.white,
    );

    final hasSelection = selectedMethodId != null;

    return Container(
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        boxShadow: [
          BoxShadow(
            color: OsmeaColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Back button
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.spacing12),
                  side: BorderSide(color: buttonBgColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.t.checkoutView.buttons.back,
                  style: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: buttonBgColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: context.spacing12),
            
            // Continue button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: hasSelection ? onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBgColor,
                  disabledBackgroundColor: buttonBgColor.withOpacity(0.3),
                  padding: EdgeInsets.symmetric(vertical: context.spacing12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.t.checkoutView.buttons.continueToPayment,
                      style: OsmeaTextStyle.titleMedium(context).copyWith(
                        color: hasSelection 
                            ? buttonTextColor 
                            : buttonTextColor.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: context.spacing8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: hasSelection 
                          ? buttonTextColor 
                          : buttonTextColor.withOpacity(0.5),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromConfig(
    AssetConfigHelper configHelper,
    String key,
    Color fallback,
  ) {
    try {
      final colorString = configHelper.getString('checkout_view_configuration.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load color $key: $e');
    }
    return fallback;
  }
}
