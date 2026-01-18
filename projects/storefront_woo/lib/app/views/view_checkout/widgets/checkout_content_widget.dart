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
  final _formKey = GlobalKey<FormState>();
  final _configHelper = AssetConfigHelper();

  /// Storage scope for checkout form persistence.
  ///
  /// Without scoping, checkout form fields can leak between users after sign in/sign out
  /// because the same local-storage keys are reused.
  ///
  /// Scope priority:
  /// - authenticated email (preferred)
  /// - authenticated user id (fallback if present)
  /// - 'guest'
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

        // Authenticated, but no stable identifier found.
        return 'auth';
      }
    } catch (_) {
      // Ignore and fallback to guest
    }
    return 'guest';
  }

  /// Builds a scoped key for checkout persistence.
  /// Example:
  /// - legacy: checkout_billing_first_name
  /// - scoped: checkout_email_xxx_billing_first_name
  String _scopedCheckoutKey(String legacyKey) {
    const prefix = 'checkout_';
    if (!legacyKey.startsWith(prefix)) return legacyKey;
    final scope = _checkoutStorageScope();
    return legacyKey.replaceFirst(prefix, '${prefix}${scope}_');
  }

  Future<String?> _getLegacyCheckoutValue(
    LocalStorageHelper storage,
    String legacyKey,
  ) async {
    return await storage.getItem(legacyKey);
  }

  Future<String?> _getScopedCheckoutValue(
    LocalStorageHelper storage,
    String legacyKey,
  ) async {
    return await storage.getItem(_scopedCheckoutKey(legacyKey));
  }

  /// Reads checkout value with scope-first strategy.
  ///
  /// For authenticated scope, legacy keys are only used if legacy billing email matches
  /// current user email (prevents cross-user leakage from older app versions).
  Future<String?> _readCheckoutValueWithLegacyFallback(
    LocalStorageHelper storage, {
    required String legacyKey,
    String? currentUserEmail,
  }) async {
    // 1) Scoped first
    final scoped = await _getScopedCheckoutValue(storage, legacyKey);
    if (scoped != null) return scoped;

    // 2) Legacy (only if safe)
    final scope = _checkoutStorageScope();
    if (scope == 'guest') {
      final legacy = await _getLegacyCheckoutValue(storage, legacyKey);
      // Migrate legacy -> guest scoped for future reads, then optionally clean legacy.
      if (legacy != null) {
        await storage.setItem(_scopedCheckoutKey(legacyKey), legacy);
        await storage.removeItem(legacyKey);
      }
      return legacy;
    }

    // Authenticated: only accept legacy values if they match the current user's email.
    final email = currentUserEmail?.trim().toLowerCase();
    if (email != null && email.isNotEmpty) {
      final legacyBillingEmail =
          (await _getLegacyCheckoutValue(storage, 'checkout_billing_email'))
              ?.trim()
              .toLowerCase();
      if (legacyBillingEmail == email) {
        final legacy = await _getLegacyCheckoutValue(storage, legacyKey);
        if (legacy != null) {
          await storage.setItem(_scopedCheckoutKey(legacyKey), legacy);
        }
        return legacy;
      }
    }

    return null;
  }

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final colorString = _configHelper.getString('checkout_view_configuration.$key');
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
        } else if (state is CheckoutOrderCompletedState ||
            state is CheckoutErrorState) {
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
      final billingAddress2 = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_billing_address_2',
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
      final shippingAddress2 = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_shipping_address_2',
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

      // Load same as billing preference
      final sameAsBilling = await _readCheckoutValueWithLegacyFallback(
        storage,
        legacyKey: 'checkout_same_as_billing',
        currentUserEmail: currentUserEmail,
      );

      // Restore billing address
      if (billingFirstName != null)
        _billingFirstNameController.text = billingFirstName;
      if (billingLastName != null)
        _billingLastNameController.text = billingLastName;
      if (billingEmail != null && _billingEmailController.text.isEmpty) {
        _billingEmailController.text = billingEmail;
      }
      if (billingPhone != null) _billingPhoneController.text = billingPhone;
      if (billingAddress1 != null)
        _billingAddress1Controller.text = billingAddress1;
      if (billingAddress2 != null)
        _billingAddress2Controller.text = billingAddress2;
      if (billingCity != null) _billingCityController.text = billingCity;
      if (billingState != null) _billingStateController.text = billingState;
      if (billingPostcode != null)
        _billingPostcodeController.text = billingPostcode;
      if (billingCountry != null)
        _billingCountryController.text = billingCountry;

      // Restore shipping address
      if (shippingFirstName != null)
        _shippingFirstNameController.text = shippingFirstName;
      if (shippingLastName != null)
        _shippingLastNameController.text = shippingLastName;
      if (shippingPhone != null) _shippingPhoneController.text = shippingPhone;
      if (shippingAddress1 != null)
        _shippingAddress1Controller.text = shippingAddress1;
      if (shippingAddress2 != null)
        _shippingAddress2Controller.text = shippingAddress2;
      if (shippingCity != null) _shippingCityController.text = shippingCity;
      if (shippingState != null) _shippingStateController.text = shippingState;
      if (shippingPostcode != null)
        _shippingPostcodeController.text = shippingPostcode;
      if (shippingCountry != null)
        _shippingCountryController.text = shippingCountry;

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
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_first_name'),
        _billingFirstNameController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_last_name'),
        _billingLastNameController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_email'),
        _billingEmailController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_phone'),
        _billingPhoneController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_address_1'),
        _billingAddress1Controller.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_address_2'),
        _billingAddress2Controller.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_city'),
        _billingCityController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_state'),
        _billingStateController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_postcode'),
        _billingPostcodeController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_billing_country'),
        _billingCountryController.text,
      );

      // Save shipping address
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_first_name'),
        _shippingFirstNameController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_last_name'),
        _shippingLastNameController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_phone'),
        _shippingPhoneController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_address_1'),
        _shippingAddress1Controller.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_address_2'),
        _shippingAddress2Controller.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_city'),
        _shippingCityController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_state'),
        _shippingStateController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_postcode'),
        _shippingPostcodeController.text,
      );
      await storage.setItem(
        _scopedCheckoutKey('checkout_shipping_country'),
        _shippingCountryController.text,
      );

      // Save same as billing preference
      await storage.setItem(
        _scopedCheckoutKey('checkout_same_as_billing'),
        _sameAsBilling.toString(),
      );

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
            _buildSectionHeader(context, context.t.checkoutView.sections.billingAddress, Icons.receipt),
            _buildBillingForm(context),

            OsmeaComponents.sizedBox(height: 24),

            // Shipping Address Section
            _buildSectionHeader(
              context,
              context.t.checkoutView.sections.shippingAddress,
              Icons.local_shipping,
            ),
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(
        left: context.spacing16,
        right: context.spacing16,
        bottom: context.spacing12,
      ),
      child: OsmeaComponents.row(
        children: [
          OsmeaComponents.container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getColorFromConfig('section_header.icon_background_color', OsmeaColors.black).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _getColorFromConfig('section_header.icon_color', OsmeaColors.black), size: 20),
          ),
          OsmeaComponents.sizedBox(width: 12),
          OsmeaComponents.text(
            title,
            textStyle: OsmeaTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.w600),
            color: _getColorFromConfig('section_header.title_color', OsmeaColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingForm(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: _billingFirstNameController,
                  label: '',
                  hint: context.t.checkoutView.formFields.firstName,
                  icon: Icons.person_outline,
                  validator: (value) =>
                      value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _billingLastNameController,
                  label: '',
                  hint: context.t.checkoutView.formFields.lastName,
                  icon: Icons.person_outline,
                  validator: (value) =>
                      value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _billingEmailController,
            label: '',
            hint: context.t.checkoutView.formFields.email,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value?.isEmpty ?? true) return context.t.checkoutView.formFields.required;
              if (!value!.contains('@')) return context.t.checkoutView.formFields.invalidEmail;
              return null;
            },
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _billingPhoneController,
            label: '',
            hint: context.t.checkoutView.formFields.phone,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _billingAddress1Controller,
            label: '',
            hint: context.t.checkoutView.formFields.addressLine1,
            icon: Icons.home_outlined,
            validator: (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _billingAddress2Controller,
            label: '',
            hint: context.t.checkoutView.formFields.addressLine2,
            icon: Icons.home_outlined,
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: _billingCityController,
                  label: '',
                  hint: context.t.checkoutView.formFields.city,
                  icon: Icons.location_city_outlined,
                  validator: (value) =>
                      value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _billingStateController,
                  label: '',
                  hint: context.t.checkoutView.formFields.state,
                  icon: Icons.map_outlined,
                  validator: (value) =>
                      value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
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
                  label: '',
                  hint: context.t.checkoutView.formFields.postcode,
                  icon: Icons.markunread_mailbox_outlined,
                  validator: (value) =>
                      value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _billingCountryController,
                  label: '',
                  hint: context.t.checkoutView.formFields.country,
                  icon: Icons.public,
                  validator: (value) =>
                      value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
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
      margin: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getColorFromConfig('form_fields.input_background_color', OsmeaColors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _sameAsBilling
              ? _getColorFromConfig('form_fields.input_focused_border_color', OsmeaColors.black)
              : _getColorFromConfig('form_fields.input_border_color', OsmeaColors.silver).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _sameAsBilling = !_sameAsBilling;
            if (_sameAsBilling) {
              _copyBillingToShipping();
            }
            _saveFormData();
          });
        },
        child: OsmeaComponents.row(
          children: [
            Icon(
              _sameAsBilling ? Icons.check_box : Icons.check_box_outline_blank,
              color: _sameAsBilling
                  ? _getColorFromConfig('form_fields.input_focused_border_color', OsmeaColors.black)
                  : _getColorFromConfig('form_fields.input_hint_color', OsmeaColors.grayMaterial[400]!),
              size: 24,
            ),
            OsmeaComponents.sizedBox(width: 12),
            OsmeaComponents.text(
              context.t.checkoutView.sections.sameAsBilling,
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.w500),
              color: _getColorFromConfig('form_fields.label_color', OsmeaColors.black),
            ),
          ],
        ),
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
    if (_sameAsBilling) {
      return OsmeaComponents.sizedBox(height: 0);
    }

    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: OsmeaComponents.column(
        children: [
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: _shippingFirstNameController,
                  label: '',
                  hint: context.t.checkoutView.formFields.firstName,
                  icon: Icons.person_outline,
                  enabled: !_sameAsBilling,
                  validator: _sameAsBilling
                      ? null
                      : (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _shippingLastNameController,
                  label: '',
                  hint: context.t.checkoutView.formFields.lastName,
                  icon: Icons.person_outline,
                  enabled: !_sameAsBilling,
                  validator: _sameAsBilling
                      ? null
                      : (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
            ],
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _shippingPhoneController,
            label: '',
            hint: context.t.checkoutView.formFields.phone,
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            enabled: !_sameAsBilling,
            validator: _sameAsBilling
                ? null
                : (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _shippingAddress1Controller,
            label: '',
            hint: context.t.checkoutView.formFields.addressLine1,
            icon: Icons.home_outlined,
            enabled: !_sameAsBilling,
            validator: _sameAsBilling
                ? null
                : (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
          ),
          OsmeaComponents.sizedBox(height: 12),
          _buildTextFormField(
            controller: _shippingAddress2Controller,
            label: '',
            hint: context.t.checkoutView.formFields.addressLine2,
            icon: Icons.home_outlined,
            enabled: !_sameAsBilling,
          ),
          OsmeaComponents.sizedBox(height: 12),
          OsmeaComponents.row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: _shippingCityController,
                  label: '',
                  hint: context.t.checkoutView.formFields.city,
                  icon: Icons.location_city_outlined,
                  enabled: !_sameAsBilling,
                  validator: _sameAsBilling
                      ? null
                      : (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _shippingStateController,
                  label: '',
                  hint: context.t.checkoutView.formFields.state,
                  icon: Icons.map_outlined,
                  enabled: !_sameAsBilling,
                  validator: _sameAsBilling
                      ? null
                      : (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
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
                  label: '',
                  hint: context.t.checkoutView.formFields.postcode,
                  icon: Icons.markunread_mailbox_outlined,
                  enabled: !_sameAsBilling,
                  validator: _sameAsBilling
                      ? null
                      : (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
              OsmeaComponents.sizedBox(width: 12),
              Expanded(
                child: _buildTextFormField(
                  controller: _shippingCountryController,
                  label: '',
                  hint: context.t.checkoutView.formFields.country,
                  icon: Icons.public,
                  enabled: !_sameAsBilling,
                  validator: _sameAsBilling
                      ? null
                      : (value) => value?.isEmpty ?? true ? context.t.checkoutView.formFields.required : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    final currentContext = context; // Capture context at build time
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      style: OsmeaTextStyle.bodyMedium(currentContext),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: OsmeaTextStyle.bodySmall(currentContext).copyWith(
          color: _getColorFromConfig('form_fields.input_hint_color', OsmeaColors.grayMaterial[400]!),
        ),
        floatingLabelStyle: OsmeaTextStyle.bodySmall(currentContext).copyWith(
          color: _getColorFromConfig('form_fields.input_focused_border_color', OsmeaColors.black),
        ),
        prefixIcon: Icon(icon, color: _getColorFromConfig('form_fields.prefix_icon_color', OsmeaColors.black), size: 20),
        filled: true,
        fillColor: _getColorFromConfig('form_fields.input_background_color', OsmeaColors.white),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _getColorFromConfig('form_fields.input_border_color', OsmeaColors.silver).withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _getColorFromConfig('form_fields.input_border_color', OsmeaColors.silver).withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _getColorFromConfig('form_fields.input_focused_border_color', OsmeaColors.black), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _getColorFromConfig('form_fields.input_error_border_color', OsmeaColors.black), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _getColorFromConfig('form_fields.input_error_border_color', OsmeaColors.black), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: OsmeaColors.silver.withOpacity(0.2)),
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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getColorFromConfig('order_summary.total_background_start', OsmeaColors.black).withOpacity(0.05),
            _getColorFromConfig('order_summary.total_background_end', OsmeaColors.black).withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getColorFromConfig('order_summary.border_color', OsmeaColors.silver).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OsmeaComponents.column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OsmeaComponents.text(
                context.t.checkoutView.sections.orderTotal,
                textStyle: OsmeaTextStyle.bodyMedium(context),
                color: _getColorFromConfig('order_summary.label_color', OsmeaColors.grayMaterial[400]!),
              ),
              OsmeaComponents.sizedBox(height: 4),
              OsmeaComponents.text(
                formattedTotal,
                textStyle: OsmeaTextStyle.headlineSmall(
                  context,
                ).copyWith(fontWeight: FontWeight.bold),
                color: _getColorFromConfig('order_summary.total_amount_color', OsmeaColors.black),
              ),
            ],
          ),
          OsmeaComponents.container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getColorFromConfig('order_summary.total_background_start', OsmeaColors.black).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: _getColorFromConfig('order_summary.total_amount_color', OsmeaColors.black),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getColorFromConfig('order_summary.background_color', OsmeaColors.white),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getColorFromConfig('order_summary.border_color', OsmeaColors.silver).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: OsmeaComponents.row(
              children: [
                OsmeaComponents.container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getColorFromConfig('order_summary.total_background_start', OsmeaColors.black).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.account_balance,
                    color: _getColorFromConfig('order_summary.total_amount_color', OsmeaColors.black),
                    size: 24,
                  ),
                ),
                OsmeaComponents.sizedBox(width: 14),
                Expanded(
                  child: OsmeaComponents.column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OsmeaComponents.text(
                        context.t.checkoutView.payment.bankTransfer,
                        textStyle: OsmeaTextStyle.bodyLarge(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                        color: _getColorFromConfig('form_fields.label_color', OsmeaColors.black),
                      ),
                      OsmeaComponents.sizedBox(height: 2),
                      OsmeaComponents.text(
                        context.t.checkoutView.payment.bankTransferSubtitle,
                        textStyle: OsmeaTextStyle.bodySmall(context),
                        color: _getColorFromConfig('form_fields.helper_text_color', OsmeaColors.grayMaterial[400]!),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: _getColorFromConfig('order_summary.total_amount_color', OsmeaColors.black),
                  size: 24,
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
          backgroundColor: _getColorFromConfig('order_summary.button_background_color', OsmeaColors.black),
          disabledBackgroundColor: _getColorFromConfig('order_summary.button_disabled_background_color', OsmeaColors.grayMaterial[400]!).withOpacity(0.3),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_configHelper.getDouble('checkout_view_configuration.order_summary.button_border_radius', 12.0)),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: _isLoading
            ? OsmeaComponents.sizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(_getColorFromConfig('order_summary.button_text_color', OsmeaColors.white)),
                ),
              )
            : OsmeaComponents.row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OsmeaComponents.text(
                    context.t.checkoutView.buttons.completeOrder,
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      color: _getColorFromConfig('order_summary.button_text_color', OsmeaColors.white),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  OsmeaComponents.sizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: _getColorFromConfig('order_summary.button_text_color', OsmeaColors.white),
                    size: 20,
                  ),
                ],
              ),
      ),
    );
  }

  void _handleContinue(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      context.snackbarWarning(context.t.checkoutView.messages.fillRequiredFields);
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
