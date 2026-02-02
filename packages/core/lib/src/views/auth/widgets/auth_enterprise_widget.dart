import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/auth/cubit/auth_cubit.dart';
import 'package:core/src/views/auth/cubit/auth_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// Helper class for match info
class _MatchInfo {
  final int start;
  final int end;
  final String type;

  _MatchInfo(this.start, this.end, this.type);
}

/// 🏢 **OSMEA Auth Enterprise Widget**
///
/// Professional card-based design with corporate aesthetics
/// Tab-based navigation with Sign In and Sign Up forms
///
/// {@category Widgets}
/// {@subCategory AuthEnterprise}
class AuthEnterpriseWidget extends StatelessWidget {
  final VoidCallback? onSignInSuccess;
  final Function(String error)? onSignInError;
  final VoidCallback? onSignUpSuccess;
  final Function(String error)? onSignUpError;
  final VoidCallback? onForgotPasswordTap;
  final Map<String, dynamic>? config;
  final int initialTab;

  const AuthEnterpriseWidget({
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
    if (config != null && config!.containsKey(section)) {
      final sectionData = config![section] as Map<String, dynamic>?;
      if (sectionData != null && sectionData.containsKey(key)) {
        return sectionData[key]?.toString() ?? fallback;
      }
    }
    return fallback;
  }

  /// Get bool from config (handles string "true"/"false" from JSON/WordPress).
  bool _getConfigBool(String section, String key, bool fallback) {
    if (config == null || !config!.containsKey(section)) return fallback;
    final sectionData = config![section] as Map<String, dynamic>?;
    if (sectionData == null || !sectionData.containsKey(key)) return fallback;
    final v = sectionData[key];
    if (v == null) return fallback;
    if (v is bool) return v;
    if (v is String) return v.toLowerCase().trim() == 'true' || v == '1';
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

  /// Get button color from config
  Color _getButtonColor(
      String buttonType, String colorType, Color defaultColor) {
    if (config != null && config!.containsKey('buttons')) {
      final buttonsConfig = config!['buttons'] as Map<String, dynamic>?;
      if (buttonsConfig != null && buttonsConfig.containsKey(buttonType)) {
        final buttonConfig = buttonsConfig[buttonType] as Map<String, dynamic>?;
        if (buttonConfig != null && buttonConfig.containsKey(colorType)) {
          final colorString = buttonConfig[colorType] as String?;
          if (colorString != null) {
            try {
              String hex = colorString;
              if (hex.startsWith('#')) {
                hex = hex.substring(1);
                if (hex.length == 8) {
                  return Color(
                      int.parse('FF${hex.substring(0, 6)}', radix: 16));
                } else if (hex.length == 6) {
                  return Color(int.parse('FF$hex', radix: 16));
                }
              }
            } catch (e) {
              debugPrint('⚠️ Invalid button color: $colorString');
            }
          }
        }
      }
    }
    return defaultColor;
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
    if (index == 1 && cubit.signUpCallback == null) {
      debugPrint('⚠️ Sign Up is not configured');
    }
    cubit.switchTab(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
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
                  _buildSimpleHeader(
                    context,
                    logoUrl,
                    logoWidth,
                    logoHeight,
                    appName,
                  ),
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
          _buildSimpleTabBar(
            context,
            currentTab,
            cubit,
            primaryColor,
            horizontalPadding,
          ),
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

  /// 📑 OSMEA Tab Bar
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
      child: OsmeaComponents.tabBar(
        tabs: [
          TabItem(
            text: _getConfigValue('sign_in', 'tab_sign_in', 'Sign In'),
            state: currentTab == 0 ? TabState.active : TabState.inactive,
          ),
          TabItem(
            text: _getConfigValue('sign_up', 'tab_sign_up', 'Sign Up'),
            state: currentTab == 1 ? TabState.active : TabState.inactive,
          ),
        ],
        variant: TabBarVariant.secondary,
        size: TabBarSize.large,
        indicatorStyle: TabBarIndicatorStyle.fill,
        currentIndex: currentTab,
        onTabTap: (index) => _switchTab(context, index, cubit),
        backgroundColor: OsmeaColors.ash,
        activeFillColor: OsmeaColors.snow,
        activeTextColor: OsmeaColors.black,
        inactiveTextColor: OsmeaColors.thunder,
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
          _buildSignUpFirstNameField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing20),
          _buildSignUpLastNameField(context, formState, cubit),
          OsmeaComponents.sizedBox(height: context.spacing24),
          ..._buildDynamicChecklists(context, formState, cubit, primaryColor),
          _buildPaymentAgreementCheckbox(
              context, formState, cubit, primaryColor),
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
    final controller = TextEditingController(text: state.signInEmail);

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
          key: const Key('sign_in_email_field'),
          controller: controller,
          hint: _getConfigValue('sign_in', 'email_hint', 'Enter your email'),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            cubit.updateSignInEmail(value);
          },
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
          key: const Key('sign_in_password_field'),
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
              color: OsmeaColors.silver,
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
              activeColor: OsmeaColors.black,
              size: CheckboxSize.small,
            ),
            OsmeaComponents.sizedBox(width: context.spacing8),
            OsmeaComponents.text(
              _getConfigValue('sign_in', 'remember_me_label', 'Remember me'),
              variant: OsmeaTextVariant.bodySmall,
              color: OsmeaColors.black,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
        if (onForgotPasswordTap != null &&
            _getConfigBool('sign_in', 'show_forgot_password', true))
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

    final buttonBgColor =
        _getButtonColor('sign_in', 'backgroundColor', primaryColor);
    final buttonTextColor =
        _getButtonColor('sign_in', 'textColor', OsmeaColors.white);
    final disabledBgColor = _getButtonColor(
        'sign_in',
        'disabledBackgroundColor',
        OsmeaColors.grayMaterial[400] ?? OsmeaColors.pewter);
    final disabledTextColor =
        _getButtonColor('sign_in', 'disabledTextColor', OsmeaColors.white);

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_in', 'sign_in_button_loading', 'Signing in...')
          : _getConfigValue('sign_in', 'sign_in_button', 'Continue'),
      onPressed: isEnabled ? cubit.signIn : null,
      variant: ButtonVariant.secondary,
      size: ButtonSize.large,
      state: isLoading
          ? ButtonState.loading
          : (isEnabled ? ButtonState.enabled : ButtonState.disabled),
      fullWidth: true,
      backgroundColor: buttonBgColor,
      textColor: buttonTextColor,
      disabledBackgroundColor: disabledBgColor,
      disabledTextColor: disabledTextColor,
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
          key: const Key('sign_up_email_field'),
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
          key: const Key('sign_up_password_field'),
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
              color: OsmeaColors.silver,
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
          key: const Key('sign_up_password_confirm_field'),
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
              color: OsmeaColors.silver,
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignUpPasswordConfirmVisibility,
          ),
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
          key: const Key('sign_up_first_name_field'),
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
          key: const Key('sign_up_last_name_field'),
          hint: _getConfigValue(
              'sign_up', 'last_name_hint', 'Enter your last name'),
          onChanged: cubit.updateSignUpLastName,
          errorText: state.signUpLastNameError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
        ),
      ],
    );
  }

  /// 📋 Build dynamic checklists from config
  List<Widget> _buildDynamicChecklists(BuildContext context,
      AuthFormState state, AuthCubit cubit, Color primaryColor) {
    final List<Widget> checklistWidgets = [];

    try {
      final signUpConfig = config?['sign_up'] as Map<String, dynamic>?;
      final checklists = signUpConfig?['checklists'] as List<dynamic>?;

      if (checklists != null && checklists.isNotEmpty) {
        for (int i = 0; i < checklists.length; i++) {
          final checklist = checklists[i] as Map<String, dynamic>;
          final id = checklist['id'] as String?;
          final label = checklist['label'] as String?;
          final required = checklist['required'] as bool? ?? false;
          final enabled = checklist['enabled'] as bool? ?? true;

          if (id != null && label != null && enabled) {
            final isChecked = state.signUpChecklists[id] ?? false;
            final displayLabel = required ? '$label *' : label;

            checklistWidgets.add(
              OsmeaComponents.row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OsmeaComponents.checkbox(
                    value: isChecked,
                    onChanged: (value) => cubit.toggleChecklist(id),
                    activeColor: OsmeaColors.black,
                    size: CheckboxSize.small,
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing8),
                  Expanded(
                    child: OsmeaComponents.text(
                      displayLabel,
                      variant: OsmeaTextVariant.bodySmall,
                      color: OsmeaColors.thunder,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );

            if (i < checklists.length - 1) {
              checklistWidgets
                  .add(OsmeaComponents.sizedBox(height: context.spacing16));
            }
          }
        }
      }
    } catch (e) {
      debugPrint('⚠️ Error building dynamic checklists: $e');
    }

    return checklistWidgets;
  }

  /// 📋 Build payment agreement checkbox
  Widget _buildPaymentAgreementCheckbox(
    BuildContext context,
    AuthFormState state,
    AuthCubit cubit,
    Color primaryColor,
  ) {
    try {
      final signUpConfig = config?['sign_up'] as Map<String, dynamic>?;
      final paymentAgreements =
          signUpConfig?['payment_agreements'] as Map<String, dynamic>?;

      if (paymentAgreements == null) {
        return const SizedBox.shrink();
      }

      final checkboxText = paymentAgreements['checkbox_text'] as String?;
      if (checkboxText == null || checkboxText.isEmpty) {
        return const SizedBox.shrink();
      }

      final linkColorString =
          paymentAgreements['checkbox_link_color'] as String? ?? '#FF6B00';
      Color linkColor;
      try {
        String hex = linkColorString.startsWith('#')
            ? linkColorString.substring(1)
            : linkColorString;
        if (hex.length == 6) {
          linkColor = Color(int.parse('FF$hex', radix: 16));
        } else if (hex.length == 8) {
          linkColor = Color(int.parse(hex, radix: 16));
        } else {
          linkColor = const Color(0xFFFF6B00);
        }
      } catch (e) {
        linkColor = const Color(0xFFFF6B00);
      }

      final preliminaryTitle = paymentAgreements['preliminary_information_form']
              ?['title'] as String? ??
          'Preliminary Information Form';
      final preliminaryContent =
          paymentAgreements['preliminary_information_form']?['content']
                  as String? ??
              '';
      final distanceSalesTitle =
          paymentAgreements['distance_sales_agreement']?['title'] as String? ??
              'Distance Sales Agreement';
      final distanceSalesContent = paymentAgreements['distance_sales_agreement']
              ?['content'] as String? ??
          '';

      final isChecked = state.signUpChecklists['payment_agreement'] ?? false;

      return OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.sizedBox(height: context.spacing16),
          GestureDetector(
            onTap: () {
              cubit.toggleChecklist('payment_agreement');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.85,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      cubit.toggleChecklist('payment_agreement');
                    },
                    activeColor: linkColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                SizedBox(width: context.spacing4),
                Expanded(
                  child: _buildCheckboxTextWithLinks(
                    context,
                    checkboxText,
                    linkColor,
                    preliminaryTitle,
                    distanceSalesTitle,
                    preliminaryContent,
                    distanceSalesContent,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } catch (e) {
      debugPrint('⚠️ Error building payment agreement checkbox: $e');
      return const SizedBox.shrink();
    }
  }

  /// 📝 Build checkbox text with clickable links
  Widget _buildCheckboxTextWithLinks(
    BuildContext context,
    String text,
    Color linkColor,
    String preliminaryTitle,
    String distanceSalesTitle,
    String preliminaryContent,
    String distanceSalesContent,
  ) {
    final spans = <TextSpan>[];
    final preliminaryPattern = RegExp(
        r'(?:the\s+)?Preliminary Information Form',
        caseSensitive: false);
    final distanceSalesPattern =
        RegExp(r'(?:the\s+)?Distance Sales Agreement', caseSensitive: false);

    int lastIndex = 0;

    final allMatches = <_MatchInfo>[];
    for (final match in preliminaryPattern.allMatches(text)) {
      allMatches.add(_MatchInfo(match.start, match.end, 'preliminary'));
    }
    for (final match in distanceSalesPattern.allMatches(text)) {
      allMatches.add(_MatchInfo(match.start, match.end, 'distance'));
    }

    allMatches.sort((a, b) => a.start.compareTo(b.start));

    for (final match in allMatches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: OsmeaTextStyle.bodySmall(context).copyWith(
            color: OsmeaColors.black,
          ),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: OsmeaTextStyle.bodySmall(context).copyWith(
          color: linkColor,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showAgreementDialog(
              context,
              match.type == 'preliminary'
                  ? preliminaryTitle
                  : distanceSalesTitle,
              match.type == 'preliminary'
                  ? preliminaryContent
                  : distanceSalesContent,
            );
          },
      ));

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: OsmeaTextStyle.bodySmall(context).copyWith(
          color: OsmeaColors.black,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
    );
  }

  /// 📄 Show agreement dialog
  void _showAgreementDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: OsmeaTextStyle.titleLarge(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: OsmeaTextStyle.bodyMedium(context).copyWith(
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, AuthFormState state,
      AuthCubit cubit, double buttonRadius, Color primaryColor) {
    final isLoading = state.operationStatus == AuthOperationStatus.loading;
    final isPaymentAgreementChecked = _isPaymentAgreementChecked(state);
    final isEnabled =
        !isLoading && cubit.signUpCallback != null && isPaymentAgreementChecked;

    final buttonBgColor =
        _getButtonColor('sign_up', 'backgroundColor', primaryColor);
    final buttonTextColor =
        _getButtonColor('sign_up', 'textColor', OsmeaColors.white);
    final disabledBgColor = _getButtonColor(
        'sign_up',
        'disabledBackgroundColor',
        OsmeaColors.grayMaterial[400] ?? OsmeaColors.pewter);
    final disabledTextColor =
        _getButtonColor('sign_up', 'disabledTextColor', OsmeaColors.white);

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
          : (cubit.signUpCallback == null || !isPaymentAgreementChecked
              ? ButtonState.disabled
              : ButtonState.enabled),
      fullWidth: true,
      backgroundColor: buttonBgColor,
      textColor: buttonTextColor,
      disabledBackgroundColor: disabledBgColor,
      disabledTextColor: disabledTextColor,
      borderRadius: buttonRadius,
    );
  }

  /// Check if payment agreement checkbox is checked
  bool _isPaymentAgreementChecked(AuthFormState state) {
    try {
      final signUpConfig = config?['sign_up'] as Map<String, dynamic>?;
      final paymentAgreements =
          signUpConfig?['payment_agreements'] as Map<String, dynamic>?;

      if (paymentAgreements != null) {
        final checkboxText = paymentAgreements['checkbox_text'] as String?;
        if (checkboxText != null && checkboxText.isNotEmpty) {
          return state.signUpChecklists['payment_agreement'] ?? false;
        }
      }
      return true;
    } catch (e) {
      debugPrint('⚠️ Error checking payment agreement: $e');
      return false;
    }
  }
}
