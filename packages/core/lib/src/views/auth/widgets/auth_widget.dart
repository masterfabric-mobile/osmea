import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/auth/cubit/auth_cubit.dart';
import 'package:core/src/views/auth/cubit/auth_state.dart';
import 'package:core/src/views/auth/enums/auth_design_variant.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🎨 **OSMEA Auth Widget**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Multi-variant authentication widget supporting:
/// - Enterprise: Professional card-based design with corporate aesthetics
/// - Startup: Modern, clean e-commerce design
///
/// {@category Widgets}
/// {@subCategory Auth}

class AuthWidget extends StatelessWidget {
  final VoidCallback? onSignInSuccess;
  final Function(String error)? onSignInError;
  final VoidCallback? onSignUpSuccess;
  final Function(String error)? onSignUpError;
  final VoidCallback? onForgotPasswordTap;
  final Map<String, dynamic>? config;
  final int initialTab;
  final AuthDesignVariant designVariant;

  const AuthWidget({
    super.key,
    this.onSignInSuccess,
    this.onSignInError,
    this.onSignUpSuccess,
    this.onSignUpError,
    this.onForgotPasswordTap,
    this.config,
    this.initialTab = 0,
    this.designVariant = AuthDesignVariant.enterprise,
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

  /// Get button color from config
  Color _getButtonColor(String buttonType, String colorType, Color defaultColor) {
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
                  return Color(int.parse('FF${hex.substring(0, 6)}', radix: 16));
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

  /// Get text link color from config
  Color _getTextLinkColor(String linkType, Color defaultColor) {
    if (config != null && config!.containsKey('text_links')) {
      final textLinksConfig = config!['text_links'] as Map<String, dynamic>?;
      if (textLinksConfig != null && textLinksConfig.containsKey(linkType)) {
        final linkConfig = textLinksConfig[linkType] as Map<String, dynamic>?;
        if (linkConfig != null && linkConfig.containsKey('color')) {
          final colorString = linkConfig['color'] as String?;
          if (colorString != null) {
            try {
              String hex = colorString;
              if (hex.startsWith('#')) {
                hex = hex.substring(1);
                if (hex.length == 8) {
                  return Color(int.parse('FF${hex.substring(0, 6)}', radix: 16));
                } else if (hex.length == 6) {
                  return Color(int.parse('FF$hex', radix: 16));
                }
              }
            } catch (e) {
              debugPrint('⚠️ Invalid text link color: $colorString');
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

        // Build variant-specific design
        switch (designVariant) {
          case AuthDesignVariant.startup:
            return _buildStartupDesign(
              context,
              formState,
              cubit,
              currentTab,
              primaryColor,
              backgroundColor,
              logoUrl,
              logoWidth,
              logoHeight,
              appName,
              buttonRadius,
              horizontalPadding,
            );
          case AuthDesignVariant.space:
            return _buildSpaceDesign(
              context,
              formState,
              cubit,
              currentTab,
              primaryColor,
              backgroundColor,
              logoUrl,
              logoWidth,
              logoHeight,
              appName,
              buttonRadius,
              horizontalPadding,
            );
          case AuthDesignVariant.enterprise:
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
        }
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
          // Dynamic checklists from config
          ..._buildDynamicChecklists(context, formState, cubit, primaryColor),
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
    // Create controller with initial value if email is not empty
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

    // Get button colors from config
    final buttonBgColor = _getButtonColor('sign_in', 'backgroundColor', primaryColor);
    final buttonTextColor = _getButtonColor('sign_in', 'textColor', OsmeaColors.white);
    final disabledBgColor = _getButtonColor('sign_in', 'disabledBackgroundColor', OsmeaColors.grayMaterial[400] ?? OsmeaColors.pewter);
    final disabledTextColor = _getButtonColor('sign_in', 'disabledTextColor', OsmeaColors.white);

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_in', 'sign_in_button_loading', 'Signing in...')
          : _getConfigValue('sign_in', 'sign_in_button', 'Continue'),
      onPressed: isEnabled ? cubit.signIn : null,
      variant: ButtonVariant.secondary,
      size: ButtonSize.large,
      state: isLoading ? ButtonState.loading : (isEnabled ? ButtonState.enabled : ButtonState.disabled),
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

            // Add spacing between checklists (except for the last one)
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

  Widget _buildSignUpButton(BuildContext context, AuthFormState state,
      AuthCubit cubit, double buttonRadius, Color primaryColor) {
    final isLoading = state.operationStatus == AuthOperationStatus.loading;
    final isEnabled = !isLoading && cubit.signUpCallback != null;
    
    // Get button colors from config
    final buttonBgColor = _getButtonColor('sign_up', 'backgroundColor', primaryColor);
    final buttonTextColor = _getButtonColor('sign_up', 'textColor', OsmeaColors.white);
    final disabledBgColor = _getButtonColor('sign_up', 'disabledBackgroundColor', OsmeaColors.grayMaterial[400] ?? OsmeaColors.pewter);
    final disabledTextColor = _getButtonColor('sign_up', 'disabledTextColor', OsmeaColors.white);

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
      backgroundColor: buttonBgColor,
      textColor: buttonTextColor,
      disabledBackgroundColor: disabledBgColor,
      disabledTextColor: disabledTextColor,
      borderRadius: buttonRadius,
    );
  }

  // ============================================================================
  // SPACE DESIGN VARIANT
  // ============================================================================

  /// 🚀 Space Design - Bold, minimalist black and white design
  Widget _buildSpaceDesign(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    int currentTab,
    Color primaryColor,
    Color backgroundColor,
    String? logoUrl,
    double logoWidth,
    double logoHeight,
    String appName,
    double buttonRadius,
    double horizontalPadding,
  ) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: OsmeaComponents.container(
        color: OsmeaColors.thunder, // Black background
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: context.highValue*1.65,
                ),
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Form Content (White Card)
                    Container(
                      decoration: BoxDecoration(
                        color: OsmeaColors.white,
                        borderRadius: BorderRadius.circular(buttonRadius),
                      ),
                      padding: EdgeInsets.all(horizontalPadding),
                      child: currentTab == 0
                          ? _buildSpaceSignInContent(
                              context, formState, cubit, buttonRadius)
                          : _buildSpaceSignUpContent(
                              context, formState, cubit, buttonRadius),
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📧 Space Sign In Content
  Widget _buildSpaceSignInContent(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    double buttonRadius,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSpaceEmailField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildSpacePasswordField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing20),
        _buildSpaceRememberMe(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing32),
        _buildSpaceSignInButton(context, formState, cubit, buttonRadius),
        OsmeaComponents.sizedBox(height: context.spacing16),
        if (onForgotPasswordTap != null)
          _buildSpaceForgotPasswordButton(context, buttonRadius),
        if (cubit.signUpCallback != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing24),
          _buildSpaceSignUpLink(context, cubit),
        ],
      ],
    );
  }

  /// 📝 Space Sign Up Content
  Widget _buildSpaceSignUpContent(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    double buttonRadius,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSpaceSignUpEmailField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildSpaceSignUpPasswordField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildSpaceSignUpPasswordConfirmField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildSpaceSignUpFirstNameField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildSpaceSignUpLastNameField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing32),
        ..._buildDynamicChecklists(context, formState, cubit, OsmeaColors.thunder),
        OsmeaComponents.sizedBox(height: context.spacing32),
        _buildSpaceSignUpButton(context, formState, cubit, buttonRadius),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildSpaceSignInLink(context, cubit),
      ],
    );
  }

  // ============================================================================
  // SPACE VARIANT FIELD BUILDERS
  // ============================================================================

  Widget _buildSpaceEmailField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    // Create controller with initial value if email is not empty
    final controller = TextEditingController(text: state.signInEmail);
    
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_in', 'email_label', 'Email'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
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
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: OsmeaColors.slate,
            size: context.iconSizeSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildSpacePasswordField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_in', 'password_label', 'Password'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
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
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: OsmeaColors.slate,
            size: context.iconSizeSmall,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              state.signInObscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.slate,
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignInPasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildSpaceRememberMe(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.start,
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
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildSpaceSignInButton(BuildContext context, AuthFormState state,
      AuthCubit cubit, double buttonRadius) {
    final isLoading = state.operationStatus == AuthOperationStatus.loading;
    final isEnabled = state.isSignInValid && !isLoading;

    // Get button colors from config
    final buttonBgColor = _getButtonColor('sign_in', 'backgroundColor', OsmeaColors.thunder);
    final buttonTextColor = _getButtonColor('sign_in', 'textColor', OsmeaColors.white);
    final disabledBgColor = _getButtonColor('sign_in', 'disabledBackgroundColor', OsmeaColors.grayMaterial[400] ?? OsmeaColors.pewter);
    final disabledTextColor = _getButtonColor('sign_in', 'disabledTextColor', OsmeaColors.white);

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_in', 'sign_in_button_loading', 'Signing in...')
          : _getConfigValue('sign_in', 'sign_in_button', 'Continue'),
      onPressed: isEnabled ? cubit.signIn : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.medium,
      state: isLoading ? ButtonState.loading : (isEnabled ? ButtonState.enabled : ButtonState.disabled),
      fullWidth: true,
      backgroundColor: buttonBgColor,
      textColor: buttonTextColor,
      disabledBackgroundColor: disabledBgColor,
      disabledTextColor: disabledTextColor,
      borderRadius: buttonRadius,
    );
  }

  Widget _buildSpaceForgotPasswordButton(
      BuildContext context, double buttonRadius) {
    return OsmeaComponents.button(
      text: _getConfigValue(
          'sign_in', 'forgot_password_label', 'Forgot Password?'),
      onPressed: onForgotPasswordTap,
      variant: ButtonVariant.ghost,
      size: ButtonSize.medium,
      fullWidth: true,
      textColor: OsmeaColors.thunder,
      borderRadius: buttonRadius,
    );
  }

  Widget _buildSpaceSignUpLink(BuildContext context, AuthCubit cubit) {
    final linkColor = _getTextLinkColor('sign_up_link', OsmeaColors.thunder);
    
    return OsmeaComponents.center(
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.text(
            'Don\'t have an account? ',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.pewter,
          ),
          GestureDetector(
            onTap: () => _switchTab(context, 1, cubit),
            child: OsmeaComponents.text(
              'Sign Up',
              variant: OsmeaTextVariant.bodyMedium,
              color: linkColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceSignUpEmailField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'email_label', 'Email'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          key: const Key('sign_up_email_field'),
          hint: _getConfigValue('sign_up', 'email_hint', 'Enter your email'),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            cubit.updateSignUpEmail(value);
          },
          errorText: state.signUpEmailError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: OsmeaColors.slate,
            size: context.iconSizeSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildSpaceSignUpPasswordField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'password_label', 'Password'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
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
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: OsmeaColors.slate,
            size: context.iconSizeSmall,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              state.signUpObscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.slate,
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignUpPasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildSpaceSignUpPasswordConfirmField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'password_confirm_label', 'Confirm Password'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          key: const Key('sign_up_password_confirm_field'),
          hint: _getConfigValue('sign_up', 'password_confirm_hint',
              'Confirm your password'),
          obscureText: state.signUpObscurePasswordConfirm,
          onChanged: cubit.updateSignUpPasswordConfirm,
          errorText: state.signUpPasswordConfirmError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: OsmeaColors.slate,
            size: context.iconSizeSmall,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              state.signUpObscurePasswordConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.slate,
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignUpPasswordConfirmVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildSpaceSignUpFirstNameField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'first_name_label', 'First Name'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          key: const Key('sign_up_first_name_field'),
          hint: _getConfigValue('sign_up', 'first_name_hint', 'Enter your first name'),
          onChanged: cubit.updateSignUpFirstName,
          errorText: state.signUpFirstNameError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          prefixIcon: Icon(
            Icons.person_outline,
            color: OsmeaColors.slate,
            size: context.iconSizeSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildSpaceSignUpLastNameField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'last_name_label', 'Last Name'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          key: const Key('sign_up_last_name_field'),
          hint: _getConfigValue('sign_up', 'last_name_hint', 'Enter your last name'),
          onChanged: cubit.updateSignUpLastName,
          errorText: state.signUpLastNameError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          prefixIcon: Icon(
            Icons.person_outline,
            color: OsmeaColors.slate,
            size: context.iconSizeSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildSpaceSignUpButton(BuildContext context, AuthFormState state,
      AuthCubit cubit, double buttonRadius) {
    final isLoading = state.operationStatus == AuthOperationStatus.loading;
    final isEnabled = !isLoading && cubit.signUpCallback != null;

    // Get button colors from config
    final buttonBgColor = _getButtonColor('sign_up', 'backgroundColor', OsmeaColors.thunder);
    final buttonTextColor = _getButtonColor('sign_up', 'textColor', OsmeaColors.white);
    final disabledBgColor = _getButtonColor('sign_up', 'disabledBackgroundColor', OsmeaColors.grayMaterial[400] ?? OsmeaColors.pewter);
    final disabledTextColor = _getButtonColor('sign_up', 'disabledTextColor', OsmeaColors.white);

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_up', 'sign_up_button_loading', 'Creating account...')
          : _getConfigValue('sign_up', 'sign_up_button', 'Create Account'),
      onPressed: isEnabled ? cubit.signUp : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.medium,
      state: isLoading
          ? ButtonState.loading
          : (cubit.signUpCallback == null
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

  Widget _buildSpaceSignInLink(BuildContext context, AuthCubit cubit) {
    final linkColor = _getTextLinkColor('sign_in_link', OsmeaColors.thunder);
    
    return OsmeaComponents.center(
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.text(
            'Already have an account? ',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.pewter,
          ),
          GestureDetector(
            onTap: () => _switchTab(context, 0, cubit),
            child: OsmeaComponents.text(
              'Sign In',
              variant: OsmeaTextVariant.bodyMedium,
              color: linkColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // STARTUP DESIGN VARIANT
  // ============================================================================

  /// ⚡ Startup Design - Modern, clean e-commerce design
  Widget _buildStartupDesign(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    int currentTab,
    Color primaryColor,
    Color backgroundColor,
    String? logoUrl,
    double logoWidth,
    double logoHeight,
    String appName,
    double buttonRadius,
    double horizontalPadding,
  ) {
    // Use orange color for startup variant
    final startupPrimaryColor = OsmeaColors.sunsetGlow;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: OsmeaComponents.container(
        color: OsmeaColors.white,
        child: SafeArea(
          top: false, // Remove top safe area padding
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  top: context.spacing64, // Top padding for title
                ),
                child: OsmeaComponents.column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    _buildStartupTitle(context, currentTab),
                OsmeaComponents.sizedBox(height: context.spacing64),
                // Form Content
                currentTab == 0
                    ? _buildStartupSignInContent(
                        context, formState, cubit, buttonRadius, startupPrimaryColor)
                    : _buildStartupSignUpContent(
                        context, formState, cubit, buttonRadius, startupPrimaryColor),
                OsmeaComponents.sizedBox(height: context.spacing32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📝 Startup Title
  Widget _buildStartupTitle(BuildContext context, int currentTab) {
    final title = currentTab == 0
        ? _getConfigValue('sign_in', 'title', 'Sign In to Your Account')
        : _getConfigValue('sign_up', 'title', 'Create Your Account');
    
    return OsmeaComponents.text(
      title,
      variant: OsmeaTextVariant.headlineSmall,
      color: OsmeaColors.thunder,
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.center,
    );
  }


  /// 📧 Startup Sign In Content
  Widget _buildStartupSignInContent(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    double buttonRadius,
    Color primaryColor,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStartupEmailField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildStartupPasswordField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing20),
        _buildStartupRememberMe(context, formState, cubit, primaryColor),
        OsmeaComponents.sizedBox(height: context.spacing32),
        _buildStartupSignInButton(
            context, formState, cubit, buttonRadius, primaryColor),
        OsmeaComponents.sizedBox(height: context.spacing16),
        if (onForgotPasswordTap != null)
          _buildStartupForgotPasswordButton(
              context, primaryColor, buttonRadius),
        // Sign Up link
        if (cubit.signUpCallback != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing24),
          _buildStartupSignUpLink(context, cubit),
        ],
      ],
    );
  }

  /// 📝 Startup Sign Up Content
  Widget _buildStartupSignUpContent(
    BuildContext context,
    AuthFormState formState,
    AuthCubit cubit,
    double buttonRadius,
    Color primaryColor,
  ) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStartupSignUpEmailField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildStartupSignUpPasswordField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildStartupSignUpPasswordConfirmField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildStartupSignUpFirstNameField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildStartupSignUpLastNameField(context, formState, cubit),
        OsmeaComponents.sizedBox(height: context.spacing32),
        ..._buildDynamicChecklists(context, formState, cubit, primaryColor),
        OsmeaComponents.sizedBox(height: context.spacing32),
        _buildStartupSignUpButton(
            context, formState, cubit, buttonRadius, primaryColor),
        OsmeaComponents.sizedBox(height: context.spacing24),
        _buildStartupSignInLink(context, cubit),
      ],
    );
  }

  /// 🔗 Startup Sign In Link (for Sign Up page)
  Widget _buildStartupSignInLink(BuildContext context, AuthCubit cubit) {
    final linkColor = _getTextLinkColor('sign_in_link', OsmeaColors.black);
    
    return OsmeaComponents.center(
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.text(
            'Already have an account? ',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.pewter,
          ),
          GestureDetector(
            onTap: () => _switchTab(context, 0, cubit),
            child: OsmeaComponents.text(
              'Sign In',
              variant: OsmeaTextVariant.bodyMedium,
              color: linkColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // STARTUP VARIANT FIELD BUILDERS
  // ============================================================================

  Widget _buildStartupEmailField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    // Create controller with initial value if email is not empty
    final controller = TextEditingController(text: state.signInEmail);
    
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_in', 'email_label', 'Email'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
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
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
        ),
      ],
    );
  }

  Widget _buildStartupPasswordField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_in', 'password_label', 'Password'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
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
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          suffixIcon: IconButton(
            icon: Icon(
              state.signInObscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.slate,
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignInPasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildStartupRememberMe(BuildContext context, AuthFormState state,
      AuthCubit cubit, Color primaryColor) {
    return OsmeaComponents.row(
      mainAxisAlignment: MainAxisAlignment.start,
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
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Widget _buildStartupSignInButton(BuildContext context, AuthFormState state,
      AuthCubit cubit, double buttonRadius, Color primaryColor) {
    final isLoading = state.operationStatus == AuthOperationStatus.loading;
    final isEnabled = state.isSignInValid && !isLoading;

    // Get button colors from config
    final buttonBgColor = _getButtonColor('sign_in', 'backgroundColor', primaryColor);
    final buttonTextColor = _getButtonColor('sign_in', 'textColor', OsmeaColors.white);
    final disabledBgColor = _getButtonColor('sign_in', 'disabledBackgroundColor', OsmeaColors.grayMaterial[400] ?? OsmeaColors.pewter);
    final disabledTextColor = _getButtonColor('sign_in', 'disabledTextColor', OsmeaColors.white);

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_in', 'sign_in_button_loading', 'Signing in...')
          : _getConfigValue('sign_in', 'sign_in_button', 'Continue'),
      onPressed: isEnabled ? cubit.signIn : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.medium,
      state: isLoading ? ButtonState.loading : (isEnabled ? ButtonState.enabled : ButtonState.disabled),
      fullWidth: true,
      backgroundColor: buttonBgColor,
      textColor: buttonTextColor,
      disabledBackgroundColor: disabledBgColor,
      disabledTextColor: disabledTextColor,
      borderRadius: buttonRadius,
    );
  }

  Widget _buildStartupForgotPasswordButton(
      BuildContext context, Color primaryColor, double buttonRadius) {
    return OsmeaComponents.button(
      text: _getConfigValue(
          'sign_in', 'forgot_password_label', 'Forgot Password?'),
      onPressed: onForgotPasswordTap,
      variant: ButtonVariant.outlined,
      size: ButtonSize.large,
      fullWidth: true,
      backgroundColor: OsmeaColors.white,
      textColor: primaryColor,
      borderColor: primaryColor,
      borderRadius: buttonRadius,
    );
  }

  /// 🔗 Startup Sign Up Link
  Widget _buildStartupSignUpLink(BuildContext context, AuthCubit cubit) {
    final linkColor = _getTextLinkColor('sign_up_link', OsmeaColors.black);
    
    return OsmeaComponents.center(
      child: OsmeaComponents.row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OsmeaComponents.text(
            'Don\'t have an account? ',
            variant: OsmeaTextVariant.bodyMedium,
            color: OsmeaColors.pewter,
          ),
          GestureDetector(
            onTap: () => _switchTab(context, 1, cubit),
            child: OsmeaComponents.text(
              'Sign Up',
              variant: OsmeaTextVariant.bodyMedium,
              color: linkColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartupSignUpEmailField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'email_label', 'Email'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          key: const Key('sign_up_email_field'),
          hint: _getConfigValue('sign_up', 'email_hint', 'Enter your email'),
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.updateSignUpEmail,
          errorText: state.signUpEmailError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
        ),
      ],
    );
  }

  Widget _buildStartupSignUpPasswordField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'password_label', 'Password'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
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
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          suffixIcon: IconButton(
            icon: Icon(
              state.signUpObscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.slate,
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignUpPasswordVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildStartupSignUpPasswordConfirmField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'password_confirm_label', 'Confirm Password'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
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
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
          suffixIcon: IconButton(
            icon: Icon(
              state.signUpObscurePasswordConfirm
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: OsmeaColors.slate,
              size: context.iconSizeSmall,
            ),
            onPressed: cubit.toggleSignUpPasswordConfirmVisibility,
          ),
        ),
      ],
    );
  }

  Widget _buildStartupSignUpFirstNameField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'first_name_label', 'First Name'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          key: const Key('sign_up_first_name_field'),
          hint: _getConfigValue(
              'sign_up', 'first_name_hint', 'Enter your first name'),
          onChanged: cubit.updateSignUpFirstName,
          errorText: state.signUpFirstNameError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
        ),
      ],
    );
  }

  Widget _buildStartupSignUpLastNameField(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return OsmeaComponents.column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          _getConfigValue('sign_up', 'last_name_label', 'Last Name'),
          variant: OsmeaTextVariant.bodyMedium,
          color: OsmeaColors.thunder,
          fontWeight: FontWeight.w500,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        OsmeaComponents.textField(
          key: const Key('sign_up_last_name_field'),
          hint: _getConfigValue(
              'sign_up', 'last_name_hint', 'Enter your last name'),
          onChanged: cubit.updateSignUpLastName,
          errorText: state.signUpLastNameError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          backgroundColor: OsmeaColors.ash,
          variant: TextFieldVariant.filled,
        ),
      ],
    );
  }

  Widget _buildStartupSignUpButton(BuildContext context, AuthFormState state,
      AuthCubit cubit, double buttonRadius, Color primaryColor) {
    final isLoading = state.operationStatus == AuthOperationStatus.loading;
    final isEnabled = !isLoading && cubit.signUpCallback != null;
    
    // Get button colors from config
    final buttonBgColor = _getButtonColor('sign_up', 'backgroundColor', primaryColor);
    final buttonTextColor = _getButtonColor('sign_up', 'textColor', OsmeaColors.white);
    final disabledBgColor = _getButtonColor('sign_up', 'disabledBackgroundColor', OsmeaColors.grayMaterial[400] ?? OsmeaColors.pewter);
    final disabledTextColor = _getButtonColor('sign_up', 'disabledTextColor', OsmeaColors.white);

    return OsmeaComponents.button(
      text: isLoading
          ? _getConfigValue(
              'sign_up', 'sign_up_button_loading', 'Creating account...')
          : _getConfigValue('sign_up', 'sign_up_button', 'Create Account'),
      onPressed: isEnabled ? cubit.signUp : null,
      variant: ButtonVariant.primary,
      size: ButtonSize.medium,
      state: isLoading
          ? ButtonState.loading
          : (cubit.signUpCallback == null
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
}
