import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/auth/cubit/auth_cubit.dart';
import 'package:core/src/views/auth/cubit/auth_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🎨 **OSMEA Auth Enterprise Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Enterprise authentication style - Professional card-based design with corporate aesthetics
/// Features: Card layouts, professional typography, corporate color schemes, enterprise styling
///
/// {@category Widgets}
/// {@subCategory AuthEnterprise}

class AuthWidget extends StatelessWidget {
  final VoidCallback? onSignInSuccess;
  final Function(String error)? onSignInError;
  final VoidCallback? onSignUpSuccess;
  final Function(String error)? onSignUpError;
  final VoidCallback? onForgotPasswordTap;
  final Map<String, dynamic>? config;
  final int initialTab;

  const AuthWidget({
    super.key,
    this.onSignInSuccess,
    this.onSignInError,
    this.onSignUpSuccess,
    this.onSignUpError,
    this.onForgotPasswordTap,
    this.config,
    this.initialTab = 0,
  });

  String _getConfigValue(String section, String key, String fallback) {
    // Config is already auth_configuration structure, so we can access it directly
    if (config != null && config!.containsKey(section)) {
      final sectionData = config![section] as Map<String, dynamic>?;
      if (sectionData != null && sectionData.containsKey(key)) {
        return sectionData[key]?.toString() ?? fallback;
      }
    }
    return fallback;
  }

  /// Get enterprise primary color from config
  Color _getEnterprisePrimaryColor() {
    if (config != null && config!.containsKey('ui_style')) {
      final uiStyle = config!['ui_style'] as Map<String, dynamic>?;
      if (uiStyle != null) {
        final primaryColor = uiStyle['primary_color'] as String? ??
            uiStyle['background_color'] as String?;
        if (primaryColor != null) {
          try {
            String colorString = primaryColor;
            if (colorString.startsWith('#')) {
              colorString = colorString.substring(1);
              if (colorString.length == 8) {
                return Color(
                    int.parse('FF${colorString.substring(0, 6)}', radix: 16));
              } else if (colorString.length == 6) {
                return Color(int.parse('FF$colorString', radix: 16));
              }
            }
          } catch (e) {
            debugPrint('⚠️ Invalid primary color: $primaryColor');
          }
        }
      }
    }
    return OsmeaColors.nordicBlue;
  }

  /// Get background color from config
  Color _getBackgroundColor() {
    if (config != null && config!.containsKey('ui_style')) {
      final uiStyle = config!['ui_style'] as Map<String, dynamic>?;
      if (uiStyle != null) {
        final backgroundColor = uiStyle['background_color'] as String?;
        if (backgroundColor != null) {
          try {
            String colorString = backgroundColor;
            if (colorString.startsWith('#')) {
              colorString = colorString.substring(1);
              if (colorString.length == 8) {
                return Color(
                    int.parse('FF${colorString.substring(0, 6)}', radix: 16));
              } else if (colorString.length == 6) {
                return Color(int.parse('FF$colorString', radix: 16));
              }
            }
          } catch (e) {
            debugPrint('⚠️ Invalid background color: $backgroundColor');
          }
        }
      }
    }
    return OsmeaColors.nordicBlue;
  }

  void _switchTab(BuildContext context, int index, AuthCubit cubit) {
    // Always allow tab switching, but show warning if Sign Up is not configured
    if (index == 1 && cubit.signUpCallback == null) {
      debugPrint('⚠️ Sign Up is not configured');
      // Still switch to show the form, but it won't work without callback
    }
    cubit.switchTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // If state is not AuthFormState, show loading
        if (state is! AuthFormState) {
          return OsmeaComponents.container(
            color: OsmeaColors.paperWhite,
            child: OsmeaComponents.center(
              child: OsmeaComponents.loading(
                type: LoadingType.circularFade,
                size: 48.0,
                color: _getEnterprisePrimaryColor(),
              ),
            ),
          );
        }

        final formState = state;
        final currentTab = formState.currentTab;
        final cubit = context.read<AuthCubit>();
        final primaryColor = _getEnterprisePrimaryColor();
        final backgroundColor = _getBackgroundColor();

        // Get config values
        final signInConfig = config?['sign_in'] as Map<String, dynamic>?;
        final logoUrl = signInConfig?['logo_url'] as String?;
        final logoWidth =
            (signInConfig?['logo_width'] as num?)?.toDouble() ?? 120.0;
        final logoHeight =
            (signInConfig?['logo_height'] as num?)?.toDouble() ?? 120.0;
        final appName = _getConfigValue('sign_in', 'app_name', 'OSMEA');

        // UI Style configuration
        final uiStyleConfig = config?['ui_style'] as Map<String, dynamic>?;
        final tabContainerRadius =
            (uiStyleConfig?['tab_container_radius'] as num?)?.toDouble() ??
                context.spacing12;
        final tabItemRadius =
            (uiStyleConfig?['tab_item_radius'] as num?)?.toDouble() ??
                context.spacing10;
        final buttonRadius =
            (uiStyleConfig?['button_radius'] as num?)?.toDouble() ??
                context.spacing12;
        final contentAreaTopRadius =
            (uiStyleConfig?['content_area_top_radius'] as num?)?.toDouble() ??
                context.spacing32;
        final horizontalPadding =
            (uiStyleConfig?['horizontal_padding'] as num?)?.toDouble() ??
                context.spacing24;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: OsmeaComponents.container(
            color: backgroundColor,
            child: SafeArea(
              bottom: false,
              child: OsmeaComponents.column(
                children: [
                  // 📱 Simple header with logo
                  _buildSimpleHeader(
                    context,
                    logoUrl,
                    logoWidth,
                    logoHeight,
                    appName,
                  ),

                  // 📄 Main content area with card layout
                  Expanded(
                    child: _buildCardContent(
                      context,
                      formState,
                      cubit,
                      currentTab,
                      primaryColor,
                      tabContainerRadius,
                      tabItemRadius,
                      buttonRadius,
                      contentAreaTopRadius,
                      horizontalPadding,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// 📱 Simple header section
  Widget _buildSimpleHeader(
    BuildContext context,
    String? logoUrl,
    double logoWidth,
    double logoHeight,
    String appName,
  ) {
    return OsmeaComponents.container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing24,
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo or App Name
          logoUrl != null
              ? OsmeaComponents.image(
                  imageUrl: logoUrl,
                  width: logoWidth,
                  height: logoHeight,
                  fit: BoxFit.contain,
                )
              : OsmeaComponents.text(
                  appName,
                  variant: OsmeaTextVariant.headlineMedium,
                  color: OsmeaColors.white,
                  fontWeight: FontWeight.w700,
                ),
        ],
      ),
    );
  }

  /// 📄 Card-based content area
  Widget _buildCardContent(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    int currentTab,
    Color primaryColor,
    double tabContainerRadius,
    double tabItemRadius,
    double buttonRadius,
    double contentAreaTopRadius,
    double horizontalPadding,
  ) {
    return OsmeaComponents.container(
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(contentAreaTopRadius),
          topRight: Radius.circular(contentAreaTopRadius),
        ),
      ),
      child: OsmeaComponents.column(
        children: [
          // 📑 Simple Tab Bar
          _buildSimpleTabBar(
            context,
            currentTab,
            cubit,
            primaryColor,
            horizontalPadding,
          ),

          // 📋 Content Area
          Expanded(
            child: currentTab == 0
                ? _buildSignInContent(
                    context,
                    formState,
                    cubit,
                    buttonRadius,
                    horizontalPadding,
                    primaryColor,
                  )
                : _buildSignUpContent(
                    context,
                    formState,
                    cubit,
                    buttonRadius,
                    horizontalPadding,
                    primaryColor,
                  ),
          ),
        ],
      ),
    );
  }

  /// 📑 Simple tab bar
  Widget _buildSimpleTabBar(
    BuildContext context,
    int currentTab,
    AuthCubit cubit,
    Color primaryColor,
    double horizontalPadding,
  ) {
    return OsmeaComponents.container(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: context.spacing20,
        bottom: context.spacing16,
      ),
      child: OsmeaComponents.row(
        children: [
          // Sign In Tab
          Expanded(
            child: GestureDetector(
              onTap: () => _switchTab(context, 0, cubit),
              child: OsmeaComponents.container(
                padding: EdgeInsets.symmetric(
                  vertical: context.spacing12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: currentTab == 0
                          ? primaryColor
                          : OsmeaColors.thunder.withOpacity(0.2),
                      width: currentTab == 0 ? 2.0 : 1.0,
                    ),
                  ),
                ),
                child: OsmeaComponents.center(
                  child: OsmeaComponents.text(
                    _getConfigValue('sign_in', 'tab_sign_in', 'Sign In'),
                    variant: OsmeaTextVariant.titleLarge,
                    fontWeight:
                        currentTab == 0 ? FontWeight.w600 : FontWeight.w400,
                    color: currentTab == 0
                        ? primaryColor
                        : OsmeaColors.thunder.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
          // Sign Up Tab - Always show, but may be disabled if callback is not available
          Expanded(
            child: GestureDetector(
              onTap: () => _switchTab(context, 1, cubit),
              child: OsmeaComponents.container(
                padding: EdgeInsets.symmetric(
                  vertical: context.spacing12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: currentTab == 1
                          ? primaryColor
                          : OsmeaColors.thunder.withOpacity(0.2),
                      width: currentTab == 1 ? 2.0 : 1.0,
                    ),
                  ),
                ),
                child: OsmeaComponents.center(
                  child: OsmeaComponents.text(
                    _getConfigValue('sign_up', 'tab_sign_up', 'Sign Up'),
                    variant: OsmeaTextVariant.titleLarge,
                    fontWeight:
                        currentTab == 1 ? FontWeight.w600 : FontWeight.w400,
                    color: cubit.signUpCallback == null
                        ? OsmeaColors.thunder.withOpacity(0.4)
                        : (currentTab == 1
                            ? primaryColor
                            : OsmeaColors.thunder.withOpacity(0.6)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📧 Sign In Content
  Widget _buildSignInContent(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    double buttonRadius,
    double horizontalPadding,
    Color primaryColor,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.sizedBox(height: context.spacing16),
          _buildEmailField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing20),
          _buildPasswordField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing16),
          _buildRememberMeAndForgotPassword(
              context, formState, cubit, primaryColor),
          OsmeaComponents.sizedBox(height: context.spacing48),
          _buildSignInButton(
              context, formState, cubit, buttonRadius, primaryColor),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
      ),
    );
  }

  /// 📝 Sign Up Content
  Widget _buildSignUpContent(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    double buttonRadius,
    double horizontalPadding,
    Color primaryColor,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OsmeaComponents.sizedBox(height: context.spacing16),
          _buildSignUpEmailField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing20),
          _buildSignUpPasswordField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing20),
          _buildSignUpPasswordConfirmField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing20),
          _buildSignUpAuthKeyField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing20),
          _buildSignUpFirstNameField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing20),
          _buildSignUpLastNameField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing24),
          _buildMarketingConsentCheckbox(
              context, formState, cubit, primaryColor),
          OsmeaComponents.sizedBox(height: context.spacing16),
          _buildPrivacyPolicyCheckbox(context, formState, cubit, primaryColor),
          OsmeaComponents.sizedBox(height: context.spacing16),
          _buildTermsCheckbox(context, formState, cubit, primaryColor),
          OsmeaComponents.sizedBox(height: context.spacing32),
          _buildSignUpButton(
              context, formState, cubit, buttonRadius, primaryColor),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
      ),
    );
  }

  // ============================================================================
  // SIGN IN FIELDS
  // ============================================================================

  Widget _buildEmailField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '${_getConfigValue('sign_in', 'email_label', 'Email')} *',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue('sign_in', 'email_hint', 'Enter your email'),
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.updateSignInEmail,
          errorText: state.signInEmailError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
        ),
      ],
    );
  }

  Widget _buildPasswordField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '${_getConfigValue('sign_in', 'password_label', 'Password')} *',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_in', 'password_hint', 'Enter your password'),
          obscureText: state.signInObscurePassword,
          onChanged: cubit.updateSignInPassword,
          errorText: state.signInPasswordError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.signInObscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.thunder.withOpacity(0.4),
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignInPasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword(BuildContext context,
      AuthFormState state, AuthCubit cubit, Color primaryColor) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OsmeaComponents.row(
          children: [
            OsmeaComponents.checkbox(
              value: state.signInRememberMe,
              onChanged: (value) => cubit.toggleRememberMe(),
              activeColor: primaryColor,
              size: CheckboxSize.small,
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            OsmeaComponents.text(
              _getConfigValue('sign_in', 'remember_me_label', 'Remember me'),
              variant: OsmeaTextVariant.bodySmall,
              color: OsmeaColors.thunder,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        if (onForgotPasswordTap != null)
          GestureDetector(
            onTap: onForgotPasswordTap,
            child: OsmeaComponents.text(
              _getConfigValue(
                  'sign_in', 'forgot_password_label', 'Forgot Password?'),
              variant: OsmeaTextVariant.bodySmall,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context, AuthFormState state,
      AuthCubit cubit, double buttonRadius, Color primaryColor) {
    final isLoading = state.operationStatus == AuthOperationStatus.loading;
    final isEnabled = state.isSignInValid && !isLoading;

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_in', 'sign_in_button_loading', 'Signing in...')
          : _getConfigValue('sign_in', 'sign_in_button', 'Continue'),
      onPressed: isEnabled ? cubit.signIn : null,
      variant: ButtonVariant.secondary,
      size: ButtonSize.large,
      state: isLoading ? ButtonState.loading : ButtonState.enabled,
      fullWidth: true,
      backgroundColor: primaryColor,
      textColor: OsmeaColors.white,
      borderRadius: buttonRadius,
    );
  }

  // ============================================================================
  // SIGN UP FIELDS
  // ============================================================================

  Widget _buildSignUpEmailField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '${_getConfigValue('sign_up', 'email_label', 'Email')} *',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue('sign_up', 'email_hint', 'Enter your email'),
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.updateSignUpEmail,
          errorText: state.signUpEmailError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
        ),
      ],
    );
  }

  Widget _buildSignUpPasswordField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '${_getConfigValue('sign_up', 'password_label', 'Password')} *',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_up', 'password_hint', 'Enter your password'),
          obscureText: state.signUpObscurePassword,
          onChanged: cubit.updateSignUpPassword,
          errorText: state.signUpPasswordError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.signUpObscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.thunder.withOpacity(0.4),
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignUpPasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpPasswordConfirmField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '${_getConfigValue('sign_up', 'password_confirm_label', 'Confirm Password')} *',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_up', 'password_confirm_hint', 'Confirm your password'),
          obscureText: state.signUpObscurePasswordConfirm,
          onChanged: cubit.updateSignUpPasswordConfirm,
          errorText: state.signUpPasswordConfirmError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.signUpObscurePasswordConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.thunder.withOpacity(0.4),
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignUpPasswordConfirmVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpAuthKeyField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '${_getConfigValue('sign_up', 'auth_key_label', 'Auth Key')} *',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_up', 'auth_key_hint', 'Enter your auth key'),
          onChanged: cubit.updateSignUpAuthKey,
          errorText: state.signUpAuthKeyError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
        ),
      ],
    );
  }

  Widget _buildSignUpFirstNameField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '${_getConfigValue('sign_up', 'first_name_label', 'First Name')} *',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_up', 'first_name_hint', 'Enter your first name'),
          onChanged: cubit.updateSignUpFirstName,
          errorText: state.signUpFirstNameError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
        ),
      ],
    );
  }

  Widget _buildSignUpLastNameField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          '${_getConfigValue('sign_up', 'last_name_label', 'Last Name')} *',
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          hint: _getConfigValue(
              'sign_up', 'last_name_hint', 'Enter your last name'),
          onChanged: cubit.updateSignUpLastName,
          errorText: state.signUpLastNameError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
        ),
      ],
    );
  }

  /// 📧 Marketing Consent Checkbox
  Widget _buildMarketingConsentCheckbox(BuildContext context,
      AuthFormState state, AuthCubit cubit, Color primaryColor) {
    return OsmeaComponents.row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.checkbox(
          value: state.signUpMarketingConsent,
          onChanged: (value) => cubit.toggleMarketingConsent(),
          activeColor: primaryColor,
          size: CheckboxSize.small,
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
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
  Widget _buildPrivacyPolicyCheckbox(BuildContext context, AuthFormState state,
      AuthCubit cubit, Color primaryColor) {
    return OsmeaComponents.row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.checkbox(
          value: state.signUpPrivacyPolicyAccepted,
          onChanged: (value) => cubit.togglePrivacyPolicy(),
          activeColor: primaryColor,
          size: CheckboxSize.small,
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        Expanded(
          child: OsmeaComponents.text(
            '${_getConfigValue('sign_up', 'privacy_policy_label', 'I have read and accept the Privacy Policy')} *',
            variant: OsmeaTextVariant.bodySmall,
            color: OsmeaColors.thunder,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  /// 📜 Terms of Service Checkbox
  Widget _buildTermsCheckbox(BuildContext context, AuthFormState state,
      AuthCubit cubit, Color primaryColor) {
    return OsmeaComponents.row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.checkbox(
          value: state.signUpTermsAccepted,
          onChanged: (value) => cubit.toggleTerms(),
          activeColor: primaryColor,
          size: CheckboxSize.small,
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        Expanded(
          child: OsmeaComponents.text(
            '${_getConfigValue('sign_up', 'terms_label', 'I have read and accept the Terms of Service')} *',
            variant: OsmeaTextVariant.bodySmall,
            color: OsmeaColors.thunder,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context, AuthFormState state,
      AuthCubit cubit, double buttonRadius, Color primaryColor) {
    final isLoading = state.operationStatus == AuthOperationStatus.loading;
    final isEnabled =
        state.isSignUpValid && !isLoading && cubit.signUpCallback != null;

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_up', 'sign_up_button_loading', 'Creating account...')
          : _getConfigValue('sign_up', 'sign_up_button', 'Create Account'),
      onPressed: isEnabled ? cubit.signUp : null,
      variant: ButtonVariant.secondary,
      size: ButtonSize.large,
      state: isLoading
          ? ButtonState.loading
          : (cubit.signUpCallback == null
              ? ButtonState.disabled
              : ButtonState.enabled),
      fullWidth: true,
      backgroundColor: primaryColor,
      textColor: OsmeaColors.white,
      borderRadius: buttonRadius,
    );
  }
}
