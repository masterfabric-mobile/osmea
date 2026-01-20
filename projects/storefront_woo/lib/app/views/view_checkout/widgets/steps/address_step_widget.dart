/*
 * AddressStepWidget
 * -----------------
 * Step 1: Billing & Shipping Address form
 * Designed to fit on screen without scrolling (compact layout)
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/gen/translations.g.dart';

class AddressStepWidget extends StatelessWidget {
  // Billing controllers
  final TextEditingController billingFirstNameController;
  final TextEditingController billingLastNameController;
  final TextEditingController billingEmailController;
  final TextEditingController billingPhoneController;
  final TextEditingController billingAddress1Controller;
  final TextEditingController billingCityController;
  final TextEditingController billingStateController;
  final TextEditingController billingPostcodeController;
  final TextEditingController billingCountryController;
  
  // Shipping controllers
  final TextEditingController shippingFirstNameController;
  final TextEditingController shippingLastNameController;
  final TextEditingController shippingPhoneController;
  final TextEditingController shippingAddress1Controller;
  final TextEditingController shippingCityController;
  final TextEditingController shippingStateController;
  final TextEditingController shippingPostcodeController;
  final TextEditingController shippingCountryController;
  
  final bool sameAsBilling;
  final ValueChanged<bool> onSameAsBillingChanged;
  final VoidCallback onContinue;
  final GlobalKey<FormState> formKey;

  const AddressStepWidget({
    super.key,
    required this.billingFirstNameController,
    required this.billingLastNameController,
    required this.billingEmailController,
    required this.billingPhoneController,
    required this.billingAddress1Controller,
    required this.billingCityController,
    required this.billingStateController,
    required this.billingPostcodeController,
    required this.billingCountryController,
    required this.shippingFirstNameController,
    required this.shippingLastNameController,
    required this.shippingPhoneController,
    required this.shippingAddress1Controller,
    required this.shippingCityController,
    required this.shippingStateController,
    required this.shippingPostcodeController,
    required this.shippingCountryController,
    required this.sameAsBilling,
    required this.onSameAsBillingChanged,
    required this.onContinue,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();
    
    return Form(
      key: formKey,
      child: Column(
        children: [
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.spacing16),
                  
                  // Billing Address Section Header
                  _buildSectionHeader(
                    context,
                    configHelper,
                    title: context.t.checkoutView.sections.billingAddress,
                    icon: Icons.receipt_outlined,
                  ),
                  
                  SizedBox(height: context.spacing12),
                  
                  // Billing Form - Compact
                  _buildBillingForm(context, configHelper),
                  
                  SizedBox(height: context.spacing20),
                  
                  // Shipping Address Section Header
                  _buildSectionHeader(
                    context,
                    configHelper,
                    title: context.t.checkoutView.sections.shippingAddress,
                    icon: Icons.local_shipping_outlined,
                  ),
                  
                  SizedBox(height: context.spacing8),
                  
                  // Same as billing checkbox
                  _buildSameAsBillingCheckbox(context, configHelper),
                  
                  // Shipping Form (only if not same as billing)
                  if (!sameAsBilling) ...[
                    SizedBox(height: context.spacing12),
                    _buildShippingForm(context, configHelper),
                  ],
                  
                  SizedBox(height: context.spacing24),
                ],
              ),
            ),
          ),
          
          // Fixed bottom button
          _buildBottomButton(context, configHelper),
        ],
      ),
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

  Widget _buildBillingForm(BuildContext context, AssetConfigHelper configHelper) {
    return Column(
      children: [
        // Name row
        Row(
          children: [
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: billingFirstNameController,
                hint: context.t.checkoutView.formFields.firstName,
                icon: Icons.person_outline,
                validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
              ),
            ),
            SizedBox(width: context.spacing8),
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: billingLastNameController,
                hint: context.t.checkoutView.formFields.lastName,
                icon: Icons.person_outline,
                validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing8),
        
        // Email
        _buildCompactTextField(
          context,
          configHelper,
          controller: billingEmailController,
          hint: context.t.checkoutView.formFields.email,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v?.isEmpty ?? true) return context.t.checkoutView.formFields.required;
            if (!v!.contains('@')) return context.t.checkoutView.formFields.invalidEmail;
            return null;
          },
        ),
        SizedBox(height: context.spacing8),
        
        // Phone
        _buildCompactTextField(
          context,
          configHelper,
          controller: billingPhoneController,
          hint: context.t.checkoutView.formFields.phone,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: context.spacing8),
        
        // Address
        _buildCompactTextField(
          context,
          configHelper,
          controller: billingAddress1Controller,
          hint: context.t.checkoutView.formFields.addressLine1,
          icon: Icons.home_outlined,
          validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
        ),
        SizedBox(height: context.spacing8),
        
        // City & State row
        Row(
          children: [
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: billingCityController,
                hint: context.t.checkoutView.formFields.city,
                icon: Icons.location_city_outlined,
                validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
              ),
            ),
            SizedBox(width: context.spacing8),
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: billingStateController,
                hint: context.t.checkoutView.formFields.state,
                icon: Icons.map_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing8),
        
        // Postcode & Country row
        Row(
          children: [
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: billingPostcodeController,
                hint: context.t.checkoutView.formFields.postcode,
                icon: Icons.markunread_mailbox_outlined,
              ),
            ),
            SizedBox(width: context.spacing8),
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: billingCountryController,
                hint: context.t.checkoutView.formFields.country,
                icon: Icons.public,
                validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShippingForm(BuildContext context, AssetConfigHelper configHelper) {
    return Column(
      children: [
        // Name row
        Row(
          children: [
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: shippingFirstNameController,
                hint: context.t.checkoutView.formFields.firstName,
                icon: Icons.person_outline,
                validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
              ),
            ),
            SizedBox(width: context.spacing8),
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: shippingLastNameController,
                hint: context.t.checkoutView.formFields.lastName,
                icon: Icons.person_outline,
                validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing8),
        
        // Phone
        _buildCompactTextField(
          context,
          configHelper,
          controller: shippingPhoneController,
          hint: context.t.checkoutView.formFields.phone,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: context.spacing8),
        
        // Address
        _buildCompactTextField(
          context,
          configHelper,
          controller: shippingAddress1Controller,
          hint: context.t.checkoutView.formFields.addressLine1,
          icon: Icons.home_outlined,
          validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
        ),
        SizedBox(height: context.spacing8),
        
        // City & State row
        Row(
          children: [
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: shippingCityController,
                hint: context.t.checkoutView.formFields.city,
                icon: Icons.location_city_outlined,
                validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
              ),
            ),
            SizedBox(width: context.spacing8),
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: shippingStateController,
                hint: context.t.checkoutView.formFields.state,
                icon: Icons.map_outlined,
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing8),
        
        // Postcode & Country row
        Row(
          children: [
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: shippingPostcodeController,
                hint: context.t.checkoutView.formFields.postcode,
                icon: Icons.markunread_mailbox_outlined,
              ),
            ),
            SizedBox(width: context.spacing8),
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: shippingCountryController,
                hint: context.t.checkoutView.formFields.country,
                icon: Icons.public,
                validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSameAsBillingCheckbox(BuildContext context, AssetConfigHelper configHelper) {
    final bgColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_background_color',
      OsmeaColors.white,
    );
    final activeColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_focused_border_color',
      OsmeaColors.black,
    );
    final inactiveColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_border_color',
      OsmeaColors.silver,
    );

    return GestureDetector(
      onTap: () => onSameAsBillingChanged(!sameAsBilling),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing12,
          vertical: context.spacing10,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: sameAsBilling ? activeColor : inactiveColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              sameAsBilling ? Icons.check_box : Icons.check_box_outline_blank,
              color: sameAsBilling ? activeColor : inactiveColor,
              size: 22,
            ),
            SizedBox(width: context.spacing8),
            Text(
              context.t.checkoutView.sections.sameAsBilling,
              style: OsmeaTextStyle.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTextField(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final bgColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_background_color',
      OsmeaColors.white,
    );
    final borderColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_border_color',
      OsmeaColors.silver,
    );
    final focusedBorderColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_focused_border_color',
      OsmeaColors.black,
    );
    final hintColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_hint_color',
      OsmeaColors.grayMaterial[400]!,
    );
    final iconColor = _getColorFromConfig(
      configHelper,
      'form_fields.prefix_icon_color',
      OsmeaColors.black,
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: OsmeaTextStyle.bodySmall(context),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: hintColor),
        prefixIcon: Icon(icon, color: iconColor, size: 18),
        filled: true,
        fillColor: bgColor,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.spacing12,
          vertical: context.spacing10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: focusedBorderColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: OsmeaColors.red[400]!, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: OsmeaColors.red[400]!, width: 1.5),
        ),
        errorStyle: OsmeaTextStyle.bodySmall(context).copyWith(
          color: OsmeaColors.red[400],
          fontSize: 10,
        ),
      ),
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
        child: ElevatedButton(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBgColor,
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
                context.t.checkoutView.buttons.continueToShipping,
                style: OsmeaTextStyle.titleMedium(context).copyWith(
                  color: buttonTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: context.spacing8),
              Icon(
                Icons.arrow_forward_rounded,
                color: buttonTextColor,
                size: 20,
              ),
            ],
          ),
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
