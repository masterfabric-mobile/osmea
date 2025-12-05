import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';

class SignupFormWidget extends StatelessWidget {
  final ProfileViewModel viewModel;
  final VoidCallback onSwitchToLogin;

  const SignupFormWidget({
    super.key,
    required this.viewModel,
    required this.onSwitchToLogin,
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
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.length < 10) {
              return 'Must be at least 10 characters.';
            }
            if (!value.contains(RegExp(r'[A-Z]'))) {
              return 'Must contain an uppercase letter.';
            }
            if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
              return 'Must contain a special character.';
            }
            return null;
          },
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.textField(
          controller: viewModel.confirmPasswordController,
          label: 'Confirm Password',
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: OsmeaColors.black,
          ),
          variant: TextFieldVariant.outlined,
          focusColor: OsmeaColors.black,
          type: TextFieldType.password,
          obscureText: true,
          validator: (value) {
            if (value != viewModel.passwordController.text) {
              return 'Passwords do not match.';
            }
            return null;
          },
        ),
        OsmeaComponents.sizedBox(height: 24),
        OsmeaComponents.button(
          text: 'Sign Up',
          onPressed: viewModel.state.isFormValid ? viewModel.signup : null,
          variant: ButtonVariant.primary,
          fullWidth: true,
          backgroundColor: OsmeaColors.black,
          textColor: OsmeaColors.white,
        ),
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.textButton(
          text: "Already have an account? Sign In",
          onPressed: onSwitchToLogin,
        ),
      ],
    );
  }
}