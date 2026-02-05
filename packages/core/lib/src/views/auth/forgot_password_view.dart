import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osmea_components/osmea_components.dart';

/// 📧 **OSMEA Forgot Password View**
///
/// Full-page forgot password screen (no popup).
/// Uses OsmeaComponents for consistent design.
/// Config-driven via auth_configuration.forgot_password (single common config for all styles).
///
/// {@category Views}
/// {@subCategory Auth}

class ForgotPasswordView extends StatefulWidget {
  /// Called when user taps back (e.g. go to /auth).
  final VoidCallback? onBack;

  /// Send reset email. Returns true on success.
  final Future<bool> Function(String email) onSendResetEmail;

  /// Optional config map (auth_configuration). If null, uses AssetConfigHelper.
  final Map<String, dynamic>? config;

  /// Optional custom goRoute for back navigation path.
  final Function(String path)? goRoute;

  const ForgotPasswordView({
    super.key,
    this.onBack,
    required this.onSendResetEmail,
    this.config,
    this.goRoute,
  });

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Resolves auth_configuration (widget.config or AssetConfigHelper).
  Map<String, dynamic>? _getAuthConfig() {
    if (widget.config != null) return widget.config;
    try {
      final obj = AssetConfigHelper().getObject('auth_configuration');
      return obj is Map<String, dynamic> ? obj : null;
    } catch (_) {
      return null;
    }
  }

  /// Forgot password config (auth_configuration.forgot_password – common for all styles).
  Map<String, dynamic> _getForgotPasswordConfig() {
    final config = _getAuthConfig();
    final fp = config?['forgot_password'] as Map<String, dynamic>?;
    return Map<String, dynamic>.from(fp ?? {});
  }

  String _getForgotPasswordString(String key, String fallback) {
    final fp = _getForgotPasswordConfig();
    final v = fp[key]?.toString();
    return (v != null && v.isNotEmpty) ? v : fallback;
  }

  static Color _parseHexColor(String? hex) {
    if (hex == null || hex.isEmpty) return OsmeaColors.black;
    String h = hex.startsWith('#') ? hex.substring(1) : hex;
    if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
    if (h.length == 8) return Color(int.parse(h, radix: 16));
    return OsmeaColors.black;
  }

  /// Color from forgot_password config (common).
  Color _getForgotPasswordColor(String key, String fallbackHex) {
    final fp = _getForgotPasswordConfig();
    final hex = fp[key]?.toString();
    return _parseHexColor(hex?.isNotEmpty == true ? hex : fallbackHex);
  }

  /// Double from forgot_password config (e.g. border_radius).
  double _getForgotPasswordDouble(String key, double fallback) {
    final fp = _getForgotPasswordConfig();
    final v = fp[key];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? fallback;
    return fallback;
  }

  Future<void> _submit() async {
    setState(() {
      _errorText = null;
    });
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final email = _emailController.text.trim();
    setState(() => _isLoading = true);
    try {
      final success = await widget.onSendResetEmail(email);
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (success) {
        if (widget.onBack != null) {
          widget.onBack!();
        } else if (widget.goRoute != null) {
          widget.goRoute!('/auth');
        } else {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorText =
              e.toString().replaceFirst(RegExp(r'^Exception:?\s*'), '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // All colors and radius from auth_configuration.forgot_password (variant-aware)
    final backgroundColor =
        _getForgotPasswordColor('background_color', '#FFFFFF');
    final appBarBg =
        _getForgotPasswordColor('app_bar_background_color', '#FFFFFF');
    final appBarFg =
        _getForgotPasswordColor('app_bar_foreground_color', '#000000');
    final appBarTitleColor =
        _getForgotPasswordColor('app_bar_title_color', '#000000');
    final primaryColor = _getForgotPasswordColor('primary_color', '#000000');
    final iconBgColor =
        _getForgotPasswordColor('icon_background_color', '#00000014');
    final titleColor = _getForgotPasswordColor('title_text_color', '#000000');
    final subtitleColor =
        _getForgotPasswordColor('subtitle_text_color', '#6B7280');
    final labelColor = _getForgotPasswordColor('label_text_color', '#374151');
    final buttonBg =
        _getForgotPasswordColor('button_background_color', '#000000');
    final buttonTextColor =
        _getForgotPasswordColor('button_text_color', '#FFFFFF');
    final linkColor = _getForgotPasswordColor('link_color', '#000000');
    final inputBgColor =
        _getForgotPasswordColor('input_background_color', '#FFFFFF');
    final inputBorderColor =
        _getForgotPasswordColor('input_border_color', '#E5E7EB');
    final inputHintColor =
        _getForgotPasswordColor('input_hint_color', '#9CA3AF');
    final borderRadius = _getForgotPasswordDouble('border_radius', 12);

    final title = _getForgotPasswordString('title', 'Reset Password');
    final subtitle = _getForgotPasswordString(
      'subtitle',
      'Enter your email and we\'ll send you a link to reset your password.',
    );
    final emailHint = _getForgotPasswordString('email_hint', 'Email');
    final submitButton =
        _getForgotPasswordString('submit_button', 'Send reset link');
    final backToSignIn =
        _getForgotPasswordString('back_to_sign_in', 'Back to Sign In');

    final statusBarBright =
        _isColorLight(appBarFg) ? Brightness.light : Brightness.dark;
    final statusBarIconBrightness =
        _isColorLight(appBarFg) ? Brightness.dark : Brightness.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarBrightness: statusBarBright,
      ),
      child: OsmeaComponents.scaffold(
        backgroundColor: backgroundColor,
        appBar: OsmeaComponents.appBar(
          title: OsmeaComponents.text(
            title,
            color: appBarTitleColor,
            textStyle: OsmeaTextStyle.titleLarge(context),
          ),
          backgroundColor: appBarBg,
          elevation: 0,
          foregroundColor: appBarFg,
          variant: AppBarVariant.standard,
          size: AppBarSize.standard,
          leading: OsmeaComponents.iconButton(
            onPressed: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else if (widget.goRoute != null) {
                widget.goRoute!('/auth');
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: appBarFg,
              size: context.iconSizeNormal,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing24,
              vertical: context.spacing32,
            ),
            child: Form(
              key: _formKey,
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  Center(
                    child: OsmeaComponents.container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        size: 40,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing32),
                  OsmeaComponents.text(
                    title,
                    variant: OsmeaTextVariant.headlineSmall,
                    color: titleColor,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing12),
                  OsmeaComponents.text(
                    subtitle,
                    variant: OsmeaTextVariant.bodyLarge,
                    color: subtitleColor,
                    textAlign: TextAlign.center,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing32),
                  OsmeaComponents.text(
                    '${_getForgotPasswordString('email_label', 'Email')} *',
                    variant: OsmeaTextVariant.bodyMedium,
                    color: labelColor,
                    fontWeight: FontWeight.w600,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  OsmeaComponents.textField(
                    controller: _emailController,
                    hint: emailHint,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    errorText: _errorText,
                    backgroundColor: inputBgColor,
                    borderColor: inputBorderColor,
                    hintColor: inputHintColor,
                    variant: TextFieldVariant.outlined,
                    onChanged: (_) {
                      if (_errorText != null) setState(() => _errorText = null);
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return _getForgotPasswordString(
                          'email_required',
                          'Please enter your email',
                        );
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value.trim())) {
                        return _getForgotPasswordString(
                          'email_invalid',
                          'Please enter a valid email',
                        );
                      }
                      return null;
                    },
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing32),
                  OsmeaComponents.button(
                    text: _isLoading
                        ? _getForgotPasswordString('sending', 'Sending...')
                        : submitButton,
                    onPressed: _isLoading ? null : _submit,
                    variant: ButtonVariant.secondary,
                    size: ButtonSize.large,
                    state:
                        _isLoading ? ButtonState.loading : ButtonState.enabled,
                    fullWidth: true,
                    backgroundColor: buttonBg,
                    textColor: buttonTextColor,
                    borderRadius: borderRadius,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  Center(
                    child: GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              if (widget.onBack != null) {
                                widget.onBack!();
                              } else if (widget.goRoute != null) {
                                widget.goRoute!('/auth');
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                      child: OsmeaComponents.text(
                        backToSignIn,
                        variant: OsmeaTextVariant.bodyMedium,
                        color: linkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static bool _isColorLight(Color color) {
    return color.computeLuminance() > 0.5;
  }
}
