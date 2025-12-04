import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'models/view_model.dart';
import 'models/states.dart';

class LoginView
    extends MasterViewCubit<LoginViewModel, LoginState> {
  LoginView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          coreAppBar: null,
        );

  @override
  void initialContent(
    LoginViewModel viewModel,
    BuildContext context,
  ) {
    viewModel.initial();
  }

  @override
  Widget viewContent(
    BuildContext context,
    LoginViewModel viewModel,
    LoginState state,
  ) {
    if (state is LoginInitialState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is LoginErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.initial(),
      );
    }

    // Assuming LoginLoadedState is the normal state for the form
    final loadedState = state as LoginLoadedState;
    return OsmeaComponents.scaffold(
      body: OsmeaComponents.center(
        child: OsmeaComponents.singleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.text(
                'Welcome Back!',
                variant: OsmeaTextVariant.headlineMedium,
                fontWeight: FontWeight.bold,
                color: OsmeaColors.nordicBlue,
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.text(
                'Login to continue your shopping experience',
                textAlign: TextAlign.center,
                color: OsmeaColors.slate,
              ),
              OsmeaComponents.sizedBox(height: 32),
              OsmeaComponents.textField(
                controller: viewModel.emailController,
                label: 'Email',
                hint: 'Enter your email',
                variant: TextFieldVariant.outlined,
                type: TextFieldType.email,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (_) {
                  if (viewModel.emailController.text.isEmpty) return 'Email cannot be empty';
                  if (!viewModel.emailController.text.contains('@')) return 'Invalid email format';
                  return null;
                },
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.textField(
                controller: viewModel.passwordController,
                label: 'Password',
                hint: 'Enter your password',
                variant: TextFieldVariant.outlined,
                type: TextFieldType.password,
                obscureText: !loadedState.isPasswordVisible,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: OsmeaComponents.iconButton(
                  icon: Icon(
                      loadedState.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: viewModel.togglePasswordVisibility,
                ),
                validator: (_) {
                  if (viewModel.passwordController.text.isEmpty) return 'Password cannot be empty';
                  if (viewModel.passwordController.text.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              OsmeaComponents.sizedBox(height: 24),
              OsmeaComponents.button(
                text: 'Login',
                fullWidth: true,
                variant: ButtonVariant.primary,
                onPressed: loadedState.isFormValid && !loadedState.isLoading
                    ? () => viewModel.login()
                    : null, // Disable button if form is invalid or loading
              ),
              OsmeaComponents.sizedBox(height: 16),
              OsmeaComponents.textButton(
                text: 'Don\'t have an account? Sign Up',
                onPressed: loadedState.isLoading
                    ? null
                    : () => goRoute('/signup'), // Disable navigation while loading
              ),
            ],
          ),
        ),
      ),
    );
  }
}
