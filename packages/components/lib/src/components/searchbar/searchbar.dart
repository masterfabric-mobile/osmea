import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/src/components/buttons/button.dart';
import 'package:osmea_components/src/components/container/container.dart';
import 'package:osmea_components/src/components/sized_box/sized_box.dart';
import 'package:osmea_components/src/components/text_field/text_field.dart';
import 'package:osmea_components/src/core/text_field_widget.dart';
import 'package:osmea_components/src/components/searchbar/cubit/searchbar_cubit.dart';
import 'package:osmea_components/src/components/searchbar/cubit/searchbar_state.dart';
import 'package:osmea_components/src/enums/enums.dart';
import 'package:osmea_components/src/styles/colors.dart';
import 'package:osmea_components/src/utils/sizer_extensions.dart';

/// 🔍 **OSMEA Searchbar**
///
/// A comprehensive and highly customizable search component for the OSMEA UI Kit.
/// Features advanced search functionality, suggestions, history, and multiple styling options.
///
/// **Features:**
/// - Multiple variants (outlined, filled, underlined, borderless, rounded)
/// - Multiple styles (standard, minimal, expanded, compact, hero)
/// - Search suggestions and autocomplete
/// - Search history management
/// - Loading states and error handling
/// - Clear and back button support
/// - Custom search and suggestion providers
/// - Debounced search functionality
/// - Responsive design with OSMEA color system
/// - Accessibility features
///
/// **Usage:**
/// ```dart
/// OsmeaSearchbar(
///   hint: 'Search products...',
///   variant: SearchbarVariant.outlined,
///   style: SearchbarStyle.standard,
///   onSearch: (query) => performSearch(query),
///   suggestionProvider: (query) => getSuggestions(query),
/// )
/// ```

class OsmeaSearchbar extends CoreTextField {
  const OsmeaSearchbar({
    super.key,
    super.customTheme,
    super.controller,
    super.focusNode,
    super.hint,
    super.size = TextFieldSize.medium,
    super.variant = TextFieldVariant.outlined,
    super.state = TextFieldState.enabled,
    super.onChanged,
    super.onSubmitted,
    super.onTap,
    super.textAlign = TextAlign.start,
    super.textCapitalization = TextCapitalization.none,
    super.keyboardType = TextInputType.text,
    super.textInputAction = TextInputAction.search,
    super.textStyle,
    super.textColor,
    super.backgroundColor,
    super.borderColor,
    super.focusColor,
    super.errorColor,
    super.hintColor,
    super.fullWidth = true,
    super.animationDuration,
    // Searchbar-specific parameters
    this.searchbarVariant = SearchbarVariant.outlined,
    this.searchbarStyle = SearchbarStyle.standard,
    this.onSearch,
    this.onClear,
    this.onBack,
    this.suggestionProvider,
    this.searchProvider,
    this.maxHistoryItems = 10,
    this.minQueryLength = 2,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.showClearButton = true,
    this.showBackButton = false,
    this.showSearchIcon = true,
    this.showSuggestions = true,
    this.suggestionBuilder,
    this.historyBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyStateBuilder,
    this.searchIcon,
    this.clearIcon,
    this.backIcon,
    this.customBorderRadius,
    this.transitionDuration,
    this.transitionCurve = Curves.easeInOut,
    this.onFocusChanged,
    this.onHoverChanged,
    this.initialHistory = const [],
    this.enableHoverEffect = true,
    this.hoverAnimationDuration,
    // New action parameters
    this.actions = const [],
    this.actionMargin = EdgeInsets.zero,
    this.actionAlignment = MainAxisAlignment.end,
  });

  /// Visual style variant for the searchbar
  final SearchbarVariant searchbarVariant;

  /// Functional style for the searchbar
  final SearchbarStyle searchbarStyle;

  /// Callback when search is performed
  final ValueChanged<String>? onSearch;

  /// Callback when clear button is pressed
  final VoidCallback? onClear;

  /// Callback when back button is pressed
  final VoidCallback? onBack;

  /// Provider for search suggestions
  final Future<List<String>> Function(String query)? suggestionProvider;

  /// Provider for search results
  final Future<List<dynamic>> Function(String query)? searchProvider;

  /// Maximum number of history items to store
  final int maxHistoryItems;

  /// Minimum query length to trigger suggestions
  final int minQueryLength;

  /// Debounce duration for suggestions
  final Duration debounceDuration;

  /// Whether to show clear button
  final bool showClearButton;

  /// Whether to show back button
  final bool showBackButton;

  /// Whether to show search icon
  final bool showSearchIcon;

  /// Whether to show suggestions
  final bool showSuggestions;

  /// Custom builder for suggestions
  final Widget Function(BuildContext context, List<String> suggestions,
      Function(String) onSelect)? suggestionBuilder;

  /// Custom builder for search history
  final Widget Function(BuildContext context, List<String> history,
      Function(String) onSelect)? historyBuilder;

  /// Custom builder for loading state
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Custom builder for error state
  final Widget Function(BuildContext context, String error)? errorBuilder;

  /// Custom builder for empty state
  final Widget Function(BuildContext context)? emptyStateBuilder;

  /// Custom search icon
  final Widget? searchIcon;

  /// Custom clear icon
  final Widget? clearIcon;

  /// Custom back icon
  final Widget? backIcon;

  /// Custom border radius
  final BorderRadius? customBorderRadius;

  /// Custom transition duration
  final Duration? transitionDuration;

  /// Animation curve for transitions
  final Curve transitionCurve;

  /// Callback when focus state changes
  final ValueChanged<bool>? onFocusChanged;

  /// Callback when hover state changes
  final ValueChanged<bool>? onHoverChanged;

  /// Initial search history
  final List<String> initialHistory;

  /// Whether hover effects are enabled
  final bool enableHoverEffect;

  /// Duration for hover animations
  final Duration? hoverAnimationDuration;

  /// 🎮 Action buttons to display on the right side of the searchbar
  final List<Widget> actions;

  /// 📏 Margin for action buttons
  final EdgeInsetsGeometry actionMargin;

  /// 📐 Alignment for action buttons
  final MainAxisAlignment actionAlignment;

  /// Get effective transition duration
  Duration getEffectiveTransitionDuration(BuildContext context) =>
      transitionDuration ?? animationDuration ?? context.animationMedium;

  /// Get effective hover animation duration
  Duration getEffectiveHoverDuration(BuildContext context) =>
      hoverAnimationDuration ?? const Duration(milliseconds: 150);

  @override
  Widget buildWidget(BuildContext context) {
    return BlocProvider<SearchbarCubit>(
      create: (context) => SearchbarCubit(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onSearch: onSearch,
        onFocusChanged: onFocusChanged,
        onHoverChanged: onHoverChanged,
        onClear: onClear,
        onBack: onBack,
        suggestionProvider: suggestionProvider,
        searchProvider: searchProvider,
        maxHistoryItems: maxHistoryItems,
        minQueryLength: minQueryLength,
        debounceDuration: debounceDuration,
        enabled: enabled ?? true,
        initialValue: controller?.text ?? '',
        initialHistory: initialHistory,
      ),
      child: _OsmeaSearchbarView(
        searchbar: this,
      ),
    ) as Widget;
  }
}

/// Stateless Searchbar View using Cubit
class _OsmeaSearchbarView extends StatelessWidget {
  const _OsmeaSearchbarView({
    required this.searchbar,
  });

  final OsmeaSearchbar searchbar;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchbarCubit, SearchbarCubitState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSearchbarField(context, state),
            if (state.shouldShowSuggestions)
              Flexible(
                child: _buildSuggestions(context, state),
              ),
            if (state.hasError) _buildError(context, state),
          ],
        );
      },
    );
  }

  Widget _buildSearchbarField(BuildContext context, SearchbarCubitState state) {
    final cubit = BlocProvider.of<SearchbarCubit>(context);

    return Container(
      width: searchbar.fullWidth ? double.infinity : null,
      height: _getSearchbarHeight(),
      decoration: _buildDecoration(context, state),
      child: Row(
        children: [
          // Back button (outside of TextField)
          if (state.shouldShowBackButton) _buildBackButton(context, cubit),

          // Text field with actions inside
          Expanded(
            child: _buildTextField(context, state, cubit),
          ),

          // Loading indicator (outside of TextField)
          if (state.isLoading) _buildLoadingIndicator(context),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(
      BuildContext context, SearchbarCubitState state) {
    Color backgroundColor = searchbar.backgroundColor ??
        (searchbar.searchbarVariant == SearchbarVariant.filled
            ? OsmeaColors.snow
            : OsmeaColors.transparent);

    Color borderColor = searchbar.borderColor ??
        (state.isFocused
            ? (searchbar.focusColor ?? OsmeaColors.nordicBlue)
            : OsmeaColors.platinum);

    if (state.hasError) {
      borderColor = searchbar.errorColor ?? OsmeaColors.amberFlame;
    }

    BorderRadius borderRadius = searchbar.customBorderRadius ??
        _getBorderRadius(searchbar.searchbarVariant, searchbar.size);

    switch (searchbar.searchbarVariant) {
      case SearchbarVariant.underlined:
        return BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: borderColor,
              width: 2.0,
            ),
          ),
        );
      case SearchbarVariant.outlined:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor, width: 1.0),
        );
      case SearchbarVariant.filled:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor, width: 0.5),
        );
      case SearchbarVariant.borderless:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        );
      case SearchbarVariant.rounded:
        return BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.all(color: borderColor, width: 1.0),
        );
    }
  }

  BorderRadius _getBorderRadius(SearchbarVariant variant, TextFieldSize size) {
    if (variant == SearchbarVariant.rounded) {
      return BorderRadius.circular(25.0);
    }

    switch (size) {
      case TextFieldSize.extraSmall:
        return BorderRadius.circular(4.0);
      case TextFieldSize.small:
        return BorderRadius.circular(6.0);
      case TextFieldSize.medium:
        return BorderRadius.circular(8.0);
      case TextFieldSize.large:
        return BorderRadius.circular(10.0);
      case TextFieldSize.extraLarge:
        return BorderRadius.circular(12.0);
    }
  }

  Widget _buildBackButton(BuildContext context, SearchbarCubit cubit) {
    return OsmeaIconButton(
      icon: searchbar.backIcon ?? const Icon(Icons.arrow_back, size: 20),
      onPressed: cubit.handleBack,
      variant: ButtonVariant.ghost,
      tooltip: 'Clear',
    );
  }

  Widget _buildTextField(
      BuildContext context, SearchbarCubitState state, SearchbarCubit cubit) {
    return OsmeaTextField(
      controller: cubit.effectiveController,
      focusNode: cubit.effectiveFocusNode,
      onChanged: searchbar.onChanged,
      onSubmitted: (value) {
        searchbar.onSubmitted?.call(value);
        searchbar.onSearch?.call(value);
      },
      onTap: searchbar.onTap,
      textAlign: searchbar.textAlign,
      textCapitalization: searchbar.textCapitalization,
      keyboardType: searchbar.keyboardType,
      textInputAction: searchbar.textInputAction,
      variant: TextFieldVariant.borderless,
      size: searchbar.size,
      enabled: !state.isEffectivelyDisabled,
      hint: searchbar.hint ?? 'Search...',
      hintColor: searchbar.hintColor,
      textStyle: searchbar.textStyle,
      textColor: searchbar.textColor,
      customContentPadding: const EdgeInsets.only(
        left: 8.0,
        right: 4.0,
        top: 12.0,
        bottom: 12.0,
      ),
      prefixIcon: searchbar.showSearchIcon
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 4.0),
              child: Icon(
                Icons.search,
                size: 20,
                color: Colors.grey[600],
              ),
            )
          : null,
      suffixIcon: _buildSuffixIcon(context, state, cubit),
    );
  }

  /// Build suffix icon with actions and clear button
  Widget? _buildSuffixIcon(
      BuildContext context, SearchbarCubitState state, SearchbarCubit cubit) {
    final List<Widget> suffixWidgets = [];

    // Add actions first
    if (searchbar.actions.isNotEmpty) {
      for (final action in searchbar.actions) {
        suffixWidgets.add(
          Container(
            margin: searchbar.actionMargin,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            child: action,
          ),
        );
      }
    }

    // Add clear button if needed
    if (state.shouldShowClearButton) {
      suffixWidgets.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          child: IconButton(
            icon: searchbar.clearIcon ?? const Icon(Icons.clear, size: 18),
            onPressed: cubit.clear,
            color: Colors.grey[600],
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ),
      );
    }

    // Return null if no suffix widgets
    if (suffixWidgets.isEmpty) return null;

    // Return single widget if only one
    if (suffixWidgets.length == 1) return suffixWidgets.first;

    // Return Row with multiple widgets
    return Container(
      padding: const EdgeInsets.only(right: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: suffixWidgets,
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: OsmeaSizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context, SearchbarCubitState state) {
    if (searchbar.suggestionBuilder != null) {
      return searchbar.suggestionBuilder!(
        context,
        state.suggestions,
        (suggestion) => BlocProvider.of<SearchbarCubit>(context)
            .selectSuggestion(suggestion),
      );
    }

    return OsmeaContainer(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 200.0,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: state.suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = state.suggestions[index];
            return ListTile(
              dense: true,
              title: Text(suggestion),
              onTap: () => BlocProvider.of<SearchbarCubit>(context)
                  .selectSuggestion(suggestion),
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, SearchbarCubitState state) {
    if (searchbar.errorBuilder != null) {
      return searchbar.errorBuilder!(context, state.errorMessage!);
    }

    return OsmeaContainer(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(8),
      child: Text(
        state.errorMessage!,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onErrorContainer,
          fontSize: 12,
        ),
      ),
    );
  }

  /// 📏 Get searchbar height based on size
  double _getSearchbarHeight() {
    switch (searchbar.size) {
      case TextFieldSize.extraSmall:
        return 32.0;
      case TextFieldSize.small:
        return 36.0;
      case TextFieldSize.medium:
        return 44.0;
      case TextFieldSize.large:
        return 52.0;
      case TextFieldSize.extraLarge:
        return 60.0;
    }
  }
}
