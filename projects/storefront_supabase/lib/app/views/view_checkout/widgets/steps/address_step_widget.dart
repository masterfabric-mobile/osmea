/*
 * AddressStepWidget
 * -----------------
 * Step 1: Billing & shipping address form.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
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
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OsmeaComponents.text(
              context.resources.firstName,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                hintText: context.resources.firstName,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? context.resources.fillRequiredFields : null,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              context.resources.lastName,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                hintText: context.resources.lastName,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? context.resources.fillRequiredFields : null,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              context.resources.email,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: context.resources.email,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? context.resources.fillRequiredFields : null,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              context.resources.phoneNumber,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: context.resources.phoneNumber,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              context.resources.addressLine1,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            TextFormField(
              controller: addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: context.resources.addressLine1,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? context.resources.fillRequiredFields : null,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              context.resources.city,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            TextFormField(
              controller: cityController,
              decoration: InputDecoration(
                hintText: context.resources.city,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? context.resources.fillRequiredFields : null,
            ),
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.text(
              context.resources.country,
              textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
            ),
            OsmeaComponents.sizedBox(height: context.spacing4),
            TextFormField(
              controller: countryController,
              decoration: InputDecoration(
                hintText: context.resources.country,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? context.resources.fillRequiredFields : null,
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            Row(
              children: [
                Checkbox(
                  value: sameAsBilling,
                  onChanged: (v) => onSameAsBillingChanged(v ?? true),
                  activeColor: OsmeaColors.black,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onSameAsBillingChanged(!sameAsBilling),
                    child: OsmeaComponents.text(
                      context.resources.sameAsBilling,
                      textStyle: OsmeaTextStyle.bodySmall(context),
                    ),
                  ),
                ),
              ],
            ),
            OsmeaComponents.sizedBox(height: context.spacing24),
            OsmeaComponents.button(
              onPressed: onContinue,
              backgroundColor: OsmeaColors.black,
              textColor: OsmeaColors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              text: context.resources.continueButton,
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                color: OsmeaColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
