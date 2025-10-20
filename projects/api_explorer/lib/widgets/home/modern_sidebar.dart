import 'package:flutter/material.dart';
import 'package:apis/apis.dart';
import 'package:apis/services/store_change_notifier.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:api_explorer/styles/app_theme.dart';
import 'package:core/core.dart';
import 'package:osmea_components/osmea_components.dart';
import 'dart:async';

/// Modern Sidebar using Osmea components
class ModernSidebar extends StatefulWidget {
  final bool expanded;
  final ApiService? selectedService;
  final Function(ApiService) onServiceSelected;
  final Animation<double> animation;

  const ModernSidebar({
    super.key,
    required this.expanded,
    required this.selectedService,
    required this.onServiceSelected,
    required this.animation,
  });

  @override
  State<ModernSidebar> createState() => _ModernSidebarState();
}

class _ModernSidebarState extends State<ModernSidebar>
    with SingleTickerProviderStateMixin {
  ApiCategory? _selectedMainCategory;
  ApiCategory? _selectedCategory;
  String? _selectedSubcategory;
  late AnimationController _categoryAnimationController;
  late Animation<double> _categoryAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _isDisposed = false;
  StreamSubscription<StoreChangeEvent>? _storeChangeSubscription;
  StoreConfiguration? _currentStore;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, List<ApiService>> _groupedFilteredServices = {};

  @override
  void initState() {
    super.initState();
    _categoryAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _categoryAnimation = CurvedAnimation(
      parent: _categoryAnimationController,
      curve: Curves.easeInOut,
    );

    _listenToStoreChanges();
    _loadCurrentStore();
    _initializeDefaultCategory();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _categoryAnimationController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _storeChangeSubscription?.cancel();
    super.dispose();
  }

  void _listenToStoreChanges() {
    try {
      _storeChangeSubscription = WizardHelper.storeChangeStream.listen(
        (event) {
          if (mounted && !_isDisposed) {
            debugPrint('🔄 Sidebar: Store change detected: ${event.type}');
            setState(() {
              // Reset selections when store changes
              _selectedMainCategory = null;
              _selectedCategory = null;
              _selectedSubcategory = null;
            });
            _loadCurrentStore();
          }
        },
        onError: (error) {
          debugPrint('❌ Error listening to store changes in sidebar: $error');
        },
      );
    } catch (e) {
      debugPrint('❌ Error setting up store change listener in sidebar: $e');
    }
  }

  Future<void> _loadCurrentStore() async {
    try {
      final store = await WizardHelper.getCurrentStore();
      if (mounted && !_isDisposed) {
        setState(() {
          _currentStore = store;
        });
        // Initialize default category after store is loaded
        _initializeDefaultCategory();
      }
    } catch (e) {
      debugPrint('❌ Error loading current store in sidebar: $e');
    }
  }

  /// Initialize default category to be expanded when sidebar opens
  void _initializeDefaultCategory() {
    if (_currentStore != null && _isCurrentStoreComplete) {
      final availableCategories = ApiServiceRegistry.categories
          .where((cat) => _hasStoreForPlatform(cat))
          .toList();

      if (availableCategories.isNotEmpty && _selectedMainCategory == null) {
        // Select the first available category by default
        final defaultMainCategory = availableCategories.first;
        final subCategories =
            _getCategoriesForCurrentStore(defaultMainCategory);

        setState(() {
          _selectedMainCategory = defaultMainCategory;
          _categoryAnimationController.forward();

          // Also auto-select first subcategory if available
          if (subCategories.isNotEmpty) {
            _selectedCategory = subCategories.first;
          }
        });
      }
    }
  }

  /// Check available store types based on current stores
  Future<Set<String>> _getAvailableStoreTypes() async {
    final Set<String> storeTypes = {};

    try {
      // Get all stores and check which platforms are configured
      final allStores = await WizardHelper.getAllStores();

      for (final store in allStores) {
        if (store.isComplete) {
          switch (store.platform) {
            case 'woocommerce':
              storeTypes.add('WooCommerce');
              break;
            case 'shopify':
              storeTypes.add('Shopify');
              break;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error getting available store types: $e');
    }

    return storeTypes;
  }

  void _selectMainCategory(ApiCategory mainCategory) {
    setState(() {
      if (_selectedMainCategory == mainCategory) {
        // Don't close if already selected, just keep it open
        return;
      } else {
        _selectedMainCategory = mainCategory;
        _selectedCategory = null;
        _selectedSubcategory = null;
        _categoryAnimationController.forward();
      }
    });
  }

  void _selectCategory(ApiCategory category) {
    setState(() {
      if (_selectedCategory == category) {
        // Don't close if already selected, just keep it open
        return;
      } else {
        _selectedCategory = category;
        _selectedSubcategory = null;
        _categoryAnimationController.forward();
      }
    });
  }

  void _selectSubcategory(String subcategory) {
    setState(() {
      _selectedSubcategory = subcategory;
    });
  }

  bool get _isCurrentStoreComplete => _currentStore?.isComplete ?? false;

  /// Check if user has configured stores for a specific platform
  bool _hasStoreForPlatform(ApiCategory mainCategory) {
    // We'll cache this to avoid repeated async calls
    // For now, check current store only, but this can be expanded
    if (_currentStore == null) return false;

    switch (mainCategory) {
      case ApiCategory.shopify:
        return _currentStore!.platform == 'shopify';
      case ApiCategory.woocommerce:
        return _currentStore!.platform == 'woocommerce';
      case ApiCategory.shopifyGraphql:
        return _currentStore!.platform == 'shopify';
      default:
        return false;
    }
  }

  List<ApiCategory> _getCategoriesForCurrentStore(ApiCategory mainCategory) {
    if (!_hasStoreForPlatform(mainCategory)) return [];

    switch (mainCategory) {
      case ApiCategory.shopify:
        return ApiServiceRegistry.getShopifyCategories();
      case ApiCategory.woocommerce:
        return ApiServiceRegistry.getWooCommerceAdminCategories();
      case ApiCategory.shopifyGraphql:
        return [
          ...ApiServiceRegistry.getShopifyGraphqlCategories(),
          ApiCategory.graphqlQueries, // Webhook'ları da dahil et
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 280;
        final isMobile = constraints.maxHeight < 600;

        return OsmeaComponents.container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? OsmeaColors.eclipse
                : OsmeaColors.white,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                offset: const Offset(2, 0),
                blurRadius: 8,
              ),
            ],
          ),
          child: OsmeaComponents.column(
            children: [
              // Responsive Sidebar Header
              OsmeaComponents.container(
                constraints: BoxConstraints(
                  minHeight: isMobile ? 120 : 140,
                  maxHeight: isMobile ? 160 : 180,
                ),
                padding: EdgeInsets.all(isNarrow ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? OsmeaAppTheme.createGradient(
                          OsmeaColors.eclipse,
                          OsmeaColors.deepSea,
                        )
                      : OsmeaAppTheme.createGradient(
                          OsmeaColors.nordicBlue,
                          OsmeaColors.nordicBlue.withValues(alpha: 0.8),
                        ),
                ),
                child: OsmeaComponents.column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OsmeaComponents.row(
                      children: [
                        OsmeaComponents.container(
                          padding: EdgeInsets.all(isNarrow ? 8 : 12),
                          decoration: BoxDecoration(
                            color: OsmeaColors.white.withValues(alpha: 0.2),
                            borderRadius: context.borderRadiusMinStandard,
                          ),
                          child: Icon(
                            Icons.explore_rounded,
                            color: OsmeaColors.white,
                            size: isNarrow ? 20 : 24,
                          ),
                        ),
                        OsmeaComponents.sizedBox(width: 12),
                        OsmeaComponents.expanded(
                          child: OsmeaComponents.column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              OsmeaComponents.text(
                                'API Explorer',
                                variant: OsmeaTextVariant.titleMedium,
                                fontSize: isNarrow ? 16 : 18,
                                fontWeight: FontWeight.w700,
                                color: OsmeaColors.white,
                              ),
                              if (!isNarrow)
                                OsmeaComponents.text(
                                  'Browse and test APIs',
                                  variant: OsmeaTextVariant.bodySmall,
                                  fontSize: 12,
                                  color:
                                      OsmeaColors.white.withValues(alpha: 0.8),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    OsmeaComponents.sizedBox(height: 8),

                    // Store Status Indicator
                    if (_currentStore != null)
                      OsmeaComponents.flexible(
                        child: OsmeaComponents.container(
                          decoration: BoxDecoration(
                            color: OsmeaColors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(12),
                          child: OsmeaComponents.row(
                            children: [
                              Icon(
                                Icons.store,
                                size: 16,
                                color: OsmeaColors.white,
                              ),
                              OsmeaComponents.sizedBox(width: 8),
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    OsmeaComponents.text(
                                      _currentStore!.platform.toUpperCase(),
                                      variant: OsmeaTextVariant.labelMedium,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: OsmeaColors.white,
                                    ),
                                    OsmeaComponents.text(
                                      _isCurrentStoreComplete
                                          ? 'Ready'
                                          : 'Setup Incomplete',
                                      variant: OsmeaTextVariant.labelSmall,
                                      fontSize: 10,
                                      color: _isCurrentStoreComplete
                                          ? OsmeaColors.green[100]
                                          : OsmeaColors.orange[100],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Store Info Panel (shown after wizard completion)
              if (_currentStore != null &&
                  _isCurrentStoreComplete &&
                  widget.expanded)
                OsmeaComponents.container(
                  margin: EdgeInsets.all(isNarrow ? 12 : 16),
                  padding: EdgeInsets.all(isNarrow ? 16 : 20),
                  decoration: BoxDecoration(
                    gradient: OsmeaAppTheme.createGradient(
                      Theme.of(context).brightness == Brightness.dark
                          ? OsmeaColors.eclipse.withValues(alpha: 0.1)
                          : OsmeaColors.snow,
                      Theme.of(context).brightness == Brightness.dark
                          ? OsmeaColors.deepSea.withValues(alpha: 0.05)
                          : OsmeaColors.white,
                    ),
                    borderRadius: context.borderRadiusMinStandard,
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? OsmeaColors.deepSea.withValues(alpha: 0.2)
                          : OsmeaColors.silver.withValues(alpha: 0.3),
                    ),
                  ),
                  child: OsmeaComponents.column(
                    children: [
                      OsmeaComponents.row(
                        children: [
                          OsmeaComponents.container(
                            padding: EdgeInsets.all(isNarrow ? 8 : 10),
                            decoration: BoxDecoration(
                              color: OsmeaAppTheme.primaryColor
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.rocket_launch_rounded,
                              size: isNarrow ? 16 : 18,
                              color: OsmeaColors.nordicBlue,
                            ),
                          ),
                          OsmeaComponents.sizedBox(width: isNarrow ? 8 : 12),
                          OsmeaComponents.expanded(
                            child: OsmeaComponents.column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OsmeaComponents.text(
                                  'Ready to Explore!',
                                  variant: OsmeaTextVariant.labelMedium,
                                  fontSize: isNarrow ? 13 : 14,
                                  fontWeight: FontWeight.w600,
                                  color: OsmeaColors.nordicBlue,
                                ),
                                OsmeaComponents.text(
                                  'Your ${_currentStore!.platform.toUpperCase()} store is configured',
                                  variant: OsmeaTextVariant.bodySmall,
                                  fontSize: isNarrow ? 10 : 11,
                                  color: OsmeaAppTheme.primaryColor
                                      .withValues(alpha: 0.7),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      OsmeaComponents.sizedBox(height: isNarrow ? 8 : 12),
                      OsmeaComponents.container(
                        padding: EdgeInsets.all(isNarrow ? 8 : 10),
                        decoration: BoxDecoration(
                          color: OsmeaAppTheme.primaryColor
                              .withValues(alpha: 0.05),
                          borderRadius: context.borderRadiusMinStandard,
                          border: Border.all(
                            color: OsmeaAppTheme.primaryColor
                                .withValues(alpha: 0.1),
                          ),
                        ),
                        child: OsmeaComponents.row(
                          children: [
                            Icon(
                              Icons.explore_rounded,
                              size: isNarrow ? 14 : 16,
                              color: OsmeaColors.nordicBlue,
                            ),
                            OsmeaComponents.sizedBox(width: isNarrow ? 6 : 8),
                            OsmeaComponents.expanded(
                              child: OsmeaComponents.text(
                                'Select a category below to start exploring APIs',
                                variant: OsmeaTextVariant.bodySmall,
                                fontSize: isNarrow ? 11 : 12,
                                color: OsmeaColors.nordicBlue,
                                fontWeight: FontWeight.w500,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Search Bar Section
              if (_currentStore != null &&
                  _isCurrentStoreComplete &&
                  widget.expanded)
                OsmeaComponents.container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isNarrow ? 12 : 16,
                    vertical: isNarrow ? 8 : 12,
                  ),
                  child: OsmeaComponents.searchbar(
                    controller: _searchController,
                    hint: 'Search APIs, categories, endpoints...',
                    size: TextFieldSize.small,
                    variant: TextFieldVariant.outlined,
                    searchbarVariant: SearchbarVariant.outlined,
                    searchbarStyle: SearchbarStyle.standard,
                    onChanged: _onSearchChanged,
                    onClear: _clearSearch,
                    showClearButton: true,
                    showSearchIcon: true,
                    minQueryLength: 1,
                    debounceDuration: const Duration(milliseconds: 200),
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    borderColor: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                    focusColor: OsmeaColors.nordicBlue,
                    hintColor: Theme.of(context).hintColor,
                    textColor: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),

              // Scrollable Content Section
              Flexible(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: OsmeaComponents.column(
                    children: [
                      // Search Results Section
                      if (_searchQuery.isNotEmpty &&
                          _groupedFilteredServices.isNotEmpty)
                        OsmeaComponents.container(
                          margin: EdgeInsets.symmetric(
                              horizontal: isNarrow ? 12 : 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: context.borderRadiusMinStandard,
                            border: Border.all(
                              color:
                                  OsmeaColors.nordicBlue.withValues(alpha: 0.2),
                            ),
                          ),
                          child: OsmeaComponents.column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Search Results Header
                              OsmeaComponents.container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: OsmeaColors.nordicBlue
                                      .withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        context.borderRadiusMinStandard.topLeft,
                                    topRight: context
                                        .borderRadiusMinStandard.topRight,
                                  ),
                                ),
                                child: OsmeaComponents.row(
                                  children: [
                                    Icon(
                                      Icons.search_rounded,
                                      size: 16,
                                      color: OsmeaColors.nordicBlue,
                                    ),
                                    OsmeaComponents.sizedBox(width: 8),
                                    OsmeaComponents.text(
                                      'Search Results ($_totalFilteredCount)',
                                      variant: OsmeaTextVariant.labelMedium,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: OsmeaColors.nordicBlue,
                                    ),
                                  ],
                                ),
                              ),

                              // Grouped Results List
                              OsmeaComponents.container(
                                constraints: BoxConstraints(
                                  maxHeight: constraints.maxHeight *
                                      0.4, // Dynamic height based on screen
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount:
                                      _groupedFilteredServices.keys.length,
                                  itemBuilder: (context, groupIndex) {
                                    final platform = _groupedFilteredServices
                                        .keys
                                        .elementAt(groupIndex);
                                    final services =
                                        _groupedFilteredServices[platform]!;

                                    return OsmeaComponents.column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Platform Header
                                        OsmeaComponents.container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getPlatformColor(platform)
                                                .withValues(alpha: 0.1),
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline
                                                    .withValues(alpha: 0.1),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: OsmeaComponents.row(
                                            children: [
                                              Icon(
                                                _getPlatformIcon(platform),
                                                size: 16,
                                                color:
                                                    _getPlatformColor(platform),
                                              ),
                                              OsmeaComponents.sizedBox(
                                                  width: 8),
                                              OsmeaComponents.text(
                                                platform,
                                                variant: OsmeaTextVariant
                                                    .labelMedium,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    _getPlatformColor(platform),
                                              ),
                                              OsmeaComponents.sizedBox(
                                                  width: 4),
                                              OsmeaComponents.container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: _getPlatformColor(
                                                          platform)
                                                      .withValues(alpha: 0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: OsmeaComponents.text(
                                                  '${services.length}',
                                                  variant: OsmeaTextVariant
                                                      .labelSmall,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: _getPlatformColor(
                                                      platform),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Platform Services
                                        ...services.map((service) {
                                          final isSelected =
                                              widget.selectedService == service;

                                          return GestureDetector(
                                            onTap: () => widget
                                                .onServiceSelected(service),
                                            child: OsmeaComponents.container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? OsmeaColors.nordicBlue
                                                        .withValues(alpha: 0.1)
                                                    : Colors.transparent,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline
                                                        .withValues(
                                                            alpha: 0.05),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              child: OsmeaComponents.row(
                                                children: [
                                                  Icon(
                                                    ApiServiceRegistry
                                                        .getCategoryIcon(
                                                            service.category),
                                                    size: 16,
                                                    color: isSelected
                                                        ? OsmeaColors.nordicBlue
                                                        : Theme.of(context)
                                                            .iconTheme
                                                            .color
                                                            ?.withValues(
                                                                alpha: 0.7),
                                                  ),
                                                  OsmeaComponents.sizedBox(
                                                      width: 12),
                                                  OsmeaComponents.expanded(
                                                    child:
                                                        OsmeaComponents.column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        OsmeaComponents.text(
                                                          service.name,
                                                          variant:
                                                              OsmeaTextVariant
                                                                  .bodySmall,
                                                          fontSize: 12,
                                                          fontWeight: isSelected
                                                              ? FontWeight.w600
                                                              : FontWeight.w500,
                                                          color: isSelected
                                                              ? OsmeaColors
                                                                  .nordicBlue
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        OsmeaComponents
                                                            .sizedBox(
                                                                height: 2),
                                                        OsmeaComponents.text(
                                                          '${service.subcategory} • ${service.supportedMethods.join(', ')}',
                                                          variant:
                                                              OsmeaTextVariant
                                                                  .bodySmall,
                                                          fontSize: 10,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall
                                                                  ?.color
                                                                  ?.withValues(
                                                                      alpha:
                                                                          0.7),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      // No Search Results
                      if (_searchQuery.isNotEmpty &&
                          _groupedFilteredServices.isEmpty)
                        OsmeaComponents.container(
                          margin: EdgeInsets.all(isNarrow ? 12 : 16),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: context.borderRadiusMinStandard,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outline
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: OsmeaComponents.column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 32,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color
                                    ?.withValues(alpha: 0.5),
                              ),
                              OsmeaComponents.sizedBox(height: 12),
                              OsmeaComponents.text(
                                'No APIs found',
                                variant: OsmeaTextVariant.titleSmall,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.color,
                                textAlign: TextAlign.center,
                              ),
                              OsmeaComponents.sizedBox(height: 4),
                              OsmeaComponents.text(
                                'Try searching with different keywords like "product", "order", or "customer"',
                                variant: OsmeaTextVariant.bodySmall,
                                fontSize: 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),

                      // Responsive Get Started Section
                      if (widget.selectedService == null &&
                          widget.expanded &&
                          (_currentStore == null || !_isCurrentStoreComplete))
                        OsmeaComponents.container(
                          margin: EdgeInsets.all(isNarrow ? 12 : 16),
                          padding: EdgeInsets.all(isNarrow ? 16 : 20),
                          decoration: BoxDecoration(
                            gradient: OsmeaAppTheme.createGradient(
                              OsmeaAppTheme.primaryColor
                                  .withValues(alpha: 0.05),
                              OsmeaAppTheme.primaryVariant
                                  .withValues(alpha: 0.02),
                            ),
                            borderRadius: context.borderRadiusMinStandard,
                            border: Border.all(
                              color: OsmeaAppTheme.primaryColor
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                          child: OsmeaComponents.column(
                            children: [
                              OsmeaComponents.container(
                                padding: EdgeInsets.all(isNarrow ? 10 : 12),
                                decoration: BoxDecoration(
                                  color: OsmeaAppTheme.primaryColor
                                      .withValues(alpha: 0.01),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.touch_app_rounded,
                                  size: isNarrow ? 20 : 24,
                                  color: OsmeaAppTheme.primaryColor,
                                ),
                              ),
                              OsmeaComponents.sizedBox(
                                  height: isNarrow ? 8 : 12),
                              OsmeaComponents.text(
                                _currentStore == null
                                    ? 'Get Started'
                                    : 'Complete Setup',
                                variant: OsmeaTextVariant.labelLarge,
                                fontSize: isNarrow ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                color: OsmeaAppTheme.primaryColor,
                                textAlign: TextAlign.center,
                              ),
                              OsmeaComponents.sizedBox(
                                  height: isNarrow ? 4 : 6),
                              OsmeaComponents.text(
                                _currentStore == null
                                    ? 'Complete the store setup wizard to access APIs'
                                    : 'Complete your store configuration to access APIs',
                                variant: OsmeaTextVariant.bodySmall,
                                fontSize: isNarrow ? 11 : 12,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.7),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                              OsmeaComponents.sizedBox(
                                  height: isNarrow ? 8 : 12),
                              OsmeaComponents.container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isNarrow ? 8 : 12,
                                  vertical: isNarrow ? 4 : 6,
                                ),
                                decoration: BoxDecoration(
                                  color: OsmeaAppTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: context.borderRadiusMedium,
                                  border: Border.all(
                                    color: OsmeaAppTheme.primaryColor
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                child: OsmeaComponents.row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.arrow_downward_rounded,
                                      size: isNarrow ? 12 : 14,
                                      color: OsmeaColors.nordicBlue,
                                    ),
                                    OsmeaComponents.sizedBox(
                                        width: isNarrow ? 4 : 6),
                                    OsmeaComponents.text(
                                      _currentStore == null
                                          ? 'Setup required'
                                          : 'Configuration needed',
                                      variant: OsmeaTextVariant.labelSmall,
                                      fontSize: isNarrow ? 10 : 11,
                                      fontWeight: FontWeight.w500,
                                      color: OsmeaColors.nordicBlue,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Selection Guidance when category is selected but no subcategory
                      if (_selectedCategory != null &&
                          _selectedSubcategory == null &&
                          widget.expanded)
                        OsmeaComponents.container(
                          margin: EdgeInsets.symmetric(
                              horizontal: isNarrow ? 12 : 16),
                          padding: EdgeInsets.all(isNarrow ? 12 : 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.05),
                            borderRadius: context.borderRadiusMinStandard,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: OsmeaComponents.row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: isNarrow ? 16 : 18,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              OsmeaComponents.sizedBox(width: isNarrow ? 6 : 8),
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.text(
                                  'Select a subcategory to view available APIs',
                                  variant: OsmeaTextVariant.bodySmall,
                                  fontSize: isNarrow ? 11 : 12,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Service Selection Guidance when subcategory is selected
                      if (_selectedSubcategory != null &&
                          widget.selectedService == null &&
                          widget.expanded)
                        OsmeaComponents.container(
                          margin: EdgeInsets.symmetric(
                              horizontal: isNarrow ? 12 : 16),
                          padding: EdgeInsets.all(isNarrow ? 12 : 16),
                          decoration: BoxDecoration(
                            color: OsmeaAppTheme.successColor
                                .withValues(alpha: 0.05),
                            borderRadius: context.borderRadiusMinStandard,
                            border: Border.all(
                              color: OsmeaAppTheme.successColor
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: OsmeaComponents.row(
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: isNarrow ? 16 : 18,
                                color: OsmeaAppTheme.successColor,
                              ),
                              OsmeaComponents.sizedBox(width: isNarrow ? 6 : 8),
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.text(
                                  'Great! Now select an API service to start testing',
                                  variant: OsmeaTextVariant.bodySmall,
                                  fontSize: isNarrow ? 11 : 12,
                                  color: OsmeaAppTheme.successColor,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Admin APIs Section Header
                      if (_currentStore != null &&
                          _isCurrentStoreComplete &&
                          widget.expanded)
                        OsmeaComponents.container(
                          margin: EdgeInsets.symmetric(
                            horizontal: isNarrow ? 12 : 16,
                            vertical: isNarrow ? 8 : 12,
                          ),
                          padding: EdgeInsets.all(isNarrow ? 12 : 16),
                          decoration: BoxDecoration(
                            gradient: OsmeaAppTheme.createGradient(
                              OsmeaColors.red[50]?.withValues(alpha: 0.3) ??
                                  Colors.red.withValues(alpha: 0.05),
                              OsmeaColors.red[100]?.withValues(alpha: 0.1) ??
                                  Colors.red.withValues(alpha: 0.02),
                            ),
                            borderRadius: context.borderRadiusMinStandard,
                            border: Border.all(
                              color: OsmeaColors.red[200]
                                      ?.withValues(alpha: 0.3) ??
                                  Colors.red.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: OsmeaComponents.row(
                            children: [
                              OsmeaComponents.container(
                                padding: EdgeInsets.all(isNarrow ? 8 : 10),
                                decoration: BoxDecoration(
                                  color: OsmeaColors.red[100]
                                          ?.withValues(alpha: 0.3) ??
                                      Colors.red.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.admin_panel_settings_rounded,
                                  size: isNarrow ? 18 : 20,
                                  color:
                                      OsmeaColors.red[600] ?? Colors.red[600],
                                ),
                              ),
                              OsmeaComponents.sizedBox(
                                  width: isNarrow ? 8 : 12),
                              OsmeaComponents.expanded(
                                child: OsmeaComponents.column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OsmeaComponents.text(
                                      'Admin APIs',
                                      variant: OsmeaTextVariant.titleSmall,
                                      fontSize: isNarrow ? 14 : 16,
                                      fontWeight: FontWeight.w700,
                                      color: OsmeaColors.red[700] ??
                                          Colors.red[700],
                                    ),
                                    OsmeaComponents.sizedBox(height: 2),
                                    OsmeaComponents.text(
                                      'Management and configuration APIs for administrators',
                                      variant: OsmeaTextVariant.bodySmall,
                                      fontSize: isNarrow ? 11 : 12,
                                      color: OsmeaColors.red[600]
                                              ?.withValues(alpha: 0.8) ??
                                          Colors.red[600]
                                              ?.withValues(alpha: 0.8),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                              OsmeaComponents.container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isNarrow ? 6 : 8,
                                  vertical: isNarrow ? 2 : 4,
                                ),
                                decoration: BoxDecoration(
                                  color: OsmeaColors.red[600]
                                          ?.withValues(alpha: 0.1) ??
                                      Colors.red[600]?.withValues(alpha: 0.1),
                                  borderRadius: context.borderRadiusMinStandard,
                                ),
                                child: OsmeaComponents.text(
                                  'Current',
                                  variant: OsmeaTextVariant.labelSmall,
                                  fontSize: isNarrow ? 10 : 11,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      OsmeaColors.red[600] ?? Colors.red[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Categories List
                      if (_currentStore != null && _isCurrentStoreComplete)
                        OsmeaComponents.container(
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight * 0.5,
                          ),
                          child: Scrollbar(
                            controller: _scrollController,
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(isNarrow ? 6 : 8),
                              itemCount: ApiServiceRegistry.categories
                                  .where((cat) => _hasStoreForPlatform(cat))
                                  .length,
                              itemBuilder: (context, mainIndex) {
                                final availableCategories = ApiServiceRegistry
                                    .categories
                                    .where((cat) => _hasStoreForPlatform(cat))
                                    .toList();
                                final mainCategory =
                                    availableCategories[mainIndex];
                                final isMainSelected =
                                    _selectedMainCategory == mainCategory;
                                final hasStore =
                                    _hasStoreForPlatform(mainCategory);
                                final subCategories = hasStore
                                    ? _getCategoriesForCurrentStore(
                                        mainCategory)
                                    : [];

                                return OsmeaComponents.column(
                                  children: [
                                    // Main Category Header
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        color: isMainSelected
                                            ? OsmeaColors.nordicBlue
                                                .withValues(alpha: 0.03)
                                            : OsmeaColors.transparent,
                                        borderRadius:
                                            context.borderRadiusMinStandard,
                                      ),
                                      child: ListTile(
                                        dense: !widget.expanded || isMobile,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: widget.expanded
                                              ? (isNarrow ? 12 : 16)
                                              : 8,
                                          vertical: isMobile ? 2 : 4,
                                        ),
                                        leading: Icon(
                                          ApiServiceRegistry.getCategoryIcon(
                                              mainCategory),
                                          color: hasStore &&
                                                  _isCurrentStoreComplete
                                              ? (isMainSelected
                                                  ? OsmeaColors.nordicBlue
                                                  : Theme.of(context)
                                                      .iconTheme
                                                      .color)
                                              : Theme.of(context)
                                                  .iconTheme
                                                  .color
                                                  ?.withValues(alpha: 0.4),
                                          size: isNarrow ? 20 : 22,
                                        ),
                                        title: widget.expanded
                                            ? OsmeaComponents.text(
                                                ApiServiceRegistry
                                                    .getCategoryName(
                                                        mainCategory),
                                                variant: OsmeaTextVariant
                                                    .labelMedium,
                                                color: hasStore &&
                                                        _isCurrentStoreComplete
                                                    ? (isMainSelected
                                                        ? OsmeaColors.nordicBlue
                                                        : Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.color)
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color
                                                        ?.withValues(
                                                            alpha: 0.4),
                                                fontWeight: isMainSelected
                                                    ? FontWeight.w700
                                                    : FontWeight.w600,
                                                fontSize: isNarrow ? 13 : 15,
                                              )
                                            : null,
                                        trailing: widget.expanded
                                            ? OsmeaComponents.row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (!hasStore ||
                                                      !_isCurrentStoreComplete)
                                                    OsmeaComponents.container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            isNarrow ? 4 : 6,
                                                        vertical: 2,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error
                                                            .withValues(
                                                                alpha: 0.1),
                                                        borderRadius: context
                                                            .borderRadiusMinStandard,
                                                      ),
                                                      child:
                                                          OsmeaComponents.text(
                                                        !hasStore
                                                            ? 'No Store'
                                                            : 'Incomplete',
                                                        variant:
                                                            OsmeaTextVariant
                                                                .labelSmall,
                                                        fontSize:
                                                            isNarrow ? 8 : 9,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  if (hasStore &&
                                                      _isCurrentStoreComplete &&
                                                      subCategories.isNotEmpty)
                                                    AnimatedRotation(
                                                      turns: isMainSelected
                                                          ? 0.25
                                                          : 0,
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      child: Icon(
                                                        Icons.chevron_right,
                                                        size:
                                                            isNarrow ? 16 : 18,
                                                        color: isMainSelected
                                                            ? OsmeaColors
                                                                .nordicBlue
                                                            : Theme.of(context)
                                                                .iconTheme
                                                                .color,
                                                      ),
                                                    ),
                                                ],
                                              )
                                            : null,
                                        onTap: hasStore &&
                                                _isCurrentStoreComplete &&
                                                subCategories.isNotEmpty
                                            ? () => _selectMainCategory(
                                                mainCategory)
                                            : null,
                                      ),
                                    ),

                                    if (isMainSelected &&
                                        widget.expanded &&
                                        hasStore &&
                                        _isCurrentStoreComplete)
                                      AnimatedBuilder(
                                        animation: _categoryAnimation,
                                        builder: (context, child) {
                                          return SizeTransition(
                                            sizeFactor: _categoryAnimation,
                                            child: OsmeaComponents.container(
                                              margin: EdgeInsets.only(
                                                left: isNarrow ? 16 : 24,
                                                bottom: isNarrow ? 6 : 8,
                                              ),
                                              child: OsmeaComponents.column(
                                                children: subCategories
                                                    .map((category) {
                                                  final isSelected =
                                                      _selectedCategory ==
                                                          category;
                                                  final subcategories =
                                                      _getSubCategoriesForGraphQLCategory(
                                                          category);
                                                  return OsmeaComponents.column(
                                                    children: [
                                                      // Category Header
                                                      ListTile(
                                                        dense: true,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                          horizontal: isNarrow
                                                              ? 12
                                                              : 16,
                                                          vertical:
                                                              isMobile ? 2 : 4,
                                                        ),
                                                        leading: Icon(
                                                          ApiServiceRegistry
                                                              .getCategoryIcon(
                                                                  category),
                                                          color: isSelected
                                                              ? OsmeaColors
                                                                  .nordicBlue
                                                              : Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                          size: isNarrow
                                                              ? 18
                                                              : 20,
                                                        ),
                                                        title: OsmeaComponents
                                                            .text(
                                                          _getCategoryDisplayName(
                                                              category),
                                                          variant:
                                                              OsmeaTextVariant
                                                                  .labelMedium,
                                                          color: isSelected
                                                              ? OsmeaColors
                                                                  .nordicBlue
                                                              : Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.color,
                                                          fontWeight: isSelected
                                                              ? FontWeight.w600
                                                              : FontWeight.w500,
                                                          fontSize: isNarrow
                                                              ? 12
                                                              : 14,
                                                        ),
                                                        trailing: subcategories
                                                                .isNotEmpty
                                                            ? AnimatedRotation(
                                                                turns:
                                                                    isSelected
                                                                        ? 0.25
                                                                        : 0,
                                                                duration:
                                                                    const Duration(
                                                                        milliseconds:
                                                                            200),
                                                                child: Icon(
                                                                  Icons
                                                                      .chevron_right,
                                                                  size: isNarrow
                                                                      ? 14
                                                                      : 16,
                                                                  color: isSelected
                                                                      ? OsmeaColors
                                                                          .deepSea
                                                                      : Theme.of(
                                                                              context)
                                                                          .iconTheme
                                                                          .color,
                                                                ),
                                                              )
                                                            : null,
                                                        onTap: () =>
                                                            _selectCategory(
                                                                category),
                                                      ),

                                                      // Subcategories with animation
                                                      if (isSelected &&
                                                          widget.expanded)
                                                        AnimatedBuilder(
                                                          animation:
                                                              _categoryAnimation,
                                                          builder:
                                                              (context, child) {
                                                            return SizeTransition(
                                                              sizeFactor:
                                                                  _categoryAnimation,
                                                              child:
                                                                  OsmeaComponents
                                                                      .container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: isNarrow
                                                                      ? 16
                                                                      : 24,
                                                                  bottom:
                                                                      isNarrow
                                                                          ? 6
                                                                          : 8,
                                                                ),
                                                                child:
                                                                    OsmeaComponents
                                                                        .column(
                                                                  children:
                                                                      subcategories
                                                                          .map(
                                                                              (subcategory) {
                                                                    final services =
                                                                        ApiServiceRegistry.getBySubcategory(
                                                                            category,
                                                                            subcategory);
                                                                    final isSubSelected =
                                                                        _selectedSubcategory ==
                                                                            subcategory;
                                                                    return OsmeaComponents
                                                                        .column(
                                                                      children: [
                                                                        // Subcategory Header
                                                                        ListTile(
                                                                          dense:
                                                                              true,
                                                                          contentPadding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal: isNarrow
                                                                                ? 12
                                                                                : 16,
                                                                            vertical: isMobile
                                                                                ? 2
                                                                                : 4,
                                                                          ),
                                                                          title:
                                                                              OsmeaComponents.text(
                                                                            subcategory,
                                                                            variant:
                                                                                OsmeaTextVariant.labelMedium,
                                                                            fontSize: isNarrow
                                                                                ? 12
                                                                                : 14,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: isSubSelected
                                                                                ? Theme.of(context).colorScheme.primary
                                                                                : Theme.of(context).textTheme.bodyMedium?.color,
                                                                          ),
                                                                          trailing:
                                                                              OsmeaComponents.container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(
                                                                              horizontal: isNarrow ? 6 : 8,
                                                                              vertical: 2,
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                                                              borderRadius: context.borderRadiusMinStandard,
                                                                            ),
                                                                            child:
                                                                                OsmeaComponents.text(
                                                                              '${services.length}',
                                                                              variant: OsmeaTextVariant.labelSmall,
                                                                              fontSize: isNarrow ? 10 : 12,
                                                                              color: Theme.of(context).colorScheme.primary,
                                                                            ),
                                                                          ),
                                                                          onTap: () =>
                                                                              _selectSubcategory(subcategory),
                                                                        ),

                                                                        // Services
                                                                        if (isSubSelected)
                                                                          ...services
                                                                              .asMap()
                                                                              .entries
                                                                              .map((entry) {
                                                                            final index =
                                                                                entry.key;
                                                                            final service =
                                                                                entry.value;
                                                                            final isServiceSelected =
                                                                                widget.selectedService == service;
                                                                            return AnimatedContainer(
                                                                              duration: Duration(milliseconds: 200 + (index * 50)),
                                                                              margin: EdgeInsets.only(
                                                                                left: isNarrow ? 12 : 16,
                                                                                bottom: isNarrow ? 2 : 4,
                                                                              ),
                                                                              child: Material(
                                                                                color: Colors.transparent,
                                                                                child: InkWell(
                                                                                  borderRadius: context.borderRadiusMinStandard,
                                                                                  onTap: () => widget.onServiceSelected(service),
                                                                                  child: OsmeaComponents.container(
                                                                                    padding: EdgeInsets.all(isNarrow ? 6 : 8),
                                                                                    decoration: BoxDecoration(
                                                                                      color: isServiceSelected ? OsmeaColors.nordicBlue.withValues(alpha: 0.1) : OsmeaColors.transparent,
                                                                                      borderRadius: context.borderRadiusMinStandard,
                                                                                      border: isServiceSelected
                                                                                          ? Border.all(
                                                                                              color: OsmeaColors.nordicBlue.withValues(alpha: 0.3),
                                                                                              width: 1,
                                                                                            )
                                                                                          : null,
                                                                                    ),
                                                                                    child: OsmeaComponents.row(
                                                                                      children: [
                                                                                        OsmeaComponents.container(
                                                                                          width: isNarrow ? 3 : 4,
                                                                                          height: isNarrow ? 12 : 16,
                                                                                          decoration: BoxDecoration(
                                                                                            color: isServiceSelected ? OsmeaColors.nordicBlue : OsmeaColors.transparent,
                                                                                            borderRadius: context.borderRadiusMinStandard,
                                                                                          ),
                                                                                        ),
                                                                                        OsmeaComponents.sizedBox(width: isNarrow ? 6 : 8),
                                                                                        OsmeaComponents.expanded(
                                                                                          child: OsmeaComponents.text(
                                                                                            service.name,
                                                                                            variant: OsmeaTextVariant.bodySmall,
                                                                                            fontSize: isNarrow ? 11 : 13,
                                                                                            color: isServiceSelected ? OsmeaColors.nordicBlue : Theme.of(context).textTheme.bodyMedium?.color,
                                                                                            fontWeight: isServiceSelected ? FontWeight.w500 : FontWeight.w400,
                                                                                            maxLines: isNarrow ? 2 : 1,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }),
                                                                      ],
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                      // Customer APIs Section
                      if (_currentStore != null &&
                          _isCurrentStoreComplete &&
                          widget.expanded &&
                          _selectedMainCategory == ApiCategory.woocommerce)
                        _buildCustomerApisSection(isNarrow, isMobile, context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<String> _getSubCategoriesForGraphQLCategory(ApiCategory category) {
    switch (category) {
      case ApiCategory.graphqlProductsAndCollections:
      //case ApiCategory.graphqlOrders:
      case ApiCategory.graphqlCustomers:
        return ['Queries', 'Mutations'];
      case ApiCategory.graphqlWebhooks:
        return ['Queries', 'Mutations'];
      default:
        return ApiServiceRegistry.getSubcategoriesByCategory(category);
    }
  }

  String _getCategoryDisplayName(ApiCategory category) {
    switch (category) {
      case ApiCategory.shopify:
        return 'Shopify';
      case ApiCategory.woocommerce:
        return 'WooCommerce';
      case ApiCategory.shopifyGraphql:
        return 'Shopify GraphQL';
      case ApiCategory.graphql:
        return 'GraphQL';
      case ApiCategory.graphqlQueries:
        return 'GraphQL Queries';
      case ApiCategory.graphqlMutations:
        return 'GraphQL Mutations';
      case ApiCategory.graphqlProductsAndCollections:
        return 'GraphQL Products & Collections';
      case ApiCategory.graphqlProductsAndCollectionsQueries:
        return 'GraphQL Products & Collections Queries';
      case ApiCategory.graphqlProductsAndCollectionsMutations:
        return 'GraphQL Products & Collections Mutations';
      // case ApiCategory.graphqlOrders:
      //   return 'GraphQL Orders';
      // case ApiCategory.graphqlOrdersQueries:
      //   return 'GraphQL Orders Queries';
      // case ApiCategory.graphqlOrdersMutations:
      //   return 'GraphQL Orders Mutations';
      case ApiCategory.graphqlCustomers:
        return 'GraphQL Customers';
      case ApiCategory.graphqlCustomersQueries:
        return 'GraphQL Customers Queries';
      case ApiCategory.graphqlCustomersMutations:
        return 'GraphQL Customers Mutations';
      case ApiCategory.graphqlWebhooks:
        return 'GraphQL Webhooks';
      case ApiCategory.graphqlWebhookQueries:
        return 'GraphQL Webhook Queries';
      case ApiCategory.graphqlWebhookMutations:
        return 'GraphQL Webhook Mutations';
      case ApiCategory.access:
        return 'Access';
      case ApiCategory.customer:
        return 'Customer';
      case ApiCategory.discounts:
        return 'Discounts';
      case ApiCategory.billing:
        return 'Billing';
      case ApiCategory.events:
        return 'Events';
      case ApiCategory.inventory:
        return 'Inventory';
      case ApiCategory.orders:
        return 'Orders';
      case ApiCategory.marketingEvent:
        return 'Marketing Event';
      case ApiCategory.giftCard:
        return 'Gift Card';
      case ApiCategory.metafield:
        return 'Metafield';
      case ApiCategory.onlineStore:
        return 'Online Store';
      case ApiCategory.products:
        return 'Products';
      case ApiCategory.storeProperties:
        return 'Store Properties';
      case ApiCategory.tendertransaction:
        return 'Tender Transaction';
      case ApiCategory.webhooks:
        return 'Webhooks';
      case ApiCategory.woocommerceCoupons:
        return 'WooCommerce Coupons';
      case ApiCategory.woocommerceProducts:
        return 'WooCommerce Products';
      case ApiCategory.woocommerceOrders:
        return 'WooCommerce Orders';
      case ApiCategory.woocommerceCustomers:
        return 'WooCommerce Customers';
      case ApiCategory.woocommerceWebhooks:
        return 'WooCommerce Webhooks';
      case ApiCategory.woocommerceSystemStatus:
        return 'WooCommerce System Status';
      case ApiCategory.woocommerceReports:
        return 'WooCommerce Reports';
      case ApiCategory.woocommerceShippingMethods:
        return 'WooCommerce Shipping Methods';
      case ApiCategory.woocommerceShippingZones:
        return 'WooCommerce Shipping Zones';
      case ApiCategory.woocommerceShippingZoneMethods:
        return 'WooCommerce Shipping Zone Methods';
      case ApiCategory.woocommercePaymentGateways:
        return 'WooCommerce Payment Gateways';
      case ApiCategory.woocommerceSetting:
        return 'WooCommerce Setting';
      case ApiCategory.woocommerceData:
        return 'WooCommerce Data';
      case ApiCategory.woocommerceContinents:
        return 'WooCommerce Continents';
      case ApiCategory.woocommerceCountries:
        return 'WooCommerce Countries';
      case ApiCategory.woocommerceCurrencies:
        return 'WooCommerce Currencies';
      case ApiCategory.woocommerceRefunds:
        return 'WooCommerce Refunds';
      case ApiCategory.woocommerceTaxes:
        return 'WooCommerce Taxes';
      case ApiCategory.woocommerceWishlist:
        return 'WooCommerce Wishlist';
      case ApiCategory.woocommerceCart:
        return 'WooCommerce Cart';
      case ApiCategory.woocommerceCheckout:
        return 'WooCommerce Checkout';
      case ApiCategory.woocommerceCheckoutOrder:
        return 'WooCommerce Checkout Order';
      case ApiCategory.woocommerceOrder:
        return 'WooCommerce Store Order';
      case ApiCategory.woocommerceStoreProducts:
        return 'WooCommerce Products';
      case ApiCategory.woocommerceStoreProductTags:
        return 'WooCommerce Product Tags';
      case ApiCategory.woocommerceStoreProductReviews:
        return 'WooCommerce Product Reviews';
      case ApiCategory.woocommerceStoreProductCollectionData:
        return 'WooCommerce Product Collection Data';
      case ApiCategory.woocommerceStoreProductCategories:
        return 'WooCommerce Product Categories';
      case ApiCategory.woocommerceStoreProductBrands:
        return 'WooCommerce Product Brands';
      case ApiCategory.woocommerceStoreProductAttributes:
        return 'WooCommerce Product Attributes';
      case ApiCategory.woocommerceStoreProductAttributeTerms:
        return 'WooCommerce Product Attribute Terms';
    }
  }

  // Search functionality methods
  Future<void> _onSearchChanged(String query) async {
    setState(() {
      _searchQuery = query.toLowerCase();
    });

    final filteredServices = await _filterAndGroupServices(query);
    setState(() {
      _groupedFilteredServices = filteredServices;
    });
  }

  Future<Map<String, List<ApiService>>> _filterAndGroupServices(
      String query) async {
    if (query.isEmpty) return {};

    final allServices = ApiServiceRegistry.all;
    final availableStoreTypes = await _getAvailableStoreTypes();

    final filteredServices = allServices.where((service) {
      final matchesName = service.name.toLowerCase().contains(query);
      final matchesCategory =
          service.category.toString().toLowerCase().contains(query);
      final matchesSubcategory =
          service.subcategory.toLowerCase().contains(query);
      final matchesEndpoint = service.endpoint.toLowerCase().contains(query);

      final matchesQuery = matchesName ||
          matchesCategory ||
          matchesSubcategory ||
          matchesEndpoint;

      if (!matchesQuery) return false;

      // Check if user has access to this platform
      switch (service.category) {
        case ApiCategory.shopify:
        case ApiCategory.shopifyGraphql:
        case ApiCategory.access:
        case ApiCategory.customer:
        case ApiCategory.discounts:
        case ApiCategory.billing:
        case ApiCategory.events:
        case ApiCategory.inventory:
        case ApiCategory.orders:
        case ApiCategory.marketingEvent:
        case ApiCategory.giftCard:
        case ApiCategory.metafield:
        case ApiCategory.onlineStore:
        case ApiCategory.products:
        case ApiCategory.storeProperties:
        case ApiCategory.tendertransaction:
        case ApiCategory.webhooks:
        case ApiCategory.graphqlQueries:
        case ApiCategory.graphqlMutations:
        case ApiCategory.graphqlProductsAndCollections:
        case ApiCategory.graphqlProductsAndCollectionsQueries:
        case ApiCategory.graphqlProductsAndCollectionsMutations:
        case ApiCategory.graphqlCustomers:
        case ApiCategory.graphqlCustomersQueries:
        case ApiCategory.graphqlCustomersMutations:
        case ApiCategory.graphqlWebhooks:
        case ApiCategory.graphqlWebhookQueries:
        case ApiCategory.graphqlWebhookMutations:
          return availableStoreTypes.contains('Shopify');
        case ApiCategory.woocommerce:
        case ApiCategory.woocommerceCoupons:
        case ApiCategory.woocommerceProducts:
        case ApiCategory.woocommerceOrders:
        case ApiCategory.woocommerceCustomers:
        case ApiCategory.woocommerceWebhooks:
        case ApiCategory.woocommerceSystemStatus:
        case ApiCategory.woocommerceReports:
        case ApiCategory.woocommerceShippingMethods:
        case ApiCategory.woocommerceShippingZones:
        case ApiCategory.woocommerceShippingZoneMethods:
        case ApiCategory.woocommercePaymentGateways:
        case ApiCategory.woocommerceSetting:
        case ApiCategory.woocommerceData:
        case ApiCategory.woocommerceContinents:
        case ApiCategory.woocommerceCountries:
        case ApiCategory.woocommerceCurrencies:
        case ApiCategory.woocommerceRefunds:
        case ApiCategory.woocommerceTaxes:
        case ApiCategory.woocommerceWishlist:
        case ApiCategory.woocommerceCart:
        case ApiCategory.woocommerceCheckout:
        case ApiCategory.woocommerceCheckoutOrder:
        case ApiCategory.woocommerceOrder:
        case ApiCategory.woocommerceStoreProducts:
        case ApiCategory.woocommerceStoreProductTags:
        case ApiCategory.woocommerceStoreProductReviews:
        case ApiCategory.woocommerceStoreProductCollectionData:
        case ApiCategory.woocommerceStoreProductCategories:
        case ApiCategory.woocommerceStoreProductBrands:
        case ApiCategory.woocommerceStoreProductAttributes:
        case ApiCategory.woocommerceStoreProductAttributeTerms:
          return availableStoreTypes.contains('WooCommerce');
        default:
          return false; // Don't allow other categories if no store configured
      }
    }).toList();

    // Group by platform
    final Map<String, List<ApiService>> grouped = {};
    for (final service in filteredServices) {
      String platform;
      switch (service.category) {
        case ApiCategory.shopify:
        case ApiCategory.shopifyGraphql:
        case ApiCategory.access:
        case ApiCategory.customer:
        case ApiCategory.discounts:
        case ApiCategory.billing:
        case ApiCategory.events:
        case ApiCategory.inventory:
        case ApiCategory.orders:
        case ApiCategory.marketingEvent:
        case ApiCategory.giftCard:
        case ApiCategory.metafield:
        case ApiCategory.onlineStore:
        case ApiCategory.products:
        case ApiCategory.storeProperties:
        case ApiCategory.tendertransaction:
        case ApiCategory.webhooks:
        case ApiCategory.graphqlQueries:
        case ApiCategory.graphqlMutations:
        case ApiCategory.graphqlProductsAndCollections:
        case ApiCategory.graphqlProductsAndCollectionsQueries:
        case ApiCategory.graphqlProductsAndCollectionsMutations:
        case ApiCategory.graphqlCustomers:
        case ApiCategory.graphqlCustomersQueries:
        case ApiCategory.graphqlCustomersMutations:
        case ApiCategory.graphqlWebhooks:
        case ApiCategory.graphqlWebhookQueries:
        case ApiCategory.graphqlWebhookMutations:
          platform = 'Shopify';
          break;
        case ApiCategory.woocommerce:
        case ApiCategory.woocommerceCoupons:
        case ApiCategory.woocommerceProducts:
        case ApiCategory.woocommerceOrders:
        case ApiCategory.woocommerceCustomers:
        case ApiCategory.woocommerceWebhooks:
        case ApiCategory.woocommerceSystemStatus:
        case ApiCategory.woocommerceReports:
        case ApiCategory.woocommerceShippingMethods:
        case ApiCategory.woocommerceShippingZones:
        case ApiCategory.woocommerceShippingZoneMethods:
        case ApiCategory.woocommercePaymentGateways:
        case ApiCategory.woocommerceSetting:
        case ApiCategory.woocommerceData:
        case ApiCategory.woocommerceContinents:
        case ApiCategory.woocommerceCountries:
        case ApiCategory.woocommerceCurrencies:
        case ApiCategory.woocommerceRefunds:
        case ApiCategory.woocommerceTaxes:
        case ApiCategory.woocommerceWishlist:
        case ApiCategory.woocommerceCart:
        case ApiCategory.woocommerceCheckout:
        case ApiCategory.woocommerceCheckoutOrder:
        case ApiCategory.woocommerceOrder:
        case ApiCategory.woocommerceStoreProducts:
        case ApiCategory.woocommerceStoreProductTags:
        case ApiCategory.woocommerceStoreProductReviews:
        case ApiCategory.woocommerceStoreProductCollectionData:
        case ApiCategory.woocommerceStoreProductCategories:
        case ApiCategory.woocommerceStoreProductBrands:
        case ApiCategory.woocommerceStoreProductAttributes:
        case ApiCategory.woocommerceStoreProductAttributeTerms:
          platform = 'WooCommerce';
          break;
        default:
          platform = 'Other';
      }

      if (!grouped.containsKey(platform)) {
        grouped[platform] = [];
      }
      grouped[platform]!.add(service);
    }

    return grouped;
  }

  int get _totalFilteredCount {
    return _groupedFilteredServices.values
        .fold(0, (sum, services) => sum + services.length);
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _groupedFilteredServices = {};
      _searchController.clear();
    });
  }

  // Helper methods for platform styling
  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'Shopify':
        return const Color(0xFF96BF47); // Shopify green
      case 'WooCommerce':
        return const Color(0xFF96588A); // WooCommerce purple
      default:
        return OsmeaColors.steel;
    }
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform) {
      case 'Shopify':
        return Icons.shopping_bag_rounded;
      case 'WooCommerce':
        return Icons.shopping_cart_rounded;
      default:
        return Icons.api_rounded;
    }
  }

  // Build Customer APIs section for WooCommerce
  Widget _buildCustomerApisSection(
      bool isNarrow, bool isMobile, BuildContext context) {
    final customerCategories =
        ApiServiceRegistry.getWooCommerceCustomerCategories();

    return OsmeaComponents.container(
      margin: EdgeInsets.only(
        left: isNarrow ? 16 : 24,
        right: isNarrow ? 16 : 24,
        bottom: isNarrow ? 8 : 12,
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer APIs Header
          OsmeaComponents.container(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 12 : 16,
              vertical: 8,
            ),
            child: OsmeaComponents.row(
              children: [
                Icon(
                  Icons.people_rounded,
                  size: isNarrow ? 18 : 20,
                  color: OsmeaColors.nordicBlue,
                ),
                OsmeaComponents.sizedBox(width: 8),
                OsmeaComponents.text(
                  'Customer APIs',
                  variant: OsmeaTextVariant.titleSmall,
                  fontSize: isNarrow ? 13 : 15,
                  fontWeight: FontWeight.w700,
                  color: OsmeaColors.nordicBlue,
                ),
                OsmeaComponents.spacer(),
                OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isNarrow ? 6 : 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.nordicBlue.withValues(alpha: 0.15),
                    borderRadius: context.borderRadiusMinStandard,
                  ),
                  child: OsmeaComponents.text(
                    'Available',
                    variant: OsmeaTextVariant.labelSmall,
                    fontSize: isNarrow ? 9 : 10,
                    fontWeight: FontWeight.w600,
                    color: OsmeaColors.nordicBlue,
                  ),
                ),
              ],
            ),
          ),

          // Customer Categories
          ...customerCategories.map((category) {
            final isSelected = _selectedCategory == category;
            final subcategories = _getSubCategoriesForGraphQLCategory(category);

            return OsmeaComponents.column(
              children: [
                // Category Header
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isNarrow ? 12 : 16,
                    vertical: isMobile ? 2 : 4,
                  ),
                  leading: Icon(
                    ApiServiceRegistry.getCategoryIcon(category),
                    color: isSelected
                        ? OsmeaColors.nordicBlue
                        : Theme.of(context).iconTheme.color,
                    size: isNarrow ? 18 : 20,
                  ),
                  title: OsmeaComponents.text(
                    _getCategoryDisplayName(category),
                    variant: OsmeaTextVariant.labelMedium,
                    color: isSelected
                        ? OsmeaColors.nordicBlue
                        : Theme.of(context).textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: isNarrow ? 12 : 14,
                  ),
                  trailing: subcategories.isNotEmpty
                      ? AnimatedRotation(
                          turns: isSelected ? 0.25 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.chevron_right,
                            size: isNarrow ? 14 : 16,
                            color: isSelected
                                ? OsmeaColors.deepSea
                                : Theme.of(context).iconTheme.color,
                          ),
                        )
                      : null,
                  onTap: () => _selectCategory(category),
                ),

                // Subcategories with animation
                if (isSelected && widget.expanded)
                  AnimatedBuilder(
                    animation: _categoryAnimation,
                    builder: (context, child) {
                      return SizeTransition(
                        sizeFactor: _categoryAnimation,
                        child: OsmeaComponents.container(
                          margin: EdgeInsets.only(
                            left: isNarrow ? 16 : 24,
                            bottom: isNarrow ? 6 : 8,
                          ),
                          child: OsmeaComponents.column(
                            children: subcategories.map((subcategory) {
                              final services =
                                  ApiServiceRegistry.getBySubcategory(
                                      category, subcategory);
                              final isSubSelected =
                                  _selectedSubcategory == subcategory;

                              return OsmeaComponents.column(
                                children: [
                                  // Subcategory Header
                                  ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: isNarrow ? 12 : 16,
                                      vertical: isMobile ? 2 : 4,
                                    ),
                                    title: OsmeaComponents.text(
                                      subcategory,
                                      variant: OsmeaTextVariant.labelMedium,
                                      fontSize: isNarrow ? 12 : 14,
                                      fontWeight: FontWeight.w500,
                                      color: isSubSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color,
                                    ),
                                    trailing: OsmeaComponents.container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isNarrow ? 6 : 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            context.borderRadiusMinStandard,
                                      ),
                                      child: OsmeaComponents.text(
                                        '${services.length}',
                                        variant: OsmeaTextVariant.labelSmall,
                                        fontSize: isNarrow ? 9 : 10,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onTap: () =>
                                        _selectSubcategory(subcategory),
                                  ),

                                  // Services
                                  if (isSubSelected)
                                    ...services.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final service = entry.value;
                                      final isServiceSelected =
                                          widget.selectedService == service;

                                      return AnimatedContainer(
                                        duration: Duration(
                                            milliseconds: 200 + (index * 50)),
                                        margin: EdgeInsets.only(
                                          left: isNarrow ? 12 : 16,
                                          bottom: isNarrow ? 2 : 4,
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                context.borderRadiusMinStandard,
                                            onTap: () => widget
                                                .onServiceSelected(service),
                                            child: OsmeaComponents.container(
                                              padding: EdgeInsets.all(
                                                  isNarrow ? 6 : 8),
                                              decoration: BoxDecoration(
                                                color: isServiceSelected
                                                    ? OsmeaColors.nordicBlue
                                                        .withValues(alpha: 0.1)
                                                    : OsmeaColors.transparent,
                                                borderRadius: context
                                                    .borderRadiusMinStandard,
                                                border: isServiceSelected
                                                    ? Border.all(
                                                        color: OsmeaColors
                                                            .nordicBlue
                                                            .withValues(
                                                                alpha: 0.3),
                                                        width: 1,
                                                      )
                                                    : null,
                                              ),
                                              child: OsmeaComponents.row(
                                                children: [
                                                  OsmeaComponents.container(
                                                    width: isNarrow ? 3 : 4,
                                                    height: isNarrow ? 12 : 16,
                                                    decoration: BoxDecoration(
                                                      color: isServiceSelected
                                                          ? OsmeaColors
                                                              .nordicBlue
                                                          : OsmeaColors
                                                              .transparent,
                                                      borderRadius: context
                                                          .borderRadiusMinStandard,
                                                    ),
                                                  ),
                                                  OsmeaComponents.sizedBox(
                                                      width: isNarrow ? 6 : 8),
                                                  OsmeaComponents.expanded(
                                                    child: OsmeaComponents.text(
                                                      service.name,
                                                      variant: OsmeaTextVariant
                                                          .bodySmall,
                                                      fontSize:
                                                          isNarrow ? 11 : 13,
                                                      color: isServiceSelected
                                                          ? OsmeaColors
                                                              .nordicBlue
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.color,
                                                      fontWeight:
                                                          isServiceSelected
                                                              ? FontWeight.w500
                                                              : FontWeight.w400,
                                                      maxLines:
                                                          isNarrow ? 2 : 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
