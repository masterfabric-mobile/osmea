/*
 * CheckoutContentWidget
 * ---------------------
 * Checkout wizard: step indicator + current step (address, shipping, payment, summary).
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_supabase/app/views/view_checkout/models/states.dart';
import 'package:storefront_supabase/app/views/view_checkout/widgets/checkout_step_indicator.dart';
import 'package:storefront_supabase/app/views/view_checkout/widgets/steps/address_step_widget.dart';
import 'package:storefront_supabase/app/views/view_checkout/widgets/steps/shipping_step_widget.dart';
import 'package:storefront_supabase/app/views/view_checkout/widgets/steps/payment_step_widget.dart';
import 'package:storefront_supabase/app/views/view_checkout/widgets/steps/summary_step_widget.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

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
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController(text: 'TR');
  bool _sameAsBilling = true;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user?.email != null && user!.email!.isNotEmpty) _email.text = user.email!;
    // Pre-fill address from profile (Supabase users table)
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillAddressFromProfile(client, user?.id));
  }

  Future<void> _prefillAddressFromProfile(SupabaseClient client, String? userId) async {
    if (userId == null) return;
    try {
      final row = await client.from('users').select().eq('id', userId).maybeSingle();
      if (row == null || !mounted) return;
      final fullName = row['full_name'] as String? ?? row['username'] as String? ?? '';
      final parts = fullName.split(RegExp(r'\s+'));
      if (parts.isNotEmpty) {
        _firstName.text = parts.first;
        if (parts.length > 1) _lastName.text = parts.skip(1).join(' ');
      }
      if (row['phone'] != null) _phone.text = row['phone'].toString();
      if (row['address'] != null) _address.text = row['address'].toString();
      if (row['city'] != null) _city.text = row['city'].toString();
      if (row['country'] != null) _country.text = row['country'].toString();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _city.dispose();
    _country.dispose();
    super.dispose();
  }

  Map<String, dynamic> _billingAddress() => {
        'first_name': _firstName.text.trim(),
        'last_name': _lastName.text.trim(),
        'address_1': _address.text.trim(),
        'city': _city.text.trim(),
        'country': _country.text.trim(),
        'phone': _phone.text.trim(),
      };

  Map<String, dynamic> _shippingAddress() => _sameAsBilling ? _billingAddress() : _billingAddress();

  void _onAddressContinue() {
    if (!_formKey.currentState!.validate()) {
      context.snackbarWarning(context.resources.fillRequiredFields);
      return;
    }
    widget.viewModel.updateAddressAndProceed(
      billingEmail: _email.text.trim(),
      billingAddress: _billingAddress(),
      shippingAddress: _shippingAddress(),
      sameAsBilling: _sameAsBilling,
    );
  }

  void _onPlaceOrder() {
    widget.viewModel.processOrder(
      billingEmail: _email.text.trim(),
      billingAddress: _billingAddress(),
      shippingAddress: _shippingAddress(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckoutStepIndicator(
          currentStep: widget.state.currentStep,
          isAddressValid: widget.state.isAddressStepValid,
          isShippingValid: widget.state.isShippingStepValid,
          isPaymentValid: widget.state.isPaymentStepValid,
          onStepTapped: (step) {
            if (step.index < widget.state.currentStep.index) widget.viewModel.goToStep(step);
          },
        ),
        Expanded(child: _buildStep()),
      ],
    );
  }

  Widget _buildStep() {
    final s = widget.state;
    switch (s.currentStep) {
      case CheckoutStep.address:
        return AddressStepWidget(
          formKey: _formKey,
          firstNameController: _firstName,
          lastNameController: _lastName,
          emailController: _email,
          phoneController: _phone,
          addressController: _address,
          cityController: _city,
          countryController: _country,
          sameAsBilling: _sameAsBilling,
          onSameAsBillingChanged: (v) => setState(() => _sameAsBilling = v),
          onContinue: _onAddressContinue,
        );
      case CheckoutStep.shipping:
        return ShippingStepWidget(
          shippingMethods: s.shippingMethods,
          selectedMethodId: s.selectedShippingMethodId,
          subtotal: s.subtotalAmount,
          currencyCode: s.currencyCode,
          onMethodSelected: widget.viewModel.selectShippingMethod,
          onContinue: widget.viewModel.proceedToPayment,
          onBack: () => widget.viewModel.goToStep(CheckoutStep.address),
        );
      case CheckoutStep.payment:
        return PaymentStepWidget(
          paymentMethods: s.paymentMethods,
          selectedMethodId: s.selectedPaymentMethodId,
          onMethodSelected: widget.viewModel.selectPaymentMethod,
          onContinue: widget.viewModel.proceedToSummary,
          onBack: () => widget.viewModel.goToStep(CheckoutStep.shipping),
        );
      case CheckoutStep.summary:
        return SummaryStepWidget(
          billingAddress: s.billingAddress,
          shippingAddress: s.shippingAddress,
          billingEmail: s.billingEmail,
          selectedShippingMethod: s.selectedShippingMethod,
          selectedPaymentMethod: s.selectedPaymentMethod,
          subtotal: s.subtotalAmount,
          shippingCost: s.shippingCost,
          currencyCode: s.currencyCode,
          lineItems: s.lineItems,
          isProcessing: false,
          onPlaceOrder: _onPlaceOrder,
          onBack: () => widget.viewModel.goToStep(CheckoutStep.payment),
        );
    }
  }
}
