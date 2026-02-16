import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/views/view_profile/models/profile_view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

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
    final resources = context.resources;
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.textField(
          controller: viewModel.usernameController,
          label: resources.username,
          prefixIcon: const Icon(
            Icons.person_outline,
            color: OsmeaColors.black,
          ),
          variant: TextFieldVariant.outlined,
          focusColor: OsmeaColors.black,
        ),
        OsmeaComponents.sizedBox(height: 16),
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
        OsmeaComponents.sizedBox(height: 16),
        OsmeaComponents.textField(
          controller: viewModel.confirmPasswordController,
          label: resources.confirmNewPassword,
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
          text: resources.signup,
          onPressed: viewModel.signup,
          variant: ButtonVariant.primary,
          fullWidth: true,
          backgroundColor: OsmeaColors.black,
          textColor: OsmeaColors.white,
        ),
                OsmeaComponents.sizedBox(height: 16),
                GestureDetector(
                  onTap: onSwitchToLogin,
                  child: OsmeaComponents.text(
                    resources.alreadyHaveAccount,
                    textStyle: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            );
          }
        }
        