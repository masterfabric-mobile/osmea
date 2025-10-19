import 'package:flutter/material.dart';
import 'package:core/src/views/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:core/src/views/auth/sign_up/cubit/sign_up_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🎨 **Sign Up Startup Widget**
///
/// Modern sign up style with tabs and gradient background
///
/// {@category Widgets}
/// {@subCategory SignUpStartup}

class SignUpStartupWidget extends StatefulWidget {
  final SignUpCubit viewModel;
  final SignUpState state;
  final VoidCallback? onSignUpSuccess;
  final Function(String error)? onSignUpError;
  final VoidCallback? onSignInTap;
  final Map<String, dynamic>? config;

  const SignUpStartupWidget({
    super.key,
    required this.viewModel,
    required this.state,
    this.onSignUpSuccess,
    this.onSignUpError,
    this.onSignInTap,
    this.config,
  });

  @override
  State<SignUpStartupWidget> createState() => _SignUpStartupWidgetState();
}

class _SignUpStartupWidgetState extends State<SignUpStartupWidget>
    with SingleTickerProviderStateMixin {
  SignUpStatus? _lastHandledStatus;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = 1; // Default to Sign Up tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SignUpStartupWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle success/error callbacks only when status changes
    if (widget.state.status == SignUpStatus.success &&
        _lastHandledStatus != SignUpStatus.success) {
      _lastHandledStatus = SignUpStatus.success;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSignUpSuccess?.call();
      });
    } else if (widget.state.status == SignUpStatus.error &&
        widget.state.errorMessage != null &&
        _lastHandledStatus != SignUpStatus.error) {
      _lastHandledStatus = SignUpStatus.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSignUpError?.call(widget.state.errorMessage!);
      });
    }
  }

  /// Get config value with fallback
  String _getConfigValue(String key, String fallback) {
    return widget.config?[key] ?? fallback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      body: Column(
        children: [
          _buildGradientHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing24,
                vertical: context.spacing32,
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEmailField(context),
                  OsmeaComponents.sizedBox(height: context.spacing20),
                  _buildPasswordField(context),
                  OsmeaComponents.sizedBox(height: context.spacing20),
                  _buildPasswordConfirmField(context),
                  OsmeaComponents.sizedBox(height: context.spacing32),
                  _buildSignUpButton(context),
                  OsmeaComponents.sizedBox(height: context.spacing64),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 Gradient Header with Tabs (Ticimax Style)
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
            Color(0xFF4A6FE8), // Ticimax blue
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
                              if (widget.onSignInTap != null) {
                                widget.onSignInTap!();
                              }
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
                              setState(() {
                                _tabController.index = 1;
                              });
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
          enabled: widget.state.status != SignUpStatus.loading,
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
          enabled: widget.state.status != SignUpStatus.loading,
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

  /// 🔑 Password Confirmation Field
  Widget _buildPasswordConfirmField(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with asterisk
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _getConfigValue('password_confirm_label', 'Şifre Tekrar'),
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
          hint: _getConfigValue('password_confirm_hint', 'Giriniz'),
          obscureText: widget.state.obscurePasswordConfirm,
          onChanged: widget.viewModel.updatePasswordConfirm,
          errorText: widget.state.passwordConfirmError,
          enabled: widget.state.status != SignUpStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              widget.state.obscurePasswordConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.thunder.withOpacity(0.4),
              size: 20,
            ),
            onPressed: widget.viewModel.togglePasswordConfirmVisibility,
          ),
        ),
      ],
    );
  }

  /// ✅ Sign Up Button (Ticimax Style)
  Widget _buildSignUpButton(BuildContext context) {
    final isLoading = widget.state.status == SignUpStatus.loading;
    final isEnabled = widget.state.isValid && !isLoading;

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue('sign_up_button_loading', 'Hesap oluşturuluyor...')
          : _getConfigValue('sign_up_button', 'Devam Et'),
      onPressed: isEnabled ? widget.viewModel.signUp : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.large,
      state: isLoading ? ButtonState.loading : ButtonState.enabled,
      fullWidth: true,
      backgroundColor: Color(0xFF4A6FE8), // Ticimax blue
    );
  }
}
