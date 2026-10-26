import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/text/text.dart';
import 'package:osmea_components/src/core/container_widget.dart';

/// 🔘 **OSMEA Components Library**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive button component that implements all variants defined
/// in the OSMEA design system with full customization support.
///
/// {@category Components}
/// {@subCategory Buttons}
///
/// Features:
/// * 🎨 Multiple style variants (primary, secondary, outlined, ghost, success, warning, danger)
/// * 📏 Five size options (extraSmall to extraLarge)
/// * 🔄 Interactive states (enabled, disabled, loading, pressed, focused, hovered)
/// * 🎯 Flexible icon positioning (leading, trailing, top, bottom, only)
/// * 🎨 Complete color customization (background, text, border, hover, splash, disabled states)
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// ```dart
/// OsmeaButton(
///   text: 'Submit Form',
///   variant: ButtonVariant.primary,
///   size: ButtonSize.large,
///   icon: Icon(Icons.send),
///   backgroundColor: Colors.blue,
///   borderColor: Colors.blue.shade700,
///   disabledBackgroundColor: Colors.grey.shade300,
///   disabledTextColor: Colors.grey.shade600,
///   onPressed: () => _handleSubmit(),
/// )
/// ```
///
/// See also:
/// * [ButtonVariant] - Style variants enum
/// * [ButtonSize] - Size variants enum
/// * [ButtonState] - Interactive states enum
/// * [IconPosition] - Icon positioning enum

/// 🔘 **OsmeaButton**
///
/// A comprehensive button component for the OSMEA UI Kit.
/// Features animations, hover effects, and complete customization with optional icons.
///
/// ---
///
/// **Features:**
/// - � Multiple size variants (extraSmall to extraLarge)
/// - 🎨 Theme-aware colors and styles
/// - ✨ Built-in animations and hover effects
/// - 🎯 Loading and disabled states
/// - 🔧 Fully customizable
/// - 🎨 Leading and trailing icon support
///
/// ---
/// _Example:_
/// ```dart
/// OsmeaButton(
///   text: 'Click Me',
///   size: ButtonSize.medium,
///   onPressed: () => print('Pressed!'),
///   icon: Icon(Icons.arrow_forward),
///   iconPosition: IconPosition.trailing,
/// )
/// ```

class OsmeaButton extends CoreContainer {
  const OsmeaButton({
    super.key,
    super.customTheme,
    this.text,
    required this.onPressed,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.primary,
    this.state = ButtonState.enabled,
    this.shape = ButtonShape.rectangle,
    this.borderRadius,
    this.elevation = 0.0,
    this.icon,
    this.iconPosition = IconPosition.leading,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.hoverColor,
    this.splashColor,
    this.borderColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.disabledBorderColor,
    this.disabledHoverColor,
    this.disabledSplashColor,
    this.disabledFocusColor,
    this.disabledHighlightColor,
    this.disabledShadowColor,
    this.isUppercase = false,
    super.padding,
    super.margin,
    this.animationDuration,
    this.onLongPress,
    this.onHover,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.fullWidth = false,
  })  : assert(
          text != null || iconPosition == IconPosition.only,
          'Text is required unless iconPosition is IconPosition.only',
        ),
        assert(
          iconPosition != IconPosition.only || icon != null,
          'Icon is required when iconPosition is IconPosition.only',
        );

  /// 📝 The text label displayed on the button
  final String? text;

  /// 🖱️ Callback triggered when the button is pressed
  final VoidCallback? onPressed;

  /// 📏 The size of the button
  final ButtonSize size;

  /// 🎨 The visual style variant of the button
  final ButtonVariant variant;

  /// 🔲 The shape of the button
  final ButtonShape shape;

  /// � Custom border radius that overrides the default shape border radius
  final double? borderRadius;

  /// 🌟 Custom elevation (shadow depth). Default is 0.0 (no shadow).
  /// Set to higher values for more shadow depth.
  final double elevation;

  /// 🔄 The current interactive state of the button
  final ButtonState state;

  /// 🎯 Icon widget displayed in the button
  final Widget? icon;

  /// 📍 The position of icons relative to text
  final IconPosition iconPosition;

  /// 🎨 Custom text style that overrides the default button text style
  final TextStyle? textStyle;

  /// 🎯 Specific color for the button's text, overriding theme defaults
  final Color? textColor;

  /// 🎨 Custom background color that overrides the default variant background
  final Color? backgroundColor;

  /// ✨ Color displayed when the user hovers over the button
  final Color? hoverColor;

  /// 💫 Color shown during the splash animation when button is pressed
  final Color? splashColor;

  /// 🎨 Custom border color that overrides the default variant border color
  final Color? borderColor;

  /// 🎨 Custom disabled background color
  final Color? disabledBackgroundColor;

  /// 🎨 Custom disabled text color
  final Color? disabledTextColor;

  /// 🎨 Custom disabled border color
  final Color? disabledBorderColor;

  /// 🎨 Custom disabled hover color
  final Color? disabledHoverColor;

  /// 🎨 Custom disabled splash color
  final Color? disabledSplashColor;

  /// 🎨 Custom disabled focus color
  final Color? disabledFocusColor;

  /// 🎨 Custom disabled highlight color
  final Color? disabledHighlightColor;

  /// 🎨 Custom disabled shadow color
  final Color? disabledShadowColor;

  /// When true, converts the button text to uppercase
  final bool isUppercase;

  /// ⏱️ Duration for button animations (hover, press effects)
  final Duration? animationDuration;

  /// Callback triggered when the button is long-pressed
  final VoidCallback? onLongPress;

  /// Callback triggered when hover state changes
  final ValueChanged<bool>? onHover;

  /// 🎯 Node for managing the focus state of the button
  final FocusNode? focusNode;

  /// 🔵 When true, the button will automatically request focus when displayed
  final bool autofocus;

  /// 💬 Tooltip text shown on hover
  final String? tooltip;

  /// ↔️ Whether the button should take the full width of its parent
  final bool fullWidth;

  // Computed properties based on state
  bool get isLoading => state == ButtonState.loading;
  bool get isDisabled => state == ButtonState.disabled;
  bool get isPressed => state == ButtonState.pressed;
  bool get isFocused => state == ButtonState.focused;
  bool get isHovered => state == ButtonState.hovered;
  bool get isEffectivelyDisabled =>
      isDisabled || isLoading || onPressed == null;
  bool get isInteractive =>
      !isEffectivelyDisabled && (isPressed || isFocused || isHovered);

  @override
  Widget buildWidget(BuildContext context) {
    final config = size.config(context);
    final colors = _getButtonColors(context);

    Widget button = _buildButton(context, config, colors);

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        decoration: BoxDecoration(
          color: OsmeaColors.eclipse,
          borderRadius: context.borderRadiusLow,
        ),
        textStyle: OsmeaTextStyle.labelSmall(context).copyWith(
          color: OsmeaColors.white,
        ),
        child: button,
      );
    }

    return button;
  }

  Widget _buildButton(
    BuildContext context,
    ButtonSizeConfig config,
    _ButtonColors colors,
  ) {
    final effectiveBorderRadius = borderRadius != null
        ? BorderRadius.circular(borderRadius!)
        : shape.getBorderRadius(context, config.size.height);

    return AnimatedContainer(
      duration: animationDuration ?? context.animationMedium,
      curve: easeInOutCubic,
      child: Material(
        color: OsmeaColors.transparent,
        elevation: _getElevation(),
        shadowColor: OsmeaColors.shadowDark,
        borderRadius: effectiveBorderRadius,
        child: InkWell(
          onTap: isEffectivelyDisabled ? null : onPressed,
          onLongPress: isEffectivelyDisabled ? null : onLongPress,
          onHover: onHover,
          focusNode: focusNode,
          autofocus: autofocus,
          splashColor: colors.splash,
          highlightColor: colors.hover,
          borderRadius: effectiveBorderRadius,
          child: AnimatedContainer(
            duration: animationDuration ?? context.animationMedium,
            curve: easeInOutCubic,
            constraints: shape == ButtonShape.circular
                ? BoxConstraints.tightFor(
                    width: config.size.height,
                    height: config.size.height,
                  )
                : BoxConstraints(
                    minWidth: fullWidth ? double.infinity : 0,
                    minHeight: config.size.height,
                  ),
            padding: _getEffectivePadding(config),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: effectiveBorderRadius,
              border: _getBorder(colors, context),
            ),
            transform: isPressed
                ? (Matrix4.identity()..scale(0.96))
                : (isHovered ? (Matrix4.identity()..scale(1.02)) : null),
            child: _buildContent(context, config, colors),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ButtonSizeConfig config,
    _ButtonColors colors,
  ) {
    if (isLoading) {
      return _buildLoadingContent(context, config, colors);
    }

    final textWidget =
        text != null ? _buildText(context, colors) : context.emptySizedBox;

    // Handle different icon positions with proper overflow handling
    return IntrinsicWidth(
      child: _buildContentLayout(textWidget, config, colors, context),
    );
  }

  Widget _buildContentLayout(
    Widget textWidget,
    ButtonSizeConfig config,
    _ButtonColors colors,
    BuildContext context,
  ) {
    switch (iconPosition) {
      case IconPosition.leading:
        return Row(
          mainAxisSize: fullWidth ? max : min,
          mainAxisAlignment: centerMain,
          crossAxisAlignment: crossCenter,
          children: [
            if (icon != null) ...[
              _buildIcon(context, icon!, config, colors),
              SizedBox(width: context.lowValue),
            ],
            Flexible(child: textWidget),
          ],
        );
      case IconPosition.trailing:
        return Row(
          mainAxisSize: fullWidth ? max : min,
          mainAxisAlignment: centerMain,
          crossAxisAlignment: crossCenter,
          children: [
            Flexible(child: textWidget),
            if (icon != null) ...[
              SizedBox(width: context.lowValue),
              _buildIcon(context, icon!, config, colors),
            ],
          ],
        );
      case IconPosition.top:
        return Column(
          mainAxisSize: min,
          mainAxisAlignment: centerMain,
          crossAxisAlignment: crossCenter,
          children: [
            if (icon != null) ...[
              _buildIcon(context, icon!, config, colors),
              SizedBox(height: context.lowValue / 2),
            ],
            textWidget,
          ],
        );
      case IconPosition.bottom:
        return Column(
          mainAxisSize: min,
          mainAxisAlignment: centerMain,
          crossAxisAlignment: crossCenter,
          children: [
            textWidget,
            if (icon != null) ...[
              SizedBox(height: context.lowValue / 2),
              _buildIcon(context, icon!, config, colors),
            ],
          ],
        );
      case IconPosition.only:
        return Center(
          child: _buildIcon(context, icon!, config, colors),
        );
    }
  }

  Widget _buildText(BuildContext context, _ButtonColors colors) {
    if (iconPosition == IconPosition.only) {
      return context.emptySizedBox;
    }

    final textVariant = _getTextVariant();
    final baseStyle = OsmeaTextStyle.fromVariant(context, textVariant);

    return Text(
      isUppercase ? text!.toUpperCase() : text!,
      style: (textStyle ?? baseStyle).copyWith(
        color: _getEffectiveTextColor(colors, context),
        fontWeight: context.semiBold,
        letterSpacing: context.letterSpacingWide,
      ),
      textAlign: textCenter,
      overflow: ellipsis,
      maxLines: 1,
    );
  }

  OsmeaTextVariant _getTextVariant() {
    switch (size) {
      case ButtonSize.extraSmall:
      case ButtonSize.small:
        return OsmeaTextVariant.buttonSmall;
      case ButtonSize.medium:
        return OsmeaTextVariant.buttonMedium;
      case ButtonSize.large:
      case ButtonSize.extraLarge:
        return OsmeaTextVariant.buttonLarge;
    }
  }

  Color _getEffectiveTextColor(_ButtonColors colors, BuildContext context) {
    if (isEffectivelyDisabled) {
      return colors.disabledText;
    } else if (isPressed) {
      return colors.text.withValues(alpha: context.alpha90);
    } else if (isHovered) {
      return colors.text;
    } else {
      return textColor ?? colors.text;
    }
  }

  Widget _buildIcon(BuildContext context, Widget iconWidget,
      ButtonSizeConfig config, _ButtonColors colors) {
    return AnimatedContainer(
      duration: context.animationMedium,
      child: IconTheme(
        data: IconThemeData(
          size: config.iconSize,
          color: _getEffectiveTextColor(colors, context),
        ),
        child: iconWidget,
      ),
    );
  }

  Widget _buildLoadingContent(
      BuildContext context, ButtonSizeConfig config, _ButtonColors colors) {
    return Row(
      mainAxisSize: fullWidth ? max : min,
      mainAxisAlignment: centerMain,
      children: [
        SizedBox(
          width: config.iconSize,
          height: config.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: context.width2,
            valueColor: AlwaysStoppedAnimation<Color>(colors.text),
            backgroundColor: colors.text.withValues(alpha: context.alpha20),
          ),
        ),
        if (text != null) ...[
          SizedBox(width: context.lowValue),
          Flexible(
            child: OsmeaText(
              'Loading...',
              style: textStyle ??
                  OsmeaTextStyle.fromVariant(context, _getTextVariant())
                      .copyWith(
                    color: colors.text,
                    fontWeight: context.medium,
                  ),
              overflow: ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ],
    );
  }

  Border? _getBorder(_ButtonColors colors, BuildContext context) {
    if (variant == ButtonVariant.outlined) {
      return Border.all(
        color: isEffectivelyDisabled
            ? colors.disabled
            : (borderColor ?? colors.border),
        width: context.width1,
      );
    }

    if (isFocused && !isEffectivelyDisabled) {
      return Border.all(
        color: borderColor ?? colors.text,
        width: context.width2,
      );
    }

    return null;
  }

  double _getElevation() {
    return elevation;
  }

  _ButtonColors _getButtonColors(BuildContext context) {
    // Modern color scheme using only OsmeaColors
    switch (variant) {
      case ButtonVariant.primary:
        return _ButtonColors(
          background: backgroundColor ??
              (isEffectivelyDisabled
                  ? OsmeaColors.silver
                  : (isPressed
                      ? OsmeaColors.atlantic
                      : OsmeaColors.nordicBlue)),
          text: isEffectivelyDisabled ? OsmeaColors.steel : OsmeaColors.white,
          border: borderColor ?? OsmeaColors.nordicBlue,
          hover: OsmeaColors.deepSea,
          splash: OsmeaColors.crystalBay,
          disabled: disabledBackgroundColor ?? OsmeaColors.silver,
          disabledText: disabledTextColor ?? OsmeaColors.steel,
          disabledBorder: disabledBorderColor ?? OsmeaColors.silver,
          disabledHover: disabledHoverColor ?? OsmeaColors.ash,
          disabledSplash: disabledSplashColor ?? OsmeaColors.ash,
          disabledFocus: disabledFocusColor ?? OsmeaColors.ash,
          disabledHighlight: disabledHighlightColor ?? OsmeaColors.ash,
          disabledShadow: disabledShadowColor ?? OsmeaColors.ash,
        );

      case ButtonVariant.secondary:
        return _ButtonColors(
          background: backgroundColor ??
              (isEffectivelyDisabled
                  ? OsmeaColors.ash
                  : (isPressed ? OsmeaColors.steel : OsmeaColors.pewter)),
          text: isEffectivelyDisabled ? OsmeaColors.steel : OsmeaColors.white,
          border: borderColor ?? OsmeaColors.pewter,
          hover: OsmeaColors.slate,
          splash: OsmeaColors.ash,
          disabled: disabledBackgroundColor ?? OsmeaColors.ash,
          disabledText: disabledTextColor ?? OsmeaColors.steel,
          disabledBorder: disabledBorderColor ?? OsmeaColors.ash,
          disabledHover: disabledHoverColor ?? OsmeaColors.ash,
          disabledSplash: disabledSplashColor ?? OsmeaColors.ash,
          disabledFocus: disabledFocusColor ?? OsmeaColors.ash,
          disabledHighlight: disabledHighlightColor ?? OsmeaColors.ash,
          disabledShadow: disabledShadowColor ?? OsmeaColors.ash,
        );

      case ButtonVariant.outlined:
        return _ButtonColors(
          background: OsmeaColors.transparent,
          text: isEffectivelyDisabled
              ? OsmeaColors.steel
              : OsmeaColors.nordicBlue,
          border: isEffectivelyDisabled
              ? OsmeaColors.silver
              : (borderColor ?? OsmeaColors.nordicBlue),
          hover: OsmeaColors.crystalBay.withValues(alpha: context.alpha20),
          splash: OsmeaColors.crystalBay.withValues(alpha: context.alpha30),
          disabled: disabledBackgroundColor ?? OsmeaColors.transparent,
          disabledText: disabledTextColor ?? OsmeaColors.steel,
          disabledBorder: disabledBorderColor ?? OsmeaColors.silver,
          disabledHover: disabledHoverColor ?? OsmeaColors.ash,
          disabledSplash: disabledSplashColor ?? OsmeaColors.ash,
          disabledFocus: disabledFocusColor ?? OsmeaColors.ash,
          disabledHighlight: disabledHighlightColor ?? OsmeaColors.ash,
          disabledShadow: disabledShadowColor ?? OsmeaColors.ash,
        );

      case ButtonVariant.ghost:
        return _ButtonColors(
          background: OsmeaColors.transparent,
          text: isEffectivelyDisabled ? OsmeaColors.steel : OsmeaColors.pewter,
          border: borderColor ?? OsmeaColors.transparent,
          hover: OsmeaColors.ash,
          splash: OsmeaColors.silver,
          disabled: disabledBackgroundColor ?? OsmeaColors.transparent,
          disabledText: disabledTextColor ?? OsmeaColors.steel,
          disabledBorder: disabledBorderColor ?? OsmeaColors.transparent,
          disabledHover: disabledHoverColor ?? OsmeaColors.ash,
          disabledSplash: disabledSplashColor ?? OsmeaColors.ash,
          disabledFocus: disabledFocusColor ?? OsmeaColors.ash,
          disabledHighlight: disabledHighlightColor ?? OsmeaColors.ash,
          disabledShadow: disabledShadowColor ?? OsmeaColors.ash,
        );

      case ButtonVariant.success:
        return _ButtonColors(
          background: OsmeaColors.forestHeart,
          text: isEffectivelyDisabled ? OsmeaColors.steel : OsmeaColors.white,
          border: borderColor ?? OsmeaColors.forestHeart,
          hover: OsmeaColors.springLeaf,
          splash: OsmeaColors.pineGrove,
          disabled: disabledBackgroundColor ?? OsmeaColors.ash,
          disabledText: disabledTextColor ?? OsmeaColors.steel,
          disabledBorder: disabledBorderColor ?? OsmeaColors.ash,
          disabledHover: disabledHoverColor ?? OsmeaColors.ash,
          disabledSplash: disabledSplashColor ?? OsmeaColors.ash,
          disabledFocus: disabledFocusColor ?? OsmeaColors.ash,
          disabledHighlight: disabledHighlightColor ?? OsmeaColors.ash,
          disabledShadow: disabledShadowColor ?? OsmeaColors.ash,
        );

      case ButtonVariant.warning:
        return _ButtonColors(
          background: OsmeaColors.sunsetGlow,
          text: isEffectivelyDisabled ? OsmeaColors.steel : OsmeaColors.white,
          border: borderColor ?? OsmeaColors.sunsetGlow,
          hover: OsmeaColors.amberFlame,
          splash: OsmeaColors.goldenHour,
          disabled: disabledBackgroundColor ?? OsmeaColors.ash,
          disabledText: disabledTextColor ?? OsmeaColors.steel,
          disabledBorder: disabledBorderColor ?? OsmeaColors.ash,
          disabledHover: disabledHoverColor ?? OsmeaColors.ash,
          disabledSplash: disabledSplashColor ?? OsmeaColors.ash,
          disabledFocus: disabledFocusColor ?? OsmeaColors.ash,
          disabledHighlight: disabledHighlightColor ?? OsmeaColors.ash,
          disabledShadow: disabledShadowColor ?? OsmeaColors.ash,
        );

      case ButtonVariant.danger:
        return _ButtonColors(
          background: OsmeaColors.amberFlame,
          text: isEffectivelyDisabled ? OsmeaColors.steel : OsmeaColors.white,
          border: borderColor ?? OsmeaColors.shark,
          hover: OsmeaColors.eclipse,
          splash: OsmeaColors.silver,
          disabled: disabledBackgroundColor ?? OsmeaColors.ash,
          disabledText: disabledTextColor ?? OsmeaColors.steel,
          disabledBorder: disabledBorderColor ?? OsmeaColors.ash,
          disabledHover: disabledHoverColor ?? OsmeaColors.ash,
          disabledSplash: disabledSplashColor ?? OsmeaColors.ash,
          disabledFocus: disabledFocusColor ?? OsmeaColors.ash,
          disabledHighlight: disabledHighlightColor ?? OsmeaColors.ash,
          disabledShadow: disabledShadowColor ?? OsmeaColors.ash,
        );

    }
  }

  /// Get effective padding based on shape
  EdgeInsetsGeometry _getEffectivePadding(ButtonSizeConfig config) {
    if (padding != null) return padding!;

    // For circular shapes with icon only, use symmetric padding for perfect centering
    if (shape == ButtonShape.circular && iconPosition == IconPosition.only) {
      return EdgeInsets.zero; // No padding for perfect circular centering
    }

    return config.padding;
  }
}

/// Internal helper class for button colors
class _ButtonColors {
  final Color background;
  final Color text;
  final Color border;
  final Color hover;
  final Color splash;
  final Color disabled;
  final Color disabledText;
  final Color disabledBorder;
  final Color disabledHover;
  final Color disabledSplash;
  final Color disabledFocus;
  final Color disabledHighlight;
  final Color disabledShadow;

  const _ButtonColors({
    required this.background,
    required this.text,
    required this.border,
    required this.hover,
    required this.splash,
    required this.disabled,
    required this.disabledText,
    required this.disabledBorder,
    required this.disabledHover,
    required this.disabledSplash,
    required this.disabledFocus,
    required this.disabledHighlight,
    required this.disabledShadow,
  });
}

/// 📝 **OSMEA Text Button**
///
/// A specialized button component optimized for text-only buttons.
/// Extends the base OsmeaButton with text-specific defaults.
///
/// ```dart
/// OsmeaTextButton(
///   text: 'Click me',
///   variant: ButtonVariant.primary,
///   onPressed: () => print('Clicked!'),
/// )
/// ```
class OsmeaTextButton extends OsmeaButton {
  const OsmeaTextButton({
    super.key,
    required String text,
    super.variant,
    super.size,
    super.state,
    super.borderRadius,
    super.elevation,
    super.onPressed,
    super.onLongPress,
    super.tooltip,
    super.autofocus,
    super.customTheme,
    super.fullWidth,
    super.backgroundColor,
    super.borderColor,
    super.disabledBackgroundColor,
    super.disabledTextColor,
    super.disabledBorderColor,
    super.disabledHoverColor,
    super.disabledSplashColor,
    super.disabledFocusColor,
    super.disabledHighlightColor,
    super.disabledShadowColor,
  }) : super(text: text);
}

/// 🎯 **OSMEA Icon Button**
///
/// A specialized button component optimized for icon-only buttons.
/// Extends the base OsmeaButton with icon-specific defaults.
///
/// ```dart
/// OsmeaIconButton(
///   icon: Icon(Icons.favorite),
///   variant: ButtonVariant.ghost,
///   shape: ButtonShape.circular, // Perfect for icon buttons
///   onPressed: () => _toggleFavorite(),
/// )
/// ```
class OsmeaIconButton extends OsmeaButton {
  const OsmeaIconButton({
    super.key,
    required Widget icon,
    super.variant,
    super.size,
    super.state,
    ButtonShape? shape, // Custom shape parameter for icon buttons
    super.borderRadius,
    super.elevation,
    super.onPressed,
    super.onLongPress,
    super.tooltip,
    super.autofocus,
    super.customTheme,
    super.backgroundColor,
    super.borderColor,
    super.disabledBackgroundColor,
    super.disabledTextColor,
    super.disabledBorderColor,
    super.disabledHoverColor,
    super.disabledSplashColor,
    super.disabledFocusColor,
    super.disabledHighlightColor,
    super.disabledShadowColor,
  }) : super(
          icon: icon,
          iconPosition: IconPosition.only,
          shape: shape ??
              ButtonShape.circular, // Default to circular for icon buttons
        );
}
