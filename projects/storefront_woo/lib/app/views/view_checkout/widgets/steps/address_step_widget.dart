/*
 * AddressStepWidget
 * -----------------
 * Step 1: Billing & Shipping Address form
 * Shows cached addresses for quick selection or allows manual entry
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/gen/translations.g.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_dashboard_response.dart';
import 'package:apis/network/remote/woocommerce/users_manager/freezed_model/response/get_user_orders_response.dart';

class AddressStepWidget extends StatefulWidget {
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
  State<AddressStepWidget> createState() => _AddressStepWidgetState();
}

class _AddressStepWidgetState extends State<AddressStepWidget> {
  List<UserAddress> _cachedAddresses = [];
  UserAddress? _selectedBillingAddress;
  bool _showManualForm = false;
  bool _isLoadingAddresses = true;
  bool _showAllAddresses = false;

  @override
  void initState() {
    super.initState();
    _loadCachedAddresses();
  }

  Future<void> _loadCachedAddresses() async {
    try {
      setState(() {
        _isLoadingAddresses = true;
      });

      final storage = LocalStorageHelper();
      
      // Load saved addresses
      final savedAddressesJson = await storage.getItem('user_addresses_cache');
      final List<UserAddress> savedAddresses = [];
      
      if (savedAddressesJson != null && savedAddressesJson.isNotEmpty) {
        final List<dynamic> addressesList = jsonDecode(savedAddressesJson);
        savedAddresses.addAll(
          addressesList.map((json) => UserAddress.fromJson(json as Map<String, dynamic>)).toList(),
        );
      }

      // Load order addresses from order cache
      final ordersJson = await storage.getItem('user_orders_cache');
      final List<UserAddress> orderAddresses = [];
      
      if (ordersJson != null && ordersJson.isNotEmpty) {
        try {
          final List<dynamic> ordersList = jsonDecode(ordersJson);
          final orders = ordersList
              .map((json) => DetailedUserOrder.fromJson(json as Map<String, dynamic>))
              .toList();
          
          // Extract addresses from orders
          final Set<String> seenAddresses = {};
          
          for (final order in orders) {
            // Process billing address
            if (order.billing != null) {
              final billing = order.billing!;
              final addressKey = '${billing.address1 ?? ''}_${billing.city ?? ''}_${billing.postcode ?? ''}';
              
              if (!seenAddresses.contains(addressKey) && 
                  billing.address1 != null && 
                  billing.address1!.isNotEmpty) {
                seenAddresses.add(addressKey);
                orderAddresses.add(UserAddress(
                  id: order.id,
                  addressType: 'billing',
                  label: 'Billing Address',
                  firstName: billing.firstName,
                  lastName: billing.lastName,
                  company: billing.company,
                  address1: billing.address1,
                  address2: billing.address2,
                  city: billing.city,
                  state: billing.state,
                  postcode: billing.postcode,
                  country: billing.country,
                  email: billing.email,
                  phone: billing.phone,
                  isDefault: false,
                  createdAt: order.dateCreated,
                  updatedAt: order.dateCreated,
                ));
              }
            }

            // Process shipping address
            if (order.shipping != null) {
              final shipping = order.shipping!;
              final addressKey = '${shipping.address1 ?? ''}_${shipping.city ?? ''}_${shipping.postcode ?? ''}';
              
              if (!seenAddresses.contains(addressKey) && 
                  shipping.address1 != null && 
                  shipping.address1!.isNotEmpty) {
                seenAddresses.add(addressKey);
                orderAddresses.add(UserAddress(
                  id: order.id + 1000000,
                  addressType: 'shipping',
                  label: 'Shipping Address',
                  firstName: shipping.firstName,
                  lastName: shipping.lastName,
                  company: shipping.company,
                  address1: shipping.address1,
                  address2: shipping.address2,
                  city: shipping.city,
                  state: shipping.state,
                  postcode: shipping.postcode,
                  country: shipping.country,
                  email: null,
                  phone: null,
                  isDefault: false,
                  createdAt: order.dateCreated,
                  updatedAt: order.dateCreated,
                ));
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ Error parsing order addresses: $e');
        }
      }

      setState(() {
        _cachedAddresses = [...savedAddresses, ...orderAddresses];
        _isLoadingAddresses = false;
      });
    } catch (e) {
      debugPrint('⚠️ Error loading cached addresses: $e');
      setState(() {
        _isLoadingAddresses = false;
      });
    }
  }

  void _selectAddress(UserAddress address) {
    setState(() {
      _selectedBillingAddress = address;
      _showManualForm = false;
    });

    // Fill billing form with selected address
    widget.billingFirstNameController.text = address.firstName ?? '';
    widget.billingLastNameController.text = address.lastName ?? '';
    widget.billingEmailController.text = address.email ?? '';
    widget.billingPhoneController.text = address.phone ?? '';
    widget.billingAddress1Controller.text = address.address1 ?? '';
    widget.billingCityController.text = address.city ?? '';
    widget.billingStateController.text = address.state ?? '';
    widget.billingPostcodeController.text = address.postcode ?? '';
    widget.billingCountryController.text = address.country ?? '';

    // If same as billing is checked, also fill shipping
    if (widget.sameAsBilling) {
      widget.shippingFirstNameController.text = address.firstName ?? '';
      widget.shippingLastNameController.text = address.lastName ?? '';
      widget.shippingPhoneController.text = address.phone ?? '';
      widget.shippingAddress1Controller.text = address.address1 ?? '';
      widget.shippingCityController.text = address.city ?? '';
      widget.shippingStateController.text = address.state ?? '';
      widget.shippingPostcodeController.text = address.postcode ?? '';
      widget.shippingCountryController.text = address.country ?? '';
    }
  }

  void _showAddAddressBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _AddAddressBottomSheet(
          billingFirstNameController: widget.billingFirstNameController,
          billingLastNameController: widget.billingLastNameController,
          billingEmailController: widget.billingEmailController,
          billingPhoneController: widget.billingPhoneController,
          billingAddress1Controller: widget.billingAddress1Controller,
          billingCityController: widget.billingCityController,
          billingStateController: widget.billingStateController,
          billingPostcodeController: widget.billingPostcodeController,
          billingCountryController: widget.billingCountryController,
          formKey: widget.formKey,
          onSave: () {
            // Form validation is already done in bottom sheet's Save button
            // Close bottom sheet and proceed to shipping step
            Navigator.of(context).pop();
            widget.onContinue();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();
    
    return Form(
      key: widget.formKey,
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
                    showMoreCount: !_showManualForm && _cachedAddresses.isNotEmpty && !_showAllAddresses && _cachedAddresses.length > 2
                        ? _cachedAddresses.length - 2
                        : null,
                  ),
                  
                  SizedBox(height: context.spacing12),
                  
                  // Show cached addresses or manual form
                  if (_isLoadingAddresses)
                    _buildLoadingIndicator(context)
                  else if (!_showManualForm && _cachedAddresses.isNotEmpty)
                    _buildAddressList(context, configHelper)
                  else
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
                  if (!widget.sameAsBilling) ...[
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

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing24),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildAddressList(BuildContext context, AssetConfigHelper configHelper) {
    final displayedAddresses = _showAllAddresses 
        ? _cachedAddresses 
        : _cachedAddresses.take(2).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address cards (show first 2 or all)
        ...displayedAddresses.map((address) => Padding(
          padding: EdgeInsets.only(bottom: context.spacing8),
          child: _buildAddressCard(context, configHelper, address),
        )),
        
        SizedBox(height: context.spacing8),
        
        // Manual entry button
        _buildManualEntryButton(context, configHelper),
      ],
    );
  }

  Widget _buildAddressCard(BuildContext context, AssetConfigHelper configHelper, UserAddress address) {
    final isSelected = _selectedBillingAddress?.id == address.id;
    final bgColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_background_color',
      OsmeaColors.white,
    );
    final borderColor = isSelected
        ? _getColorFromConfig(
            configHelper,
            'form_fields.input_focused_border_color',
            OsmeaColors.black,
          )
        : _getColorFromConfig(
            configHelper,
            'form_fields.input_border_color',
            OsmeaColors.silver,
          );

    return GestureDetector(
      onTap: () => _selectAddress(address),
      child: Container(
        padding: EdgeInsets.all(context.spacing12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? borderColor : borderColor.withOpacity(0.3),
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? borderColor : borderColor.withOpacity(0.5),
                  width: 2,
                ),
                color: isSelected ? borderColor.withOpacity(0.1) : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14, color: borderColor)
                  : null,
            ),
            SizedBox(width: context.spacing12),
            
            // Address details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  if (address.firstName != null || address.lastName != null)
                    Text(
                      '${address.firstName ?? ''} ${address.lastName ?? ''}'.trim(),
                      style: OsmeaTextStyle.bodyMedium(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  
                  SizedBox(height: context.spacing4),
                  
                  // Address line 1
                  if (address.address1 != null && address.address1!.isNotEmpty)
                    Text(
                      address.address1!,
                      style: OsmeaTextStyle.bodySmall(context),
                    ),
                  
                  // City, State, Postcode
                  if (address.city != null || address.state != null || address.postcode != null)
                    Text(
                      [
                        address.city,
                        address.state,
                        address.postcode,
                      ].where((e) => e != null && e.isNotEmpty).join(', '),
                      style: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.pewter,
                      ),
                    ),
                  
                  // Country
                  if (address.country != null && address.country!.isNotEmpty)
                    Text(
                      address.country!,
                      style: OsmeaTextStyle.bodySmall(context).copyWith(
                        color: OsmeaColors.pewter,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualEntryButton(BuildContext context, AssetConfigHelper configHelper) {
    final borderColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_focused_border_color',
      OsmeaColors.black,
    );
    final bgColor = _getColorFromConfig(
      configHelper,
      'form_fields.input_background_color',
      OsmeaColors.white,
    );

    return GestureDetector(
      onTap: _showAddAddressBottomSheet,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing16,
          vertical: context.spacing12,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: borderColor,
              size: 24,
            ),
            SizedBox(width: context.spacing10),
            Text(
              'Add New Address',
              style: OsmeaTextStyle.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: borderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    AssetConfigHelper configHelper, {
    required String title,
    required IconData icon,
    int? showMoreCount,
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
    final showMoreColor = _getColorFromConfig(
      configHelper,
      'section_header.show_more_color',
      OsmeaColors.grayMaterial[600]!,
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
        Expanded(
          child: Text(
            title,
            style: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
        ),
        if (showMoreCount != null && showMoreCount > 0)
          GestureDetector(
            onTap: () {
              setState(() {
                _showAllAddresses = true;
              });
            },
            child: Text(
              'Show more ($showMoreCount)',
              style: OsmeaTextStyle.bodySmall(context).copyWith(
                color: showMoreColor,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
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
                controller: widget.billingFirstNameController,
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
                controller: widget.billingLastNameController,
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
                controller: widget.billingEmailController,
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
                controller: widget.billingPhoneController,
          hint: context.t.checkoutView.formFields.phone,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: context.spacing8),
        
        // Address
        _buildCompactTextField(
          context,
          configHelper,
                controller: widget.billingAddress1Controller,
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
                controller: widget.billingCityController,
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
                controller: widget.billingStateController,
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
                controller: widget.billingPostcodeController,
                hint: context.t.checkoutView.formFields.postcode,
                icon: Icons.markunread_mailbox_outlined,
              ),
            ),
            SizedBox(width: context.spacing8),
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: widget.billingCountryController,
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
                controller: widget.shippingFirstNameController,
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
                controller: widget.shippingLastNameController,
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
                controller: widget.shippingPhoneController,
          hint: context.t.checkoutView.formFields.phone,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: context.spacing8),
        
        // Address
        _buildCompactTextField(
          context,
          configHelper,
                controller: widget.shippingAddress1Controller,
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
                controller: widget.shippingCityController,
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
                controller: widget.shippingStateController,
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
                controller: widget.shippingPostcodeController,
                hint: context.t.checkoutView.formFields.postcode,
                icon: Icons.markunread_mailbox_outlined,
              ),
            ),
            SizedBox(width: context.spacing8),
            Expanded(
              child: _buildCompactTextField(
                context,
                configHelper,
                controller: widget.shippingCountryController,
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
      onTap: () => widget.onSameAsBillingChanged(!widget.sameAsBilling),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing12,
          vertical: context.spacing10,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              widget.sameAsBilling ? Icons.check_box : Icons.check_box_outline_blank,
              color: widget.sameAsBilling ? activeColor : inactiveColor,
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
          onPressed: () {
            // Check if address is selected or manual form is filled
            if (_selectedBillingAddress != null) {
              // Address selected from cache, proceed
              widget.onContinue();
            } else if (_showManualForm) {
              // Manual form is shown, validate it
              if (widget.formKey.currentState?.validate() ?? false) {
                widget.onContinue();
              } else {
                // Form is invalid, show snackbar
                context.snackbarWarning(
                  context.t.checkoutView.messages.fillRequiredFields,
                  duration: const Duration(seconds: 2),
                );
              }
            } else {
              // No address selected, show snackbar
              context.snackbarWarning(
                context.t.checkoutView.messages.selectAddress,
                duration: const Duration(seconds: 2),
              );
            }
          },
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

/// Bottom sheet widget for adding new address
class _AddAddressBottomSheet extends StatefulWidget {
  final TextEditingController billingFirstNameController;
  final TextEditingController billingLastNameController;
  final TextEditingController billingEmailController;
  final TextEditingController billingPhoneController;
  final TextEditingController billingAddress1Controller;
  final TextEditingController billingCityController;
  final TextEditingController billingStateController;
  final TextEditingController billingPostcodeController;
  final TextEditingController billingCountryController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSave;

  const _AddAddressBottomSheet({
    required this.billingFirstNameController,
    required this.billingLastNameController,
    required this.billingEmailController,
    required this.billingPhoneController,
    required this.billingAddress1Controller,
    required this.billingCityController,
    required this.billingStateController,
    required this.billingPostcodeController,
    required this.billingCountryController,
    required this.formKey,
    required this.onSave,
  });

  @override
  State<_AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<_AddAddressBottomSheet> {
  final _localFormKey = GlobalKey<FormState>();
  final configHelper = AssetConfigHelper();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: context.spacing8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: OsmeaColors.silver,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing16,
              vertical: context.spacing12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Add New Address',
                    style: OsmeaTextStyle.titleLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
          
          Divider(height: 1),
          
          // Form content
          Flexible(
            child: Form(
              key: _localFormKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.spacing16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name row
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactTextField(
                            context,
                            configHelper,
                            controller: widget.billingFirstNameController,
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
                            controller: widget.billingLastNameController,
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
                      controller: widget.billingEmailController,
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
                      controller: widget.billingPhoneController,
                      hint: context.t.checkoutView.formFields.phone,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: context.spacing8),
                    
                    // Address
                    _buildCompactTextField(
                      context,
                      configHelper,
                      controller: widget.billingAddress1Controller,
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
                            controller: widget.billingCityController,
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
                            controller: widget.billingStateController,
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
                            controller: widget.billingPostcodeController,
                            hint: context.t.checkoutView.formFields.postcode,
                            icon: Icons.markunread_mailbox_outlined,
                          ),
                        ),
                        SizedBox(width: context.spacing8),
                        Expanded(
                          child: _buildCompactTextField(
                            context,
                            configHelper,
                            controller: widget.billingCountryController,
                            hint: context.t.checkoutView.formFields.country,
                            icon: Icons.public,
                            validator: (v) => v?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom button
          Container(
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
                onPressed: () {
                  if (_localFormKey.currentState?.validate() ?? false) {
                    widget.onSave();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getColorFromConfig(
                    configHelper,
                    'order_summary.button_background_color',
                    OsmeaColors.black,
                  ),
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
                      'Save Address',
                      style: OsmeaTextStyle.titleMedium(context).copyWith(
                        color: _getColorFromConfig(
                          configHelper,
                          'order_summary.button_text_color',
                          OsmeaColors.white,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
