import 'package:flutter/material.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/text/text.dart';
import 'package:osmea_components/src/core/container_widget.dart';

/// 🔄 **OSMEA Switch**
///
/// A modern, customizable switch component with multiple styles and variants.
/// Supports all the visual styles from the attached design reference.
class OsmeaSwitch extends CoreContainer {
  const OsmeaSwitch({
    super.key,
    super.customTheme,
    required this.value,
    required this.onChanged,
    this.size = SwitchSize.medium,
    this.variant = SwitchVariant.simple,
    this.state = SwitchState.enabled,
    this.style = SwitchStyle.modern,
    this.label,
    this.description,
    this.labelPosition = SwitchLabelPosition.trailing,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.trackColor,
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

  /// 🔄 The current state of the switch (true = on, false = off)
  final bool value;

  /// 🖱️ Callback triggered when the switch state changes
  final ValueChanged<bool>? onChanged;

  /// 📏 The size of the switch
  final SwitchSize size;

  /// 🎨 The visual style variant of the switch
  final SwitchVariant variant;

  /// 🔄 The current interactive state of the switch
  final SwitchState state;

  /// 🎭 The visual style of the switch
  final SwitchStyle style;

  /// 🏷️ Optional text label displayed next to the switch
  final String? label;

  /// 📝 Optional description text displayed below the label
  final String? description;

  /// 📍 Position of the label relative to the switch
  final SwitchLabelPosition labelPosition;

  /// 🎨 Custom active state color
  final Color? activeColor;

  /// 🎨 Custom inactive state color
  final Color? inactiveColor;

  /// 🎯 Custom thumb color
  final Color? thumbColor;

  /// 🛤️ Custom track color
  final Color? trackColor;

  /// 🎯 Color displayed when the switch has focus
  final Color? focusColor;

  /// ✨ Color displayed when the user hovers over the switch
  final Color? hoverColor;

  /// ⏱️ Duration for switch animations
  final Duration? animationDuration;

  /// 🖱️ Callback triggered when hover state changes
  final ValueChanged<bool>? onHover;

  /// 🎯 Node for managing the focus state of the switch
  final FocusNode? focusNode;

  /// 🔵 When true, the switch will automatically request focus when displayed
  final bool autofocus;

  /// ♿ Semantic label for accessibility
  final String? semanticLabel;

  /// ↔️ Whether the switch container should take the full width of its parent
  final bool fullWidth;

  // Computed properties based on state
  bool get isDisabled => state == SwitchState.disabled;
  bool get isFocused => state == SwitchState.focused;
  bool get isHovered => state == SwitchState.hovered;
  bool get isEffectivelyDisabled => isDisabled || onChanged == null;

  @override
  Widget buildWidget(BuildContext context) {
    final config = size.config(context);
    final colors = _getSwitchColors(context);

    Widget switchWidget = _buildSwitch(context, config, colors);

    // Show label according to the variant
    if ((variant == SwitchVariant.labeled ||
            variant == SwitchVariant.extended ||
            variant == SwitchVariant.card) &&
        (label != null || description != null)) {
      switchWidget = _buildWithLabel(context, switchWidget, colors);
    }

    if (margin != null) {
      switchWidget = Padding(padding: margin!, child: switchWidget);
    }

    if (semanticLabel != null) {
      switchWidget = Semantics(
        label: semanticLabel!,
        value: value ? 'On' : 'Off',
        onTap: isEffectivelyDisabled ? null : () => onChanged?.call(!value),
        child: switchWidget,
      );
    }

    return switchWidget;
  }

  Widget _buildSwitch(
    BuildContext context,
    SwitchSizeConfig config,
    _SwitchColors colors,
  ) {
    return AnimatedContainer(
      duration: animationDuration ?? context.animationMedium,
      curve: Curves.easeInOutCubic,
      child: Focus(
        focusNode: focusNode,
        autofocus: autofocus,
        onFocusChange: (focused) {
          // Note: Since this is now stateless, we cannot track focus state
          // The focus behavior will be handled by the focus node itself
        },
        child: GestureDetector(
          onTap: isEffectivelyDisabled ? null : () => onChanged?.call(!value),
          child: MouseRegion(
            cursor: isEffectivelyDisabled ? forbiddenCursor : clickCursor,
            onEnter: (event) {
              // Note: Since this is now stateless, hover effects will be
              // handled through style properties rather than state
              onHover?.call(true);
            },
            onExit: (event) {
              onHover?.call(false);
            },
            child: _buildSwitchTrack(context, config, colors),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTrack(
    BuildContext context,
    SwitchSizeConfig config,
    _SwitchColors colors,
  ) {
    return AnimatedContainer(
      duration: animationDuration ?? context.animationMedium,
      curve: easeInOutCubic,
      width: config.trackSize.width,
      height: config.trackSize.height,
      decoration: _getTrackDecoration(context, config, colors),
      child: Stack(
        children: [
          // Track inner content (only for extended variant)
          if (variant == SwitchVariant.extended)
            _buildTrackContent(context, config, colors),
          // Thumb
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(config.thumbPadding),
              child: _buildSwitchThumb(context, config, colors),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackContent(
      BuildContext context, SwitchSizeConfig config, _SwitchColors colors) {
    return Positioned.fill(
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: AnimatedOpacity(
                duration: context.animationMedium,
                opacity: value ? context.opacity30 : context.opacity70,
                child: Icon(
                  Icons.close,
                  size: config.trackSize.height * 0.3,
                  color: colors.trackIcon,
                ),
              ),
            ),
          ),
          // Right side (on state)
          Expanded(
            child: Center(
              child: AnimatedOpacity(
                duration: context.animationMedium,
                opacity: value ? context.opacity70 : context.opacity30,
                child: Icon(
                  Icons.check,
                  size: config.trackSize.height * 0.3,
                  color: colors.trackIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _getTrackDecoration(
      BuildContext context, SwitchSizeConfig config, _SwitchColors colors) {
    switch (style) {
      case SwitchStyle.material:
        return BoxDecoration(
          color: value ? colors.activeTrack : colors.inactiveTrack,
          borderRadius: BorderRadius.circular(config.trackSize.height / 2),
        );

      case SwitchStyle.cupertino:
        return BoxDecoration(
          color: value ? colors.activeTrack : colors.inactiveTrack,
          borderRadius: BorderRadius.circular(config.trackSize.height / 2),
          border: Border.all(
            color: value
                ? colors.activeTrack
                : OsmeaColors.pewter.withValues(alpha: context.alpha30),
            width: context.width1 / 2,
          ),
        );

      case SwitchStyle.modern:
        return BoxDecoration(
          gradient: value
              ? LinearGradient(
                  begin: centerLeft,
                  end: centerRight,
                  colors: [
                    colors.activeTrack,
                    colors.activeTrack.withValues(alpha: context.alpha60),
                  ],
                )
              : LinearGradient(
                  begin: centerLeft,
                  end: centerRight,
                  colors: [
                    colors.inactiveTrack,
                    colors.inactiveTrack.withValues(alpha: context.alpha90),
                  ],
                ),
          borderRadius: BorderRadius.circular(config.trackSize.height / 2),
          boxShadow: [
            if (!isEffectivelyDisabled) ...[
              BoxShadow(
                color: value
                    ? colors.activeTrack.withValues(alpha: context.alpha30)
                    : OsmeaColors.shadowLight,
                offset: context.offsetVertical2,
                blurRadius: context.blurRadiusNormal,
                spreadRadius: context.spreadRadiusZero,
              ),
              if (value)
                BoxShadow(
                  color: colors.activeTrack.withValues(alpha: 0.2),
                  offset: context.offsetZero,
                  blurRadius: context.blurRadiusStrong,
                  spreadRadius: context.spreadRadiusZero,
                ),
            ],
          ],
        );

      case SwitchStyle.glassmorphism:
        return BoxDecoration(
          color: (value ? colors.activeTrack : colors.inactiveTrack)
              .withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(config.trackSize.height / 2),
          border: Border.all(
            color: OsmeaColors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: OsmeaColors.shadowLight.withValues(alpha: 0.1),
              offset: context.offsetVertical8,
              blurRadius: context.blurRadiusMax,
              spreadRadius: context.spreadRadiusZero,
            ),
          ],
        );

      case SwitchStyle.minimal:
        return BoxDecoration(
          color: value ? colors.activeTrack : colors.inactiveTrack,
          borderRadius: BorderRadius.circular(context.radiusLow.toDouble()),
          border: Border.all(
            color: isFocused && !isEffectivelyDisabled
                ? colors.focus
                : OsmeaColors.pewter.withValues(alpha: context.alpha30),
            width: context.width1,
          ),
        );

      case SwitchStyle.custom:
        return BoxDecoration(
          color: value ? colors.activeTrack : colors.inactiveTrack,
          borderRadius: BorderRadius.circular(config.trackSize.height / 2),
        );
    }
  }

  Widget _buildSwitchThumb(
    BuildContext context,
    SwitchSizeConfig config,
    _SwitchColors colors,
  ) {
    return AnimatedAlign(
      duration: animationDuration ?? const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: animationDuration ?? const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
        width: config.thumbSize,
        height: config.thumbSize,
        decoration: _getThumbDecoration(context, config, colors),
        transform: isHovered && !isEffectivelyDisabled
            ? (Matrix4.identity()..scale(1.05))
            : null,
        child: _buildThumbContent(context, config, colors),
      ),
    );
  }

  Widget? _buildThumbContent(
      BuildContext context, SwitchSizeConfig config, _SwitchColors colors) {
    if (variant == SwitchVariant.extended && style == SwitchStyle.modern) {
      return Center(
        child: AnimatedSwitcher(
          duration: context.animationMedium,
          child: Icon(
            value ? Icons.check : Icons.close,
            key: ValueKey(value),
            size: config.thumbSize * 0.4,
            color: value ? colors.activeTrack : OsmeaColors.pewter,
          ),
        ),
      );
    }

    return null;
  }

  BoxDecoration _getThumbDecoration(
      BuildContext context, SwitchSizeConfig config, _SwitchColors colors) {
    switch (style) {
      case SwitchStyle.material:
        return BoxDecoration(
          color: colors.thumb,
          borderRadius: BorderRadius.circular(config.thumbSize / 2),
        );

      case SwitchStyle.cupertino:
        return BoxDecoration(
          color: colors.thumb,
          borderRadius: BorderRadius.circular(config.thumbSize / 2),
        );

      case SwitchStyle.modern:
        return BoxDecoration(
          color: colors.thumb,
          borderRadius: BorderRadius.circular(config.thumbSize / 2),
          border: Border.all(
            color: OsmeaColors.white.withValues(alpha: context.alpha30),
            width: context.width1 / 2,
          ),
        );

      case SwitchStyle.glassmorphism:
        return BoxDecoration(
          color: colors.thumb.withValues(alpha: context.alpha90),
          borderRadius: BorderRadius.circular(config.thumbSize / 2),
          border: Border.all(
            color: OsmeaColors.white.withValues(alpha: context.alpha40),
            width: context.width1,
          ),
        );

      case SwitchStyle.minimal:
        return BoxDecoration(
          color: colors.thumb,
          borderRadius: BorderRadius.circular(context.radiusLow.toDouble()),
          border: Border.all(
            color: OsmeaColors.pewter.withValues(alpha: context.alpha40),
            width: context.width1,
          ),
        );

      case SwitchStyle.custom:
        return BoxDecoration(
          color: colors.thumb,
          borderRadius: BorderRadius.circular(config.thumbSize / 2),
          boxShadow: [
            if (!isEffectivelyDisabled)
              BoxShadow(
                color:
                    OsmeaColors.shadowDark.withValues(alpha: context.alpha20),
                offset: context.offsetVertical1,
                blurRadius: context.blurRadiusSubtle,
                spreadRadius: context.spreadRadiusZero,
              ),
          ],
        );
    }
  }

  Widget _buildWithLabel(
    BuildContext context,
    Widget switchWidget,
    _SwitchColors colors,
  ) {
    final labelWidget = _buildLabelContent(context, colors);

    final children = <Widget>[];
    final spacing = context.emptySizedWidthBoxNormal;

    if (labelPosition == SwitchLabelPosition.leading) {
      children.addAll([
        Expanded(child: labelWidget),
        spacing,
        switchWidget,
      ]);
    } else {
      children.addAll([
        switchWidget,
        spacing,
        Expanded(child: labelWidget),
      ]);
    }

    return Container(
      width: fullWidth ? double.infinity : null,
      padding: padding ?? context.paddingNormal,
      decoration: variant == SwitchVariant.card
          ? BoxDecoration(
              color: OsmeaColors.white,
              borderRadius: context.borderRadiusNormal,
            )
          : null,
      child: Row(
        mainAxisSize: fullWidth ? context.max : context.min,
        crossAxisAlignment: context.crossCenter,
        children: children,
      ),
    );
  }

  Widget _buildLabelContent(BuildContext context, _SwitchColors colors) {
    return Column(
      crossAxisAlignment: context.crossStart,
      mainAxisSize: context.min,
      children: [
        if (label != null)
          OsmeaText(
            label!,
            style: _getEffectiveLabelStyle(context).copyWith(
              color: isEffectivelyDisabled ? colors.disabledText : colors.text,
            ),
          ),
        if (description != null) ...[
          context.emptySizedHeightBoxLow,
          OsmeaText(
            description!,
            style: _getEffectiveDescriptionStyle(context).copyWith(
              color: colors.disabledText,
            ),
          ),
        ],
      ],
    );
  }

  TextStyle _getEffectiveLabelStyle(BuildContext context) {
    switch (size) {
      case SwitchSize.small:
        return OsmeaTextStyle.labelSmall(context);
      case SwitchSize.medium:
        return OsmeaTextStyle.labelMedium(context);
      case SwitchSize.large:
        return OsmeaTextStyle.labelLarge(context);
    }
  }

  TextStyle _getEffectiveDescriptionStyle(BuildContext context) {
    return OsmeaTextStyle.captionMedium(context);
  }

  _SwitchColors _getSwitchColors(BuildContext context) {
    return _SwitchColors(
      activeTrack: activeColor ??
          (isEffectivelyDisabled ? OsmeaColors.silver : OsmeaColors.nordicBlue),
      inactiveTrack: inactiveColor ??
          (isEffectivelyDisabled ? OsmeaColors.ash : OsmeaColors.pewter),
      thumb: thumbColor ??
          (isEffectivelyDisabled ? OsmeaColors.steel : OsmeaColors.white),
      text: isEffectivelyDisabled ? OsmeaColors.steel : OsmeaColors.eclipse,
      focus: focusColor ?? OsmeaColors.crystalBay,
      hover: hoverColor ?? OsmeaColors.deepSea,
      disabledText: OsmeaColors.steel,
      trackIcon: OsmeaColors.white.withValues(alpha: context.alpha80),
    );
  }
}

/// Internal helper class for switch colors
class _SwitchColors {
  final Color activeTrack;
  final Color inactiveTrack;
  final Color thumb;
  final Color text;
  final Color focus;
  final Color hover;
  final Color disabledText;
  final Color trackIcon;

  const _SwitchColors({
    required this.activeTrack,
    required this.inactiveTrack,
    required this.thumb,
    required this.text,
    required this.focus,
    required this.hover,
    required this.disabledText,
    required this.trackIcon,
  });
}

/// 🏷️ **OSMEA Labeled Switch**
class OsmeaLabeledSwitch extends OsmeaSwitch {
  const OsmeaLabeledSwitch({
    super.key,
    required super.value,
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
          variant: SwitchVariant.labeled,
        );
}

/// 🎯 **OSMEA Simple Switch**
class OsmeaSimpleSwitch extends OsmeaSwitch {
  const OsmeaSimpleSwitch({
    super.key,
    required super.value,
    super.size,
    super.state,
    super.onChanged,
    super.customTheme,
    super.activeColor,
    super.inactiveColor,
    super.style,
  }) : super(
          variant: SwitchVariant.simple,
        );
}
