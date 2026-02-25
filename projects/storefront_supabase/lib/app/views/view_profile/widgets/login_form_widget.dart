import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/views/view_profile/models/profile_view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class LoginFormWidget extends StatefulWidget {
  final ProfileViewModel viewModel;
  final VoidCallback onSwitchToSignup;

  const LoginFormWidget({
    super.key,
    required this.viewModel,
    required this.onSwitchToSignup,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.column(
      children: [
        OsmeaComponents.textField(
          controller: widget.viewModel.emailController,
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
          controller: widget.viewModel.passwordController,
          label: resources.password,
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: OsmeaColors.black,
          ),
          variant: TextFieldVariant.outlined,
          focusColor: OsmeaColors.black,
          type: TextFieldType.password,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: OsmeaColors.black,
              size: context.iconSizeSmall,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        OsmeaComponents.sizedBox(height: 24),
        OsmeaComponents.button(
          text: resources.signIn,
          onPressed: widget.viewModel.login,
          variant: ButtonVariant.primary,
          fullWidth: true,
          backgroundColor: OsmeaColors.black,
          textColor: OsmeaColors.white,
        ),
        OsmeaComponents.sizedBox(height: 16),
        GestureDetector(
          onTap: widget.onSwitchToSignup,
          child: OsmeaComponents.text(
            resources.dontHaveAccount,
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
