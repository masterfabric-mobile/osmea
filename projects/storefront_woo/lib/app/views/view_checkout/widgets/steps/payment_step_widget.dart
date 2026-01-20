/*
 * PaymentStepWidget
 * -----------------
 * Step 3: Payment Method Selection & Order Confirmation
 * Shows available payment options and final order summary
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

class PaymentStepWidget extends StatelessWidget {
  final List<PaymentMethod> paymentMethods;
  final String? selectedMethodId;
  final double subtotal;
  final double shippingCost;
  final String? currencyCode;
  final String? shippingMethodName;
  final Map<String, dynamic>? billingAddress;
  final Map<String, dynamic>? shippingAddress;
  final bool isProcessing;
  final ValueChanged<String> onMethodSelected;
  final VoidCallback onCompleteOrder;
  final VoidCallback onBack;

  const PaymentStepWidget({
    super.key,
    required this.paymentMethods,
    this.selectedMethodId,
    required this.subtotal,
    required this.shippingCost,
    this.currencyCode,
    this.shippingMethodName,
    this.billingAddress,
    this.shippingAddress,
    this.isProcessing = false,
    required this.onMethodSelected,
    required this.onCompleteOrder,
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
                
                // Payment methods section
                _buildSectionHeader(
                  context,
                  configHelper,
                  title: context.t.checkoutView.steps.selectPayment,
                  icon: Icons.payment_outlined,
                ),
                
                SizedBox(height: context.spacing12),
                
                // Payment methods list
                ...paymentMethods.map((method) => Padding(
                  padding: EdgeInsets.only(bottom: context.spacing10),
                  child: _buildPaymentMethodCard(context, configHelper, method),
                )),
                
                SizedBox(height: context.spacing20),
                
                // Order review section
                _buildSectionHeader(
                  context,
                  configHelper,
                  title: context.t.checkoutView.steps.orderReview,
                  icon: Icons.receipt_long_outlined,
                ),
                
                SizedBox(height: context.spacing12),
                
                // Delivery info card
                _buildDeliveryInfoCard(context, configHelper),
                
                SizedBox(height: context.spacing16),
                
                // Final order summary
                _buildFinalSummary(context, configHelper),
                
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

  Widget _buildSectionHeader(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required String title,
    required IconData icon,
  }) {
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

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        SizedBox(width: context.spacing12),
        Text(
          title,
          style: OsmeaTextStyle.titleMedium(context).copyWith(
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    AssetConfigHelper configHelper,
    PaymentMethod method,
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

    // Get icon based on payment method
    IconData methodIcon;
    switch (method.id) {
      case 'bacs':
        methodIcon = Icons.account_balance;
        break;
      case 'cod':
        methodIcon = Icons.payments_outlined;
        break;
      case 'credit_card':
      case 'stripe':
        methodIcon = Icons.credit_card;
        break;
      case 'paypal':
        methodIcon = Icons.payment;
        break;
      default:
        methodIcon = Icons.payment;
    }

    return GestureDetector(
      onTap: method.enabled ? () => onMethodSelected(method.id) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(context.spacing12),
        decoration: BoxDecoration(
          color: isSelected 
              ? activeColor.withOpacity(0.05) 
              : method.enabled 
                  ? OsmeaColors.white 
                  : OsmeaColors.grayMaterial[100],
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
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: method.enabled 
                      ? (isSelected ? activeColor : borderColor)
                      : borderColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeColor,
                        ),
                      ),
                    )
                  : null,
            ),
            
            SizedBox(width: context.spacing12),
            
            // Method icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: activeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                methodIcon,
                color: method.enabled ? activeColor : OsmeaColors.grayMaterial[400],
                size: 20,
              ),
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
                      color: method.enabled 
                          ? OsmeaColors.black 
                          : OsmeaColors.grayMaterial[500],
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
                ],
              ),
            ),
            
            // Selected check
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: activeColor,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfoCard(BuildContext context, AssetConfigHelper configHelper) {
    final address = shippingAddress ?? billingAddress;
    final addressLine = address != null
        ? '${address['address_1'] ?? ''}, ${address['city'] ?? ''}'
        : context.t.checkoutView.payment.noAddressSet;

    return Container(
      padding: EdgeInsets.all(context.spacing12),
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
          // Delivery address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: OsmeaColors.grayMaterial[600],
              ),
              SizedBox(width: context.spacing10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.checkoutView.payment.deliveryAddress,
                      style: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.grayMaterial[500],
                      ),
                    ),
                    SizedBox(height: context.spacing2),
                    Text(
                      addressLine,
                      style: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.spacing10),
            child: Divider(color: OsmeaColors.grayMaterial[200], height: 1),
          ),
          
          // Shipping method
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: 20,
                color: OsmeaColors.grayMaterial[600],
              ),
              SizedBox(width: context.spacing10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.checkoutView.payment.shippingMethod,
                      style: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.grayMaterial[500],
                      ),
                    ),
                    SizedBox(height: context.spacing2),
                    Text(
                      shippingMethodName ?? context.t.checkoutView.payment.standardShipping,
                      style: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinalSummary(BuildContext context, AssetConfigHelper configHelper) {
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
        gradient: LinearGradient(
          colors: [
            OsmeaColors.black.withOpacity(0.05),
            OsmeaColors.black.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
            padding: EdgeInsets.symmetric(vertical: context.spacing10),
            child: Divider(color: OsmeaColors.grayMaterial[300], height: 1),
          ),
          _buildSummaryRow(
            context,
            label: context.t.checkoutView.orderSummary.total,
            value: formattedTotal,
            isBold: true,
            isLarge: true,
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
    bool isLarge = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isLarge 
              ? OsmeaTextStyle.bodyLarge(context) 
              : OsmeaTextStyle.bodyMedium(context)).copyWith(
            color: isBold ? OsmeaColors.black : OsmeaColors.grayMaterial[600],
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: (isLarge 
              ? OsmeaTextStyle.titleLarge(context) 
              : OsmeaTextStyle.bodyMedium(context)).copyWith(
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
    final canComplete = hasSelection && !isProcessing;

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
                onPressed: isProcessing ? null : onBack,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.spacing12),
                  side: BorderSide(
                    color: isProcessing 
                        ? buttonBgColor.withOpacity(0.3) 
                        : buttonBgColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  context.t.checkoutView.buttons.back,
                  style: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: isProcessing 
                        ? buttonBgColor.withOpacity(0.3) 
                        : buttonBgColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(width: context.spacing12),
            
            // Complete order button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: canComplete ? onCompleteOrder : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBgColor,
                  disabledBackgroundColor: buttonBgColor.withOpacity(0.3),
                  padding: EdgeInsets.symmetric(vertical: context.spacing12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isProcessing
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.t.checkoutView.buttons.continueToSummary,
                            style: OsmeaTextStyle.titleMedium(context).copyWith(
                              color: canComplete 
                                  ? buttonTextColor 
                                  : buttonTextColor.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: context.spacing8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: canComplete 
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
