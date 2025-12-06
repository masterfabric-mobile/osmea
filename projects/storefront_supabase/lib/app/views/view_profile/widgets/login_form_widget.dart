import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';

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
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.textField(
          controller: viewModel.emailController,
          label: 'Email',
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
          label: 'Password',
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
          text: 'Sign In',
          onPressed: viewModel.login,
          variant: ButtonVariant.primary,
          fullWidth: true,
          backgroundColor: OsmeaColors.black,
          textColor: OsmeaColors.white,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.textButton(
          text: "Don't have an account? Sign Up",
          onPressed: onSwitchToSignup,
        ),
      ],
    );
  }
}