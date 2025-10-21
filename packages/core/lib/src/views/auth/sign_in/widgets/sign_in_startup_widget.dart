import 'package:flutter/material.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:core/src/views/auth/sign_in/cubit/sign_in_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🔐 **OSMEA Sign In Startup Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Modern sign in style with tabs and gradient background
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
  final Map<String, dynamic>? config;

  const SignInStartupWidget({
    super.key,
    required this.viewModel,
    required this.state,
    this.onSignInSuccess,
    this.onSignInError,
    this.onSignUpTap,
    this.onForgotPasswordTap,
    this.config,
  });

  @override
  State<SignInStartupWidget> createState() => _SignInStartupWidgetState();
}

class _SignInStartupWidgetState extends State<SignInStartupWidget>
    with SingleTickerProviderStateMixin {
  SignInStatus? _lastHandledStatus;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    return Scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      body: Column(
        children: [
          // 🎨 Top Gradient Section with Tabs
          _buildGradientHeader(context),

          // 📋 Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing24,
                vertical: context.spacing32,
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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

                  OsmeaComponents.sizedBox(height: context.spacing64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get config value with fallback
  String _getConfigValue(String key, String fallback) {
    return widget.config?[key] ?? fallback;
  }

  /// 🎨 Gradient Header with Tabs
  Widget _buildGradientHeader(BuildContext context) {
    final showLogo = widget.config?['show_logo'] as bool? ?? true;
    final logoIcon = widget.config?['logo_icon'] as String? ?? 'store';
    final appName = _getConfigValue('app_name', 'OSMEA');

    return Container(
      height: MediaQuery.of(context).size.height * 0.38, // 38% of screen
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A6FE8),
            Color(0xFF5B7BED),
            Color(0xFF6C8BF2),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 🎨 Logo Area
            Expanded(
              child: Center(
                child: showLogo
                    ? OsmeaComponents.text(
                        appName,
                        variant: OsmeaTextVariant.headlineLarge,
                        color: OsmeaColors.white,
                        fontWeight: FontWeight.bold,
                      )
                    : Icon(
                        _getIconData(logoIcon),
                        size: 80,
                        color: OsmeaColors.white,
                      ),
              ),
            ),

            // 📑 Tabs Container (Rounded bottom design)
            Container(
              margin: EdgeInsets.symmetric(horizontal: context.spacing16),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.spacing24),
                ),
              ),
              child: Column(
                children: [
                  OsmeaComponents.sizedBox(height: context.spacing16),
                  // Tab buttons
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: context.spacing24,
                    ),
                    padding: EdgeInsets.all(context.spacing4),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5), // Light gray background
                      borderRadius: BorderRadius.circular(context.spacing12),
                    ),
                    child: Row(
                      children: [
                        // Sign In Tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _tabController.index = 0;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: context.spacing12,
                              ),
                              decoration: BoxDecoration(
                                color: _tabController.index == 0
                                    ? OsmeaColors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  context.spacing10,
                                ),
                                boxShadow: _tabController.index == 0
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: OsmeaComponents.text(
                                  _getConfigValue('tab_sign_in', 'Giriş Yap'),
                                  variant: OsmeaTextVariant.bodyLarge,
                                  fontWeight: _tabController.index == 0
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: _tabController.index == 0
                                      ? OsmeaColors.thunder
                                      : OsmeaColors.thunder.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Sign Up Tab
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onSignUpTap != null) {
                                widget.onSignUpTap!();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: context.spacing12,
                              ),
                              decoration: BoxDecoration(
                                color: _tabController.index == 1
                                    ? OsmeaColors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  context.spacing10,
                                ),
                                boxShadow: _tabController.index == 1
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: OsmeaComponents.text(
                                  _getConfigValue('tab_sign_up', 'Kayıt Ol'),
                                  variant: OsmeaTextVariant.bodyLarge,
                                  fontWeight: _tabController.index == 1
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: _tabController.index == 1
                                      ? OsmeaColors.thunder
                                      : OsmeaColors.thunder.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get icon data from string
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'store':
        return Icons.store;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'shopping_cart':
        return Icons.shopping_cart;
      default:
        return Icons.store;
    }
  }

  /// 📧 Email Field
  Widget _buildEmailField(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with asterisk
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _getConfigValue('email_label', 'E-Posta'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.thunder,
                ),
              ),
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue('email_hint', 'Giriniz'),
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
        // Label with asterisk
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _getConfigValue('password_label', 'Şifre'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OsmeaColors.thunder,
                ),
              ),
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue('password_hint', 'Giriniz'),
          obscureText: widget.state.obscurePassword,
          onChanged: widget.viewModel.updatePassword,
          errorText: widget.state.passwordError,
          enabled: widget.state.status != SignInStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              widget.state.obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.thunder.withOpacity(0.4),
              size: 20,
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
            OsmeaComponents.checkbox(
              value: widget.state.rememberMe,
              onChanged: (value) => widget.viewModel.toggleRememberMe(),
              activeColor: Color(0xFF4A6FE8),
              size: CheckboxSize.small,
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            OsmeaComponents.text(
              _getConfigValue('remember_me_label', 'Beni Hatırla'),
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.thunder,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),

        // Forgot Password Link
        if (widget.onForgotPasswordTap != null)
          GestureDetector(
            onTap: widget.onForgotPasswordTap,
            child: OsmeaComponents.text(
              _getConfigValue('forgot_password_label', 'Şifremi Unuttum'),
              variant: OsmeaTextVariant.bodyMedium,
              color: Color(0xFF4A6FE8),
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final isLoading = widget.state.status == SignInStatus.loading;
    final isEnabled = widget.state.isValid && !isLoading;

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue('sign_in_button_loading', 'Giriş yapılıyor...')
          : _getConfigValue('sign_in_button', 'Devam Et'),
      onPressed: isEnabled ? widget.viewModel.signIn : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.large,
      state: isLoading ? ButtonState.loading : ButtonState.enabled,
      fullWidth: true,
      backgroundColor: Color(0xFF4A6FE8),
    );
  }
}
