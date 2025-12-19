import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_profile/models/states.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';

class AddressesView extends MasterViewCubit<ProfileViewModel, ProfileState> {
  AddressesView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text('My Addresses'),
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
              label: 'Country',
              value: viewModel.selectedCountry,
              items: viewModel.countryCityMap.keys.toList(),
              onChanged: viewModel.setCountry,
              icon: Icons.public,
            ),
            const SizedBox(height: 16),
            
            // City Dropdown (Dependent)
            _buildDropdown(
              context: context,
              label: 'City',
              value: viewModel.selectedCity,
              items: viewModel.availableCities,
              onChanged: viewModel.setCity,
              icon: Icons.location_city,
              hint: viewModel.selectedCountry == null ? 'Select Country First' : 'Select City',
            ),
             const SizedBox(height: 16),
             
            _buildTextField(context, viewModel.addressController, 'Address', Icons.home),
            const SizedBox(height: 16),
            
            _buildTextField(context, viewModel.postalCodeController, 'Postal Code', Icons.markunread_mailbox),
            const SizedBox(height: 16),
            
            _buildTextField(context, viewModel.phoneController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
            const SizedBox(height: 32),
            
            OsmeaComponents.button(
              text: 'Save Address',
              variant: ButtonVariant.primary,
              fullWidth: true,
              onPressed: () async {
                await viewModel.updateAddress();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Address updated successfully!'), 
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
    return const Center(child: Text('Please log in to manage addresses.'));
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
              Text(hint ?? "Select $label"),
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
