import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_profile/models/states.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class AddressesView extends MasterViewCubit<ProfileViewModel, ProfileState> {
  AddressesView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(
              context.resources.myAddresses,
              textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                fontWeight: FontWeight.w600,
                color: OsmeaColors.thunder,
              ),
            ),
            variant: AppBarVariant.primary,
            backgroundColor: OsmeaColors.white,
            foregroundColor: OsmeaColors.thunder,
            elevation: 0,
            leading: OsmeaComponents.iconButton(
              onPressed: () => context.pop(),
              icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
              backgroundColor: OsmeaColors.transparent,
            ),
          ),
        );

  @override
  void initialContent(ProfileViewModel viewModel, BuildContext context) {
    viewModel.populateUserInfo();
  }

  @override
  Widget viewContent(
      BuildContext context, ProfileViewModel viewModel, ProfileState state) {
    final resources = context.resources;
    if (state is ProfileLoading) {
      return Center(child: CircularProgressIndicator(color: OsmeaColors.black));
    }

    if (state is ProfileAuthenticated) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: context.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: context.spacing12),
              child: OsmeaComponents.text(
                'Saved address',
                textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(context.spacing12),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OsmeaColors.silver, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OsmeaComponents.dropdown<String>(
                    items: viewModel.countryCityMap.keys.toList(),
                    value: viewModel.selectedCountry,
                    onChanged: viewModel.setCountry,
                    hint: viewModel.selectedCountry == null ? resources.selectCountryFirst : resources.country,
                    label: resources.country,
                    variant: DropdownVariant.outlined,
                    fullWidth: true,
                  ),
                  SizedBox(height: context.spacing16),
                  OsmeaComponents.dropdown<String>(
                    items: viewModel.availableCities,
                    value: viewModel.selectedCity,
                    onChanged: viewModel.setCity,
                    hint: viewModel.selectedCountry == null ? resources.selectCountryFirst : resources.selectCity,
                    label: resources.city,
                    variant: DropdownVariant.outlined,
                    fullWidth: true,
                  ),
                  SizedBox(height: context.spacing16),
                  _buildTextField(context, viewModel.addressController, resources.address),
                  SizedBox(height: context.spacing16),
                  _buildTextField(context, viewModel.postalCodeController, resources.postalCode),
                  SizedBox(height: context.spacing16),
                  _buildTextField(context, viewModel.phoneController, resources.phoneNumber, keyboardType: TextInputType.phone),
                  SizedBox(height: context.spacing24),
                  OsmeaComponents.button(
                    text: resources.saveAddress,
                    variant: ButtonVariant.primary,
                    backgroundColor: OsmeaColors.black,
                    textColor: OsmeaColors.white,
                    fullWidth: true,
                    onPressed: () async {
                      await viewModel.updateAddress();
                      if (context.mounted) {
                        context.showSnackbar(
                          message: resources.addressUpdated,
                          type: SnackbarType.success,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: OsmeaComponents.text(
        resources.loginToManageAddresses,
        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black),
      ),
    );
  }
  
  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return OsmeaComponents.textField(
      controller: controller,
      label: label,
      variant: TextFieldVariant.outlined,
      focusColor: OsmeaColors.black,
      type: keyboardType == TextInputType.phone ? TextFieldType.phone : TextFieldType.text,
    );
  }
}
