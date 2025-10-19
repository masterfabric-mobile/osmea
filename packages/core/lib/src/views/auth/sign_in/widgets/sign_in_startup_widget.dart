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

  /// 🎨 Gradient Header with Tabs
  Widget _buildGradientHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35, // 35% of screen
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            OsmeaColors.nordicBlue,
            OsmeaColors.nordicBlue.withOpacity(0.8),
            OsmeaColors.nordicBlue.withOpacity(0.9),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🎨 Logo Area
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(context.spacing20),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.store,
                    size: 80,
                    color: OsmeaColors.white,
                  ),
                ),
              ),
            ),

            // 📑 Tabs Container
            Container(
              margin: EdgeInsets.symmetric(horizontal: context.spacing24),
              padding: EdgeInsets.all(context.spacing4),
              decoration: BoxDecoration(
                color: OsmeaColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.spacing16),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: OsmeaColors.white,
                  borderRadius: BorderRadius.circular(context.spacing12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: OsmeaColors.nordicBlue,
                unselectedLabelColor: OsmeaColors.white.withOpacity(0.8),
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Giriş Yap'),
                  Tab(text: 'Kayıt Ol'),
                ],
                onTap: (index) {
                  if (index == 1 && widget.onSignUpTap != null) {
                    widget.onSignUpTap!();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 📧 Email Field
  Widget _buildEmailField(BuildContext context) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          'E-Posta',
          variant: OsmeaTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: OsmeaColors.thunder,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: 'Giriniz',
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
          'Şifre',
          variant: OsmeaTextVariant.bodyMedium,
          fontWeight: FontWeight.w600,
          color: OsmeaColors.thunder,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: 'Giriniz',
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
            OsmeaComponents.checkbox(
              value: widget.state.rememberMe,
              onChanged: (value) => widget.viewModel.toggleRememberMe(),
              activeColor: OsmeaColors.nordicBlue,
              size: CheckboxSize.small,
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            OsmeaComponents.text(
              'Beni Hatırla',
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
              'Şifremi Unuttum',
              variant: OsmeaTextVariant.bodyMedium,
              color: OsmeaColors.nordicBlue,
              fontWeight: FontWeight.w500,
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
      text: isLoading ? 'Giriş Yapılıyor...' : 'Devam Et',
      onPressed: isEnabled ? widget.viewModel.signIn : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.large,
      state: isLoading ? ButtonState.loading : ButtonState.enabled,
      fullWidth: true,
      backgroundColor: OsmeaColors.nordicBlue,
    );
  }
}
