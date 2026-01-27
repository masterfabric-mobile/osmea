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

/// ⚡ **OSMEA Auth Startup Widget**
///
/// Modern, clean e-commerce design
/// Orange accent color with filled text fields
///
/// {@category Widgets}
/// {@subCategory AuthStartup}
class AuthStartupWidget extends StatelessWidget {
  final VoidCallback? onSignInSuccess;
  final Function(String error)? onSignInError;
  final VoidCallback? onSignUpSuccess;
  final Function(String error)? onSignUpError;
  final VoidCallback? onForgotPasswordTap;
  final Map<String, dynamic>? config;
  final int initialTab;

  const AuthStartupWidget({
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
                  return Color(
                      int.parse('FF${hex.substring(0, 6)}', radix: 16));
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
            color: OsmeaColors.white,
            child: OsmeaComponents.center(
              child: OsmeaComponents.loading(
                type: LoadingType.circularFade,
                size: 48.0,
                color: OsmeaColors.sunsetGlow,
              ),
            ),
          );
        }

        final formState = state;
        final currentTab = formState.currentTab;
        final cubit = context.read<AuthCubit>();
        final primaryColor = OsmeaColors.sunsetGlow;

        // UI Style configuration
        final uiStyleConfig = config?['ui_style'] as Map<String, dynamic>?;
        final buttonRadius =
            (uiStyleConfig?['button_radius'] as num?)?.toDouble() ??
                context.spacing12;
        final horizontalPadding =
            (uiStyleConfig?['horizontal_padding'] as num?)?.toDouble() ??
                context.spacing24;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          child: OsmeaComponents.container(
            color: OsmeaColors.white,
            child: SafeArea(
              top: false,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      top: context.spacing64,
                    ),
                    child: OsmeaComponents.column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStartupTitle(context, currentTab),
                        OsmeaComponents.sizedBox(height: context.spacing64),
                        currentTab == 0
                            ? _buildStartupSignInContent(context, formState,
                                cubit, buttonRadius, primaryColor)
                            : _buildStartupSignUpContent(context, formState,
                                cubit, buttonRadius, primaryColor),
                        OsmeaComponents.sizedBox(height: context.spacing32),
                      ],
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
        _buildPaymentAgreementCheckbox(context, formState, cubit, primaryColor),
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
      variant: ButtonVariant.primary,
      size: ButtonSize.medium,
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
          _getConfigValue(
              'sign_up', 'password_confirm_label', 'Confirm Password'),
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
      variant: ButtonVariant.primary,
      size: ButtonSize.medium,
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
