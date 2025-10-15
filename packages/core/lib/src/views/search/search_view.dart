import 'package:flutter/material.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:core/src/views/search/cubit/search_cubit.dart';
import 'package:core/src/views/search/cubit/search_state.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:osmea_components/osmea_components.dart';
import 'package:osmea_components/src/components/appbar_searchbar/appbar_searchbar.dart';

/// 🔍 **OSMEA Search View**
///
/// Copyright (c) 2025, OSMEA Team
/// https://github.com/masterfabric-mobile/osmea/tree/dev/packages/core
///
/// Main search view - provides comprehensive search functionality
/// Uses MasterViewCubit for lifecycle management
///
/// **Features:**
/// * 🔍 Integrated search bar in app bar
/// * 📝 Search suggestions and history
/// * ⚡ Debounced search functionality
/// * 🎨 Customizable appearance
/// * 📱 Responsive design
/// * 🔄 State management with cubit
///
/// **Usage:**
/// ```dart
/// SearchView(
///   goRoute: goRoute,
///   title: 'Search Products',
///   searchHint: 'Search for products...',
///   searchProvider: (query) async => await searchAPI(query),
///   onSearchResult: (results) => handleResults(results),
/// )
/// ```
///
/// {@category Views}
/// {@subCategory SearchView}
class SearchView extends MasterViewCubit<SearchCubit, SearchState> {
  /// 🏷️ Title for the search view
  final Widget? title;

  /// 🔍 Hint text for the search bar
  final String? searchHint;

  /// 🎮 Controller for the search text field
  final TextEditingController? searchController;

  /// 🎯 Focus node for the search text field
  final FocusNode? searchFocusNode;

  /// 📝 Callback when search text changes
  final ValueChanged<String>? onSearchChanged;

  /// ✅ Callback when search is submitted
  final ValueChanged<String>? onSearchSubmitted;

  /// 🗑️ Callback when search is cleared
  final VoidCallback? onSearchClear;

  /// 💡 Provider for search suggestions
  final Future<List<String>> Function(String query)? searchSuggestionProvider;

  /// 🔍 Provider for search results
  final Future<List<dynamic>> Function(String query)? searchProvider;

  /// 📊 Callback when search results are available
  final ValueChanged<List<dynamic>>? onSearchResult;

  /// ⚡ Actions for the app bar
  final List<AppBarWithSearchBarAction> actions;

  /// 🎨 AppBar visual variant
  final AppBarVariant appBarVariant;

  /// 📏 AppBar size
  final AppBarSize appBarSize;

  /// 🎨 SearchBar visual variant
  final SearchbarVariant searchBarVariant;

  /// 📏 SearchBar size
  final TextFieldSize searchBarSize;

  /// 🎨 Background color for the scaffold
  final Color? backgroundColor;

  /// ⬅️ Whether to show back button
  final bool showBackButton;

  /// 🔙 Callback when back button is pressed
  final VoidCallback? onBackPressed;

  /// � Maximum number of search history items
  final int maxHistoryItems;

  /// � Minimum query length to trigger search
  final int minQueryLength;

  /// 📜 Initial search history
  final List<String> initialHistory;

  SearchView({
    super.key,
    required Function(String path) goRoute,
    Map<String, dynamic> arguments = const {'search': true},
    this.title,
    this.searchHint,
    this.searchController,
    this.searchFocusNode,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchClear,
    this.searchSuggestionProvider,
    this.searchProvider,
    this.onSearchResult,
    this.actions = const [],
    this.appBarVariant = AppBarVariant.standard,
    this.appBarSize = AppBarSize.standard,
    this.searchBarVariant = SearchbarVariant.outlined,
    this.searchBarSize = TextFieldSize.medium,
    this.backgroundColor,
    this.showBackButton = true,
    this.onBackPressed,
    this.maxHistoryItems = 10,
    this.minQueryLength = 2,
    this.initialHistory = const [],
  }) : super(
          goRoute: goRoute,
          arguments: arguments,
        );

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🔍 Search View Started!');

    // Initialize search with history
    await viewModel.initializeSearch(
      maxHistoryItems: maxHistoryItems,
      minQueryLength: minQueryLength,
      initialHistory: initialHistory,
    );

    // Listen for search state changes
    viewModel.stream.listen((state) {
      if (state.hasResults && onSearchResult != null) {
        onSearchResult!(state.results);
      }
    });
  }

  @override
  Widget viewContent(BuildContext context, viewModel, state) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context, viewModel, state),
      body: SafeArea(
        child: Center(
          child: _buildBody(context, viewModel, state),
        ),
      ),
    );
  }

  /// Build the app bar with search functionality
  PreferredSizeWidget _buildAppBar(
      BuildContext context, SearchCubit viewModel, SearchState state) {
    // Get app bar color from configuration
    final AssetConfigHelper configHelper = AssetConfigHelper();
    final Color appBarBgColor =
        configHelper.getSearchAppBarColor(Theme.of(context).primaryColor);

    return OsmeaAppBarWithSearchBar(
      title: title ?? const Text('Search'),
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      actions: actions,
      // Apply color from configuration
      appBarBackgroundColor: appBarBgColor,
      appBarVariant: appBarVariant,
      appBarSize: appBarSize,
      searchBarVariant: searchBarVariant,
      searchBarSize: searchBarSize,
      searchHint: searchHint ?? 'Search...',
      searchController: searchController,
      searchFocusNode: searchFocusNode,
      onSearchChanged: (query) {
        viewModel.updateQuery(query);
        onSearchChanged?.call(query);

        // Get suggestions if provider is available
        if (searchSuggestionProvider != null) {
          viewModel.getSuggestions(query,
              suggestionProvider: searchSuggestionProvider);
        }
      },
      onSearchSubmitted: (query) {
        viewModel.performSearch(query, searchProvider: searchProvider);
        onSearchSubmitted?.call(query);
      },
      onSearchClear: () {
        viewModel.clearSearch();
        onSearchClear?.call();
      },
      searchSuggestionProvider: searchSuggestionProvider,
      searchProvider: searchProvider,
      showClearButton: true,
      showBackButton: false,
      showSearchIcon: true,
      showSuggestions: true,
      minQueryLength: minQueryLength,
      debounceDuration: const Duration(milliseconds: 300),
      searchBarActions: [
        IconButton(
          icon: const Icon(Icons.qr_code_scanner, size: 20),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Barcode scanner clicked!')),
            );
          },
          tooltip: 'Scan barcode',
        ),
        IconButton(
          icon: const Icon(Icons.mic, size: 20),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voice search clicked!')),
            );
          },
          tooltip: 'Voice search',
        ),
      ],
    );
  }

  /// Build the main body content
  Widget _buildBody(
      BuildContext context, SearchCubit viewModel, SearchState state) {
    if (state.isLoading) {
      return _buildLoadingView(context);
    }

    if (state.shouldShowError) {
      return _buildErrorView(context, state, viewModel);
    }

    if (state.hasResults) {
      return _buildResultsView(context, state, viewModel);
    }

    if (state.shouldShowNoResults) {
      return _buildNoResultsView(context, state);
    }

    // Default empty state
    return _buildEmptyView(context, state, viewModel);
  }

  /// Loading view using OSMEA components
  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: OsmeaComponents.container(
            padding: context.paddingNormal,
            width: double.infinity,
            alignment: Alignment.center,
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OsmeaComponents.progress(
                  type: ProgressType.linearRounded,
                  value: 0.0,
                  size: ProgressSize.medium,
                  progressColor: OsmeaColors.nordicBlue,
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.text(
                  'Searching...',
                  variant: OsmeaTextVariant.titleMedium,
                  color: OsmeaColors.pewter,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Error view using OSMEA components
  Widget _buildErrorView(
      BuildContext context, SearchState state, SearchCubit viewModel) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: OsmeaComponents.container(
            padding: context.paddingNormal,
            width: double.infinity,
            alignment: Alignment.center,
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.text(
                  'Error: ${state.errorMessage}',
                  variant: OsmeaTextVariant.titleMedium,
                  color: Colors.red,
                  textAlign: TextAlign.center,
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                Center(
                  child: OsmeaComponents.button(
                    text: 'Try Again',
                    onPressed: () => viewModel.reset(),
                    variant: ButtonVariant.outlined,
                    size: ButtonSize.medium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Results view using OSMEA components
  Widget _buildResultsView(
      BuildContext context, SearchState state, SearchCubit viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final result = state.results[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(result.toString()),
            onTap: () {
              // Handle result selection
              debugPrint('Selected result: $result');
            },
          ),
        );
      },
    );
  }

  /// No results view using OSMEA components
  Widget _buildNoResultsView(BuildContext context, SearchState state) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: OsmeaComponents.container(
            padding: context.paddingNormal,
            width: double.infinity,
            alignment: Alignment.center,
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.text(
                  'No results found for "${state.query}"',
                  variant: OsmeaTextVariant.titleMedium,
                  color: OsmeaColors.pewter,
                  textAlign: TextAlign.center,
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.text(
                  'Try searching with different keywords',
                  variant: OsmeaTextVariant.bodyMedium,
                  color: OsmeaColors.ash,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Empty state view using OSMEA components
  Widget _buildEmptyView(
      BuildContext context, SearchState state, SearchCubit viewModel) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: OsmeaComponents.container(
            padding: context.paddingNormal,
            width: double.infinity,
            alignment: Alignment.center,
            child: OsmeaComponents.column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.search,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                OsmeaComponents.text(
                  state.isSearching
                      ? 'Type to search...'
                      : 'Start typing to search',
                  variant: OsmeaTextVariant.titleMedium,
                  color: OsmeaColors.pewter,
                  textAlign: TextAlign.center,
                ),
                if (state.searchHistory.isNotEmpty) ...[
                  OsmeaComponents.sizedBox(height: context.spacing24),
                  OsmeaComponents.text(
                    'Recent searches:',
                    variant: OsmeaTextVariant.bodyMedium,
                    color: OsmeaColors.steel,
                    textAlign: TextAlign.center,
                  ),
                  OsmeaComponents.sizedBox(height: context.spacing8),
                  Center(
                    child: Wrap(
                      spacing: 8,
                      alignment: WrapAlignment.center,
                      children: state.searchHistory
                          .take(3)
                          .map(
                            (item) => Chip(
                              label: Text(item),
                              onDeleted: () =>
                                  viewModel.removeFromHistory(item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
