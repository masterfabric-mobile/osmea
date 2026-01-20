/*
 * SummaryStepWidget
 * -----------------
 * Step 4: Order Summary & Confirmation
 * Shows complete order review before final submission
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

class SummaryStepWidget extends StatelessWidget {
  // Address info
  final Map<String, dynamic>? billingAddress;
  final Map<String, dynamic>? shippingAddress;
  final String? billingEmail;
  final bool sameAsBilling;
  
  // Shipping info
  final ShippingMethod? selectedShippingMethod;
  
  // Payment info
  final PaymentMethod? selectedPaymentMethod;
  
  // Price info
  final double subtotal;
  final double shippingCost;
  final String? currencyCode;
  
  // Actions
  final bool isProcessing;
  final VoidCallback onCompleteOrder;
  final VoidCallback onBack;
  final VoidCallback onEditAddress;
  final VoidCallback onEditShipping;
  final VoidCallback onEditPayment;

  const SummaryStepWidget({
    super.key,
    this.billingAddress,
    this.shippingAddress,
    this.billingEmail,
    this.sameAsBilling = true,
    this.selectedShippingMethod,
    this.selectedPaymentMethod,
    required this.subtotal,
    required this.shippingCost,
    this.currencyCode,
    this.isProcessing = false,
    required this.onCompleteOrder,
    required this.onBack,
    required this.onEditAddress,
    required this.onEditShipping,
    required this.onEditPayment,
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
                
                // Page title
                _buildPageHeader(context, configHelper),
                
                SizedBox(height: context.spacing20),
                
                // Delivery Address Card
                _buildSummaryCard(
                  context,
                  configHelper,
                  title: context.t.checkoutView.summary.deliveryAddress,
                  icon: Icons.location_on_outlined,
                  onEdit: onEditAddress,
                  content: _buildAddressContent(context),
                ),
                
                SizedBox(height: context.spacing12),
                
                // Shipping Method Card
                _buildSummaryCard(
                  context,
                  configHelper,
                  title: context.t.checkoutView.summary.shippingMethod,
                  icon: Icons.local_shipping_outlined,
                  onEdit: onEditShipping,
                  content: _buildShippingContent(context),
                ),
                
                SizedBox(height: context.spacing12),
                
                // Payment Method Card
                _buildSummaryCard(
                  context,
                  configHelper,
                  title: context.t.checkoutView.summary.paymentMethod,
                  icon: Icons.payment_outlined,
                  onEdit: onEditPayment,
                  content: _buildPaymentContent(context),
                ),
                
                SizedBox(height: context.spacing20),
                
                // Order Total
                _buildOrderTotal(context, configHelper),
                
                SizedBox(height: context.spacing24),
              ],
            ),
          ),
        ),
        
        // Bottom button
        _buildBottomButton(context, configHelper),
      ],
    );
  }

  Widget _buildPageHeader(BuildContext context, AssetConfigHelper configHelper) {
    final titleColor = _getColorFromConfig(
      configHelper,
      'section_header.title_color',
      OsmeaColors.black,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.checkoutView.summary.title,
          style: OsmeaTextStyle.headlineSmall(context).copyWith(
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
        SizedBox(height: context.spacing4),
        Text(
          context.t.checkoutView.summary.subtitle,
          style: OsmeaTextStyle.bodyMedium(context).copyWith(
            color: OsmeaColors.grayMaterial[500],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required String title,
    required IconData icon,
    required VoidCallback onEdit,
    required Widget content,
  }) {
    final activeColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_focused_border_color',
      OsmeaColors.black,
    );

    return Container(
      padding: EdgeInsets.all(context.spacing16),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: OsmeaColors.grayMaterial[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with edit button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: activeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: activeColor, size: 18),
              ),
              SizedBox(width: context.spacing10),
              Expanded(
                child: Text(
                  title,
                  style: OsmeaTextStyle.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              GestureDetector(
                onTap: isProcessing ? null : onEdit,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing10,
                    vertical: context.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: activeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    context.t.checkoutView.summary.edit,
                    style: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: activeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: context.spacing12),
          
          // Content
          content,
        ],
      ),
    );
  }

  Widget _buildAddressContent(BuildContext context) {
    final address = shippingAddress ?? billingAddress;
    
    if (address == null) {
      return Text(
        context.t.checkoutView.payment.noAddressSet,
        style: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.grayMaterial[500],
        ),
      );
    }

    final name = '${address['first_name'] ?? ''} ${address['last_name'] ?? ''}'.trim();
    final addressLine = address['address_1'] ?? '';
    final cityLine = '${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['postcode'] ?? ''}'.trim();
    final country = address['country'] ?? '';
    final phone = address['phone'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (name.isNotEmpty)
          Text(
            name,
            style: OsmeaTextStyle.bodyMedium(context).copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        if (addressLine.isNotEmpty) ...[
          SizedBox(height: context.spacing2),
          Text(
            addressLine,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.grayMaterial[600],
            ),
          ),
        ],
        if (cityLine.isNotEmpty) ...[
          SizedBox(height: context.spacing2),
          Text(
            cityLine,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.grayMaterial[600],
            ),
          ),
        ],
        if (country.isNotEmpty) ...[
          SizedBox(height: context.spacing2),
          Text(
            country,
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.grayMaterial[600],
            ),
          ),
        ],
        if (phone.isNotEmpty) ...[
          SizedBox(height: context.spacing6),
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                size: 14,
                color: OsmeaColors.grayMaterial[500],
              ),
              SizedBox(width: context.spacing4),
              Text(
                phone,
                style: OsmeaTextStyle.bodySmall(context).copyWith(
                  color: OsmeaColors.grayMaterial[600],
                ),
              ),
            ],
          ),
        ],
        if (billingEmail != null && billingEmail!.isNotEmpty) ...[
          SizedBox(height: context.spacing4),
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14,
                color: OsmeaColors.grayMaterial[500],
              ),
              SizedBox(width: context.spacing4),
              Expanded(
                child: Text(
                  billingEmail!,
                  style: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.grayMaterial[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildShippingContent(BuildContext context) {
    if (selectedShippingMethod == null) {
      return Text(
        context.t.checkoutView.summary.noShippingSelected,
        style: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.grayMaterial[500],
        ),
      );
    }

    final formattedPrice = selectedShippingMethod!.cost == 0
        ? context.t.checkoutView.shipping.free
        : PriceInfoCurrencyHelper.formatPrice(
            selectedShippingMethod!.cost,
            currencyCode: currencyCode,
          );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedShippingMethod!.title,
                style: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (selectedShippingMethod!.deliveryTime != null) ...[
                SizedBox(height: context.spacing2),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: OsmeaColors.grayMaterial[500],
                    ),
                    SizedBox(width: context.spacing4),
                    Text(
                      selectedShippingMethod!.deliveryTime!,
                      style: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.grayMaterial[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Text(
          formattedPrice,
          style: OsmeaTextStyle.bodyMedium(context).copyWith(
            fontWeight: FontWeight.bold,
            color: selectedShippingMethod!.cost == 0
                ? OsmeaColors.green[600]
                : OsmeaColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentContent(BuildContext context) {
    if (selectedPaymentMethod == null) {
      return Text(
        context.t.checkoutView.summary.noPaymentSelected,
        style: OsmeaTextStyle.bodyMedium(context).copyWith(
          color: OsmeaColors.grayMaterial[500],
        ),
      );
    }

    IconData methodIcon;
    switch (selectedPaymentMethod!.id) {
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
      default:
        methodIcon = Icons.payment;
    }

    return Row(
      children: [
        Icon(
          methodIcon,
          size: 20,
          color: OsmeaColors.grayMaterial[600],
        ),
        SizedBox(width: context.spacing10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedPaymentMethod!.title,
                style: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (selectedPaymentMethod!.description != null) ...[
                SizedBox(height: context.spacing2),
                Text(
                  selectedPaymentMethod!.description!,
                  style: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: OsmeaColors.grayMaterial[500],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTotal(BuildContext context, AssetConfigHelper configHelper) {
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
          _buildPriceRow(
            context,
            label: context.t.checkoutView.orderSummary.subtotal,
            value: formattedSubtotal,
          ),
          SizedBox(height: context.spacing8),
          _buildPriceRow(
            context,
            label: context.t.checkoutView.orderSummary.shipping,
            value: formattedShipping,
            valueColor: shippingCost == 0 ? OsmeaColors.green[600] : null,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.spacing12),
            child: Divider(color: OsmeaColors.grayMaterial[300], height: 1),
          ),
          _buildPriceRow(
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

  Widget _buildPriceRow(
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
                  : OsmeaTextStyle.bodyMedium(context))
              .copyWith(
            color: isBold ? OsmeaColors.black : OsmeaColors.grayMaterial[600],
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: (isLarge
                  ? OsmeaTextStyle.titleLarge(context)
                  : OsmeaTextStyle.bodyMedium(context))
              .copyWith(
            color: valueColor ?? OsmeaColors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, AssetConfigHelper configHelper) {
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
                onPressed: isProcessing ? null : onCompleteOrder,
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
                          Icon(
                            Icons.lock_outline,
                            color: buttonTextColor,
                            size: 18,
                          ),
                          SizedBox(width: context.spacing8),
                          Text(
                            context.t.checkoutView.buttons.placeOrder,
                            style: OsmeaTextStyle.titleMedium(context).copyWith(
                              color: buttonTextColor,
                              fontWeight: FontWeight.w600,
                            ),
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
