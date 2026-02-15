import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_profile/change_password/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_profile/change_password/models/change_password_view_model.dart';
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
            title: OsmeaComponents.text(
              context.resources.changePassword,
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
  void initialContent(ChangePasswordViewModel viewModel, BuildContext context) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
      BuildContext context, ChangePasswordViewModel viewModel, ChangePasswordState state) {
    final resources = context.resources;
    if (state is ChangePasswordLoading) {
      return Center(child: CircularProgressIndicator(color: OsmeaColors.black));
    }

    if (state is ChangePasswordError) {
      return buildError(state.message, onRetry: () => viewModel.initial());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: context.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                _buildEditableField(
                  context,
                  viewModel.newPasswordController,
                  resources.newPassword,
                  obscureText: true,
                ),
                SizedBox(height: context.spacing16),
                _buildEditableField(
                  context,
                  viewModel.confirmNewPasswordController,
                  resources.confirmNewPassword,
                  obscureText: true,
                ),
                SizedBox(height: context.spacing24),
                OsmeaComponents.button(
                  text: resources.updatePassword,
                  variant: ButtonVariant.primary,
                  backgroundColor: OsmeaColors.black,
                  textColor: OsmeaColors.white,
                  fullWidth: true,
                  onPressed: () async {
                    final success = await viewModel.changePassword();
                    if (!context.mounted) return;
                    if (success) {
                      context.showSnackbar(
                        message: resources.passwordChanged,
                        type: SnackbarType.success,
                      );
                      context.pop();
                    } else {
                      context.snackbarWarning(resources.failedChangePassword);
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

  Widget _buildEditableField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    bool obscureText = false,
  }) {
    return OsmeaComponents.textField(
      controller: controller,
      label: label,
      variant: TextFieldVariant.outlined,
      focusColor: OsmeaColors.black,
      obscureText: obscureText,
      type: TextFieldType.text,
    );
  }
}
