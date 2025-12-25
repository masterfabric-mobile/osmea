import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class LoginFormWidget extends StatelessWidget {
  final ProfileViewModel viewModel;
  final VoidCallback onSwitchToSignup;

  const LoginFormWidget({
    super.key,
    required this.viewModel,
    required this.onSwitchToSignup,
  });

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.textField(
          controller: viewModel.emailController,
          label: resources.email,
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: OsmeaColors.black,
          ),
          variant: TextFieldVariant.outlined,
          focusColor: OsmeaColors.black,
          type: TextFieldType.email,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.textField(
          controller: viewModel.passwordController,
          label: resources.password,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: OsmeaColors.black,
          ),
          variant: TextFieldVariant.outlined,
          focusColor: OsmeaColors.black,
          type: TextFieldType.password,
          obscureText: true,
        ),
        OsmeaComponents.sizedBox(height: 24),
        OsmeaComponents.button(
          text: resources.signIn,
          onPressed: viewModel.login,
          variant: ButtonVariant.primary,
          fullWidth: true,
          backgroundColor: OsmeaColors.black,
          textColor: OsmeaColors.white,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.textButton(
          text: resources.dontHaveAccount,
          onPressed: onSwitchToSignup,
        ),
      ],
    );
  }
}