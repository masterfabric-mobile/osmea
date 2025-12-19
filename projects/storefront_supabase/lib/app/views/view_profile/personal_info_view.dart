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
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildEditableField(context, viewModel.usernameController, 'Username', Icons.person),
            const SizedBox(height: 16),
            _buildEditableField(context, viewModel.emailController, 'Email', Icons.email, readOnly: true),
            const Padding(
              padding: EdgeInsets.only(left: 4.0, top: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '* Email cannot be changed here directly.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 32),
            OsmeaComponents.button(
              text: 'Save Changes',
              variant: ButtonVariant.primary,
              fullWidth: true,
              onPressed: () async {
                await viewModel.updateProfile();
                if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!')),
                   );
                }
              },
            ),
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
    {bool readOnly = false}
  ) {
    return OsmeaComponents.textField(
      controller: controller,
      label: label,
      prefixIcon: Icon(icon, color: Colors.black),
      variant: TextFieldVariant.outlined,
      focusColor: Colors.black,
      readOnly: readOnly,
    );
  }
}
