import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/src/views/auth/cubit/auth_cubit.dart';
import 'package:core/src/views/auth/cubit/auth_state.dart';
import 'package:osmea_components/osmea_components.dart';

/// 🚀 **OSMEA Auth Space Widget**
///
/// Split-screen modern authentication design
/// Side-by-side layout with visual branding area
///
/// {@category Widgets}
/// {@subCategory AuthSpace}
class AuthSpaceWidget extends StatefulWidget {
  final VoidCallback? onSignInSuccess;
  final Function(String error)? onSignInError;
  final VoidCallback? onSignUpSuccess;
  final Function(String error)? onSignUpError;
  final VoidCallback? onForgotPasswordTap;
  final Map<String, dynamic>? config;
  final int initialTab;

  const AuthSpaceWidget({
    super.key,
    this.onSignInSuccess,
    this.onSignInError,
    this.onSignUpSuccess,
    this.onSignUpError,
    this.onForgotPasswordTap,
    this.config,
    this.initialTab = 0,
  });

  @override
  State<AuthSpaceWidget> createState() => _AuthSpaceWidgetState();
}

class _AuthSpaceWidgetState extends State<AuthSpaceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return StreamBuilder<AuthState>(
      stream: cubit.stream,
      initialData: cubit.state,
      builder: (context, snapshot) {
        final state = snapshot.data ?? cubit.state;

        if (state is! AuthFormState) {
          return const SizedBox.shrink();
        }

        final formState = state;
        final currentTab = formState.currentTab;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          child: OsmeaComponents.scaffold(
            backgroundColor: OsmeaColors.white,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Mobile layout
                  if (constraints.maxWidth < 600) {
                    return _buildMobileLayout(
                        context, formState, cubit, currentTab);
                  }
                  // Desktop/Tablet split layout
                  return _buildSplitLayout(
                      context, formState, cubit, currentTab);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // Mobile: Stack layout
  Widget _buildMobileLayout(BuildContext context, AuthFormState state,
      AuthCubit cubit, int currentTab) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBrandingSection(context, compact: true),
          _buildFormSection(context, state, cubit, currentTab),
        ],
      ),
    );
  }

  // Desktop: Side by side
  Widget _buildSplitLayout(BuildContext context, AuthFormState state,
      AuthCubit cubit, int currentTab) {
    return Row(
      children: [
        // Left: Branding
        Expanded(
          flex: 5,
          child: _buildBrandingSection(context),
        ),
        // Right: Form
        Expanded(
          flex: 6,
          child: _buildFormSection(context, state, cubit, currentTab),
        ),
      ],
    );
  }

  Widget _buildBrandingSection(BuildContext context, {bool compact = false}) {
    final logoUrl = widget.config?['logo_url']?.toString() ?? '';
    final appName = widget.config?['app_name']?.toString() ?? 'MasterFabric';

    return FadeTransition(
      opacity: _fadeIn,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
              Color(0xFFA855F7),
            ],
          ),
        ),
        padding:
            EdgeInsets.all(compact ? context.spacing32 : context.spacing48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (logoUrl.isNotEmpty)
              Container(
                width: compact ? 60 : 80,
                height: compact ? 60 : 80,
                decoration: BoxDecoration(
                  color: OsmeaColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: OsmeaComponents.image(
                  imageUrl: logoUrl,
                  fit: BoxFit.contain,
                ),
              ),
            if (logoUrl.isNotEmpty)
              SizedBox(height: compact ? context.spacing16 : context.spacing24),
            OsmeaComponents.text(
              appName,
              variant: compact
                  ? OsmeaTextVariant.headlineMedium
                  : OsmeaTextVariant.displaySmall,
              color: OsmeaColors.white,
              fontWeight: FontWeight.w800,
            ),
            SizedBox(height: compact ? context.spacing8 : context.spacing12),
            OsmeaComponents.text(
              'Your trusted e-commerce platform',
              variant: OsmeaTextVariant.bodyLarge,
              color: OsmeaColors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
            if (!compact) ...[
              SizedBox(height: context.spacing40),
              _buildFeatureList(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final features = [
      {'icon': Icons.verified_user, 'text': 'Secure & Trusted'},
      {'icon': Icons.flash_on, 'text': 'Fast Checkout'},
      {'icon': Icons.support_agent, 'text': '24/7 Support'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.only(bottom: context.spacing16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: OsmeaColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: OsmeaColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              OsmeaComponents.text(
                feature['text'] as String,
                variant: OsmeaTextVariant.bodyMedium,
                color: OsmeaColors.white.withOpacity(0.95),
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFormSection(BuildContext context, AuthFormState state,
      AuthCubit cubit, int currentTab) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.spacing16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tabs
            Row(
              children: [
                _buildTabButton(
                    'Sign In', currentTab == 0, () => cubit.switchTab(0)),
                const SizedBox(width: 16),
                if (cubit.signUpCallback != null)
                  _buildTabButton(
                      'Sign Up', currentTab == 1, () => cubit.switchTab(1)),
              ],
            ),
            const SizedBox(height: 20),

            // Form
            currentTab == 0
                ? _buildSignInForm(context, state, cubit)
                : _buildSignUpForm(context, state, cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color:
                  isActive ? const Color(0xFF6366F1) : const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF6366F1) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          context,
          label: 'Email',
          hint: 'Enter your email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.updateSignInEmail,
          errorText: state.signInEmailError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        _buildTextField(
          context,
          label: 'Password',
          hint: 'Enter your password',
          icon: Icons.lock_outlined,
          obscureText: state.signInObscurePassword,
          onChanged: cubit.updateSignInPassword,
          errorText: state.signInPasswordError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.signInObscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: const Color(0xFF6B7280),
              size: 20,
            ),
            onPressed: cubit.toggleSignInPasswordVisibility,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        _buildRememberMe(context, state, cubit),
        OsmeaComponents.sizedBox(height: context.spacing16),
        _buildButton(
          context,
          label: state.operationStatus == AuthOperationStatus.loading
              ? 'Signing In...'
              : 'Sign In',
          onPressed: state.isSignInValid &&
                  state.operationStatus != AuthOperationStatus.loading
              ? cubit.signIn
              : null,
          isLoading: state.operationStatus == AuthOperationStatus.loading,
        ),
        if (widget.onForgotPasswordTap != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing12),
          Center(
            child: GestureDetector(
              onTap: widget.onForgotPasswordTap,
              child: OsmeaComponents.text(
                'Forgot Password?',
                variant: OsmeaTextVariant.bodyMedium,
                color: const Color(0xFF111827),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSignUpForm(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    // Debug: Check if config and checklists exist
    debugPrint('🔍 Space Widget - Config: ${widget.config}');
    debugPrint('🔍 Space Widget - sign_up: ${widget.config?['sign_up']}');
    debugPrint(
        '🔍 Space Widget - checklists: ${widget.config?['sign_up']?['checklists']}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTextField(
          context,
          label: 'Email',
          hint: 'Enter your email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onChanged: cubit.updateSignUpEmail,
          errorText: state.signUpEmailError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        _buildTextField(
          context,
          label: 'Password',
          hint: 'Create a password',
          icon: Icons.lock_outlined,
          obscureText: state.signUpObscurePassword,
          onChanged: cubit.updateSignUpPassword,
          errorText: state.signUpPasswordError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.signUpObscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: const Color(0xFF6B7280),
              size: 20,
            ),
            onPressed: cubit.toggleSignUpPasswordVisibility,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        _buildTextField(
          context,
          label: 'Confirm Password',
          hint: 'Confirm your password',
          icon: Icons.lock_outlined,
          obscureText: state.signUpObscurePasswordConfirm,
          onChanged: cubit.updateSignUpPasswordConfirm,
          errorText: state.signUpPasswordConfirmError,
          enabled: state.operationStatus != AuthOperationStatus.loading,
          suffixIcon: IconButton(
            icon: Icon(
              state.signUpObscurePasswordConfirm
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: const Color(0xFF6B7280),
              size: 20,
            ),
            onPressed: cubit.toggleSignUpPasswordConfirmVisibility,
          ),
        ),
        OsmeaComponents.sizedBox(height: context.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                context,
                label: 'First Name',
                hint: 'First name',
                icon: Icons.person_outline,
                onChanged: cubit.updateSignUpFirstName,
                errorText: state.signUpFirstNameError,
                enabled: state.operationStatus != AuthOperationStatus.loading,
              ),
            ),
            OsmeaComponents.sizedBox(width: context.spacing12),
            Expanded(
              child: _buildTextField(
                context,
                label: 'Last Name',
                hint: 'Last name',
                icon: Icons.person_outline,
                onChanged: cubit.updateSignUpLastName,
                errorText: state.signUpLastNameError,
                enabled: state.operationStatus != AuthOperationStatus.loading,
              ),
            ),
          ],
        ),
        // Payment agreements checkbox
        if (widget.config?['sign_up']?['payment_agreements'] != null) ...[
          OsmeaComponents.sizedBox(height: context.spacing12),
          _buildPaymentAgreementsCheckbox(
            context,
            state,
            cubit,
            widget.config!['sign_up']['payment_agreements']
                as Map<String, dynamic>,
          ),
        ],
        OsmeaComponents.sizedBox(height: context.spacing16),
        _buildButton(
          context,
          label: state.operationStatus == AuthOperationStatus.loading
              ? 'Creating Account...'
              : 'Create Account',
          onPressed: cubit.signUpCallback != null &&
                  state.operationStatus != AuthOperationStatus.loading
              ? cubit.signUp
              : null,
          isLoading: state.operationStatus == AuthOperationStatus.loading,
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    required Function(String) onChanged,
    String? errorText,
    bool enabled = true,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OsmeaComponents.text(
          label,
          variant: OsmeaTextVariant.bodyMedium,
          color: const Color(0xFF374151),
          fontWeight: FontWeight.w600,
        ),
        OsmeaComponents.sizedBox(height: context.spacing8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: errorText != null
                  ? const Color(0xFFEF4444)
                  : const Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          child: OsmeaComponents.textField(
            hint: hint,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onChanged: onChanged,
            errorText: errorText,
            enabled: enabled,
            backgroundColor: Colors.transparent,
            variant: TextFieldVariant.filled,
            prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    final isEnabled = onPressed != null && !isLoading;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isEnabled ? const Color(0xFF111827) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(OsmeaColors.white),
                    ),
                  )
                : OsmeaComponents.text(
                    label,
                    variant: OsmeaTextVariant.bodyLarge,
                    color:
                        isEnabled ? OsmeaColors.white : const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMe(
      BuildContext context, AuthFormState state, AuthCubit cubit) {
    return Row(
      children: [
        GestureDetector(
          onTap: cubit.toggleRememberMe,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: state.signInRememberMe
                  ? const Color(0xFF111827)
                  : OsmeaColors.white,
              border: Border.all(
                color: state.signInRememberMe
                    ? const Color(0xFF111827)
                    : const Color(0xFFD1D5DB),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: state.signInRememberMe
                ? const Icon(Icons.check, size: 14, color: OsmeaColors.white)
                : null,
          ),
        ),
        OsmeaComponents.sizedBox(width: context.spacing8),
        OsmeaComponents.text(
          'Remember me',
          variant: OsmeaTextVariant.bodyMedium,
          color: const Color(0xFF6B7280),
        ),
      ],
    );
  }

  Widget _buildPaymentAgreementsCheckbox(
    BuildContext context,
    AuthFormState state,
    AuthCubit cubit,
    Map<String, dynamic> paymentAgreements,
  ) {
    final checkboxText =
        paymentAgreements['checkbox_text']?.toString() ?? 'I accept the terms';
    final linkColorHex =
        paymentAgreements['checkbox_link_color']?.toString() ?? '#FF6B00';
    final linkColor = Color(
      int.parse(linkColorHex.replaceFirst('#', '0xFF')),
    );

    final isChecked = state.signUpChecklists['payment_agreements'] == true;

    // Parse checkbox text to find links
    final preliminaryForm = paymentAgreements['preliminary_information_form']
        as Map<String, dynamic>?;
    final distanceSales =
        paymentAgreements['distance_sales_agreement'] as Map<String, dynamic>?;

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => cubit.toggleChecklist('payment_agreements'),
            child: Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF6366F1) : Colors.transparent,
                border: Border.all(
                  color: isChecked
                      ? const Color(0xFF6366F1)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          OsmeaComponents.sizedBox(width: context.spacing12),
          Expanded(
            child: Wrap(
              children: _buildCheckboxTextSpans(
                context,
                checkboxText,
                linkColor,
                preliminaryForm,
                distanceSales,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCheckboxTextSpans(
    BuildContext context,
    String text,
    Color linkColor,
    Map<String, dynamic>? preliminaryForm,
    Map<String, dynamic>? distanceSales,
  ) {
    final widgets = <Widget>[];
    final textStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xFF374151),
      height: 1.5,
    );
    final linkStyle = TextStyle(
      fontSize: 14,
      color: linkColor,
      height: 1.5,
      decoration: TextDecoration.underline,
      decorationColor: linkColor,
    );

    // Simple approach: split by known phrases and create clickable links
    final preliminaryTitle =
        preliminaryForm?['title']?.toString() ?? 'Preliminary Information Form';
    final distanceTitle =
        distanceSales?['title']?.toString() ?? 'Distance Sales Agreement';

    // Check if text contains the titles
    if (text.contains(preliminaryTitle) || text.contains(distanceTitle)) {
      String remaining = text;

      // Find and process Preliminary Information Form
      if (remaining.contains(preliminaryTitle) && preliminaryForm != null) {
        final parts = remaining.split(preliminaryTitle);
        if (parts.isNotEmpty && parts[0].isNotEmpty) {
          widgets.add(Text(parts[0], style: textStyle));
        }
        widgets.add(
          GestureDetector(
            onTap: () => _showAgreementDialog(
              context,
              preliminaryTitle,
              preliminaryForm['content']?.toString() ?? '',
            ),
            child: Text(preliminaryTitle, style: linkStyle),
          ),
        );
        remaining =
            parts.length > 1 ? parts.sublist(1).join(preliminaryTitle) : '';
      }

      // Find and process Distance Sales Agreement
      if (remaining.contains(distanceTitle) && distanceSales != null) {
        final parts = remaining.split(distanceTitle);
        if (parts.isNotEmpty && parts[0].isNotEmpty) {
          widgets.add(Text(parts[0], style: textStyle));
        }
        widgets.add(
          GestureDetector(
            onTap: () => _showAgreementDialog(
              context,
              distanceTitle,
              distanceSales['content']?.toString() ?? '',
            ),
            child: Text(distanceTitle, style: linkStyle),
          ),
        );
        remaining =
            parts.length > 1 ? parts.sublist(1).join(distanceTitle) : '';
      }

      if (remaining.isNotEmpty) {
        widgets.add(Text(remaining, style: textStyle));
      }
    } else {
      // Fallback: just show the text as is
      widgets.add(Text(text, style: textStyle));
    }

    return widgets;
  }

  void _showAgreementDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
