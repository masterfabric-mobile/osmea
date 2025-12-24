import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_profile/models/states.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';
import 'package:storefront_supabase/l10n/app_localizations.dart';

class PersonalInfoView extends MasterViewCubit<ProfileViewModel, ProfileState> {
  PersonalInfoView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(AppLocalizations.of(context)!.myInformation),
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
    // Populate controllers when entering the view
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
            _buildEditableField(context, viewModel.usernameController, l10n.username, Icons.person),
            const SizedBox(height: 16),
            _buildEditableField(context, viewModel.emailController, l10n.email, Icons.email, readOnly: true),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 4.0, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.emailCannotBeChanged,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            
            // Date of Birth (Age)
            GestureDetector(
              onTap: () => viewModel.pickBirthdate(context),
              child: AbsorbPointer(
                child: _buildEditableField(
                  context, 
                  viewModel.birthdateController, 
                  l10n.dateOfBirth, 
                  Icons.calendar_today, 
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gender Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4), // Matches TextFieldVariant.outlined usually
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: viewModel.selectedGender,
                  hint: Row(
                    children: [
                      const Icon(Icons.people_outline, color: Colors.black),
                      const SizedBox(width: 12),
                      Text(l10n.selectGender),
                    ],
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: [
                    l10n.genderMale,
                    l10n.genderFemale,
                    l10n.genderOther,
                    l10n.genderPreferNotToSay
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    // Trigger a state update or UI refresh (handled by bloc listener/builder usually, but here handled by setGender)
                    viewModel.setGender(newValue);
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),
            OsmeaComponents.button(
              text: l10n.savePersonalInfo,
              variant: ButtonVariant.primary,
              fullWidth: true,
              onPressed: () async {
                await viewModel.updateProfile();
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.profileUpdated), backgroundColor: Colors.green),
                   );
                }
              },
            ),


            const SizedBox(height: 32), // Bottom padding
          ],
        ),
      );
    }
    return Center(child: Text(l10n.loginToViewInfo));
  }

  Widget _buildEditableField(
    BuildContext context, 
    TextEditingController controller, 
    String label, 
    IconData icon,
    {
      bool readOnly = false, 
      bool obscureText = false,
      TextInputType? keyboardType,
    }
  ) {
    return OsmeaComponents.textField(
      controller: controller,
      label: label,
      prefixIcon: Icon(icon, color: Colors.black),
      variant: TextFieldVariant.outlined,
      focusColor: Colors.black,
      readOnly: readOnly,
      obscureText: obscureText,
      type: keyboardType == TextInputType.number ? TextFieldType.number : TextFieldType.text, // Simple mapping
    );
  }
}
