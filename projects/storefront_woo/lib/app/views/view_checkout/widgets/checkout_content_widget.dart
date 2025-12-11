/*
 * CheckoutContentWidget
 * ---------------------
 * Widget that displays checkout form with billing and shipping addresses.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';

class CheckoutContentWidget extends StatefulWidget {
  final CheckoutViewModel viewModel;
  final CheckoutLoadedState state;

  const CheckoutContentWidget({
    super.key,
    required this.viewModel,
    required this.state,
  });

  @override
  State<CheckoutContentWidget> createState() => _CheckoutContentWidgetState();
}

class _CheckoutContentWidgetState extends State<CheckoutContentWidget> {
  final _formKey = GlobalKey<FormState>();
  
  final _billingFirstNameController = TextEditingController();
  final _billingLastNameController = TextEditingController();
  final _billingEmailController = TextEditingController();
  final _billingPhoneController = TextEditingController();
  final _billingAddress1Controller = TextEditingController();
  final _billingAddress2Controller = TextEditingController();
  final _billingCityController = TextEditingController();
  final _billingStateController = TextEditingController();
  final _billingPostcodeController = TextEditingController();
  final _billingCountryController = TextEditingController(text: 'TR');

  final _shippingFirstNameController = TextEditingController();
  final _shippingLastNameController = TextEditingController();
  final _shippingPhoneController = TextEditingController();
  final _shippingAddress1Controller = TextEditingController();
  final _shippingAddress2Controller = TextEditingController();
  final _shippingCityController = TextEditingController();
  final _shippingStateController = TextEditingController();
  final _shippingPostcodeController = TextEditingController();
  final _shippingCountryController = TextEditingController(text: 'TR');

  bool _sameAsBilling = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSavedFormData();
    _setupFormListeners();
    
    // Listen to viewModel state changes for loading state
    widget.viewModel.stream.listen((state) {
      if (mounted) {
        if (state is CheckoutProcessingOrderState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is CheckoutOrderCompletedState || state is CheckoutErrorState) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  void _loadUserData() {
    try {
      final authCubit = GetIt.I<AuthCubit>();
      final authState = authCubit.state;
      if (authState is AuthAuthenticatedState && authState.userData != null) {
        final userData = authState.userData!;
        _billingEmailController.text = userData['email'] as String? ?? '';
        // Could load more user data here
      }
    } catch (e) {
      debugPrint('⚠️ Could not load user data: $e');
    }
  }

  /// Load saved form data from local storage
  Future<void> _loadSavedFormData() async {
    try {
      final storage = LocalStorageHelper();
      await storage.init();

      // Load billing address
      final billingFirstName = await storage.getItem('checkout_billing_first_name');
      final billingLastName = await storage.getItem('checkout_billing_last_name');
      final billingEmail = await storage.getItem('checkout_billing_email');
      final billingPhone = await storage.getItem('checkout_billing_phone');
      final billingAddress1 = await storage.getItem('checkout_billing_address_1');
      final billingAddress2 = await storage.getItem('checkout_billing_address_2');
      final billingCity = await storage.getItem('checkout_billing_city');
      final billingState = await storage.getItem('checkout_billing_state');
      final billingPostcode = await storage.getItem('checkout_billing_postcode');
      final billingCountry = await storage.getItem('checkout_billing_country');

      // Load shipping address
      final shippingFirstName = await storage.getItem('checkout_shipping_first_name');
      final shippingLastName = await storage.getItem('checkout_shipping_last_name');
      final shippingPhone = await storage.getItem('checkout_shipping_phone');
      final shippingAddress1 = await storage.getItem('checkout_shipping_address_1');
      final shippingAddress2 = await storage.getItem('checkout_shipping_address_2');
      final shippingCity = await storage.getItem('checkout_shipping_city');
      final shippingState = await storage.getItem('checkout_shipping_state');
      final shippingPostcode = await storage.getItem('checkout_shipping_postcode');
      final shippingCountry = await storage.getItem('checkout_shipping_country');

      // Load same as billing preference
      final sameAsBilling = await storage.getItem('checkout_same_as_billing');

      // Restore billing address
      if (billingFirstName != null) _billingFirstNameController.text = billingFirstName;
      if (billingLastName != null) _billingLastNameController.text = billingLastName;
      if (billingEmail != null && _billingEmailController.text.isEmpty) {
        _billingEmailController.text = billingEmail;
      }
      if (billingPhone != null) _billingPhoneController.text = billingPhone;
      if (billingAddress1 != null) _billingAddress1Controller.text = billingAddress1;
      if (billingAddress2 != null) _billingAddress2Controller.text = billingAddress2;
      if (billingCity != null) _billingCityController.text = billingCity;
      if (billingState != null) _billingStateController.text = billingState;
      if (billingPostcode != null) _billingPostcodeController.text = billingPostcode;
      if (billingCountry != null) _billingCountryController.text = billingCountry;

      // Restore shipping address
      if (shippingFirstName != null) _shippingFirstNameController.text = shippingFirstName;
      if (shippingLastName != null) _shippingLastNameController.text = shippingLastName;
      if (shippingPhone != null) _shippingPhoneController.text = shippingPhone;
      if (shippingAddress1 != null) _shippingAddress1Controller.text = shippingAddress1;
      if (shippingAddress2 != null) _shippingAddress2Controller.text = shippingAddress2;
      if (shippingCity != null) _shippingCityController.text = shippingCity;
      if (shippingState != null) _shippingStateController.text = shippingState;
      if (shippingPostcode != null) _shippingPostcodeController.text = shippingPostcode;
      if (shippingCountry != null) _shippingCountryController.text = shippingCountry;

      // Restore same as billing preference
      if (sameAsBilling != null) {
        setState(() {
          _sameAsBilling = sameAsBilling == 'true';
          if (_sameAsBilling) {
            _copyBillingToShipping();
          }
        });
      }

      debugPrint('✅ Checkout form data loaded from storage');
    } catch (e) {
      debugPrint('⚠️ Could not load saved form data: $e');
    }
  }

  /// Save form data to local storage
  Future<void> _saveFormData() async {
    try {
      final storage = LocalStorageHelper();
      await storage.init();

      // Save billing address
      await storage.setItem('checkout_billing_first_name', _billingFirstNameController.text);
      await storage.setItem('checkout_billing_last_name', _billingLastNameController.text);
      await storage.setItem('checkout_billing_email', _billingEmailController.text);
      await storage.setItem('checkout_billing_phone', _billingPhoneController.text);
      await storage.setItem('checkout_billing_address_1', _billingAddress1Controller.text);
      await storage.setItem('checkout_billing_address_2', _billingAddress2Controller.text);
      await storage.setItem('checkout_billing_city', _billingCityController.text);
      await storage.setItem('checkout_billing_state', _billingStateController.text);
      await storage.setItem('checkout_billing_postcode', _billingPostcodeController.text);
      await storage.setItem('checkout_billing_country', _billingCountryController.text);

      // Save shipping address
      await storage.setItem('checkout_shipping_first_name', _shippingFirstNameController.text);
      await storage.setItem('checkout_shipping_last_name', _shippingLastNameController.text);
      await storage.setItem('checkout_shipping_phone', _shippingPhoneController.text);
      await storage.setItem('checkout_shipping_address_1', _shippingAddress1Controller.text);
      await storage.setItem('checkout_shipping_address_2', _shippingAddress2Controller.text);
      await storage.setItem('checkout_shipping_city', _shippingCityController.text);
      await storage.setItem('checkout_shipping_state', _shippingStateController.text);
      await storage.setItem('checkout_shipping_postcode', _shippingPostcodeController.text);
      await storage.setItem('checkout_shipping_country', _shippingCountryController.text);

      // Save same as billing preference
      await storage.setItem('checkout_same_as_billing', _sameAsBilling.toString());

      debugPrint('💾 Checkout form data saved to storage');
    } catch (e) {
      debugPrint('⚠️ Could not save form data: $e');
    }
  }

  /// Setup listeners to auto-save form data on changes
  void _setupFormListeners() {
    // Billing address listeners
    _billingFirstNameController.addListener(_saveFormData);
    _billingLastNameController.addListener(_saveFormData);
    _billingEmailController.addListener(_saveFormData);
    _billingPhoneController.addListener(_saveFormData);
    _billingAddress1Controller.addListener(_saveFormData);
    _billingAddress2Controller.addListener(_saveFormData);
    _billingCityController.addListener(_saveFormData);
    _billingStateController.addListener(_saveFormData);
    _billingPostcodeController.addListener(_saveFormData);
    _billingCountryController.addListener(_saveFormData);

    // Shipping address listeners
    _shippingFirstNameController.addListener(_saveFormData);
    _shippingLastNameController.addListener(_saveFormData);
    _shippingPhoneController.addListener(_saveFormData);
    _shippingAddress1Controller.addListener(_saveFormData);
    _shippingAddress2Controller.addListener(_saveFormData);
    _shippingCityController.addListener(_saveFormData);
    _shippingStateController.addListener(_saveFormData);
    _shippingPostcodeController.addListener(_saveFormData);
    _shippingCountryController.addListener(_saveFormData);
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    _billingFirstNameController.removeListener(_saveFormData);
    _billingLastNameController.removeListener(_saveFormData);
    _billingEmailController.removeListener(_saveFormData);
    _billingPhoneController.removeListener(_saveFormData);
    _billingAddress1Controller.removeListener(_saveFormData);
    _billingAddress2Controller.removeListener(_saveFormData);
    _billingCityController.removeListener(_saveFormData);
    _billingStateController.removeListener(_saveFormData);
    _billingPostcodeController.removeListener(_saveFormData);
    _billingCountryController.removeListener(_saveFormData);
    _shippingFirstNameController.removeListener(_saveFormData);
    _shippingLastNameController.removeListener(_saveFormData);
    _shippingPhoneController.removeListener(_saveFormData);
    _shippingAddress1Controller.removeListener(_saveFormData);
    _shippingAddress2Controller.removeListener(_saveFormData);
    _shippingCityController.removeListener(_saveFormData);
    _shippingStateController.removeListener(_saveFormData);
    _shippingPostcodeController.removeListener(_saveFormData);
    _shippingCountryController.removeListener(_saveFormData);

    // Dispose controllers
    _billingFirstNameController.dispose();
    _billingLastNameController.dispose();
    _billingEmailController.dispose();
    _billingPhoneController.dispose();
    _billingAddress1Controller.dispose();
    _billingAddress2Controller.dispose();
    _billingCityController.dispose();
    _billingStateController.dispose();
    _billingPostcodeController.dispose();
    _billingCountryController.dispose();
    _shippingFirstNameController.dispose();
    _shippingLastNameController.dispose();
    _shippingPhoneController.dispose();
    _shippingAddress1Controller.dispose();
    _shippingAddress2Controller.dispose();
    _shippingCityController.dispose();
    _shippingStateController.dispose();
    _shippingPostcodeController.dispose();
    _shippingCountryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Billing Address Section
            _buildSectionHeader(context, 'Billing Address', Icons.receipt),
            _buildBillingForm(context),
            
            OsmeaComponents.sizedBox(height: 24),
            
            // Shipping Address Section
            _buildSectionHeader(context, 'Shipping Address', Icons.local_shipping),
            _buildSameAsBillingCheckbox(context),
            _buildShippingForm(context),
            
            OsmeaComponents.sizedBox(height: 24),
            
            // Order Summary
            _buildOrderSummary(context),
            
            OsmeaComponents.sizedBox(height: 24),
            
            // Payment Method Selection
            _buildPaymentMethodSection(context),
            
            OsmeaComponents.sizedBox(height: 32),
            
            // Continue to Payment Button
            _buildContinueButton(context),
            
            OsmeaComponents.sizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: OsmeaComponents.row(
        children: [
          Icon(icon, color: OsmeaColors.nordicBlue, size: context.iconSizeNormal),
          OsmeaComponents.sizedBox(width: 8),
          OsmeaComponents.text(
            title,
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
            color: OsmeaColors.thunder,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingForm(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      padding: context.paddingNormal,
      decoration: BoxDecoration(
        color: OsmeaColors.paperWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: _billingFirstNameController,
                  label: 'First Name',
                  icon: Icons.person,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _billingLastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _billingEmailController,
            label: 'Email',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Required';
              if (!value!.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _billingPhoneController,
            label: 'Phone',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _billingAddress1Controller,
            label: 'Address Line 1',
            icon: Icons.home,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _billingAddress2Controller,
            label: 'Address Line 2 (Optional)',
            icon: Icons.home_outlined,
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: _billingCityController,
                  label: 'City',
                  icon: Icons.location_city,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _billingStateController,
                  label: 'State',
                  icon: Icons.map,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: _billingPostcodeController,
                  label: 'Postcode',
                  icon: Icons.markunread_mailbox,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _billingCountryController,
                  label: 'Country',
                  icon: Icons.public,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSameAsBillingCheckbox(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: CheckboxListTile(
        value: _sameAsBilling,
        onChanged: (value) {
          setState(() {
            _sameAsBilling = value ?? false;
            if (_sameAsBilling) {
              _copyBillingToShipping();
            }
            _saveFormData(); // Save preference change
          });
        },
        title: OsmeaComponents.text(
          'Same as billing address',
          textStyle: OsmeaTextStyle.bodyMedium(context),
          color: OsmeaColors.thunder,
        ),
        activeColor: OsmeaColors.nordicBlue,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  void _copyBillingToShipping() {
    _shippingFirstNameController.text = _billingFirstNameController.text;
    _shippingLastNameController.text = _billingLastNameController.text;
    _shippingPhoneController.text = _billingPhoneController.text;
    _shippingAddress1Controller.text = _billingAddress1Controller.text;
    _shippingAddress2Controller.text = _billingAddress2Controller.text;
    _shippingCityController.text = _billingCityController.text;
    _shippingStateController.text = _billingStateController.text;
    _shippingPostcodeController.text = _billingPostcodeController.text;
    _shippingCountryController.text = _billingCountryController.text;
  }

  Widget _buildShippingForm(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      padding: context.paddingNormal,
      decoration: BoxDecoration(
        color: OsmeaColors.paperWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: Opacity(
        opacity: _sameAsBilling ? 0.5 : 1.0,
        child: OsmeaComponents.column(
          children: [
            OsmeaComponents.row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    controller: _shippingFirstNameController,
                    label: 'First Name',
                    icon: Icons.person,
                    enabled: !_sameAsBilling,
                    validator: _sameAsBilling
                        ? null
                        : (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),
                Expanded(
                  child: _buildTextFormField(
                    controller: _shippingLastNameController,
                    label: 'Last Name',
                    icon: Icons.person_outline,
                    enabled: !_sameAsBilling,
                    validator: _sameAsBilling
                        ? null
                        : (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: 12),
            _buildTextFormField(
              controller: _shippingPhoneController,
              label: 'Phone',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              enabled: !_sameAsBilling,
              validator: _sameAsBilling
                  ? null
                  : (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            OsmeaComponents.sizedBox(height: 12),
            _buildTextFormField(
              controller: _shippingAddress1Controller,
              label: 'Address Line 1',
              icon: Icons.home,
              enabled: !_sameAsBilling,
              validator: _sameAsBilling
                  ? null
                  : (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            OsmeaComponents.sizedBox(height: 12),
            _buildTextFormField(
              controller: _shippingAddress2Controller,
              label: 'Address Line 2 (Optional)',
              icon: Icons.home_outlined,
              enabled: !_sameAsBilling,
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    controller: _shippingCityController,
                    label: 'City',
                    icon: Icons.location_city,
                    enabled: !_sameAsBilling,
                    validator: _sameAsBilling
                        ? null
                        : (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),
                Expanded(
                  child: _buildTextFormField(
                    controller: _shippingStateController,
                    label: 'State',
                    icon: Icons.map,
                    enabled: !_sameAsBilling,
                    validator: _sameAsBilling
                        ? null
                        : (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: 12),
            OsmeaComponents.row(
              children: [
                Expanded(
                  child: _buildTextFormField(
                    controller: _shippingPostcodeController,
                    label: 'Postcode',
                    icon: Icons.markunread_mailbox,
                    enabled: !_sameAsBilling,
                    validator: _sameAsBilling
                        ? null
                        : (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
                OsmeaComponents.sizedBox(width: 12),
                Expanded(
                  child: _buildTextFormField(
                    controller: _shippingCountryController,
                    label: 'Country',
                    icon: Icons.public,
                    enabled: !_sameAsBilling,
                    validator: _sameAsBilling
                        ? null
                        : (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: OsmeaColors.nordicBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: OsmeaColors.silver),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: OsmeaColors.nordicBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final formattedTotal = PriceInfoCurrencyHelper.formatPrice(
      widget.state.totalAmount,
      currencyCode: widget.state.currencyCode,
    );

    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      padding: context.paddingNormal,
      decoration: BoxDecoration(
        color: OsmeaColors.paperWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.text(
            'Order Summary',
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
            color: OsmeaColors.thunder,
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.text(
                'Total',
                textStyle: OsmeaTextStyle.bodyLarge(context),
                color: OsmeaColors.pewter,
              ),
              OsmeaComponents.text(
                formattedTotal,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: OsmeaColors.nordicBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      padding: context.paddingNormal,
      decoration: BoxDecoration(
        color: OsmeaColors.paperWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: OsmeaColors.silver, width: 1),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            'Payment Method',
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
            color: OsmeaColors.thunder,
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.container(
            padding: context.paddingNormal,
            decoration: BoxDecoration(
              color: OsmeaColors.nordicBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OsmeaColors.nordicBlue, width: 2),
            ),
            child: OsmeaComponents.row(
              children: [
                Icon(Icons.account_balance, color: OsmeaColors.nordicBlue),
                OsmeaComponents.sizedBox(width: 12),
                Expanded(
                  child: OsmeaComponents.text(
                    'Bank Transfer (Havale/EFT)',
                    textStyle: OsmeaTextStyle.bodyLarge(context).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    color: OsmeaColors.thunder,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _handleContinue(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: OsmeaColors.nordicBlue,
          padding: context.paddingNormal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        child: _isLoading
            ? OsmeaComponents.loading(
                type: LoadingType.circularFade,
                size: 24,
                color: OsmeaColors.white,
              )
            : OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OsmeaComponents.text(
                    'Complete Order',
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      color: OsmeaColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  OsmeaComponents.sizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: OsmeaColors.white, size: 20),
                ],
              ),
      ),
    );
  }

  void _handleContinue(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      context.snackbarWarning('Please fill in all required fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Prepare billing address
    final billingAddress = {
      'first_name': _billingFirstNameController.text.trim(),
      'last_name': _billingLastNameController.text.trim(),
      'address_1': _billingAddress1Controller.text.trim(),
      'address_2': _billingAddress2Controller.text.trim(),
      'city': _billingCityController.text.trim(),
      'state': _billingStateController.text.trim(),
      'postcode': _billingPostcodeController.text.trim(),
      'country': _billingCountryController.text.trim(),
      'phone': _billingPhoneController.text.trim(),
    };

    // Prepare shipping address
    final shippingAddress = {
      'first_name': _shippingFirstNameController.text.trim(),
      'last_name': _shippingLastNameController.text.trim(),
      'address_1': _shippingAddress1Controller.text.trim(),
      'address_2': _shippingAddress2Controller.text.trim(),
      'city': _shippingCityController.text.trim(),
      'state': _shippingStateController.text.trim(),
      'postcode': _shippingPostcodeController.text.trim(),
      'country': _shippingCountryController.text.trim(),
      'phone': _shippingPhoneController.text.trim(),
    };

    // Process order directly
    widget.viewModel.processOrder(
      billingEmail: _billingEmailController.text.trim(),
      billingAddress: billingAddress,
      shippingAddress: shippingAddress,
    );
  }
}

