/*
 * CheckoutContentWidget
 * ---------------------
 * Main checkout wizard container with 4 steps:
 * Step 1: Address (Billing & Shipping)
 * Step 2: Shipping Method
 * Step 3: Payment Method
 * Step 4: Order Summary & Confirmation
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/checkout_step_indicator.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/steps/address_step_widget.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/steps/shipping_step_widget.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/steps/payment_step_widget.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/steps/summary_step_widget.dart';
import 'package:storefront_woo/gen/translations.g.dart';

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
  final _addressFormKey = GlobalKey<FormState>();

  /// Storage scope for checkout form persistence.
  String _checkoutStorageScope() {
    try {
      final authCubit = GetIt.I<AuthCubit>();
      final s = authCubit.state;
      if (s is AuthAuthenticatedState && s.userData != null) {
        final userData = s.userData!;

        final email = (userData['email'] as String?)?.trim();
        if (email != null && email.isNotEmpty) {
          final normalized = email.toLowerCase();
          final safe = normalized.replaceAll(RegExp(r'[^a-z0-9@._-]'), '_');
          return 'email_$safe';
        }

        final id = userData['id'] ?? userData['user_id'] ?? userData['userId'];
        if (id != null) {
          final safe = id.toString().replaceAll(RegExp(r'[^a-z0-9._-]'), '_');
          if (safe.isNotEmpty) return 'user_$safe';
        }

        return 'auth';
      }
    } catch (_) {}
    return 'guest';
  }

  String _scopedCheckoutKey(String legacyKey) {
    const prefix = 'checkout_';
    if (!legacyKey.startsWith(prefix)) return legacyKey;
    final scope = _checkoutStorageScope();
    return legacyKey.replaceFirst(prefix, '$prefix${scope}_');
  }

  Future<String?> _readCheckoutValueWithLegacyFallback(
    LocalStorageHelper storage, {
    required String legacyKey,
    String? currentUserEmail,
  }) async {
    final scoped = await storage.getItem(_scopedCheckoutKey(legacyKey));
    if (scoped != null) return scoped;

    final scope = _checkoutStorageScope();
    if (scope == 'guest') {
      final legacy = await storage.getItem(legacyKey);
      if (legacy != null) {
        await storage.setItem(_scopedCheckoutKey(legacyKey), legacy);
        await storage.removeItem(legacyKey);
      }
      return legacy;
    }

    final email = currentUserEmail?.trim().toLowerCase();
    if (email != null && email.isNotEmpty) {
      final legacyBillingEmail =
          (await storage.getItem('checkout_billing_email'))?.trim().toLowerCase();
      if (legacyBillingEmail == email) {
        final legacy = await storage.getItem(legacyKey);
        if (legacy != null) {
          await storage.setItem(_scopedCheckoutKey(legacyKey), legacy);
        }
        return legacy;
      }
    }

    return null;
  }

  // Billing controllers
  final _billingFirstNameController = TextEditingController();
  final _billingLastNameController = TextEditingController();
  final _billingEmailController = TextEditingController();
  final _billingPhoneController = TextEditingController();
  final _billingAddress1Controller = TextEditingController();
  final _billingCityController = TextEditingController();
  final _billingStateController = TextEditingController();
  final _billingPostcodeController = TextEditingController();
  final _billingCountryController = TextEditingController(text: 'TR');

  // Shipping controllers
  final _shippingFirstNameController = TextEditingController();
  final _shippingLastNameController = TextEditingController();
  final _shippingPhoneController = TextEditingController();
  final _shippingAddress1Controller = TextEditingController();
  final _shippingCityController = TextEditingController();
  final _shippingStateController = TextEditingController();
  final _shippingPostcodeController = TextEditingController();
  final _shippingCountryController = TextEditingController(text: 'TR');

  bool _sameAsBilling = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSavedFormData();
    _setupFormListeners();

    // Listen to viewModel state changes
    widget.viewModel.stream.listen((state) {
      if (mounted) {
        if (state is CheckoutProcessingOrderState) {
          setState(() {
            _isProcessing = true;
          });
        } else if (state is CheckoutOrderCompletedState ||
            state is CheckoutErrorState) {
          setState(() {
            _isProcessing = false;
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
      }
    } catch (e) {
      debugPrint('⚠️ Could not load user data: $e');
    }
  }

  Future<void> _loadSavedFormData() async {
    try {
      final storage = LocalStorageHelper();
      await storage.init();

      String? currentUserEmail;
      try {
        currentUserEmail = _billingEmailController.text.trim().isNotEmpty
            ? _billingEmailController.text.trim()
            : null;
      } catch (_) {}

      // Load billing address
      final billingFirstName = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_first_name',
        currentUserEmail: currentUserEmail,
      );
      final billingLastName = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_last_name',
        currentUserEmail: currentUserEmail,
      );
      final billingEmail = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_email',
        currentUserEmail: currentUserEmail,
      );
      final billingPhone = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_phone',
        currentUserEmail: currentUserEmail,
      );
      final billingAddress1 = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_address_1',
        currentUserEmail: currentUserEmail,
      );
      final billingCity = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_city',
        currentUserEmail: currentUserEmail,
      );
      final billingState = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_state',
        currentUserEmail: currentUserEmail,
      );
      final billingPostcode = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_postcode',
        currentUserEmail: currentUserEmail,
      );
      final billingCountry = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_country',
        currentUserEmail: currentUserEmail,
      );

      // Load shipping address
      final shippingFirstName = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_first_name',
        currentUserEmail: currentUserEmail,
      );
      final shippingLastName = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_last_name',
        currentUserEmail: currentUserEmail,
      );
      final shippingPhone = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_phone',
        currentUserEmail: currentUserEmail,
      );
      final shippingAddress1 = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_address_1',
        currentUserEmail: currentUserEmail,
      );
      final shippingCity = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_city',
        currentUserEmail: currentUserEmail,
      );
      final shippingState = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_state',
        currentUserEmail: currentUserEmail,
      );
      final shippingPostcode = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_postcode',
        currentUserEmail: currentUserEmail,
      );
      final shippingCountry = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_country',
        currentUserEmail: currentUserEmail,
      );

      final sameAsBilling = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_same_as_billing',
        currentUserEmail: currentUserEmail,
      );

      // Restore billing address
      if (billingFirstName != null) _billingFirstNameController.text = billingFirstName;
      if (billingLastName != null) _billingLastNameController.text = billingLastName;
      if (billingEmail != null && _billingEmailController.text.isEmpty) {
        _billingEmailController.text = billingEmail;
      }
      if (billingPhone != null) _billingPhoneController.text = billingPhone;
      if (billingAddress1 != null) _billingAddress1Controller.text = billingAddress1;
      if (billingCity != null) _billingCityController.text = billingCity;
      if (billingState != null) _billingStateController.text = billingState;
      if (billingPostcode != null) _billingPostcodeController.text = billingPostcode;
      if (billingCountry != null) _billingCountryController.text = billingCountry;

      // Restore shipping address
      if (shippingFirstName != null) _shippingFirstNameController.text = shippingFirstName;
      if (shippingLastName != null) _shippingLastNameController.text = shippingLastName;
      if (shippingPhone != null) _shippingPhoneController.text = shippingPhone;
      if (shippingAddress1 != null) _shippingAddress1Controller.text = shippingAddress1;
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

  Future<void> _saveFormData() async {
    try {
      final storage = LocalStorageHelper();
      await storage.init();

      // Save billing address
      await storage.setItem(_scopedCheckoutKey('checkout_billing_first_name'), _billingFirstNameController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_billing_last_name'), _billingLastNameController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_billing_email'), _billingEmailController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_billing_phone'), _billingPhoneController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_billing_address_1'), _billingAddress1Controller.text);
      await storage.setItem(_scopedCheckoutKey('checkout_billing_city'), _billingCityController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_billing_state'), _billingStateController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_billing_postcode'), _billingPostcodeController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_billing_country'), _billingCountryController.text);

      // Save shipping address
      await storage.setItem(_scopedCheckoutKey('checkout_shipping_first_name'), _shippingFirstNameController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_shipping_last_name'), _shippingLastNameController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_shipping_phone'), _shippingPhoneController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_shipping_address_1'), _shippingAddress1Controller.text);
      await storage.setItem(_scopedCheckoutKey('checkout_shipping_city'), _shippingCityController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_shipping_state'), _shippingStateController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_shipping_postcode'), _shippingPostcodeController.text);
      await storage.setItem(_scopedCheckoutKey('checkout_shipping_country'), _shippingCountryController.text);

      // Save same as billing preference
      await storage.setItem(_scopedCheckoutKey('checkout_same_as_billing'), _sameAsBilling.toString());

      debugPrint('💾 Checkout form data saved to storage');
    } catch (e) {
      debugPrint('⚠️ Could not save form data: $e');
    }
  }

  void _setupFormListeners() {
    // Billing address listeners
    _billingFirstNameController.addListener(_saveFormData);
    _billingLastNameController.addListener(_saveFormData);
    _billingEmailController.addListener(_saveFormData);
    _billingPhoneController.addListener(_saveFormData);
    _billingAddress1Controller.addListener(_saveFormData);
    _billingCityController.addListener(_saveFormData);
    _billingStateController.addListener(_saveFormData);
    _billingPostcodeController.addListener(_saveFormData);
    _billingCountryController.addListener(_saveFormData);

    // Shipping address listeners
    _shippingFirstNameController.addListener(_saveFormData);
    _shippingLastNameController.addListener(_saveFormData);
    _shippingPhoneController.addListener(_saveFormData);
    _shippingAddress1Controller.addListener(_saveFormData);
    _shippingCityController.addListener(_saveFormData);
    _shippingStateController.addListener(_saveFormData);
    _shippingPostcodeController.addListener(_saveFormData);
    _shippingCountryController.addListener(_saveFormData);
  }

  @override
  void dispose() {
    // Remove listeners
    _billingFirstNameController.removeListener(_saveFormData);
    _billingLastNameController.removeListener(_saveFormData);
    _billingEmailController.removeListener(_saveFormData);
    _billingPhoneController.removeListener(_saveFormData);
    _billingAddress1Controller.removeListener(_saveFormData);
    _billingCityController.removeListener(_saveFormData);
    _billingStateController.removeListener(_saveFormData);
    _billingPostcodeController.removeListener(_saveFormData);
    _billingCountryController.removeListener(_saveFormData);
    _shippingFirstNameController.removeListener(_saveFormData);
    _shippingLastNameController.removeListener(_saveFormData);
    _shippingPhoneController.removeListener(_saveFormData);
    _shippingAddress1Controller.removeListener(_saveFormData);
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
    _billingCityController.dispose();
    _billingStateController.dispose();
    _billingPostcodeController.dispose();
    _billingCountryController.dispose();
    _shippingFirstNameController.dispose();
    _shippingLastNameController.dispose();
    _shippingPhoneController.dispose();
    _shippingAddress1Controller.dispose();
    _shippingCityController.dispose();
    _shippingStateController.dispose();
    _shippingPostcodeController.dispose();
    _shippingCountryController.dispose();
    super.dispose();
  }

  void _copyBillingToShipping() {
    _shippingFirstNameController.text = _billingFirstNameController.text;
    _shippingLastNameController.text = _billingLastNameController.text;
    _shippingPhoneController.text = _billingPhoneController.text;
    _shippingAddress1Controller.text = _billingAddress1Controller.text;
    _shippingCityController.text = _billingCityController.text;
    _shippingStateController.text = _billingStateController.text;
    _shippingPostcodeController.text = _billingPostcodeController.text;
    _shippingCountryController.text = _billingCountryController.text;
  }

  Map<String, dynamic> _getBillingAddress() {
    return {
      'first_name': _billingFirstNameController.text.trim(),
      'last_name': _billingLastNameController.text.trim(),
      'address_1': _billingAddress1Controller.text.trim(),
      'address_2': '',
      'city': _billingCityController.text.trim(),
      'state': _billingStateController.text.trim(),
      'postcode': _billingPostcodeController.text.trim(),
      'country': _billingCountryController.text.trim(),
      'phone': _billingPhoneController.text.trim(),
    };
  }

  Map<String, dynamic> _getShippingAddress() {
    if (_sameAsBilling) {
      return _getBillingAddress();
    }
    return {
      'first_name': _shippingFirstNameController.text.trim(),
      'last_name': _shippingLastNameController.text.trim(),
      'address_1': _shippingAddress1Controller.text.trim(),
      'address_2': '',
      'city': _shippingCityController.text.trim(),
      'state': _shippingStateController.text.trim(),
      'postcode': _shippingPostcodeController.text.trim(),
      'country': _shippingCountryController.text.trim(),
      'phone': _shippingPhoneController.text.trim(),
    };
  }

  void _handleAddressContinue() {
    if (!_addressFormKey.currentState!.validate()) {
      context.snackbarWarning(context.t.checkoutView.messages.fillRequiredFields);
      return;
    }

    // Copy billing to shipping if needed
    if (_sameAsBilling) {
      _copyBillingToShipping();
    }

    // Update state with address data and move to shipping step
    widget.viewModel.updateAddressAndProceed(
      billingEmail: _billingEmailController.text.trim(),
      billingAddress: _getBillingAddress(),
      shippingAddress: _getShippingAddress(),
      sameAsBilling: _sameAsBilling,
    );
  }

  void _handleShippingMethodSelected(String methodId) {
    widget.viewModel.selectShippingMethod(methodId);
  }

  void _handleShippingContinue() {
    if (widget.state.selectedShippingMethodId == null) {
      context.snackbarWarning(context.t.checkoutView.messages.selectShippingMethod);
      return;
    }
    widget.viewModel.proceedToPayment();
  }

  void _handlePaymentMethodSelected(String methodId) {
    widget.viewModel.selectPaymentMethod(methodId);
  }

  void _handlePaymentContinue() {
    if (widget.state.selectedPaymentMethodId == null) {
      context.snackbarWarning(context.t.checkoutView.messages.selectPaymentMethod);
      return;
    }
    widget.viewModel.proceedToSummary();
  }

  void _handleCompleteOrder() {
    widget.viewModel.processOrder(
      billingEmail: _billingEmailController.text.trim(),
      billingAddress: _getBillingAddress(),
      shippingAddress: _getShippingAddress(),
    );
  }

  void _handleStepTapped(CheckoutStep step) {
    // Only allow going back to previous steps
    if (step.index < widget.state.currentStep.index) {
      widget.viewModel.goToStep(step);
    }
  }

  void _handleBack() {
    final currentIndex = widget.state.currentStep.index;
    if (currentIndex > 0) {
      widget.viewModel.goToStep(CheckoutStep.values[currentIndex - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Step indicator
        CheckoutStepIndicator(
          currentStep: widget.state.currentStep,
          isAddressValid: widget.state.isAddressStepValid,
          isShippingValid: widget.state.isShippingStepValid,
          isPaymentValid: widget.state.isPaymentStepValid,
          onStepTapped: _handleStepTapped,
        ),
        
        // Step content
        Expanded(
          child: _buildCurrentStep(),
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (widget.state.currentStep) {
      case CheckoutStep.address:
        return AddressStepWidget(
          formKey: _addressFormKey,
          billingFirstNameController: _billingFirstNameController,
          billingLastNameController: _billingLastNameController,
          billingEmailController: _billingEmailController,
          billingPhoneController: _billingPhoneController,
          billingAddress1Controller: _billingAddress1Controller,
          billingCityController: _billingCityController,
          billingStateController: _billingStateController,
          billingPostcodeController: _billingPostcodeController,
          billingCountryController: _billingCountryController,
          shippingFirstNameController: _shippingFirstNameController,
          shippingLastNameController: _shippingLastNameController,
          shippingPhoneController: _shippingPhoneController,
          shippingAddress1Controller: _shippingAddress1Controller,
          shippingCityController: _shippingCityController,
          shippingStateController: _shippingStateController,
          shippingPostcodeController: _shippingPostcodeController,
          shippingCountryController: _shippingCountryController,
          sameAsBilling: _sameAsBilling,
          onSameAsBillingChanged: (value) {
            setState(() {
              _sameAsBilling = value;
              if (_sameAsBilling) {
                _copyBillingToShipping();
              }
              _saveFormData();
            });
          },
          onContinue: _handleAddressContinue,
        );
        
      case CheckoutStep.shipping:
        return ShippingStepWidget(
          shippingMethods: widget.state.shippingMethods,
          selectedMethodId: widget.state.selectedShippingMethodId,
          subtotal: widget.state.subtotalAmount,
          currencyCode: widget.state.currencyCode,
          onMethodSelected: _handleShippingMethodSelected,
          onContinue: _handleShippingContinue,
          onBack: _handleBack,
        );
        
      case CheckoutStep.payment:
        return PaymentStepWidget(
          paymentMethods: widget.state.paymentMethods,
          selectedMethodId: widget.state.selectedPaymentMethodId,
          subtotal: widget.state.subtotalAmount,
          shippingCost: widget.state.shippingCost,
          currencyCode: widget.state.currencyCode,
          shippingMethodName: widget.state.selectedShippingMethod?.title,
          billingAddress: widget.state.billingAddress,
          shippingAddress: widget.state.shippingAddress,
          isProcessing: false,
          onMethodSelected: _handlePaymentMethodSelected,
          onCompleteOrder: _handlePaymentContinue,
          onBack: _handleBack,
        );
        
      case CheckoutStep.summary:
        return SummaryStepWidget(
          billingAddress: widget.state.billingAddress,
          shippingAddress: widget.state.shippingAddress,
          billingEmail: widget.state.billingEmail,
          sameAsBilling: widget.state.sameAsBilling,
          selectedShippingMethod: widget.state.selectedShippingMethod,
          selectedPaymentMethod: widget.state.selectedPaymentMethod,
          subtotal: widget.state.subtotalAmount,
          shippingCost: widget.state.shippingCost,
          currencyCode: widget.state.currencyCode,
          lineItems: widget.state.lineItems,
          isProcessing: _isProcessing,
          onCompleteOrder: _handleCompleteOrder,
          onBack: _handleBack,
          onEditAddress: () => widget.viewModel.goToStep(CheckoutStep.address),
          onEditShipping: () => widget.viewModel.goToStep(CheckoutStep.shipping),
          onEditPayment: () => widget.viewModel.goToStep(CheckoutStep.payment),
        );
    }
  }
}
