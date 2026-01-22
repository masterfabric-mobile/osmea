/*
 * PaymentStepWidget
 * -----------------
 * Step 3: Payment Method Selection & Order Confirmation
 * Shows available payment options and final order summary
 */

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/gen/translations.g.dart';

class _MatchInfo {
  final int start;
  final int end;
  final String type;

  _MatchInfo(this.start, this.end, this.type);
}

class PaymentStepWidget extends StatefulWidget {
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
  State<PaymentStepWidget> createState() => _PaymentStepWidgetState();
}

class _PaymentStepWidgetState extends State<PaymentStepWidget> {
  bool _isAgreementAccepted = false;
  bool _isPreliminaryFormExpanded = true;
  bool _isDistanceSalesExpanded = false;

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
                ...widget.paymentMethods.map((method) => Padding(
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
                
                SizedBox(height: context.spacing20),
                
                // Payment Agreements Section
                _buildAgreementsSection(context, configHelper),
                
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
    final isSelected = method.id == widget.selectedMethodId;
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
      onTap: method.enabled ? () => widget.onMethodSelected(method.id) : null,
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
    final address = widget.shippingAddress ?? widget.billingAddress;
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
                      widget.shippingMethodName ?? context.t.checkoutView.payment.standardShipping,
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
    final total = widget.subtotal + widget.shippingCost;
    
    final formattedSubtotal = PriceInfoCurrencyHelper.formatPrice(
      widget.subtotal,
      currencyCode: widget.currencyCode,
    );
    final formattedShipping = widget.shippingCost == 0
        ? context.t.checkoutView.shipping.free
        : PriceInfoCurrencyHelper.formatPrice(widget.shippingCost, currencyCode: widget.currencyCode);
    final formattedTotal = PriceInfoCurrencyHelper.formatPrice(
      total,
      currencyCode: widget.currencyCode,
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
            valueColor: widget.shippingCost == 0 ? OsmeaColors.greenMaterial[600] : null,
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
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: (isLarge
                    ? OsmeaTextStyle.bodyLarge(context)
                    : OsmeaTextStyle.bodyMedium(context))
                .copyWith(
              color: isBold ? OsmeaColors.black : OsmeaColors.grayMaterial[600],
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        SizedBox(width: context.spacing12),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: (isLarge
                    ? OsmeaTextStyle.titleLarge(context)
                    : OsmeaTextStyle.bodyMedium(context))
                .copyWith(
              color: valueColor ?? OsmeaColors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreementsSection(BuildContext context, AssetConfigHelper configHelper) {
    final agreementBgColor = _getColorFromConfig(
      configHelper,
      'payment_agreements.agreement_section_background_color',
      OsmeaColors.white,
    );
    final agreementBorderColor = _getColorFromConfig(
      configHelper,
      'payment_agreements.agreement_section_border_color',
      OsmeaColors.grayMaterial[200]!,
    );
    final agreementTextColor = _getColorFromConfig(
      configHelper,
      'payment_agreements.agreement_text_color',
      OsmeaColors.grayMaterial[600]!,
    );
    final agreementTitleColor = _getColorFromConfig(
      configHelper,
      'payment_agreements.agreement_title_color',
      OsmeaColors.black,
    );
    final linkColor = _getColorFromConfig(
      configHelper,
      'payment_agreements.checkbox_link_color',
      const Color(0xFFFF6B00),
    );

    // Get agreement content from config
    final preliminaryTitle = configHelper.getString(
      'checkout_view_configuration.payment_agreements.preliminary_information_form.title',
      'Preliminary Information Form',
    );
    final preliminaryContent = configHelper.getString(
      'checkout_view_configuration.payment_agreements.preliminary_information_form.content',
      '',
    );
    final distanceSalesTitle = configHelper.getString(
      'checkout_view_configuration.payment_agreements.distance_sales_agreement.title',
      'Distance Sales Agreement',
    );
    final distanceSalesContent = configHelper.getString(
      'checkout_view_configuration.payment_agreements.distance_sales_agreement.content',
      '',
    );
    final checkboxText = configHelper.getString(
      'checkout_view_configuration.payment_agreements.checkbox_text',
      'I approve the Preliminary Information Form and the Distance Sales Agreement.',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preliminary Information Form
        _buildAgreementExpansionTile(
          context,
          configHelper,
          title: preliminaryTitle,
          content: preliminaryContent,
          isExpanded: _isPreliminaryFormExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isPreliminaryFormExpanded = expanded;
            });
          },
          agreementBgColor: agreementBgColor,
          agreementBorderColor: agreementBorderColor,
          agreementTextColor: agreementTextColor,
          agreementTitleColor: agreementTitleColor,
        ),
        
        SizedBox(height: context.spacing12),
        
        // Distance Sales Agreement
        _buildAgreementExpansionTile(
          context,
          configHelper,
          title: distanceSalesTitle,
          content: distanceSalesContent,
          isExpanded: _isDistanceSalesExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isDistanceSalesExpanded = expanded;
            });
          },
          agreementBgColor: agreementBgColor,
          agreementBorderColor: agreementBorderColor,
          agreementTextColor: agreementTextColor,
          agreementTitleColor: agreementTitleColor,
        ),
        
        SizedBox(height: context.spacing16),
        
        // Agreement Checkbox
        _buildAgreementCheckbox(
          context,
          configHelper,
          checkboxText: checkboxText,
          linkColor: linkColor,
          preliminaryTitle: preliminaryTitle,
          distanceSalesTitle: distanceSalesTitle,
          preliminaryContent: preliminaryContent,
          distanceSalesContent: distanceSalesContent,
        ),
      ],
    );
  }

  Widget _buildAgreementExpansionTile(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required String title,
    required String content,
    required bool isExpanded,
    required ValueChanged<bool> onExpansionChanged,
    required Color agreementBgColor,
    required Color agreementBorderColor,
    required Color agreementTextColor,
    required Color agreementTitleColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: agreementBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: agreementBorderColor,
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            title,
            style: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.w600,
              color: agreementTitleColor,
            ),
          ),
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: agreementTitleColor,
          ),
          children: [
            if (content.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(context.spacing16),
                child: Text(
                  content,
                  style: OsmeaTextStyle.bodySmall(context).copyWith(
                    color: agreementTextColor,
                    height: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementCheckbox(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required String checkboxText,
    required Color linkColor,
    required String preliminaryTitle,
    required String distanceSalesTitle,
    required String preliminaryContent,
    required String distanceSalesContent,
  }) {
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAgreementAccepted = !_isAgreementAccepted;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.85,
            child: Checkbox(
              value: _isAgreementAccepted,
              onChanged: (value) {
                setState(() {
                  _isAgreementAccepted = value ?? false;
                });
              },
              activeColor: linkColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          SizedBox(width: context.spacing4),
          Expanded(
            child: _buildCheckboxTextWithLinks(
              context,
              checkboxText,
              linkColor,
              preliminaryTitle,
              distanceSalesTitle,
              preliminaryContent,
              distanceSalesContent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTextWithLinks(
    BuildContext context,
    String text,
    Color linkColor,
    String preliminaryTitle,
    String distanceSalesTitle,
    String preliminaryContent,
    String distanceSalesContent,
  ) {
    final spans = <TextSpan>[];
    // Match "Preliminary Information Form" with optional "the" before it
    final preliminaryPattern = RegExp(r'(?:the\s+)?Preliminary Information Form', caseSensitive: false);
    // Match "Distance Sales Agreement" with optional "the" before it
    final distanceSalesPattern = RegExp(r'(?:the\s+)?Distance Sales Agreement', caseSensitive: false);
    
    int lastIndex = 0;
    
    // Find all matches
    final allMatches = <_MatchInfo>[];
    for (final match in preliminaryPattern.allMatches(text)) {
      allMatches.add(_MatchInfo(match.start, match.end, 'preliminary'));
    }
    for (final match in distanceSalesPattern.allMatches(text)) {
      allMatches.add(_MatchInfo(match.start, match.end, 'distance'));
    }
    
    // Sort by position
    allMatches.sort((a, b) => a.start.compareTo(b.start));
    
    for (final match in allMatches) {
      // Add text before match
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: OsmeaTextStyle.bodySmall(context).copyWith(
            color: OsmeaColors.black,
          ),
        ));
      }
      
      // Add link
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: OsmeaTextStyle.bodySmall(context).copyWith(
          color: linkColor,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showAgreementDialog(
              context,
              match.type == 'preliminary' ? preliminaryTitle : distanceSalesTitle,
              match.type == 'preliminary' ? preliminaryContent : distanceSalesContent,
            );
          },
      ));
      
      lastIndex = match.end;
    }
    
    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: OsmeaTextStyle.bodySmall(context).copyWith(
          color: OsmeaColors.black,
        ),
      ));
    }
    
    return RichText(
      text: TextSpan(children: spans),
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
    );
  }

  void _showAgreementDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: OsmeaTextStyle.titleLarge(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: OsmeaTextStyle.bodyMedium(context).copyWith(
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.t.checkoutView.buttons.back,
              style: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.black,
              ),
            ),
          ),
        ],
      ),
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

    final hasSelection = widget.selectedMethodId != null;
    final canComplete = hasSelection && _isAgreementAccepted && !widget.isProcessing;

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
                onPressed: widget.isProcessing ? null : widget.onBack,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: context.spacing12),
                  side: BorderSide(
                    color: widget.isProcessing 
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
                    color: widget.isProcessing 
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
                onPressed: canComplete ? widget.onCompleteOrder : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBgColor,
                  disabledBackgroundColor: buttonBgColor.withOpacity(0.3),
                  padding: EdgeInsets.symmetric(vertical: context.spacing12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: widget.isProcessing
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
