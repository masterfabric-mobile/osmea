import 'package:flutter/material.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🔐 **OSMEA Sign In Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Basic sign in style - Clean and simple design
///
/// {@category Widgets}
/// {@subCategory SignInStartup}

class SignInStartupWidget extends StatefulWidget {
  final SignInCubit viewModel;
  final SignInState state;
  final VoidCallback? onSignInSuccess;
  final Function(String error)? onSignInError;
  final VoidCallback? onSignUpTap;
  final VoidCallback? onForgotPasswordTap;

  const SignInStartupWidget({
    super.key,
    required this.viewModel,
    required this.state,
    this.onSignInSuccess,
    this.onSignInError,
    this.onSignUpTap,
    this.onForgotPasswordTap,
  });

  @override
  State<SignInStartupWidget> createState() => _SignInStartupWidgetState();
}

class _SignInStartupWidgetState extends State<SignInStartupWidget> {
  SignInStatus? _lastHandledStatus;

  @override
  void didUpdateWidget(SignInStartupWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle success callback
    if (widget.state.status == SignInStatus.success &&
        _lastHandledStatus != SignInStatus.success) {
      _lastHandledStatus = SignInStatus.success;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSignInSuccess?.call();
      });
    }
    // Handle error callback
    else if (widget.state.status == SignInStatus.error &&
        widget.state.errorMessage != null &&
        _lastHandledStatus != SignInStatus.error) {
      _lastHandledStatus = SignInStatus.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSignInError?.call(widget.state.errorMessage!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: OsmeaComponents.container(
        color: OsmeaColors.paperWhite,
        child: SingleChildScrollView(
          padding: context.paddingNormal,
          child: OsmeaComponents.column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OsmeaComponents.sizedBox(height: context.spacing64),

              // 🎯 Header Section
              _buildHeader(context),

              OsmeaComponents.sizedBox(height: context.spacing48),

              // 📧 Email Field
              _buildEmailField(context),

              OsmeaComponents.sizedBox(height: context.spacing20),

              // 🔑 Password Field
              _buildPasswordField(context),

              OsmeaComponents.sizedBox(height: context.spacing16),

              // 🔗 Remember Me & Forgot Password
              _buildRememberMeAndForgotPassword(context),

              OsmeaComponents.sizedBox(height: context.spacing32),

              // ✅ Sign In Button
              _buildSignInButton(context),

              OsmeaComponents.sizedBox(height: context.spacing24),

              // 🔗 Sign Up Link
              if (widget.onSignUpTap != null) _buildSignUpLink(context),

              OsmeaComponents.sizedBox(height: context.spacing64),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎯 Header Section
  Widget _buildHeader(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Lock icon
        Icon(
          Icons.lock_outline,
          size: 64,
          color: OsmeaColors.nordicBlue,
        ),

        OsmeaComponents.sizedBox(height: context.spacing20),

        // Title
        OsmeaComponents.text(
          'Welcome Back',
          variant: OsmeaTextVariant.headlineLarge,
          fontWeight: FontWeight.bold,
          color: OsmeaColors.thunder,
          textAlign: TextAlign.center,
        ),

        OsmeaComponents.sizedBox(height: context.spacing8),

        // Subtitle
        OsmeaComponents.text(
          'Sign in to continue',
          variant: OsmeaTextVariant.bodyLarge,
          color: OsmeaColors.thunder.withOpacity(0.6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 📧 Email Field
  Widget _buildEmailField(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Email',
          variant: OsmeaTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: OsmeaColors.thunder,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: 'Enter your email',
          prefixIcon: Icon(Icons.email_outlined,
              color: OsmeaColors.thunder.withOpacity(0.5)),
          keyboardType: TextInputType.emailAddress,
          onChanged: widget.viewModel.updateEmail,
          errorText: widget.state.emailError,
          enabled: widget.state.status != SignInStatus.loading,
        ),
      ],
    );
  }

  /// 🔑 Password Field
  Widget _buildPasswordField(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'Password',
          variant: OsmeaTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: OsmeaColors.thunder,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: 'Enter your password',
          prefixIcon: Icon(Icons.lock_outline,
              color: OsmeaColors.thunder.withOpacity(0.5)),
          obscureText: widget.state.obscurePassword,
          onChanged: widget.viewModel.updatePassword,
          errorText: widget.state.passwordError,
          enabled: widget.state.status != SignInStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              widget.state.obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: OsmeaColors.thunder.withOpacity(0.5),
            ),
            onPressed: widget.viewModel.togglePasswordVisibility,
          ),
        ),
      ],
    );
  }

  /// 🔗 Remember Me & Forgot Password
  Widget _buildRememberMeAndForgotPassword(BuildContext context) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me Checkbox
        OsmeaComponents.row(
          children: [
            Checkbox(
              value: widget.state.rememberMe,
              onChanged: (value) => widget.viewModel.toggleRememberMe(),
              activeColor: OsmeaColors.nordicBlue,
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            OsmeaComponents.text(
              'Remember me',
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.thunder,
            ),
          ],
        ),

        // Forgot Password Link
        if (widget.onForgotPasswordTap != null)
          GestureDetector(
            onTap: widget.onForgotPasswordTap,
            child: OsmeaComponents.text(
              'Forgot Password?',
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.nordicBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  /// ✅ Sign In Button
  Widget _buildSignInButton(BuildContext context) {
    final isLoading = widget.state.status == SignInStatus.loading;
    final isEnabled = widget.state.isValid && !isLoading;

    return OsmeaComponents.button(
      text: isLoading ? 'Signing In...' : 'Sign In',
      onPressed: isEnabled ? widget.viewModel.signIn : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.large,
      state: isLoading ? ButtonState.loading : ButtonState.enabled,
      fullWidth: true,
    );
  }

  /// 🔗 Sign Up Link
  Widget _buildSignUpLink(BuildContext context) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OsmeaComponents.text(
          "Don't have an account? ",
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder.withOpacity(0.6),
        ),
        GestureDetector(
          onTap: widget.onSignUpTap,
          child: OsmeaComponents.text(
            'Sign Up',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.nordicBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
