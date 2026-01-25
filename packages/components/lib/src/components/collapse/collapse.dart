import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/osmea_components.dart';

// Export the cubit and state for external use
export 'package:osmea_components/src/components/collapse/cubit/collapse_cubit.dart';
export 'package:osmea_components/src/components/collapse/cubit/collapse_state.dart';

/// 📋 **OSMEA Components Library**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/components
///
/// A comprehensive collapse component that implements all variants defined
/// in the OSMEA design system with full customization support.
///
/// {@category Components}
/// {@subCategory Collapse}
///
/// Features:
/// * 📏 Multiple size options (small, medium, large)
/// * 🎨 Multiple style variants (block, card, accordion, ghost, outlined, filled)
/// * 🔄 Interactive states (collapsed, expanded, animating, loading)
/// * 🎯 Accordion mode support (only one panel open at a time)
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
///
/// ```dart
/// OsmeaCollapse(
///   size: CollapseSize.medium,
///   variant: CollapseVariant.block,
///   children: [
///     OsmeaCollapsePanel(
///       header: 'Section 1',
///       body: Text('Content 1'),
///     ),
///     OsmeaCollapsePanel(
///       header: 'Section 2',
///       body: Text('Content 2'),
///     ),
///   ],
/// )
/// ```
///
/// See also:
/// * [CollapseSize] - Size variants enum
/// * [CollapseVariant] - Style variants enum
/// * [CollapseState] - Interactive states enum
/// * [CollapseMode] - Mode options enum
/// * [OsmeaCollapsePanel] - Individual panel component

/// 📋 **OsmeaCollapse**
///
/// A comprehensive collapse component for the OSMEA UI Kit.
/// Features smooth animations, accordion mode, and complete customization.
/// Now uses Cubit pattern for state management.
///
/// ---
///
/// **Features:**
/// - 📏 Multiple size variants (small, medium, large)
/// - 🎨 Theme-aware colors and styles
/// - ✨ Built-in animations and transitions
/// - 🎯 Accordion mode support
/// - 🔧 Fully customizable
/// - 📱 Responsive design
///
/// ---
/// _Example:_
/// ```dart
/// OsmeaCollapse(
///   size: CollapseSize.medium,
///   variant: CollapseVariant.block,
///   mode: CollapseMode.accordion,
///   children: [
///     OsmeaCollapsePanel(
///       header: 'FAQ 1',
///       body: Text('Answer 1'),
///     ),
///   ],
/// )
/// ```
class OsmeaCollapse extends StatelessWidget {
  /// Creates a comprehensive collapse component for the Osmea design system.
  ///
  /// [size]: Size of the collapse (small, medium, large)
  /// [variant]: Visual style variant (block, card, accordion, ghost, outlined, filled)
  /// [mode]: Behavior mode (multiple, accordion)
  /// [children]: List of collapse panels
  /// [accordionValue]: Current open panel value (for accordion mode)
  /// [onAccordionChanged]: Callback when accordion value changes
  /// [expansionCallback]: Callback when any panel expands/collapses
  /// [backgroundColor]: Background color
  /// [borderColor]: Border color
  /// [borderRadius]: Border radius
  /// [elevation]: Material elevation
  /// [padding]: Internal padding
  /// [margin]: External margin
  /// [animationDuration]: Animation duration
  /// [maintainState]: Whether to keep children in the tree when collapsed
  /// [disabled]: Whether the collapse is disabled
  /// [loading]: Whether the collapse is loading
  /// [error]: Whether the collapse is in error state
  const OsmeaCollapse({
    super.key,
    this.size = CollapseSize.medium,
    this.variant = CollapseVariant.block,
    this.mode = CollapseBehaviorMode.multiple,
    required this.children,
    this.accordionValue,
    this.onAccordionChanged,
    this.expansionCallback,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation = 0,
    this.padding,
    this.margin,
    this.animationDuration = const Duration(milliseconds: 300),
    this.maintainState = false,
    this.disabled = false,
    this.loading = false,
    this.error = false,
  });

  final CollapseSize size;
  final CollapseVariant variant;
  final CollapseBehaviorMode mode;
  final List<OsmeaCollapsePanel> children;
  final String? accordionValue;
  final ValueChanged<String?>? onAccordionChanged;
  final ExpansionPanelCallback? expansionCallback;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Duration animationDuration;
  final bool maintainState;
  final bool disabled;
  final bool loading;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollapseCubit(
        mode: mode,
        accordionValue: accordionValue,
        onAccordionChanged: onAccordionChanged,
        expansionCallback: expansionCallback,
        animationDuration: animationDuration,
      ),
      child: BlocBuilder<CollapseCubit, CollapseState>(
        builder: (context, state) {
          return _CollapseView(
            size: size,
            variant: variant,
            mode: mode,
            children: children,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderRadius: borderRadius,
            elevation: elevation,
            padding: padding,
            margin: margin,
            disabled: disabled,
            loading: loading,
            error: error,
            state: state,
          );
        },
      ),
    );
  }
}

/// Stateless collapse view using cubit state
class _CollapseView extends StatelessWidget {
  final CollapseSize size;
  final CollapseVariant variant;
  final CollapseBehaviorMode mode;
  final List<OsmeaCollapsePanel> children;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool disabled;
  final bool loading;
  final bool error;
  final CollapseState state;

  const _CollapseView({
    required this.size,
    required this.variant,
    required this.mode,
    required this.children,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    required this.elevation,
    this.padding,
    this.margin,
    required this.disabled,
    required this.loading,
    required this.error,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final config = size.config(context);
    final variantConfig = variant.config(context);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? variantConfig.backgroundColor,
        borderRadius: borderRadius ?? config.borderRadius,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.0)
            : variantConfig.border,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: OsmeaColors.shadowLight,
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                )
              ]
            : null,
      ),
      padding: padding ?? config.padding,
      margin: margin,
      child: ExpansionPanelList(
        elevation: 0,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (panelIndex, isExpanded) {
          final panel = children[panelIndex];
          // If panel handles its own header tap, do not toggle expansion.
          if (disabled || panel.disabled || panel.onHeaderTap != null) {
            return;
          }
          if (mode == CollapseBehaviorMode.accordion) {
            context.read<CollapseCubit>().togglePanel(panelIndex, panel.value);
          } else {
            context.read<CollapseCubit>().togglePanel(panelIndex);
          }
        },
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final panel = entry.value;
          final isExpanded = mode == CollapseBehaviorMode.accordion
              ? panel.value == state.accordionValue
              : state.expandedPanels.contains(index);

          Widget headerWidget = _buildHeader(context, panel, isExpanded);
          if (!disabled && !panel.disabled && panel.onHeaderTap != null) {
            headerWidget = Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: panel.onHeaderTap,
                child: headerWidget,
              ),
            );
          }

          return ExpansionPanel(
            headerBuilder: (context, isExpanded) => headerWidget,
            body: _buildBody(context, panel),
            isExpanded: isExpanded,
            canTapOnHeader:
                !disabled && !panel.disabled && panel.onHeaderTap == null,
            backgroundColor: OsmeaColors.transparent,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, OsmeaCollapsePanel panel, bool isExpanded) {
    final config = size.config(context);
    // Use panel variant if available, otherwise use collapse variant
    final panelVariant = panel.variant ?? variant;
    final variantConfig = panelVariant.config(context);

    return Container(
      padding: config.headerPadding,
      decoration: BoxDecoration(
        color: variantConfig.headerBackgroundColor,
        borderRadius: variantConfig.headerBorderRadius,
      ),
      child: Row(
        children: [
          if (panel.leading != null) ...[
            panel.leading!,
            SizedBox(width: config.iconSpacing),
          ],
          Expanded(
            child: panel.header is String
                ? OsmeaComponents.text(
                    panel.header as String,
                    textStyle: variantConfig.headerTextStyle,
                    color: variantConfig.headerTextColor,
                  )
                : panel.header as Widget,
          ),
          if (panel.trailing != null) ...[
            SizedBox(width: config.iconSpacing),
            panel.trailing!,
          ],
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, OsmeaCollapsePanel panel) {
    final config = size.config(context);
    // Use panel variant if available, otherwise use collapse variant
    final panelVariant = panel.variant ?? variant;
    final variantConfig = panelVariant.config(context);

    return Container(
      padding: config.bodyPadding,
      decoration: BoxDecoration(
        color: variantConfig.bodyBackgroundColor,
        borderRadius: variantConfig.bodyBorderRadius,
      ),
      child: panel.body,
    );
  }
}
