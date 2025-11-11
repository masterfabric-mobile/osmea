/*
 * CheckoutWidgets
 * ---------------
 * Widgets for the checkout view.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';

/// Checkout form widget
class CheckoutFormWidget extends StatefulWidget {
  final CheckoutLoadedState state;
  final CheckoutViewModel viewModel;

  const CheckoutFormWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  State<CheckoutFormWidget> createState() => _CheckoutFormWidgetState();
}

class _CheckoutFormWidgetState extends State<CheckoutFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _billingFirstNameController;
  late TextEditingController _billingLastNameController;
  late TextEditingController _billingEmailController;
  late TextEditingController _billingPhoneController;
  late TextEditingController _billingAddress1Controller;
  late TextEditingController _billingAddress2Controller;
  late TextEditingController _billingCityController;
  late TextEditingController _billingStateController;
  late TextEditingController _billingPostcodeController;
  late TextEditingController _billingCountryController;
  late TextEditingController _shippingFirstNameController;
  late TextEditingController _shippingLastNameController;
  late TextEditingController _shippingAddress1Controller;
  late TextEditingController _shippingAddress2Controller;
  late TextEditingController _shippingCityController;
  late TextEditingController _shippingStateController;
  late TextEditingController _shippingPostcodeController;
  late TextEditingController _shippingCountryController;
  late TextEditingController _orderNotesController;
  String? _selectedPaymentMethod;
  bool _sameAsBilling = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _billingFirstNameController = TextEditingController(text: widget.state.billingFirstName);
    _billingLastNameController = TextEditingController(text: widget.state.billingLastName);
    _billingEmailController = TextEditingController(text: widget.state.billingEmail);
    _billingPhoneController = TextEditingController(text: widget.state.billingPhone);
    _billingAddress1Controller = TextEditingController(text: widget.state.billingAddress1);
    _billingAddress2Controller = TextEditingController(text: widget.state.billingAddress2);
    _billingCityController = TextEditingController(text: widget.state.billingCity);
    _billingStateController = TextEditingController(text: widget.state.billingState);
    _billingPostcodeController = TextEditingController(text: widget.state.billingPostcode);
    _billingCountryController = TextEditingController(text: widget.state.billingCountry);
    _shippingFirstNameController = TextEditingController(text: widget.state.shippingFirstName);
    _shippingLastNameController = TextEditingController(text: widget.state.shippingLastName);
    _shippingAddress1Controller = TextEditingController(text: widget.state.shippingAddress1);
    _shippingAddress2Controller = TextEditingController(text: widget.state.shippingAddress2);
    _shippingCityController = TextEditingController(text: widget.state.shippingCity);
    _shippingStateController = TextEditingController(text: widget.state.shippingState);
    _shippingPostcodeController = TextEditingController(text: widget.state.shippingPostcode);
    _shippingCountryController = TextEditingController(text: widget.state.shippingCountry);
    _orderNotesController = TextEditingController(text: widget.state.orderNotes);
    _selectedPaymentMethod = widget.state.paymentMethod ?? 'bacs';
  }

  @override
  void dispose() {
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
    _shippingAddress1Controller.dispose();
    _shippingAddress2Controller.dispose();
    _shippingCityController.dispose();
    _shippingStateController.dispose();
    _shippingPostcodeController.dispose();
    _shippingCountryController.dispose();
    _orderNotesController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update checkout data first
      widget.viewModel.updateCheckoutData(
        billingFirstName: _billingFirstNameController.text,
        billingLastName: _billingLastNameController.text,
        billingEmail: _billingEmailController.text,
        billingPhone: _billingPhoneController.text,
        billingAddress1: _billingAddress1Controller.text,
        billingAddress2: _billingAddress2Controller.text,
        billingCity: _billingCityController.text,
        billingState: _billingStateController.text,
        billingPostcode: _billingPostcodeController.text,
        billingCountry: _billingCountryController.text,
        shippingFirstName: _sameAsBilling
            ? _billingFirstNameController.text
            : _shippingFirstNameController.text,
        shippingLastName: _sameAsBilling
            ? _billingLastNameController.text
            : _shippingLastNameController.text,
        shippingAddress1: _sameAsBilling
            ? _billingAddress1Controller.text
            : _shippingAddress1Controller.text,
        shippingAddress2: _sameAsBilling
            ? _billingAddress2Controller.text
            : _shippingAddress2Controller.text,
        shippingCity: _sameAsBilling
            ? _billingCityController.text
            : _shippingCityController.text,
        shippingState: _sameAsBilling
            ? _billingStateController.text
            : _shippingStateController.text,
        shippingPostcode: _sameAsBilling
            ? _billingPostcodeController.text
            : _shippingPostcodeController.text,
        shippingCountry: _sameAsBilling
            ? _billingCountryController.text
            : _shippingCountryController.text,
        paymentMethod: _selectedPaymentMethod,
        orderNotes: _orderNotesController.text,
      );

      // Process payment and order
      widget.viewModel.processPaymentAndOrder(
        billingEmail: _billingEmailController.text,
        paymentMethod: _selectedPaymentMethod,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing16),
      child: Form(
        key: _formKey,
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Billing Address Section
            _buildSection(
              context,
              title: 'Billing Address',
              children: [
                OsmeaComponents.row(
                  children: [
                    Expanded(
                      child: OsmeaComponents.textField(
                        controller: _billingFirstNameController,
                        label: 'First Name',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing8),
                    Expanded(
                      child: OsmeaComponents.textField(
                        controller: _billingLastNameController,
                        label: 'Last Name',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                OsmeaComponents.textField(
                  controller: _billingEmailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Required';
                    if (!value!.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                OsmeaComponents.textField(
                  controller: _billingPhoneController,
                  label: 'Phone',
                  keyboardType: TextInputType.phone,
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                OsmeaComponents.textField(
                  controller: _billingAddress1Controller,
                  label: 'Address Line 1',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                OsmeaComponents.textField(
                  controller: _billingAddress2Controller,
                  label: 'Address Line 2',
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                OsmeaComponents.row(
                  children: [
                    Expanded(
                      child: OsmeaComponents.textField(
                        controller: _billingCityController,
                        label: 'City',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing8),
                    Expanded(
                      child: OsmeaComponents.textField(
                        controller: _billingStateController,
                        label: 'State',
                      ),
                    ),
                  ],
                ),
                OsmeaComponents.sizedBox(height: context.spacing12),
                OsmeaComponents.row(
                  children: [
                    Expanded(
                      child: OsmeaComponents.textField(
                        controller: _billingPostcodeController,
                        label: 'Postcode',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                    OsmeaComponents.sizedBox(width: context.spacing8),
                    Expanded(
                      child: OsmeaComponents.textField(
                        controller: _billingCountryController,
                        label: 'Country',
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: context.spacing24),

            // Same as Billing Checkbox
            CheckboxListTile(
              title: OsmeaComponents.text('Same as billing address'),
              value: _sameAsBilling,
              onChanged: (value) {
                setState(() {
                  _sameAsBilling = value ?? true;
                });
              },
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),

            // Shipping Address Section (if not same as billing)
            if (!_sameAsBilling)
              _buildSection(
                context,
                title: 'Shipping Address',
                children: [
                  OsmeaComponents.row(
                    children: [
                      Expanded(
                        child: OsmeaComponents.textField(
                          controller: _shippingFirstNameController,
                          label: 'First Name',
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing8),
                      Expanded(
                        child: OsmeaComponents.textField(
                          controller: _shippingLastNameController,
                          label: 'Last Name',
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: _shippingAddress1Controller,
                    label: 'Address Line 1',
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: _shippingAddress2Controller,
                    label: 'Address Line 2',
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.row(
                    children: [
                      Expanded(
                        child: OsmeaComponents.textField(
                          controller: _shippingCityController,
                          label: 'City',
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing8),
                      Expanded(
                        child: OsmeaComponents.textField(
                          controller: _shippingStateController,
                          label: 'State',
                        ),
                      ),
                    ],
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.row(
                    children: [
                      Expanded(
                        child: OsmeaComponents.textField(
                          controller: _shippingPostcodeController,
                          label: 'Postcode',
                        ),
                      ),
                      OsmeaComponents.sizedBox(width: context.spacing8),
                      Expanded(
                        child: OsmeaComponents.textField(
                          controller: _shippingCountryController,
                          label: 'Country',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (!_sameAsBilling) OsmeaComponents.sizedBox(height: context.spacing24),

            // Payment Method Section
            _buildSection(
              context,
              title: 'Payment Method',
              children: [
                RadioListTile<String>(
                  title: OsmeaComponents.text('Bank Transfer'),
                  value: 'bacs',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: OsmeaComponents.text('Cash on Delivery'),
                  value: 'cod',
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: context.spacing24),

            // Order Notes Section
            _buildSection(
              context,
              title: 'Order Notes (Optional)',
              children: [
                OsmeaComponents.textField(
                  controller: _orderNotesController,
                  label: 'Notes',
                  maxLines: 3,
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: context.spacing24),

            // Place Order Button
            OsmeaComponents.button(
              onPressed: _handlePlaceOrder,
              backgroundColor: OsmeaColors.nordicBlue,
              textColor: OsmeaColors.white,
              padding: EdgeInsets.symmetric(vertical: context.spacing16),
              text: 'Place Order',
              textStyle: OsmeaTextStyle.labelLarge(context).copyWith(
                color: OsmeaColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.spacing16),
        child: OsmeaComponents.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OsmeaComponents.text(
              title,
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            ...children,
          ],
        ),
      ),
    );
  }
}

