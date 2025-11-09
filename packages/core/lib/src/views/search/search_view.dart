import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:core/src/base/master_view_cubit/master_view_cubit.dart';
import 'package:core/src/views/search/cubit/search_cubit.dart';
import 'package:core/src/views/search/cubit/search_state.dart';
import 'package:core/src/helper/asset_config_helper.dart';
import 'package:osmea_components/osmea_components.dart';

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
///   body: MyCustomSearchWidget(), // Optional custom body
///   // SearchBar styling (parameters only, no config dependency)
///   searchBarBorderRadius: BorderRadius.circular(16.0),
///   searchBarPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
///   // Action button customization (parameters only)
///   actionButtonSpacing: 1.0, // Reduce spacing between buttons
///   actionButtonMinWidth: 28.0, // Smaller button width
///   actionButtonMinHeight: 28.0, // Smaller button height
///   actionButtonPadding: EdgeInsets.all(2.0), // Tighter padding
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

  /// 🎨 AppBar background color
  final Color? appBarBackgroundColor;

  /// 🎨 SearchBar background color
  final Color? searchBarBackgroundColor;

  /// � SearchBar border radius
  final BorderRadius? searchBarBorderRadius;

  /// 🔲 SearchBar border color
  final Color? searchBarBorderColor;

  /// � SearchBar padding around the search field
  final EdgeInsetsGeometry? searchBarPadding;

  /// � SearchBar maximum width constraint
  final double? searchBarMaxWidth;

  /// ��📏 AppBar elevation
  final double elevation;

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

  /// 📱 Body widget to display instead of default search body
  final Widget? body;

  /// 📷 Whether to show barcode scanner action
  final bool showBarcodeScanner;

  /// 🎤 Whether to show voice search action
  final bool showVoiceSearch;

  /// 🗑️ Whether to show clear button in search bar
  final bool showClearButton;

  /// 🔍 Whether to show search icon in search bar
  final bool showSearchIcon;

  /// � Horizontal spacing between action buttons
  final double actionButtonSpacing;

  /// 📏 Minimum width for action buttons
  final double actionButtonMinWidth;

  /// 📏 Minimum height for action buttons
  final double actionButtonMinHeight;

  /// �📦 Padding for action buttons
  final EdgeInsetsGeometry actionButtonPadding;

  /// 📍 AppBar title alignment
  final AppBarTitleAlignment titleAlignment;

  /// 🏷️ Whether to show the title in AppBar
  final bool showTitle;

  /// 🎮 Action buttons to display in the searchbar
  final List<Widget> searchBarActions;

  /// 📏 Margin for searchbar action buttons
  final EdgeInsetsGeometry searchBarActionMargin;

  /// 📐 Alignment for searchbar action buttons
  final MainAxisAlignment searchBarActionAlignment;

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
    this.appBarBackgroundColor,
    this.searchBarBackgroundColor,
    this.searchBarBorderRadius,
    this.searchBarBorderColor,
    this.searchBarPadding,
    this.searchBarMaxWidth,
    this.elevation = 0,
    this.showBackButton = true,
    this.onBackPressed,
    this.maxHistoryItems = 10,
    this.minQueryLength = 2,
    this.initialHistory = const [],
    this.body,
    this.showBarcodeScanner = true,
    this.showVoiceSearch = true,
    this.showClearButton = true,
    this.showSearchIcon = false,
    this.actionButtonSpacing = 2.0,
    this.actionButtonMinWidth = 32.0,
    this.actionButtonMinHeight = 32.0,
    this.actionButtonPadding = const EdgeInsets.all(4.0),
    this.titleAlignment = AppBarTitleAlignment.center,
    this.showTitle = true,
    // SearchBar action parameters
    this.searchBarActions = const [],
    this.searchBarActionMargin = EdgeInsets.zero,
    this.searchBarActionAlignment = MainAxisAlignment.end,
  }) : super(
          goRoute: goRoute,
          arguments: arguments,
          appBarPadding: const AppBarPaddingVisibility.disabled(),
          verticalPadding: const PaddingVisibility.disabled(),
          navbarSpacer: const SpacerVisibility.disabled(),
          footerSpacer: const SpacerVisibility.disabled(),
          horizontalPadding: const PaddingVisibility.disabled(),
          coreAppBar: (context, viewModel) {
            final configHelper = AssetConfigHelper();
            final actionIconColor =
                configHelper.getSearchViewActionIconColor(OsmeaColors.pewter);

            if (showTitle) {
              // Build actions inline
              List<Widget> effectiveActions = [];
              if (searchBarActions.isNotEmpty) {
                effectiveActions = searchBarActions;
              } else {
                // Build default actions
                if (showBarcodeScanner) {
                  effectiveActions.add(
                    IconButton(
                      icon: Icon(Icons.qr_code_scanner,
                          size: 20, color: actionIconColor),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Barcode scanner clicked!')),
                        );
                      },
                      tooltip: 'Scan barcode',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                  );
                }

                if (showVoiceSearch) {
                  effectiveActions.add(
                    IconButton(
                      icon: Icon(Icons.mic, size: 20, color: actionIconColor),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) =>
                              OsmeaComponents.soundDialogWidget(
                            variant: SoundDialogVariant.inlineSearchBar,
                            promptTitleText: 'Speak now',
                            recordingTitleText: 'Listening...',
                            onConfirm: (searchText) {
                              debugPrint(
                                  '🎤 Voice search result (showTitle=true): $searchText');
                            },
                            onCancel: () {
                              debugPrint(
                                  '🎤 Voice search cancelled (showTitle=true)');
                            },
                          ),
                        );
                      },
                      tooltip: 'Voice search',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                  );
                }
              }

              return OsmeaComponents.appBarWithSearchBar(
                title: title,
                titleAlignment: titleAlignment,
                centerTitle: titleAlignment == AppBarTitleAlignment.center,
                leading: showBackButton
                    ? OsmeaComponents.iconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed:
                            onBackPressed ?? () => Navigator.of(context).pop(),
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.medium,
                        backgroundColor: Colors.transparent,
                      )
                    : null,
                appBarBackgroundColor: appBarBackgroundColor ??
                    configHelper.getSearchAppBarColor(),
                searchBarBackgroundColor: searchBarBackgroundColor ??
                    configHelper.getSearchBarBackgroundColor(),
                searchBarActions: effectiveActions,
                searchBarActionMargin: searchBarActionMargin,
                searchBarActionAlignment: searchBarActionAlignment,
                appBarVariant: appBarVariant,
                appBarSize: appBarSize,
                searchBarVariant: searchBarVariant,
                searchHint: searchHint ?? 'Search...',
                searchController: searchController,
                searchFocusNode: searchFocusNode,
                onSearch: (query) {
                  viewModel.performSearch(query,
                      searchProvider: searchProvider);
                  onSearchSubmitted?.call(query);
                },
                onSearchChanged: (query) {
                  viewModel.updateQuery(query);
                  onSearchChanged?.call(query);

                  if (searchSuggestionProvider != null) {
                    viewModel.getSuggestions(query,
                        suggestionProvider: searchSuggestionProvider);
                  }
                },
                onSearchClear: () {
                  viewModel.clearSearch();
                  onSearchClear?.call();
                },
                searchSuggestionProvider: searchSuggestionProvider,
              );
            } else {
              // Build actions inline
              List<Widget> effectiveActions = [];
              if (searchBarActions.isNotEmpty) {
                effectiveActions = searchBarActions;
              } else {
                // Build default actions
                if (showBarcodeScanner) {
                  effectiveActions.add(
                    IconButton(
                      icon: Icon(Icons.qr_code_scanner,
                          size: 20, color: actionIconColor),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Barcode scanner clicked!')),
                        );
                      },
                      tooltip: 'Scan barcode',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                  );
                }

                if (showVoiceSearch) {
                  effectiveActions.add(
                    IconButton(
                      icon: Icon(Icons.mic, size: 20, color: actionIconColor),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) =>
                              OsmeaComponents.soundDialogWidget(
                            variant: SoundDialogVariant.inlineSearchBar,
                            promptTitleText: 'Speak now',
                            recordingTitleText: 'Listening...',
                            onConfirm: (searchText) {
                              debugPrint(
                                  '🎤 Voice search result (showTitle=false): $searchText');
                            },
                            onCancel: () {
                              debugPrint(
                                  '🎤 Voice search cancelled (showTitle=false)');
                            },
                          ),
                        );
                      },
                      tooltip: 'Voice search',
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                  );
                }
              }

              return OsmeaComponents.appBar(
                backgroundColor: appBarBackgroundColor ??
                    configHelper.getSearchAppBarColor(),
                elevation: elevation,
                size: AppBarSize.large,
                leading: showBackButton
                    ? OsmeaComponents.iconButton(
                        icon: const Icon(Icons.arrow_back, size: 24),
                        onPressed:
                            onBackPressed ?? () => Navigator.of(context).pop(),
                        variant: ButtonVariant.ghost,
                        size: ButtonSize.medium,
                        backgroundColor: Colors.transparent,
                      )
                    : null,
                title: OsmeaComponents.searchbar(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  hint: searchHint ?? 'Search...',
                  size: searchBarSize,
                  showBackButton: showBackButton,
                  searchIcon: showSearchIcon
                      ? const Icon(Icons.search, size: 20)
                      : null,
                  borderColor: searchBarBorderColor,
                  variant: TextFieldVariant.outlined,
                  backgroundColor: searchBarBackgroundColor ??
                      configHelper.getSearchBarBackgroundColor(),
                  onChanged: (query) {
                    viewModel.updateQuery(query);
                    onSearchChanged?.call(query);

                    if (searchSuggestionProvider != null) {
                      viewModel.getSuggestions(query,
                          suggestionProvider: searchSuggestionProvider);
                    }
                  },
                  onSubmitted: (query) {
                    viewModel.performSearch(query,
                        searchProvider: searchProvider);
                    onSearchSubmitted?.call(query);
                  },
                  onClear: () {
                    viewModel.clearSearch();
                    onSearchClear?.call();
                  },
                  showClearButton: showClearButton,
                  showSearchIcon: showSearchIcon,
                  actions: effectiveActions,
                  actionMargin: searchBarActionMargin,
                  actionAlignment: searchBarActionAlignment,
                ),
                actions: [],
              );
            }
          },
        );

  @override
  Future<void> initialContent(viewModel, BuildContext context) async {
    debugPrint('🔍 Search View Started!');

    // Load configuration from app_config.json
    final AssetConfigHelper configHelper = AssetConfigHelper();
    await configHelper.loadConfig();
    debugPrint('🔧 Configuration loaded for SearchView');

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
    return _buildBody(context, viewModel, state);
  }

  // MARK: - Config Helper Methods

  /// Get effective elevation value (parameter or config)
  double get effectiveElevation {
    if (elevation != 0) return elevation;
    final configHelper = AssetConfigHelper();
    return configHelper.getSearchViewElevation();
  }

  /// Get effective search bar size (parameter or config)
  TextFieldSize get effectiveSearchBarSize {
    final configHelper = AssetConfigHelper();
    final sizeStr = configHelper.getSearchViewBarSize();
    switch (sizeStr.toLowerCase()) {
      case 'small':
        return TextFieldSize.small;
      case 'large':
        return TextFieldSize.large;
      default:
        return searchBarSize;
    }
  }

  /// Get effective search bar variant (parameter or config)
  SearchbarVariant get effectiveSearchBarVariant {
    final configHelper = AssetConfigHelper();
    final variantStr = configHelper.getSearchViewBarVariant();
    switch (variantStr.toLowerCase()) {
      case 'outlined':
        return SearchbarVariant.outlined;
      case 'filled':
        return SearchbarVariant.filled;
      default:
        return searchBarVariant;
    }
  }

  /// Get effective title (parameter or config)
  Widget? get effectiveTitle {
    if (title != null) return title;
    final configHelper = AssetConfigHelper();
    return Text(configHelper.getSearchViewTitle());
  }

  /// Get effective search hint (parameter or config)
  String get effectiveSearchHint {
    if (searchHint != null) return searchHint!;
    final configHelper = AssetConfigHelper();
    return configHelper.getSearchViewHint();
  }

  /// Get effective show barcode scanner (parameter or config)
  bool get effectiveShowBarcodeScanner {
    final configHelper = AssetConfigHelper();
    return configHelper.getSearchViewShowBarcodeScanner(showBarcodeScanner);
  }

  /// Get effective show voice search (parameter or config)
  bool get effectiveShowVoiceSearch {
    final configHelper = AssetConfigHelper();
    return configHelper.getSearchViewShowVoiceSearch(showVoiceSearch);
  }

  /// Get effective show back button (parameter or config)
  bool get effectiveShowBackButton {
    final configHelper = AssetConfigHelper();
    return configHelper.getSearchViewShowBackButton(showBackButton);
  }

  /// Get effective action button spacing (parameter or config)
  double get effectiveActionButtonSpacing {
    final configHelper = AssetConfigHelper();
    return configHelper.getSearchViewActionButtonSpacing(actionButtonSpacing);
  }

  /// Get effective action button min width (parameter or config)
  double get effectiveActionButtonMinWidth {
    final configHelper = AssetConfigHelper();
    return configHelper.getSearchViewActionButtonMinWidth(actionButtonMinWidth);
  }

  /// Get effective action button min height (parameter or config)
  double get effectiveActionButtonMinHeight {
    final configHelper = AssetConfigHelper();
    return configHelper
        .getSearchViewActionButtonMinHeight(actionButtonMinHeight);
  }

  /// Get effective action button padding (parameter or config)
  EdgeInsetsGeometry get effectiveActionButtonPadding {
    final configHelper = AssetConfigHelper();
    final paddingValue = configHelper.getSearchViewActionButtonPadding(4.0);
    return EdgeInsets.all(paddingValue);
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
