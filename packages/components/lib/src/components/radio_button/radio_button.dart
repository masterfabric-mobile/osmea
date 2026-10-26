import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/core/container_widget.dart';

/// 🔘 **OSMEA Radio**
///
/// A modern, customizable radio button component with multiple styles and variants.
/// Supports comprehensive selection functionality with rich visual feedback.
class OsmeaRadio<T> extends CoreContainer {
  const OsmeaRadio({
    super.key,
    super.customTheme,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.size = RadioSize.medium,
    this.variant = RadioVariant.simple,
    this.state = RadioState.enabled,
    this.style = RadioStyle.modern,
    this.label,
    this.description,
    this.labelPosition = RadioLabelPosition.trailing,
    this.activeColor,
    this.inactiveColor,
    this.dotColor,
    this.borderColor,
    this.focusColor,
    this.hoverColor,
    super.padding,
    super.margin,
    this.animationDuration,
    this.onHover,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.fullWidth = false,
  });

  /// 🎯 The value represented by this radio button
  final T value;

  /// 🔄 The currently selected value for this group of radio buttons
  final T? groupValue;

  /// 🖱️ Callback triggered when the radio button is selected
  final ValueChanged<T?>? onChanged;

  /// 📏 The size of the radio button
  final RadioSize size;

  /// 🎨 The visual style variant of the radio button
  final RadioVariant variant;

  /// 🔄 The current interactive state of the radio button
  final RadioState state;

  /// 🎭 The visual style of the radio button
  final RadioStyle style;

  /// 🏷️ Optional text label displayed next to the radio button
  final String? label;

  /// 📝 Optional description text displayed below the label
  final String? description;

  /// 📍 Position of the label relative to the radio button
  final RadioLabelPosition labelPosition;

  /// 🎨 Custom active state color
  final Color? activeColor;

  /// 🎨 Custom inactive state color
  final Color? inactiveColor;

  /// 🎯 Custom inner dot color
  final Color? dotColor;

  /// 🔲 Custom border color
  final Color? borderColor;

  /// 🎯 Color displayed when the radio button has focus
  final Color? focusColor;

  /// ✨ Color displayed when the user hovers over the radio button
  final Color? hoverColor;

  /// ⏱️ Duration for radio button animations
  final Duration? animationDuration;

  /// 🖱️ Callback triggered when hover state changes
  final ValueChanged<bool>? onHover;

  /// 🎯 Node for managing the focus state of the radio button
  final FocusNode? focusNode;

  /// 🔵 When true, the radio button will automatically request focus when displayed
  final bool autofocus;

  /// ♿ Semantic label for accessibility
  final String? semanticLabel;

  /// ↔️ Whether the radio button container should take the full width of its parent
  final bool fullWidth;

  // Computed properties based on state
  bool get isSelected => value == groupValue;
  bool get isDisabled => state == RadioState.disabled;
  bool get isFocused => state == RadioState.focused;
  bool get isHovered => state == RadioState.hovered;
  bool get isEffectivelyDisabled => isDisabled || onChanged == null;

  @override
  Widget buildWidget(BuildContext context) {
    final config = size.config(context);
    final colors = _getRadioColors(context);

    Widget radioWidget = _buildRadio(context, config, colors);

    // Show label according to the variant
    if ((variant == RadioVariant.labeled ||
            variant == RadioVariant.extended ||
            variant == RadioVariant.card ||
            variant == RadioVariant.tile) &&
        (label != null || description != null)) {
      radioWidget = _buildWithLabel(context, radioWidget, colors);
    }

    if (margin != null) {
      radioWidget = Padding(padding: margin!, child: radioWidget);
    }

    if (semanticLabel != null) {
      radioWidget = Semantics(
        label: semanticLabel!,
        value: isSelected ? 'Selected' : 'Not selected',
        onTap: isEffectivelyDisabled ? null : () => onChanged?.call(value),
        child: radioWidget,
      );
    }

    return radioWidget;
  }

  Widget _buildRadio(
    BuildContext context,
    RadioSizeConfig config,
    _RadioColors colors,
  ) {
    return AnimatedContainer(
      duration: animationDuration ?? const Duration(milliseconds: 200),
      curve: Curves.easeInOutCubic,
      child: Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        onFocusChange: (focused) {
          // Note: Since this is now stateless, we cannot track focus state
          // The focus behavior will be handled by the focus node itself
        },
        child: GestureDetector(
          onTap: isEffectivelyDisabled ? null : () => onChanged?.call(value),
          child: MouseRegion(
            cursor: isEffectivelyDisabled
                ? SystemMouseCursors.forbidden
                : SystemMouseCursors.click,
            onEnter: (event) {
              onHover?.call(true);
            },
            onExit: (event) {
              onHover?.call(false);
            },
            child: _buildRadioCircle(context, config, colors),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioCircle(
    BuildContext context,
    RadioSizeConfig config,
    _RadioColors colors,
  ) {
    return AnimatedContainer(
      duration: animationDuration ?? const Duration(milliseconds: 200),
      curve: easeInOutCubic,
      width: config.outerSize,
      height: config.outerSize,
      decoration: _getOuterDecoration(context, config, colors),
      child: Center(
        child: AnimatedContainer(
          duration: animationDuration ?? const Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic,
          width: isSelected ? config.innerSize : context.widthZero,
          height: isSelected ? config.innerSize : context.widthZero,
          decoration: _getInnerDecoration(context, config, colors),
        ),
      ),
    );
  }

  Widget _buildWithLabel(
    BuildContext context,
    Widget radioWidget,
    _RadioColors colors,
  ) {
    Widget labelWidget = _buildLabelWidget(context, colors);

    List<Widget> children = labelPosition == RadioLabelPosition.leading
        ? [labelWidget, radioWidget]
        : [radioWidget, labelWidget];

    Widget content = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );

    // For card and tile variants, wrap in container
    if (variant == RadioVariant.card || variant == RadioVariant.tile) {
      content = _wrapInContainer(context, content, colors);
    }

    return content;
  }

  Widget _buildLabelWidget(BuildContext context, _RadioColors colors) {
    return Expanded(
      flex: fullWidth ? 1 : 0,
      child: Padding(
        padding: labelPosition == RadioLabelPosition.leading
            ? context.onlyRightPaddingLow
            : context.onlyLeftPaddingLow,
        child: Column(
          crossAxisAlignment: crossStart,
          mainAxisSize: min,
          children: [
            if (label != null)
              Text(
                label!,
                style: _getEffectiveLabelStyle(context).copyWith(
                  color:
                      isEffectivelyDisabled ? colors.disabledText : colors.text,
                ),
              ),
            if (description != null) ...[
              context.emptySizedHeightBoxLow,
              Text(
                description!,
                style: _getEffectiveDescriptionStyle(context).copyWith(
                  color: isEffectivelyDisabled
                      ? colors.disabledText
                      : colors.text.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _wrapInContainer(
    BuildContext context,
    Widget content,
    _RadioColors colors,
  ) {
    return AnimatedContainer(
      duration: animationDuration ?? context.animationMedium,
      curve: Curves.easeInOutCubic,
      width: fullWidth ? double.infinity : null,
      padding: variant == RadioVariant.tile
          ? context.paddingNormal
          : context.paddingLow,
      decoration: _getContainerDecoration(context, colors),
      child: content,
    );
  }

  BoxDecoration _getOuterDecoration(
    BuildContext context,
    RadioSizeConfig config,
    _RadioColors colors,
  ) {
    final baseColor = isSelected ? colors.activeOuter : colors.inactiveOuter;
    final borderColor =
        isSelected ? colors.activeBorder : colors.inactiveBorder;

    switch (style) {
      case RadioStyle.material:
        return BoxDecoration(
          color: baseColor,
          shape: circleShape,
          border: Border.all(
            color: borderColor,
            width: config.borderWidth,
          ),
          boxShadow: isFocused && !isEffectivelyDisabled
              ? [
                  BoxShadow(
                    color: colors.focus.withValues(alpha: context.alpha30),
                    offset: context.offsetZero,
                    blurRadius: context.blurRadius8,
                    spreadRadius: context.spacing2,
                  ),
                ]
              : null,
        );

      case RadioStyle.cupertino:
        return BoxDecoration(
          color: baseColor,
          shape: circleShape,
          border: Border.all(
            color: borderColor,
            width: config.borderWidth,
          ),
        );

      case RadioStyle.modern:
        return BoxDecoration(
          color: baseColor,
          shape: circleShape,
          border: Border.all(
            color: borderColor,
            width: config.borderWidth,
          ),
          boxShadow: isHovered && !isEffectivelyDisabled
              ? [
                  BoxShadow(
                    color: colors.hover.withValues(alpha: context.alpha20),
                    offset: context.shadowOffsetNormal,
                    blurRadius: context.blurRadius8,
                    spreadRadius: context.spacingZero,
                  ),
                ]
              : null,
        );
      case RadioStyle.glassmorphism:
        return BoxDecoration(
          color: baseColor.withValues(alpha: context.alpha20),
          shape: circleShape,
          border: Border.all(
            color: OsmeaColors.white.withValues(alpha: context.alpha30),
            width: config.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.shadowLight.withValues(alpha: context.alpha10),
              offset: context.offsetVertical8,
              blurRadius: context.blurRadius8,
              spreadRadius: context.spacingZero,
            ),
          ],
        );

      case RadioStyle.minimal:
        return BoxDecoration(
          color: baseColor,
          shape: circleShape,
          border: Border.all(
            color: isFocused && !isEffectivelyDisabled
                ? colors.focus
                : borderColor,
            width: config.borderWidth,
          ),
        );

      case RadioStyle.custom:
        return BoxDecoration(
          color: baseColor,
          shape: circleShape,
          border: Border.all(
            color: borderColor,
            width: config.borderWidth,
          ),
        );
    }
  }

  BoxDecoration _getInnerDecoration(
    BuildContext context,
    RadioSizeConfig config,
    _RadioColors colors,
  ) {
    return BoxDecoration(
      color: colors.innerDot,
      shape: BoxShape.circle,
    );
  }

  BoxDecoration _getContainerDecoration(
    BuildContext context,
    _RadioColors colors,
  ) {
    switch (variant) {
      case RadioVariant.card:
        return BoxDecoration(
          color: isSelected ? colors.activeContainer : colors.inactiveContainer,
          borderRadius: context.borderRadiusLow,
          border: Border.all(
            color: isSelected ? colors.activeBorder : colors.inactiveBorder,
            width: context.width1,
          ),
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.shadowLight.withValues(alpha: context.alpha10),
              offset: context.offsetVertical2,
              blurRadius: context.blurRadius8,
              spreadRadius: context.spacingZero,
            ),
          ],
        );

      case RadioVariant.tile:
        return BoxDecoration(
          color: isSelected ? colors.activeContainer : colors.inactiveContainer,
          borderRadius: context.borderRadiusLow,
          border: isSelected
              ? Border.all(
                  color: colors.activeBorder,
                  width: context.width1,
                )
              : null,
        );

      default:
        return const BoxDecoration();
    }
  }

  TextStyle _getEffectiveLabelStyle(BuildContext context) {
    switch (size) {
      case RadioSize.small:
        return OsmeaTextStyle.labelSmall(context);
      case RadioSize.medium:
        return OsmeaTextStyle.labelMedium(context);
      case RadioSize.large:
        return OsmeaTextStyle.labelLarge(context);
    }
  }

  TextStyle _getEffectiveDescriptionStyle(BuildContext context) {
    return OsmeaTextStyle.captionMedium(context);
  }

  _RadioColors _getRadioColors(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = activeColor ?? theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;

    return _RadioColors(
      activeOuter: primaryColor.withValues(alpha: context.alpha10),
      inactiveOuter: surfaceColor,
      activeBorder: primaryColor,
      inactiveBorder: onSurfaceColor.withValues(alpha: context.alpha30),
      innerDot: dotColor ?? primaryColor,
      text: onSurfaceColor,
      focus: focusColor ?? primaryColor.withValues(alpha: context.alpha80),
      hover: hoverColor ?? primaryColor.withValues(alpha: context.alpha10),
      disabledText: onSurfaceColor.withValues(alpha: context.alpha40),
      activeContainer: primaryColor.withValues(alpha: context.alpha10),
      inactiveContainer: surfaceColor,
    );
  }
}

/// Internal helper class for radio button colors
class _RadioColors {
  final Color activeOuter;
  final Color inactiveOuter;
  final Color activeBorder;
  final Color inactiveBorder;
  final Color innerDot;
  final Color text;
  final Color focus;
  final Color hover;
  final Color disabledText;
  final Color activeContainer;
  final Color inactiveContainer;

  const _RadioColors({
    required this.activeOuter,
    required this.inactiveOuter,
    required this.activeBorder,
    required this.inactiveBorder,
    required this.innerDot,
    required this.text,
    required this.focus,
    required this.hover,
    required this.disabledText,
    required this.activeContainer,
    required this.inactiveContainer,
  });
}

/// 🏷️ **OSMEA Labeled Radio**
class OsmeaLabeledRadio<T> extends OsmeaRadio<T> {
  const OsmeaLabeledRadio({
    super.key,
    required super.value,
    required super.groupValue,
    required String label,
    String? description,
    super.size,
    super.state,
    super.onChanged,
    super.labelPosition,
    super.customTheme,
    super.fullWidth,
    super.activeColor,
    super.inactiveColor,
    super.style,
  }) : super(
          label: label,
          description: description,
          variant: RadioVariant.labeled,
        );
}

/// 🎯 **OSMEA Simple Radio**
class OsmeaSimpleRadio<T> extends OsmeaRadio<T> {
  const OsmeaSimpleRadio({
    super.key,
    required super.value,
    required super.groupValue,
    super.size,
    super.state,
    super.onChanged,
    super.customTheme,
    super.activeColor,
    super.inactiveColor,
    super.style,
  }) : super(
          variant: RadioVariant.simple,
        );
}

/// 📦 **OSMEA Card Radio**
class OsmeaCardRadio<T> extends OsmeaRadio<T> {
  const OsmeaCardRadio({
    super.key,
    required super.value,
    required super.groupValue,
    required String label,
    String? description,
    super.size,
    super.state,
    super.onChanged,
    super.labelPosition,
    super.customTheme,
    super.fullWidth = true,
    super.activeColor,
    super.inactiveColor,
    super.style,
  }) : super(
          label: label,
          description: description,
          variant: RadioVariant.card,
        );
}

/// 📋 **OSMEA Tile Radio**
class OsmeaTileRadio<T> extends OsmeaRadio<T> {
  const OsmeaTileRadio({
    super.key,
    required super.value,
    required super.groupValue,
    required String label,
    String? description,
    super.size,
    super.state,
    super.onChanged,
    super.labelPosition,
    super.customTheme,
    super.fullWidth = true,
    super.activeColor,
    super.inactiveColor,
    super.style,
  }) : super(
          label: label,
          description: description,
          variant: RadioVariant.tile,
        );
}
