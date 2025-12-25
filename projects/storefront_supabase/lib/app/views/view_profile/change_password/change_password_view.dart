import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_profile/change_password/models/states.dart';
import 'package:storefront_supabase/app/views/view_profile/change_password/models/view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';


class ChangePasswordView extends MasterViewCubit<ChangePasswordViewModel, ChangePasswordState> {
  ChangePasswordView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
            title: OsmeaComponents.text(context.resources.changePassword),
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
  void initialContent(ChangePasswordViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
      BuildContext context, ChangePasswordViewModel viewModel, ChangePasswordState state) {
    final resources = context.resources;
    if (state is ChangePasswordLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ChangePasswordError) {
      return buildError(state.message, onRetry: () => viewModel.initial());
    }

    // Default or Loaded state (assuming view model handles clearing after success)
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          _buildEditableField(
            context,
            viewModel.newPasswordController,
            resources.newPassword,
            Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          _buildEditableField(
            context,
            viewModel.confirmNewPasswordController,
            resources.confirmNewPassword,
            Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          OsmeaComponents.button(
            text: resources.updatePassword,
            variant: ButtonVariant.primary,
            fullWidth: true,
            onPressed: () async {
              final success = await viewModel.changePassword();
              if (!context.mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(resources.passwordChanged),
                    backgroundColor: Colors.green,
                  ),
                );
                context.pop(); // Go back to profile after success
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(resources.failedChangePassword),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context,
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
  }) {
    return OsmeaComponents.textField(
      controller: controller,
      label: label,
      prefixIcon: Icon(icon, color: Colors.black),
      variant: TextFieldVariant.outlined,
      focusColor: Colors.black,
      obscureText: obscureText,
      type: TextFieldType.text,
    );
  }
}
