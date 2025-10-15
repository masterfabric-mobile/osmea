// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osmea_components/src/core/scaffold_widget.dart';
import 'package:osmea_components/src/components/appbar_searchbar/appbar_searchbar_action.dart';
import 'package:osmea_components/src/components/searchbar/searchbar.dart';
import 'package:osmea_components/src/components/searchbar/cubit/searchbar_cubit.dart';
import 'package:osmea_components/src/enums/appbar_enums.dart';
import 'package:osmea_components/src/enums/components_enum.dart';
import 'package:osmea_components/src/utils/appbar_extensions.dart';
import 'package:osmea_components/src/utils/text_field_size_extensions.dart';

/// 🎯 **OSMEA Components Library - AppBar with SearchBar**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/osmea/components
///
/// A comprehensive application bar component that combines AppBar functionality
/// with an integrated SearchBar below it. Perfect for apps that need both
/// navigation and search functionality in a unified interface.
///
/// {@category Components}
/// {@subCategory AppBar}
///
/// Features:
/// * 🎨 Multiple AppBar design variants (primary, secondary, standard, surface, glass, gradient, outlined, elevated, transparent)
/// * 📏 Five AppBar size options (compact, standard, comfortable, large, extraLarge)
/// * 🔄 Flexible AppBar behavior types (fixed, scrollable, collapsible, floating, pinned, expandable)
/// * 🔍 Integrated SearchBar with multiple variants (outlined, filled, underlined, borderless, rounded)
/// * 🎭 Sharp visual style for consistent design language
/// * 🎮 Multiple action types support
/// * ♿ Full accessibility support
/// * 🌐 RTL/LTR language support
/// * 📱 Responsive design
/// * 🎭 Custom theming capabilities
/// * 🔍 Search suggestions and autocomplete
/// * 📝 Search history management
/// * ⚡ Debounced search functionality
///
/// ```dart
/// OsmeaAppBarWithSearchBar(
///   appBarVariant: AppBarVariant.primary,
///   appBarSize: AppBarSize.standard,
///   appBarType: AppBarType.fixed,
///   appBarStyle: AppBarStyle.sharp,
///   searchBarVariant: SearchbarVariant.outlined,
///   searchBarStyle: SearchbarStyle.standard,
///   title: Text('Beautiful App'),
///   searchHint: 'Search products...',
///   onSearch: (query) => performSearch(query),
///   actions: [
///     AppBarWithSearchBarAction(
///       type: AppBarActionType.notification,
///       icon: Icon(Icons.notifications),
///       onPressed: () => showNotifications(),
///     ),
///   ],
/// )
/// ```
class OsmeaAppBarWithSearchBar extends CoreScaffold
    implements PreferredSizeWidget {
  const OsmeaAppBarWithSearchBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.appBarSize = AppBarSize.standard,
    this.appBarVariant = AppBarVariant.standard,
    this.appBarType = AppBarType.fixed,
    this.appBarStyle = AppBarStyle.sharp,
    this.searchBarVariant = SearchbarVariant.outlined,
    this.searchBarStyle = SearchbarStyle.standard,
    this.appBarBackgroundColor,
    this.appBarForegroundColor,
    this.appBarShadowColor,
    this.appBarSurfaceTintColor,
    this.appBarTitleTextColor,
    this.appBarSubtitleTextColor,
    this.appBarIconColor,
    this.appBarActionColor,
    this.appBarAnimationDuration,
    this.appBarElevation,
    this.appBarBorderRadius,
    this.centerTitle = false,
    this.titleAlignment = AppBarTitleAlignment.left,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
    this.excludeHeaderSemantics = false,
    this.primary = true,
    this.scrolledUnderElevation,
    this.notificationPredicate,
    this.onTitleTap,
    this.onLeadingTap,
    this.appBarBottom,
    this.flexibleSpace,
    // SearchBar specific properties
    this.searchHint,
    this.searchController,
    this.searchFocusNode,
    this.onSearch,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchClear,
    this.onSearchBack,
    this.searchSuggestionProvider,
    this.searchProvider,
    this.maxHistoryItems = 10,
    this.minQueryLength = 2,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.showClearButton = true,
    this.showBackButton = false,
    this.showSearchIcon = true,
    this.showSuggestions = true,
    this.searchIcon,
    this.clearIcon,
    this.backIcon,
    this.searchBarBorderRadius,
    this.transitionDuration,
    this.transitionCurve = Curves.easeInOut,
    this.onSearchFocusChanged,
    this.onSearchHoverChanged,
    this.initialHistory = const [],
    this.enableHoverEffect = true,
    this.hoverAnimationDuration,
    this.searchBarPadding =
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.searchBarMargin = EdgeInsets.zero,
    this.searchBarBackgroundColor,
    this.searchBarBorderColor,
    this.searchBarFocusColor,
    this.searchBarErrorColor,
    this.searchBarHintColor,
    this.searchBarTextColor,
    this.searchBarTextStyle,
    this.searchBarSize = TextFieldSize.medium,
    this.searchBarState = TextFieldState.enabled,
    this.searchBarTextAlign = TextAlign.start,
    this.searchBarTextCapitalization = TextCapitalization.none,
    this.searchBarKeyboardType = TextInputType.text,
    this.searchBarTextInputAction = TextInputAction.search,
    this.searchBarFullWidth = true,
    this.searchBarAnimationDuration,
    // SearchBar action parameters
    this.searchBarActions = const [],
    this.searchBarActionMargin = EdgeInsets.zero,
    this.searchBarActionAlignment = MainAxisAlignment.end,
  });

  // AppBar properties
  /// 📝 The primary title widget
  final Widget? title;

  /// 📄 Optional subtitle widget
  final Widget? subtitle;

  /// ⬅️ Widget to display before the title (typically menu or back button)
  final Widget? leading;

  /// ➡️ List of action widgets to display after the title
  final List<AppBarWithSearchBarAction> actions;

  /// 📏 The size of the AppBar
  final AppBarSize appBarSize;

  /// 🎨 The visual style variant of the AppBar
  final AppBarVariant appBarVariant;

  /// 🔄 The behavior type of the AppBar
  final AppBarType appBarType;

  /// 🎭 The visual style approach of the AppBar
  final AppBarStyle appBarStyle;

  /// 🎨 Custom background color that overrides the default variant background
  final Color? appBarBackgroundColor;

  /// 🎯 Custom foreground color for all content
  final Color? appBarForegroundColor;

  /// ✨ Custom shadow color
  final Color? appBarShadowColor;

  /// 🌊 Surface tint color for Material 3
  final Color? appBarSurfaceTintColor;

  /// 📝 Specific color for the title text
  final Color? appBarTitleTextColor;

  /// 📄 Specific color for the subtitle text
  final Color? appBarSubtitleTextColor;

  /// 🎯 Color for icons
  final Color? appBarIconColor;

  /// 🎮 Color for action buttons
  final Color? appBarActionColor;

  /// ⏱️ Duration for AppBar animations
  final Duration? appBarAnimationDuration;

  /// ✨ Elevation/shadow depth
  final double? appBarElevation;

  /// ⭕ Custom border radius
  final BorderRadius? appBarBorderRadius;

  /// 🎯 Whether to center the title
  final bool centerTitle;

  /// 📝 Title alignment
  final AppBarTitleAlignment titleAlignment;

  /// 📏 Spacing around the title
  final double? titleSpacing;

  /// 👁️ Opacity of the toolbar
  final double toolbarOpacity;

  /// 👁️ Opacity of the bottom widget
  final double bottomOpacity;

  /// 📏 Width of the leading widget
  final double? leadingWidth;

  /// 🔄 Whether to automatically imply leading widget
  final bool automaticallyImplyLeading;

  /// ♿ Whether to exclude header semantics
  final bool excludeHeaderSemantics;

  /// 🔝 Whether this is the primary AppBar
  @override
  final bool primary;

  /// 📜 Elevation when scrolled under
  final double? scrolledUnderElevation;

  /// 🔔 Notification predicate
  final ScrollNotificationPredicate? notificationPredicate;

  /// 👆 Callback when title is tapped
  final VoidCallback? onTitleTap;

  /// 👆 Callback when leading widget is tapped
  final VoidCallback? onLeadingTap;

  /// ⬇️ Widget to display at the bottom of the AppBar
  final PreferredSizeWidget? appBarBottom;

  /// 🌌 A flexible space widget to display behind the AppBar
  final Widget? flexibleSpace;

  // SearchBar specific properties
  /// Visual style variant for the searchbar
  final SearchbarVariant searchBarVariant;

  /// Functional style for the searchbar
  final SearchbarStyle searchBarStyle;

  /// Hint text for the searchbar
  final String? searchHint;

  /// Controller for the searchbar text field
  final TextEditingController? searchController;

  /// Focus node for the searchbar text field
  final FocusNode? searchFocusNode;

  /// Callback when search is performed
  final ValueChanged<String>? onSearch;

  /// Callback when search text changes
  final ValueChanged<String>? onSearchChanged;

  /// Callback when search is submitted
  final ValueChanged<String>? onSearchSubmitted;

  /// Callback when clear button is pressed
  final VoidCallback? onSearchClear;

  /// Callback when back button is pressed
  final VoidCallback? onSearchBack;

  /// Provider for search suggestions
  final Future<List<String>> Function(String query)? searchSuggestionProvider;

  /// Provider for search results
  final Future<List<dynamic>> Function(String query)? searchProvider;

  /// Maximum number of history items to store
  final int maxHistoryItems;

  /// Minimum query length to trigger suggestions/search
  final int minQueryLength;

  /// Duration for debouncing search input
  final Duration debounceDuration;

  /// Whether to show the clear button
  final bool showClearButton;

  /// Whether to show the back button
  final bool showBackButton;

  /// Whether to show the search icon
  final bool showSearchIcon;

  /// Whether to show search suggestions
  final bool showSuggestions;

  /// Custom search icon
  final Widget? searchIcon;

  /// Custom clear icon
  final Widget? clearIcon;

  /// Custom back icon
  final Widget? backIcon;

  /// Custom border radius for the searchbar
  final BorderRadius? searchBarBorderRadius;

  /// Duration for searchbar transitions
  final Duration? transitionDuration;

  /// Curve for searchbar transitions
  final Curve transitionCurve;

  /// Callback when searchbar focus changes
  final ValueChanged<bool>? onSearchFocusChanged;

  /// Callback when searchbar hover changes
  final ValueChanged<bool>? onSearchHoverChanged;

  /// Initial search history
  final List<String> initialHistory;

  /// Whether to enable hover effect for searchbar
  final bool enableHoverEffect;

  /// Duration for searchbar hover animation
  final Duration? hoverAnimationDuration;

  /// Padding for the searchbar
  final EdgeInsetsGeometry searchBarPadding;

  /// Margin for the searchbar
  final EdgeInsetsGeometry searchBarMargin;

  /// Background color for the searchbar
  final Color? searchBarBackgroundColor;

  /// Border color for the searchbar
  final Color? searchBarBorderColor;

  /// Focus color for the searchbar
  final Color? searchBarFocusColor;

  /// Error color for the searchbar
  final Color? searchBarErrorColor;

  /// Hint color for the searchbar
  final Color? searchBarHintColor;

  /// Text color for the searchbar
  final Color? searchBarTextColor;

  /// Text style for the searchbar
  final TextStyle? searchBarTextStyle;

  /// Size for the searchbar text field
  final TextFieldSize searchBarSize;

  /// State for the searchbar text field
  final TextFieldState searchBarState;

  /// Text alignment for the searchbar
  final TextAlign searchBarTextAlign;

  /// Text capitalization for the searchbar
  final TextCapitalization searchBarTextCapitalization;

  /// Keyboard type for the searchbar
  final TextInputType searchBarKeyboardType;

  /// Text input action for the searchbar
  final TextInputAction searchBarTextInputAction;

  /// Whether the searchbar should take full width
  final bool searchBarFullWidth;

  /// Animation duration for search bar
  final Duration? searchBarAnimationDuration;

  /// 🎮 Action buttons to display in the searchbar
  final List<Widget> searchBarActions;

  /// 📏 Margin for searchbar action buttons
  final EdgeInsetsGeometry searchBarActionMargin;

  /// 📐 Alignment for searchbar action buttons
  final MainAxisAlignment searchBarActionAlignment;

  @override
  Size get preferredSize {
    // Calculate total height: AppBar height + SearchBar height + padding
    final appBarHeight = _getAppBarHeight();
    final searchBarHeight = _getSearchBarHeight();
    final searchBarPaddingHeight = _getSearchBarPaddingHeight();
    return Size.fromHeight(
        appBarHeight + searchBarHeight + searchBarPaddingHeight);
  }

  double _getSearchBarPaddingHeight() {
    if (searchBarPadding is EdgeInsets) {
      final padding = searchBarPadding as EdgeInsets;
      return padding.top + padding.bottom;
    }
    return 16.0; // Default padding height
  }

  double _getAppBarHeight() {
    return appBarSize.height;
  }

  double _getSearchBarHeight() {
    return searchBarSize.height;
  }

  List<Widget> _buildActions(BuildContext context) {
    return actions.map((action) {
      return IconButton(
        icon: action.icon,
        onPressed: action.isEnabled ? action.onPressed : null,
        tooltip: action.tooltip,
        color: action.color ?? appBarActionColor,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchbarCubit(
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: onSearchChanged,
        onSubmitted: onSearchSubmitted,
        onSearch: onSearch,
        onFocusChanged: onSearchFocusChanged,
        onHoverChanged: onSearchHoverChanged,
        onClear: onSearchClear,
        onBack: onSearchBack,
        suggestionProvider: searchSuggestionProvider,
        searchProvider: searchProvider,
        maxHistoryItems: maxHistoryItems,
        minQueryLength: minQueryLength,
        debounceDuration: debounceDuration,
        initialHistory: initialHistory,
      ),
      child: AppBar(
        key: key,
        title: title,
        leading: leading,
        actions: _buildActions(context),
        backgroundColor: appBarBackgroundColor,
        foregroundColor: appBarForegroundColor,
        shadowColor: appBarShadowColor,
        surfaceTintColor: appBarSurfaceTintColor,
        elevation: appBarElevation,
        centerTitle: centerTitle,
        titleSpacing: titleSpacing,
        toolbarOpacity: toolbarOpacity,
        bottomOpacity: bottomOpacity,
        leadingWidth: leadingWidth,
        automaticallyImplyLeading: automaticallyImplyLeading,
        excludeHeaderSemantics: excludeHeaderSemantics,
        primary: primary,
        scrolledUnderElevation: scrolledUnderElevation,
        flexibleSpace: flexibleSpace,
        clipBehavior: Clip.none,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              _getSearchBarHeight() + _getSearchBarPaddingHeight()),
          child: Container(
            padding: searchBarPadding,
            margin: searchBarMargin,
            child: SizedBox(
              height: _getSearchBarHeight(),
              width: double.infinity,
              child: OsmeaSearchbar(
                controller: searchController,
                focusNode: searchFocusNode,
                hint: searchHint,
                size: searchBarSize,
                variant: _searchbarVariantToTextFieldVariant(searchBarVariant),
                state: searchBarState,
                onChanged: onSearchChanged,
                onSubmitted: onSearchSubmitted,
                textAlign: searchBarTextAlign,
                textCapitalization: searchBarTextCapitalization,
                keyboardType: searchBarKeyboardType,
                textInputAction: searchBarTextInputAction,
                textStyle: searchBarTextStyle,
                textColor: searchBarTextColor,
                backgroundColor: searchBarBackgroundColor,
                borderColor: searchBarBorderColor,
                focusColor: searchBarFocusColor,
                errorColor: searchBarErrorColor,
                hintColor: searchBarHintColor,
                fullWidth: searchBarFullWidth,
                animationDuration: searchBarAnimationDuration,
                searchbarVariant: searchBarVariant,
                searchbarStyle: searchBarStyle,
                onSearch: onSearch,
                onClear: onSearchClear,
                onBack: onSearchBack,
                suggestionProvider: searchSuggestionProvider,
                searchProvider: searchProvider,
                maxHistoryItems: maxHistoryItems,
                minQueryLength: minQueryLength,
                debounceDuration: debounceDuration,
                showClearButton: showClearButton,
                showBackButton: showBackButton,
                showSearchIcon: showSearchIcon,
                showSuggestions: showSuggestions,
                searchIcon: searchIcon,
                clearIcon: clearIcon,
                backIcon: backIcon,
                customBorderRadius: searchBarBorderRadius,
                transitionDuration: transitionDuration,
                transitionCurve: transitionCurve,
                onFocusChanged: onSearchFocusChanged,
                onHoverChanged: onSearchHoverChanged,
                initialHistory: initialHistory,
                enableHoverEffect: enableHoverEffect,
                hoverAnimationDuration: hoverAnimationDuration,
                // SearchBar action parameters
                actions: searchBarActions,
                actionMargin: searchBarActionMargin,
                actionAlignment: searchBarActionAlignment,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to convert SearchbarVariant to TextFieldVariant
  TextFieldVariant _searchbarVariantToTextFieldVariant(
      SearchbarVariant variant) {
    switch (variant) {
      case SearchbarVariant.outlined:
        return TextFieldVariant.outlined;
      case SearchbarVariant.filled:
        return TextFieldVariant.filled;
      case SearchbarVariant.underlined:
        return TextFieldVariant.underlined;
      case SearchbarVariant.borderless:
        return TextFieldVariant.borderless;
      case SearchbarVariant.rounded:
        return TextFieldVariant.outlined; // Default to outlined for rounded
    }
  }
}
