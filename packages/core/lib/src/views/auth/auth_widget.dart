import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_state.dart';
import 'package:core/src/views/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:core/src/views/auth/sign_up/cubit/sign_up_state.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:get_it/get_it.dart';

/// 🎨 **Auth Widget - Completely Rewritten for Simplicity**
///
/// Combined Sign In and Sign Up with manual tab switching
class AuthWidget extends StatefulWidget {
  final SignInCubit signInViewModel;
  final SignInState signInState;
  final Future<bool> Function(String, String, bool)? signUpCallback;
  final VoidCallback? onSignInSuccess;
  final Function(String error)? onSignInError;
  final VoidCallback? onSignUpSuccess;
  final Function(String error)? onSignUpError;
  final VoidCallback? onForgotPasswordTap;
  final Map<String, dynamic>? config;
  final int initialTab;

  const AuthWidget({
    super.key,
    required this.signInViewModel,
    required this.signInState,
    this.signUpCallback,
    this.onSignInSuccess,
    this.onSignInError,
    this.onSignUpSuccess,
    this.onSignUpError,
    this.onForgotPasswordTap,
    this.config,
    this.initialTab = 0,
  });

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  late SignUpCubit _signUpCubit;
  late int _currentTab;
  SignInStatus? _lastSignInStatus;
  SignUpStatus? _lastSignUpStatus;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;

    // Initialize Sign Up Cubit
    _signUpCubit = GetIt.I<SignUpCubit>();
    if (widget.signUpCallback != null) {
      _signUpCubit.authenticationCallback = widget.signUpCallback;
    }
  }

  @override
  void dispose() {
    _signUpCubit.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(AuthWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle Sign In callbacks
    if (widget.signInState.status == SignInStatus.success &&
        _lastSignInStatus != SignInStatus.success) {
      _lastSignInStatus = SignInStatus.success;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSignInSuccess?.call();
      });
    } else if (widget.signInState.status == SignInStatus.error &&
        widget.signInState.errorMessage != null &&
        _lastSignInStatus != SignInStatus.error) {
      _lastSignInStatus = SignInStatus.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSignInError?.call(widget.signInState.errorMessage!);
      });
    }
  }

  String _getConfigValue(String section, String key, String fallback) {
    return widget.config?[section]?[key] ?? fallback;
  }

  void _switchTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final logoUrl = widget.config?['sign_in']?['logo_url'] as String?;
    final logoWidth =
        (widget.config?['sign_in']?['logo_width'] as num?)?.toDouble() ?? 120.0;
    final logoHeight =
        (widget.config?['sign_in']?['logo_height'] as num?)?.toDouble() ??
            120.0;
    final appName = _getConfigValue('sign_in', 'app_name', 'OSMEA');

    // UI Style configuration
    final tabContainerRadius =
        (widget.config?['ui_style']?['tab_container_radius'] as num?)
                ?.toDouble() ??
            12.0;
    final tabItemRadius =
        (widget.config?['ui_style']?['tab_item_radius'] as num?)?.toDouble() ??
            10.0;
    final buttonRadius =
        (widget.config?['ui_style']?['button_radius'] as num?)?.toDouble() ??
            12.0;
    final contentAreaTopRadius =
        (widget.config?['ui_style']?['content_area_top_radius'] as num?)
                ?.toDouble() ??
            32.0;
    final horizontalPadding =
        (widget.config?['ui_style']?['horizontal_padding'] as num?)
                ?.toDouble() ??
            24.0;
    final backgroundColor =
        widget.config?['ui_style']?['background_color'] as String?;

    return Scaffold(
      backgroundColor: backgroundColor != null
          ? Color(int.parse(backgroundColor.replaceAll('#', '0xFF')))
          : Color(0xFF4A6FE8),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        left: false,
        right: false,
        bottom: false,
        child: Column(
          children: [
            // 🎨 Logo/App Name Header
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: logoUrl != null
                    ? OsmeaComponents.image(
                        imageUrl: logoUrl,
                        width: logoWidth,
                        height: logoHeight,
                        fit: BoxFit.contain,
                      )
                    : OsmeaComponents.text(
                        appName,
                        variant: OsmeaTextVariant.headlineLarge,
                        color: OsmeaColors.white,
                        fontWeight: FontWeight.bold,
                      ),
              ),
            ),

            // 📋 White Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: OsmeaColors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(contentAreaTopRadius),
                  ),
                ),
                child: Column(
                  children: [
                    // 📑 Tab Bar
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 24,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius:
                              BorderRadius.circular(tabContainerRadius),
                        ),
                        child: Row(
                          children: [
                            // Sign In Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _switchTab(0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _currentTab == 0
                                        ? OsmeaColors.white
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(tabItemRadius),
                                    boxShadow: _currentTab == 0
                                        ? [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: OsmeaComponents.text(
                                      _getConfigValue(
                                          'sign_in', 'tab_sign_in', 'Sign In'),
                                      variant: OsmeaTextVariant.bodyLarge,
                                      fontWeight: _currentTab == 0
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: _currentTab == 0
                                          ? OsmeaColors.thunder
                                          : OsmeaColors.thunder
                                              .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Sign Up Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _switchTab(1),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _currentTab == 1
                                        ? OsmeaColors.white
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(tabItemRadius),
                                    boxShadow: _currentTab == 1
                                        ? [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: OsmeaComponents.text(
                                      _getConfigValue(
                                          'sign_up', 'tab_sign_up', 'Sign Up'),
                                      variant: OsmeaTextVariant.bodyLarge,
                                      fontWeight: _currentTab == 1
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: _currentTab == 1
                                          ? OsmeaColors.thunder
                                          : OsmeaColors.thunder
                                              .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 📋 Content Area
                    Expanded(
                      child: _currentTab == 0
                          ? _buildSignInContent(buttonRadius, horizontalPadding)
                          : _buildSignUpContent(
                              buttonRadius, horizontalPadding),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📧 Sign In Content
  Widget _buildSignInContent(double buttonRadius, double horizontalPadding) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          _buildEmailField(widget.signInViewModel, widget.signInState),
          SizedBox(height: 20),
          _buildPasswordField(widget.signInViewModel, widget.signInState),
          SizedBox(height: 16),
          _buildRememberMeAndForgotPassword(),
          SizedBox(height: 48),
          _buildSignInButton(buttonRadius),
          SizedBox(height: 64),
        ],
      ),
    );
  }

  /// 📝 Sign Up Content
  Widget _buildSignUpContent(double buttonRadius, double horizontalPadding) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      bloc: _signUpCubit,
      builder: (context, signUpState) {
        // Handle Sign Up callbacks
        if (signUpState.status == SignUpStatus.success &&
            _lastSignUpStatus != SignUpStatus.success) {
          _lastSignUpStatus = SignUpStatus.success;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onSignUpSuccess?.call();
          });
        } else if (signUpState.status == SignUpStatus.error &&
            signUpState.errorMessage != null &&
            _lastSignUpStatus != SignUpStatus.error) {
          _lastSignUpStatus = SignUpStatus.error;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onSignUpError?.call(signUpState.errorMessage!);
          });
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              _buildSignUpEmailField(signUpState),
              SizedBox(height: 20),
              _buildSignUpPasswordField(signUpState),
              SizedBox(height: 20),
              _buildSignUpPasswordConfirmField(signUpState),
              SizedBox(height: 24),
              _buildMarketingConsentCheckbox(signUpState),
              SizedBox(height: 16),
              _buildPrivacyPolicyCheckbox(signUpState),
              SizedBox(height: 16),
              _buildTermsCheckbox(signUpState),
              SizedBox(height: 32),
              _buildSignUpButton(signUpState, buttonRadius),
              SizedBox(height: 64),
            ],
          ),
        );
      },
    );
  }

  // ============================================================================
  // SIGN IN FIELDS
  // ============================================================================

  Widget _buildEmailField(SignInCubit viewModel, SignInState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _getConfigValue('sign_in', 'email_label', 'Email'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.thunder,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        OsmeaComponents.textField(
          hint: _getConfigValue('sign_in', 'email_hint', 'Enter your email'),
          keyboardType: TextInputType.emailAddress,
          onChanged: viewModel.updateEmail,
          errorText: state.emailError,
          enabled: state.status != SignInStatus.loading,
        ),
      ],
    );
  }

  Widget _buildPasswordField(SignInCubit viewModel, SignInState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _getConfigValue('sign_in', 'password_label', 'Password'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.thunder,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_in', 'password_hint', 'Enter your password'),
          obscureText: state.obscurePassword,
          onChanged: viewModel.updatePassword,
          errorText: state.passwordError,
          enabled: state.status != SignInStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.thunder.withOpacity(0.4),
              size: 20,
            ),
            onPressed: viewModel.togglePasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            OsmeaComponents.checkbox(
              value: widget.signInState.rememberMe,
              onChanged: (value) => widget.signInViewModel.toggleRememberMe(),
              activeColor: Color(0xFF4A6FE8),
              size: CheckboxSize.small,
            ),
            SizedBox(width: 8),
            OsmeaComponents.text(
              _getConfigValue('sign_in', 'remember_me_label', 'Remember me'),
              variant: OsmeaTextVariant.bodySmall,
              color: OsmeaColors.thunder,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        if (widget.onForgotPasswordTap != null)
          GestureDetector(
            onTap: widget.onForgotPasswordTap,
            child: OsmeaComponents.text(
              _getConfigValue(
                  'sign_in', 'forgot_password_label', 'Forgot Password?'),
              variant: OsmeaTextVariant.bodySmall,
              color: Color(0xFF4A6FE8),
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildSignInButton(double buttonRadius) {
    final isLoading = widget.signInState.status == SignInStatus.loading;
    final isEnabled = widget.signInState.isValid && !isLoading;

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_in', 'sign_in_button_loading', 'Signing in...')
          : _getConfigValue('sign_in', 'sign_in_button', 'Continue'),
      onPressed: isEnabled ? widget.signInViewModel.signIn : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.large,
      state: isLoading ? ButtonState.loading : ButtonState.enabled,
      fullWidth: true,
      backgroundColor: Color(0xFF4A6FE8),
      borderRadius: buttonRadius,
    );
  }

  // ============================================================================
  // SIGN UP FIELDS
  // ============================================================================

  Widget _buildSignUpEmailField(SignUpState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _getConfigValue('sign_up', 'email_label', 'Email'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.thunder,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        OsmeaComponents.textField(
          hint: _getConfigValue('sign_up', 'email_hint', 'Enter your email'),
          keyboardType: TextInputType.emailAddress,
          onChanged: _signUpCubit.updateEmail,
          errorText: state.emailError,
          enabled: state.status != SignUpStatus.loading,
        ),
      ],
    );
  }

  Widget _buildSignUpPasswordField(SignUpState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _getConfigValue('sign_up', 'password_label', 'Password'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.thunder,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_up', 'password_hint', 'Enter your password'),
          obscureText: state.obscurePassword,
          onChanged: _signUpCubit.updatePassword,
          errorText: state.passwordError,
          enabled: state.status != SignUpStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.thunder.withOpacity(0.4),
              size: 20,
            ),
            onPressed: _signUpCubit.togglePasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpPasswordConfirmField(SignUpState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _getConfigValue(
                    'sign_up', 'password_confirm_label', 'Confirm Password'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.thunder,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_up', 'password_confirm_hint', 'Confirm your password'),
          obscureText: state.obscurePasswordConfirm,
          onChanged: _signUpCubit.updatePasswordConfirm,
          errorText: state.passwordConfirmError,
          enabled: state.status != SignUpStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.obscurePasswordConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.thunder.withOpacity(0.4),
              size: 20,
            ),
            onPressed: _signUpCubit.togglePasswordConfirmVisibility,
          ),
        ),
      ],
    );
  }

  /// 📧 Marketing Consent Checkbox
  Widget _buildMarketingConsentCheckbox(SignUpState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.checkbox(
          value: state.marketingConsent,
          onChanged: (value) => _signUpCubit.toggleMarketingConsent(),
          activeColor: Color(0xFF4A6FE8),
          size: CheckboxSize.small,
        ),
        SizedBox(width: 8),
        Expanded(
          child: OsmeaComponents.text(
            _getConfigValue(
              'sign_up',
              'marketing_consent_label',
              'I would like to receive promotional emails/SMS',
            ),
            variant: OsmeaTextVariant.bodySmall,
            color: OsmeaColors.thunder,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// 📄 Privacy Policy Checkbox
  Widget _buildPrivacyPolicyCheckbox(SignUpState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.checkbox(
          value: state.privacyPolicyAccepted,
          onChanged: (value) => _signUpCubit.togglePrivacyPolicy(),
          activeColor: Color(0xFF4A6FE8),
          size: CheckboxSize.small,
        ),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _getConfigValue(
                    'sign_up',
                    'privacy_policy_label',
                    'I have read and accept the Privacy Policy',
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: OsmeaColors.thunder,
                  ),
                ),
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 📜 Terms of Service Checkbox
  Widget _buildTermsCheckbox(SignUpState state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.checkbox(
          value: state.termsAccepted,
          onChanged: (value) => _signUpCubit.toggleTerms(),
          activeColor: Color(0xFF4A6FE8),
          size: CheckboxSize.small,
        ),
        SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: _getConfigValue(
                    'sign_up',
                    'terms_label',
                    'I have read and accept the Terms of Service',
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: OsmeaColors.thunder,
                  ),
                ),
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(SignUpState state, double buttonRadius) {
    final isLoading = state.status == SignUpStatus.loading;
    final isEnabled = state.isValid && !isLoading;

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_up', 'sign_up_button_loading', 'Creating account...')
          : _getConfigValue('sign_up', 'sign_up_button', 'Create Account'),
      onPressed: isEnabled ? _signUpCubit.signUp : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.large,
      state: isLoading ? ButtonState.loading : ButtonState.enabled,
      fullWidth: true,
      backgroundColor: Color(0xFF4A6FE8),
      borderRadius: buttonRadius,
    );
  }
}
