import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_profile/models/states.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';
import 'package:storefront_supabase/l10n/app_localizations.dart';

class AddressesView extends MasterViewCubit<ProfileViewModel, ProfileState> {
  AddressesView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(AppLocalizations.of(context)!.myAddresses),
            variant: AppBarVariant.primary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            leading: OsmeaComponents.iconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
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
    final l10n = AppLocalizations.of(context)!;
    if (state is ProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProfileAuthenticated) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            // Country Dropdown
            _buildDropdown(
              context: context,
              label: l10n.country,
              value: viewModel.selectedCountry,
              items: viewModel.countryCityMap.keys.toList(),
              onChanged: viewModel.setCountry,
              icon: Icons.public,
            ),
            const SizedBox(height: 16),
            
            // City Dropdown (Dependent)
            _buildDropdown(
              context: context,
              label: l10n.city,
              value: viewModel.selectedCity,
              items: viewModel.availableCities,
              onChanged: viewModel.setCity,
              icon: Icons.location_city,
              hint: viewModel.selectedCountry == null ? l10n.selectCountryFirst : l10n.selectCity,
            ),
             const SizedBox(height: 16),
             
            _buildTextField(context, viewModel.addressController, l10n.address, Icons.home),
            const SizedBox(height: 16),
            
            _buildTextField(context, viewModel.postalCodeController, l10n.postalCode, Icons.markunread_mailbox),
            const SizedBox(height: 16),
            
            _buildTextField(context, viewModel.phoneController, l10n.phoneNumber, Icons.phone, keyboardType: TextInputType.phone),
            const SizedBox(height: 32),
            
            OsmeaComponents.button(
              text: l10n.saveAddress,
              variant: ButtonVariant.primary,
              fullWidth: true,
              onPressed: () async {
                await viewModel.updateAddress();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.addressUpdated), 
                      backgroundColor: Colors.green
                    ),
                  );
                }
              },
            ),
          ],
        ),
      );
    }
    return Center(child: Text(l10n.loginToManageAddresses));
  }
  
  Widget _buildDropdown({
    required BuildContext context,
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    String? hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: items.contains(value) ? value : null,
          hint: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 12),
              Text(hint ?? "${AppLocalizations.of(context)!.selectPrefix}$label"),
            ],
          ),
          icon: const Icon(Icons.arrow_drop_down),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context,
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType? keyboardType,
      }) {
    return OsmeaComponents.textField(
      controller: controller,
      label: label,
      prefixIcon: Icon(icon, color: Colors.black),
      variant: TextFieldVariant.outlined,
      focusColor: Colors.black,
      type: TextFieldType.text,
    );
  }
}
