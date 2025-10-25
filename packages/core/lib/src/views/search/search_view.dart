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
  }) : super(
          goRoute: goRoute,
          arguments: arguments,
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(context, viewModel, state),
      body: SafeArea(
        child: body ??
            Container(
              width: double.infinity,
              height: double.infinity,
              child: _buildBody(context, viewModel, state),
            ),
      ),
    );
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

  /// Build the app bar with search functionality
  PreferredSizeWidget _buildAppBar(
      BuildContext context, SearchCubit viewModel, SearchState state) {
    // Determine AppBar background color
    // Priority: 1. Parameter value, 2. Config value, 3. Theme primary color
    Color appBarBgColor;
    if (appBarBackgroundColor != null) {
      appBarBgColor = appBarBackgroundColor!;
      debugPrint('🎨 Using parameter AppBar color: $appBarBgColor');
    } else {
      // Get app bar color from configuration
      final AssetConfigHelper configHelper = AssetConfigHelper();
      appBarBgColor =
          configHelper.getSearchAppBarColor(Theme.of(context).primaryColor);
      debugPrint('🎨 Using config AppBar color: $appBarBgColor');
    }

    return OsmeaComponents.appBar(
      backgroundColor: appBarBgColor,
      elevation: effectiveElevation,
      variant: appBarVariant,
      size: appBarSize,
      leading: effectiveShowBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: _buildSearchBarTitle(context, viewModel, state),
      titleAlignment: AppBarTitleAlignment.left,
      actions: _buildAppBarActions(context, viewModel),
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

  /// Build search bar as title
  Widget _buildSearchBarTitle(
      BuildContext context, SearchCubit viewModel, SearchState state) {
    final AssetConfigHelper configHelper = AssetConfigHelper();

    // Determine SearchBar background color
    // Priority: 1. Parameter value, 2. Config value, 3. Default light gray
    Color searchBarBgColor;
    if (searchBarBackgroundColor != null) {
      searchBarBgColor = searchBarBackgroundColor!;
      debugPrint(
          '🎨 Using parameter SearchBar background color: $searchBarBgColor');
    } else {
      searchBarBgColor = configHelper.getSearchBarBackgroundColor();
      debugPrint(
          '🎨 Using config SearchBar background color: $searchBarBgColor');
    }

    // Determine SearchBar border color
    // Priority: 1. Parameter value, 2. Config value, 3. Default light gray
    Color searchBarBorderCol;
    if (searchBarBorderColor != null) {
      searchBarBorderCol = searchBarBorderColor!;
      debugPrint(
          '🎨 Using parameter SearchBar border color: $searchBarBorderCol');
    } else {
      searchBarBorderCol = configHelper.getSearchBarBorderColor();
      debugPrint('🎨 Using config SearchBar border color: $searchBarBorderCol');
    }

    // Determine SearchBar border radius
    // Priority: 1. Parameter value, 2. Default radius
    BorderRadius searchBarBorderRad =
        searchBarBorderRadius ?? BorderRadius.circular(12.0);
    debugPrint('🎨 Using SearchBar border radius: $searchBarBorderRad');

    // Determine SearchBar padding
    // Priority: 1. Parameter value, 2. Default padding
    EdgeInsetsGeometry searchBarPad = searchBarPadding ??
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
    debugPrint('🎨 Using SearchBar padding: $searchBarPad');

    // Determine SearchBar show clear button
    // Priority: 1. Parameter value, 2. Config value, 3. Default value
    bool showClearBtn = showClearButton;
    if (!showClearButton) {
      // If parameter is explicitly false, check config for override
      showClearBtn = configHelper.getSearchBarShowClearButton(showClearButton);
      debugPrint('🎨 Using config SearchBar show clear button: $showClearBtn');
    } else {
      debugPrint(
          '🎨 Using parameter SearchBar show clear button: $showClearBtn');
    }

    // Determine SearchBar show search icon
    // Priority: 1. Parameter value, 2. Config value, 3. Default value
    bool showSearchIco = showSearchIcon;
    if (!showSearchIcon) {
      // If parameter is explicitly false, check config for override
      showSearchIco = configHelper.getSearchBarShowSearchIcon(showSearchIcon);
      debugPrint('🎨 Using config SearchBar show search icon: $showSearchIco');
    } else {
      debugPrint(
          '🎨 Using parameter SearchBar show search icon: $showSearchIco');
    }

    // Build the searchbar widget
    Widget searchBarWidget = OsmeaComponents.searchbar(
      controller: searchController,
      focusNode: searchFocusNode,
      hint: effectiveSearchHint,
      size: effectiveSearchBarSize, // Use the configurable size parameter
      searchbarVariant: effectiveSearchBarVariant,
      backgroundColor: searchBarBgColor,
      borderColor: searchBarBorderCol,
      customBorderRadius: searchBarBorderRad,
      onChanged: (query) {
        viewModel.updateQuery(query);
        onSearchChanged?.call(query);

        // Get suggestions if provider is available
        if (searchSuggestionProvider != null) {
          viewModel.getSuggestions(query,
              suggestionProvider: searchSuggestionProvider);
        }
      },
      onSubmitted: (query) {
        viewModel.performSearch(query, searchProvider: searchProvider);
        onSearchSubmitted?.call(query);
      },
      onClear: () {
        viewModel.clearSearch();
        onSearchClear?.call();
      },
      suggestionProvider: searchSuggestionProvider,
      searchProvider: searchProvider,
      showClearButton: showClearBtn,
      showSearchIcon: showSearchIco,
      actions: _buildSearchActions(context),
    );

    // Apply width constraint if specified
    if (searchBarMaxWidth != null) {
      searchBarWidget = SizedBox(
        width: searchBarMaxWidth,
        child: searchBarWidget,
      );
    }

    return Padding(
      padding: searchBarPad,
      child: searchBarWidget,
    );
  }

  /// Build app bar actions
  List<AppBarAction> _buildAppBarActions(
      BuildContext context, SearchCubit viewModel) {
    List<AppBarAction> appBarActions = [];

    // Add custom actions if any
    appBarActions.addAll(actions
        .map((action) => AppBarAction(
              icon: action.icon,
              onPressed: action.isEnabled ? action.onPressed : null,
              tooltip: action.tooltip,
              type: action.type,
            ))
        .toList());

    return appBarActions;
  }

  /// Build search actions based on configuration
  List<Widget> _buildSearchActions(BuildContext context) {
    List<Widget> actions = [];

    // Add barcode scanner action if enabled
    if (effectiveShowBarcodeScanner) {
      actions.add(
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: effectiveActionButtonSpacing),
          child: IconButton(
            constraints: BoxConstraints(
              minWidth: effectiveActionButtonMinWidth,
              minHeight: effectiveActionButtonMinHeight,
            ),
            padding: effectiveActionButtonPadding,
            icon: const Icon(Icons.qr_code_scanner, size: 18),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Barcode scanner clicked!')),
              );
            },
            tooltip: 'Scan barcode',
          ),
        ),
      );
    }

    // Add voice search action if enabled
    if (effectiveShowVoiceSearch) {
      actions.add(
        Container(
          margin:
              EdgeInsets.symmetric(horizontal: effectiveActionButtonSpacing),
          child: IconButton(
            constraints: BoxConstraints(
              minWidth: effectiveActionButtonMinWidth,
              minHeight: effectiveActionButtonMinHeight,
            ),
            padding: effectiveActionButtonPadding,
            icon: const Icon(Icons.mic, size: 18),
            onPressed: () {
              OsmeaComponents.soundDialog(
                context,
                variant: SoundDialogVariant.standard,
                promptTitleText: 'Voice Search',
                recordingTitleText: 'Listening...',
                okButtonText: 'Search',
                cancelButtonText: 'Cancel',
                onConfirm: (filePath) {
                  // Handle voice search result
                  debugPrint('🎤 Voice search recorded: $filePath');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Voice search completed! Processing...'),
                  ));
                },
                onCancel: () {
                  debugPrint('🚫 Voice search cancelled');
                },
                primaryActionColor: Theme.of(context).primaryColor,
                maxRecordingDuration: const Duration(seconds: 30),
                autoStopOnMaxDuration: true,
              );
            },
            tooltip: 'Voice search',
          ),
        ),
      );
    }

    return actions;
  }
}
