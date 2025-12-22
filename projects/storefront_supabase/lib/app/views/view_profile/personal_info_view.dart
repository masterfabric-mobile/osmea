import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_profile/models/states.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';

class PersonalInfoView extends MasterViewCubit<ProfileViewModel, ProfileState> {
  PersonalInfoView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text('My Information'),
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
    if (state is ProfileLoading) {
       return const Center(child: CircularProgressIndicator());
    }
    
    if (state is ProfileAuthenticated) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            _buildEditableField(context, viewModel.usernameController, 'Username', Icons.person),
            const SizedBox(height: 16),
            _buildEditableField(context, viewModel.emailController, 'Email', Icons.email, readOnly: true),
            const Padding(
              padding: EdgeInsets.only(left: 4.0, top: 4.0, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '* Email cannot be changed here directly.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
                  'Date of Birth', 
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
                  hint: const Row(
                    children: [
                      Icon(Icons.people_outline, color: Colors.black),
                      SizedBox(width: 12),
                      Text("Select Gender"),
                    ],
                  ),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: ['Male', 'Female', 'Other', 'Prefer not to say'].map((String value) {
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
              text: 'Save Personal Info',
              variant: ButtonVariant.primary,
              fullWidth: true,
              onPressed: () async {
                await viewModel.updateProfile();
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
                   );
                }
              },
            ),


            const SizedBox(height: 32), // Bottom padding
          ],
        ),
      );
    }
    return const Center(child: Text('Please log in to view information.'));
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
