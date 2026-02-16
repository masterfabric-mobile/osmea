/*
 * AddressStepWidget
 * -----------------
 * Step 1: Billing & shipping address form with saved addresses selection.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/models/user_address.dart';
import 'package:storefront_supabase/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_supabase/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AddressStepWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController countryController;
  final bool sameAsBilling;
  final ValueChanged<bool> onSameAsBillingChanged;
  final VoidCallback onContinue;
  final CheckoutViewModel viewModel;
  final CheckoutLoadedState state;

  const AddressStepWidget({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.cityController,
    required this.countryController,
    required this.sameAsBilling,
    required this.onSameAsBillingChanged,
    required this.onContinue,
    required this.viewModel,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final List<UserAddress> userAddresses = state.userAddresses ?? [];
    final hasAddresses = userAddresses.isNotEmpty;
    // Show manual form if no addresses OR if billing address is null (Add New Address clicked)
    final showManualForm = state.selectedBillingAddressId == null;

    return BlocBuilder<CheckoutViewModel, CheckoutState>(
      bloc: viewModel,
      builder: (context, checkoutState) {
        if (checkoutState is! CheckoutLoadedState) {
          return const SizedBox.shrink();
        }

        return OsmeaComponents.singleChildScrollView(
          padding: EdgeInsets.all(context.spacing16),
          child: Form(
            key: formKey,
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Saved Addresses Section
                if (hasAddresses) ...[
                  OsmeaComponents.text(
                    'Select Address',
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.black,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  ...userAddresses.map((address) => _buildAddressCard(
                    context,
                    address,
                    checkoutState.selectedBillingAddressId != null && checkoutState.selectedBillingAddressId! == address.id,
                    checkoutState.selectedShippingAddressId != null && checkoutState.selectedShippingAddressId! == address.id,
                  )),
                  OsmeaComponents.sizedBox(height: context.spacing16),
                  OsmeaComponents.button(
                    text: 'Add New Address',
                    variant: ButtonVariant.outlined,
                    backgroundColor: OsmeaColors.white,
                    textColor: OsmeaColors.black,
                    borderColor: OsmeaColors.black,
                    splashColor: OsmeaColors.transparent,
                    hoverColor: OsmeaColors.transparent,
                    onPressed: () {
                      // Always clear selections to show manual form
                      viewModel.selectBillingAddress(null);
                      viewModel.selectShippingAddress(null);
                    },
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing24),
                ],

                // Manual Form (shown if no addresses or "Add New Address" clicked)
                if (showManualForm) ...[
                  OsmeaComponents.text(
                    hasAddresses ? 'New Address' : 'Billing Address',
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      fontWeight: FontWeight.w600,
                      color: OsmeaColors.black,
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: firstNameController,
                    label: resources.firstName,
                    hint: resources.firstName,
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    borderColor: OsmeaColors.silver,
                    validator: (v) => (v == null || v.trim().isEmpty) ? resources.fillRequiredFields : null,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: lastNameController,
                    label: resources.lastName,
                    hint: resources.lastName,
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    borderColor: OsmeaColors.silver,
                    validator: (v) => (v == null || v.trim().isEmpty) ? resources.fillRequiredFields : null,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: emailController,
                    label: resources.email,
                    hint: resources.email,
                    type: TextFieldType.email,
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    borderColor: OsmeaColors.silver,
                    validator: (v) => (v == null || v.trim().isEmpty) ? resources.fillRequiredFields : null,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: phoneController,
                    label: resources.phoneNumber,
                    hint: resources.phoneNumber,
                    type: TextFieldType.phone,
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    borderColor: OsmeaColors.silver,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: addressController,
                    label: resources.addressLine1,
                    hint: resources.addressLine1,
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    borderColor: OsmeaColors.silver,
                    maxLines: 2,
                    validator: (v) => (v == null || v.trim().isEmpty) ? resources.fillRequiredFields : null,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: cityController,
                    label: resources.city,
                    hint: resources.city,
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    borderColor: OsmeaColors.silver,
                    validator: (v) => (v == null || v.trim().isEmpty) ? resources.fillRequiredFields : null,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.textField(
                    controller: countryController,
                    label: resources.country,
                    hint: resources.country,
                    variant: TextFieldVariant.outlined,
                    focusColor: OsmeaColors.black,
                    borderColor: OsmeaColors.silver,
                    validator: (v) => (v == null || v.trim().isEmpty) ? resources.fillRequiredFields : null,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing16),
                ],

                // Same as billing checkbox
                OsmeaComponents.row(
                  children: [
                    OsmeaComponents.checkbox(
                      value: sameAsBilling,
                      onChanged: (v) => onSameAsBillingChanged(v ?? true),
                      activeColor: OsmeaColors.black,
                    ),
                    OsmeaComponents.expanded(
                      child: OsmeaComponents.button(
                        text: resources.sameAsBilling,
                        variant: ButtonVariant.ghost,
                        backgroundColor: OsmeaColors.transparent,
                        textColor: OsmeaColors.black,
                        padding: EdgeInsets.zero,
                        onPressed: () => onSameAsBillingChanged(!sameAsBilling),
                        textStyle: OsmeaTextStyle.bodySmall(context),
                      ),
                    ),
                  ],
                ),
                OsmeaComponents.sizedBox(height: context.spacing24),
                OsmeaComponents.button(
                  onPressed: () {
                    if (checkoutState.selectedBillingAddressId != null) {
                      // Using saved address
                      final billingId = checkoutState.selectedBillingAddressId!;
                      final selectedAddress = userAddresses.firstWhere(
                        (a) => a.id == billingId,
                      );
                      final shippingId = checkoutState.selectedShippingAddressId;
                      UserAddress shippingAddress = selectedAddress;
                      if (!sameAsBilling && shippingId != null) {
                        shippingAddress = userAddresses.firstWhere((a) => a.id == shippingId);
                      }
                      final shippingAddressMap = shippingAddress.toCheckoutMap();
                      viewModel.updateAddressAndProceed(
                        billingEmail: checkoutState.billingEmail ?? emailController.text.trim(),
                        billingAddress: selectedAddress.toCheckoutMap(),
                        shippingAddress: shippingAddressMap,
                        sameAsBilling: sameAsBilling,
                      );
                    } else {
                      // Using manual form
                      if (!formKey.currentState!.validate()) {
                        context.snackbarWarning(resources.fillRequiredFields);
                        return;
                      }
                      viewModel.updateAddressAndProceed(
                        billingEmail: emailController.text.trim(),
                        billingAddress: {
                          'first_name': firstNameController.text.trim(),
                          'last_name': lastNameController.text.trim(),
                          'address_1': addressController.text.trim(),
                          'city': cityController.text.trim(),
                          'country': countryController.text.trim(),
                          'phone': phoneController.text.trim(),
                        },
                        shippingAddress: sameAsBilling
                            ? {
                                'first_name': firstNameController.text.trim(),
                                'last_name': lastNameController.text.trim(),
                                'address_1': addressController.text.trim(),
                                'city': cityController.text.trim(),
                                'country': countryController.text.trim(),
                                'phone': phoneController.text.trim(),
                              }
                            : {
                                'first_name': firstNameController.text.trim(),
                                'last_name': lastNameController.text.trim(),
                                'address_1': addressController.text.trim(),
                                'city': cityController.text.trim(),
                                'country': countryController.text.trim(),
                                'phone': phoneController.text.trim(),
                              },
                        sameAsBilling: sameAsBilling,
                      );
                    }
                  },
                  backgroundColor: OsmeaColors.black,
                  textColor: OsmeaColors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  text: resources.continueButton,
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: OsmeaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    UserAddress address,
    bool isBillingSelected,
    bool isShippingSelected,
  ) {
    final resources = context.resources;
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing12),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isBillingSelected || isShippingSelected) ? OsmeaColors.black : OsmeaColors.silver,
          width: (isBillingSelected || isShippingSelected) ? 2 : 1,
        ),
      ),
      padding: EdgeInsets.all(context.spacing16),
      onTap: () {
        // Toggle: if already selected, deselect; otherwise select
        final currentState = viewModel.state;
        if (currentState is! CheckoutLoadedState) return;
        
        final isCurrentlySelected = currentState.selectedBillingAddressId == address.id;
        final stateSameAsBilling = currentState.sameAsBilling;
        
        if (isCurrentlySelected) {
          // Currently selected - deselect it
          viewModel.selectBillingAddress(null);
          // If sameAsBilling is true, also deselect shipping
          if (stateSameAsBilling) {
            viewModel.selectShippingAddress(null);
          }
        } else {
          // Not selected - select it
          viewModel.selectBillingAddress(address.id);
          // If sameAsBilling is true, also select shipping
          if (stateSameAsBilling) {
            viewModel.selectShippingAddress(address.id);
          }
        }
      },
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address.label != null && address.label!.isNotEmpty) ...[
                      OsmeaComponents.text(
                        address.label!,
                        textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                          fontWeight: FontWeight.w600,
                          color: OsmeaColors.black,
                        ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing4),
                    ],
                    if (address.isDefault) ...[
                      OsmeaComponents.container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: OsmeaColors.black,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: OsmeaComponents.text(
                          'Default',
                          textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                            color: OsmeaColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      OsmeaComponents.sizedBox(height: context.spacing8),
                    ],
                    OsmeaComponents.text(
                      _formatAddress(address),
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        color: OsmeaColors.thunder,
                      ),
                    ),
                    if (address.phone != null && address.phone!.isNotEmpty) ...[
                      OsmeaComponents.sizedBox(height: context.spacing4),
                      OsmeaComponents.text(
                        '${resources.phoneNumber}: ${address.phone}',
                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                          color: OsmeaColors.pewter,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isBillingSelected || isShippingSelected)
                Icon(Icons.check_circle, color: OsmeaColors.black, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  String _formatAddress(UserAddress address) {
    final parts = <String>[];
    if (address.address != null && address.address!.isNotEmpty) {
      parts.add(address.address!);
    }
    if (address.city != null && address.city!.isNotEmpty) {
      parts.add(address.city!);
    }
    if (address.postalCode != null && address.postalCode!.isNotEmpty) {
      parts.add(address.postalCode!);
    }
    if (address.country != null && address.country!.isNotEmpty) {
      // Normalize country display: show "Türkiye" instead of "Turkey"
      final country = address.country == 'Turkey' ? 'Türkiye' : address.country;
      parts.add(country!);
    }
    return parts.isEmpty ? 'Address' : parts.join(', ');
  }
}
