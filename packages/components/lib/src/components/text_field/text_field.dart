import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/src/core/text_field_widget.dart';
import 'package:osmea_components/src/components/text_field/controllers/text_field_controller.dart';
import 'package:osmea_components/src/utils/text_field_size_extensions.dart';
import 'package:osmea_components/src/utils/sizer_extensions.dart';
import 'package:osmea_components/src/styles/colors.dart';
import 'package:osmea_components/src/enums/components_enum.dart';
import 'package:osmea_components/src/components/text_field/cubit/text_field_cubit.dart';
import 'package:osmea_components/src/components/text_field/cubit/text_field_state.dart';

/// 🔤 **OSMEA TextField**
///
/// A comprehensive and highly customizable text field component for the OSMEA UI Kit.
/// Features advanced state management, validation, theming, and extensive customization options.
///
/// **Features:**
/// - Multiple OSMEA variants (outlined, filled, underlined, borderless)
/// - Size options (extraSmall to extraLarge)
/// - Input types (text, email, password, number, etc.)
/// - Advanced validation with custom error builders
/// - Animated state transitions and hover effects
/// - Interactive states (hover, focus, disabled)
/// - Custom error and helper text builders
/// - Floating label support
/// - Responsive design with OSMEA color system
/// - Accessibility features
///
/// **Usage:**
/// ```dart
/// OsmeaTextField(
///   label: 'Email Address',
///   hint: 'Enter your email',
///   type: TextFieldType.email,
///   variant: TextFieldVariant.outlined,
///   size: TextFieldSize.medium,
///   showErrorIcon: true,
///   hasFloatingLabel: true,
///   errorBuilder: (context, error) => CustomErrorWidget(error),
///   onChanged: (value) => print(value),
///   onFocusChanged: (hasFocus) => print('Focus: $hasFocus'),
///   onHoverChanged: (isHovering) => print('Hover: $isHovering'),
/// )
/// ```

class OsmeaTextField extends CoreTextField {
  const OsmeaTextField({
    super.key,
    super.customTheme,
    super.controller,
    this.osmeaController,
    super.focusNode,
    super.label,
    super.hint,
    super.helperText,
    super.errorText,
    super.prefixIcon,
    super.suffixIcon,
    super.size,
    super.variant,
    super.state,
    super.type,
    super.isRequired,
    super.validator,
    super.onChanged,
    super.onSubmitted,
    super.onTap,
    super.onEditingComplete,
    super.maxLines,
    super.minLines,
    super.maxLength,
    super.obscureText,
    super.readOnly,
    super.autofocus,
    super.enabled,
    super.textAlign,
    super.textCapitalization,
    super.keyboardType,
    super.textInputAction,
    super.inputFormatters,
    super.textStyle,
    super.textColor,
    super.backgroundColor,
    super.borderColor,
    super.focusColor,
    super.errorColor,
    super.hintColor,
    super.labelColor,
    super.fullWidth,
    super.animationDuration,
    // Advanced OSMEA-specific parameters
    this.hasFloatingLabel = false,
    this.showErrorIcon = true,
    this.errorMaxLines = 2,
    this.transitionDuration,
    this.transitionCurve = Curves.easeInOut,
    this.onFocusChanged,
    this.onHoverChanged,
    this.errorBuilder,
    this.helperBuilder,
    this.interactiveStates = const {
      WidgetState.hovered,
      WidgetState.focused,
      WidgetState.pressed,
    },
    this.enableHoverEffect = true,
    this.hoverAnimationDuration,
    this.customBorderRadius,
    this.showCharacterCount = false,
    this.characterCountBuilder,
    this.customContentPadding,
  });

  /// Optional OSMEA-specific controller with enhanced features
  final OsmeaTextFieldController? osmeaController;

  /// Whether the label should float above the field when focused or filled
  final bool hasFloatingLabel;

  /// Whether to show an error icon when there's an error
  final bool showErrorIcon;

  /// Maximum number of lines for error text
  final int errorMaxLines;

  /// Custom transition duration for state changes
  final Duration? transitionDuration;

  /// Animation curve for transitions
  final Curve transitionCurve;

  /// Callback when focus state changes
  final ValueChanged<bool>? onFocusChanged;

  /// Callback when hover state changes
  final ValueChanged<bool>? onHoverChanged;

  /// Custom builder for error messages
  final Widget Function(BuildContext context, String error)? errorBuilder;

  /// Custom builder for helper text
  final Widget Function(BuildContext context, String helper)? helperBuilder;

  /// Set of material states that should trigger interactive effects
  final Set<WidgetState> interactiveStates;

  /// Whether hover effects are enabled
  final bool enableHoverEffect;

  /// Duration for hover animations
  final Duration? hoverAnimationDuration;

  /// Custom border radius override
  final BorderRadius? customBorderRadius;

  /// Whether to show character count
  final bool showCharacterCount;

  /// Custom builder for character count display
  final Widget Function(BuildContext context, int current, int? max)?
      characterCountBuilder;

  /// Custom content padding
  final EdgeInsets? customContentPadding;

  /// Get the effective controller (OSMEA controller takes priority)
  TextEditingController get effectiveController =>
      osmeaController ?? controller ?? TextEditingController();

  /// Get effective transition duration
  Duration getEffectiveTransitionDuration(BuildContext context) =>
      transitionDuration ?? animationDuration ?? context.animationMedium;

  /// Get effective hover animation duration
  Duration getEffectiveHoverDuration(BuildContext context) =>
      hoverAnimationDuration ?? const Duration(milliseconds: 150);

  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => TextFieldCubit(
        controller: effectiveController,
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
        onFocusChanged: onFocusChanged,
        onHoverChanged: onHoverChanged,
        onTap: onTap,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        enabled: enabled ?? true,
        initialValue: effectiveController.text,
      ),
      child: _OsmeaTextFieldView(
        textField: this,
      ),
    );
  }
}

/// Stateless TextField View using Cubit
class _OsmeaTextFieldView extends StatelessWidget {
  const _OsmeaTextFieldView({
    required this.textField,
  });

  final OsmeaTextField textField;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextFieldCubit, TextFieldCubitState>(
      builder: (context, state) {
        final config = textField.size.getConfig(context);
        final colors = _getTextFieldColors(context, state);

        return MouseRegion(
          onEnter: (_) => context.read<TextFieldCubit>().setHover(true),
          onExit: (_) => context.read<TextFieldCubit>().setHover(false),
          child: AnimatedContainer(
            duration: textField.getEffectiveTransitionDuration(context),
            curve: textField.transitionCurve,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (textField.label != null && !textField.hasFloatingLabel)
                  _buildLabel(context, config, colors, state),
                _buildTextField(context, config, colors, state),
                _buildBottomSection(context, config, colors, state),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build the label widget
  Widget _buildLabel(BuildContext context, TextFieldSizeConfig config,
      _TextFieldColors colors, TextFieldCubitState state) {
    return Padding(
      padding: EdgeInsets.only(bottom: config.labelSpacing),
      child: Row(
        children: [
          Text(
            textField.label!,
            style: textField.size.getLabelStyle(context).copyWith(
                  color: colors.label,
                ),
          ),
          if (textField.isRequired) ...[
            SizedBox(width: context.spacing4),
            Text(
              '*',
              style: textField.size.getLabelStyle(context).copyWith(
                    color: colors.error,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build the main text field widget
  Widget _buildTextField(
    BuildContext context,
    TextFieldSizeConfig config,
    _TextFieldColors colors,
    TextFieldCubitState state,
  ) {
    final cubit = context.read<TextFieldCubit>();
    final decoration = _buildInputDecoration(context, config, colors, state);

    return AnimatedContainer(
        duration: textField.getEffectiveTransitionDuration(context),
        curve: textField.transitionCurve,
        width: textField.fullWidth ? double.infinity : null,
        child: ClipRect(
          child: SizedBox(
            height: math.min(config.height, 42.0),
            child: TextField(
              controller: cubit.effectiveController,
              focusNode: cubit.effectiveFocusNode,
              decoration: decoration,
              keyboardType: textField.effectiveKeyboardType,
              textInputAction: textField.effectiveTextInputAction,
              textCapitalization: textField.effectiveTextCapitalization,
              style: _getInputTextStyle(context, config, colors, state),
              maxLines: textField.maxLines,
              minLines: textField.minLines,
              maxLength: textField.maxLength,
              obscureText: textField.shouldObscureText,
              readOnly: textField.readOnly,
              autofocus: textField.autofocus,
              enabled: state.isEnabled && !textField.isEffectivelyDisabled,
              textAlign: textField.textAlign,
              inputFormatters: textField.inputFormatters,
              canRequestFocus: true,
              showCursor: true,
              enableInteractiveSelection: true,
              onTap: () => cubit.handleTap(),
              onChanged: (value) => cubit.validate(),
              onSubmitted: (value) => cubit.handleSubmitted(value),
              onEditingComplete: () => cubit.handleEditingComplete(),
            ),
          ),
        ));
  }

  /// Build bottom section with helper text, error text, and character count
  Widget _buildBottomSection(BuildContext context, TextFieldSizeConfig config,
      _TextFieldColors colors, TextFieldCubitState state) {
    final shouldShowHelper = _shouldShowHelperText(state);
    final shouldShowCount =
        textField.showCharacterCount && textField.maxLength != null;

    if (!shouldShowHelper && !shouldShowCount) {
      return const SizedBox(height: 0);
    }

    return Padding(
      padding: EdgeInsets.only(top: config.helperSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (shouldShowHelper)
            Expanded(
                child: _buildHelperOrErrorText(context, config, colors, state)),
          if (shouldShowCount)
            _buildCharacterCount(context, config, colors, state),
        ],
      ),
    );
  }

  /// Build helper or error text with custom builders
  Widget _buildHelperOrErrorText(
      BuildContext context,
      TextFieldSizeConfig config,
      _TextFieldColors colors,
      TextFieldCubitState state) {
    final displayText = _getDisplayHelperText(state);
    final isError = _isErrorText(state);

    // Use custom error builder if available and it's an error
    if (isError && textField.errorBuilder != null) {
      return AnimatedSwitcher(
        duration: textField.getEffectiveTransitionDuration(context),
        child: textField.errorBuilder!(context, displayText),
      );
    }

    // Use custom helper builder if available and it's not an error
    if (!isError && textField.helperBuilder != null) {
      return textField.helperBuilder!(context, displayText);
    }

    // Default text display
    return AnimatedSwitcher(
      duration: textField.getEffectiveTransitionDuration(context),
      child: Row(
        key: ValueKey(displayText),
        children: [
          if (isError && textField.showErrorIcon) ...[
            Icon(
              Icons.error_outline,
              size: config.iconSize * 0.8,
              color: colors.error,
            ),
            SizedBox(width: context.spacing2),
          ],
          Expanded(
            child: Text(
              displayText,
              style: textField.size.getHelperStyle(context).copyWith(
                    color: isError ? colors.error : colors.helper,
                  ),
              maxLines: isError ? textField.errorMaxLines : null,
              overflow: isError ? TextOverflow.ellipsis : null,
            ),
          ),
        ],
      ),
    );
  }

  /// Build character count display
  Widget _buildCharacterCount(BuildContext context, TextFieldSizeConfig config,
      _TextFieldColors colors, TextFieldCubitState state) {
    final currentLength = state.currentValue.length;
    final maxLength = textField.maxLength!;

    if (textField.characterCountBuilder != null) {
      return textField.characterCountBuilder!(
          context, currentLength, maxLength);
    }

    final isOverLimit = currentLength > maxLength;
    return Text(
      '$currentLength/$maxLength',
      style: textField.size.getHelperStyle(context).copyWith(
            color: isOverLimit ? colors.error : colors.helper,
          ),
    );
  }

  /// Build input decoration
  InputDecoration _buildInputDecoration(
    BuildContext context,
    TextFieldSizeConfig config,
    _TextFieldColors colors,
    TextFieldCubitState state,
  ) {
    return InputDecoration(
      isDense: true,
      labelText: textField.hasFloatingLabel ? textField.label : null,
      labelStyle: textField.hasFloatingLabel
          ? textField.size.getLabelStyle(context).copyWith(color: colors.label)
          : null,
      floatingLabelStyle: textField.hasFloatingLabel
          ? textField.size.getLabelStyle(context).copyWith(color: colors.focus)
          : null,
      hintText: textField.hint,
      hintStyle: _getHintTextStyle(context, config, colors, state),
      prefixIcon: textField.prefixIcon != null
          ? _buildIcon(textField.prefixIcon!, config, colors, state)
          : null,
      suffixIcon: textField.suffixIcon != null
          ? _buildIcon(textField.suffixIcon!, config, colors, state)
          : null,
      filled: textField.backgroundColor != null ||
          textField.variant == TextFieldVariant.filled ||
          textField.variant == TextFieldVariant.borderless,
      fillColor: colors.background,
      contentPadding: textField.customContentPadding ?? config.padding,
      border: _getBorder(context, config, colors.border, state),
      enabledBorder: _getBorder(context, config, colors.border, state),
      focusedBorder: _getBorder(context, config, colors.focus, state),
      errorBorder: _getBorder(context, config, colors.error, state),
      focusedErrorBorder: _getBorder(context, config, colors.error, state),
      disabledBorder: _getBorder(context, config, colors.disabled, state),
      counterText: '', // Hide default character counter
    );
  }

  /// Build icon wrapper with proper theming
  Widget _buildIcon(Widget icon, TextFieldSizeConfig config,
      _TextFieldColors colors, TextFieldCubitState state) {
    return IconTheme(
      data: IconThemeData(
        size: config.iconSize,
        color: !state.isEnabled || textField.isEffectivelyDisabled
            ? colors.disabled
            : colors.icon,
      ),
      child: icon,
    );
  }

  /// Get border based on variant and state with animation support
  InputBorder _getBorder(BuildContext context, TextFieldSizeConfig config,
      Color color, TextFieldCubitState state) {
    final borderRadius = textField.customBorderRadius ?? config.borderRadius;
    final borderWidth = _getBorderWidth(state);

    switch (textField.variant) {
      case TextFieldVariant.outlined:
        return OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: color, width: borderWidth),
        );
      case TextFieldVariant.filled:
        return OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(
              color: color.withValues(alpha: 0.3), width: borderWidth),
        );
      case TextFieldVariant.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: borderWidth),
        );
      case TextFieldVariant.borderless:
        return InputBorder.none;
    }
  }

  /// Get border width based on focus and hover state
  double _getBorderWidth(TextFieldCubitState state) {
    if (state.isFocused) return 2.0;
    if (state.isHovering && textField.enableHoverEffect) return 1.5;
    return 1.0;
  }

  /// Get input text style
  TextStyle _getInputTextStyle(BuildContext context, TextFieldSizeConfig config,
      _TextFieldColors colors, TextFieldCubitState state) {
    return (textField.textStyle ?? textField.size.getInputStyle(context))
        .copyWith(
      color: !state.isEnabled || textField.isEffectivelyDisabled
          ? colors.disabled
          : (textField.textColor ?? colors.text),
    );
  }

  /// Get hint text style
  TextStyle _getHintTextStyle(BuildContext context, TextFieldSizeConfig config,
      _TextFieldColors colors, TextFieldCubitState state) {
    return textField.size.getInputStyle(context).copyWith(
          color: textField.hintColor ?? colors.hint,
        );
  }

  /// Get text field colors based on theme and state
  _TextFieldColors _getTextFieldColors(
      BuildContext context, TextFieldCubitState state) {
    final baseColors = _TextFieldColors(
      text: textField.textColor ??
          (!state.isEnabled || textField.isEffectivelyDisabled
              ? OsmeaColors.steel
              : OsmeaColors.eclipse),
      hint: textField.hintColor ?? OsmeaColors.pewter,
      label: textField.labelColor ??
          (state.hasError ? OsmeaColors.amberFlame : OsmeaColors.slate),
      background: textField.backgroundColor ??
          (textField.variant == TextFieldVariant.filled
              ? OsmeaColors.ash
              : OsmeaColors.transparent),
      border: textField.borderColor ??
          (state.hasError ? OsmeaColors.amberFlame : OsmeaColors.silver),
      focus: textField.focusColor ?? OsmeaColors.nordicBlue,
      error: textField.errorColor ?? OsmeaColors.amberFlame,
      success: OsmeaColors.forestHeart,
      warning: OsmeaColors.sunsetGlow,
      helper: OsmeaColors.pewter,
      disabled: OsmeaColors.silver,
      icon: OsmeaColors.slate,
    );

    // Apply hover and focus color modifications
    if (state.isFocused) {
      return baseColors.copyWith(
        border: baseColors.focus,
        label: baseColors.focus,
      );
    }

    if (state.isHovering && textField.enableHoverEffect) {
      return baseColors.copyWith(
        border: Color.lerp(baseColors.border, baseColors.focus, 0.3),
      );
    }

    return baseColors;
  }

  /// Whether to show helper text
  bool _shouldShowHelperText(TextFieldCubitState state) {
    return textField.helperText != null ||
        textField.errorText != null ||
        state.hasError;
  }

  /// Get the text to display in helper area
  String _getDisplayHelperText(TextFieldCubitState state) {
    if (textField.errorText != null) return textField.errorText!;
    if (state.hasError) return state.errorMessage!;
    return textField.helperText ?? '';
  }

  /// Whether the helper text is an error
  bool _isErrorText(TextFieldCubitState state) {
    return textField.errorText != null || state.hasError || textField.hasError;
  }
}

/// Internal helper class for text field colors
class _TextFieldColors {
  const _TextFieldColors({
    required this.text,
    required this.hint,
    required this.label,
    required this.background,
    required this.border,
    required this.focus,
    required this.error,
    required this.success,
    required this.warning,
    required this.helper,
    required this.disabled,
    required this.icon,
  });

  final Color text;
  final Color hint;
  final Color label;
  final Color background;
  final Color border;
  final Color focus;
  final Color error;
  final Color success;
  final Color warning;
  final Color helper;
  final Color disabled;
  final Color icon;

  _TextFieldColors copyWith({
    Color? text,
    Color? hint,
    Color? label,
    Color? background,
    Color? border,
    Color? focus,
    Color? error,
    Color? success,
    Color? warning,
    Color? helper,
    Color? disabled,
    Color? icon,
  }) {
    return _TextFieldColors(
      text: text ?? this.text,
      hint: hint ?? this.hint,
      label: label ?? this.label,
      background: background ?? this.background,
      border: border ?? this.border,
      focus: focus ?? this.focus,
      error: error ?? this.error,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      helper: helper ?? this.helper,
      disabled: disabled ?? this.disabled,
      icon: icon ?? this.icon,
    );
  }
}
