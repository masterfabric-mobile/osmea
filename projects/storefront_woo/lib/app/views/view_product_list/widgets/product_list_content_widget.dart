/*
 * ProductListContentWidget
 * ------------------------
 * Main content widget for product list view.
 * Displays products in a grid with pull-to-refresh and infinite scroll.
 * Includes filter chips at the top for active filters.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/list_product_categories_response_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/product_list_filters_widget.dart';
// Animation helpers are now imported from core
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';
import 'package:storefront_woo/gen/translations.g.dart';
import 'package:storefront_woo/app/utils/cart_add_helper.dart';

/// Main content widget for product list view
class ProductListContentWidget extends StatefulWidget {
  final ProductListLoadedState state;
  final ProductListViewModel viewModel;

  const ProductListContentWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  State<ProductListContentWidget> createState() =>
      _ProductListContentWidgetState();
}

class _ProductListContentWidgetState extends State<ProductListContentWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  bool _showFiltersBar = false;
  final AssetConfigHelper _configHelper = AssetConfigHelper();
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  Timer? _searchDebounceTimer;
  String _lastAppliedSearch = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController(text: widget.viewModel.filters.search ?? '');
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 300;
    if (shouldShow != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShow;
      });
    }

    // Filter/sort bar: show after a small scroll up (content moves up).
    // Hysteresis prevents flicker near the threshold.
    final offset = _scrollController.offset;
    final shouldShowFilters = offset > 60
        ? true
        : (offset < 20 ? false : _showFiltersBar);
    if (shouldShowFilters != _showFiltersBar) {
      setState(() {
        _showFiltersBar = shouldShowFilters;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final viewModel = widget.viewModel;

    debugPrint(
      '📦 ProductListContentWidget: Building with ${state.products.length} products',
    );
    debugPrint('📦 ProductListContentWidget: State type: ${state.runtimeType}');
    debugPrint(
      '📦 ProductListContentWidget: Has active filters: ${viewModel.filters.hasActiveFilters}',
    );
    debugPrint(
      '📦 ProductListContentWidget: Has chip-worthy filters: ${_hasChipWorthyFilters()}',
    );

    if (state.products.isEmpty) {
      debugPrint(
        '⚠️ ProductListContentWidget: Products list is empty, navigating to empty view',
      );
      // Navigate to empty view route - similar to wishlist pattern
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          final hasFilters = viewModel.filters.hasActiveFilters;
          // If there are active filters, pass clearFilters action
          final actionPath = hasFilters ? '/products?clearFilters=true' : '/home';
          context.go('/empty/products?actionPath=$actionPath');
        }
      });
      // Return empty container while navigating
      return const SizedBox.shrink();
    }

    debugPrint(
      '✅ ProductListContentWidget: Showing product grid with ${state.products.length} products',
    );

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                widget.state.hasMore) {
              widget.viewModel.loadMore();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async => widget.viewModel.loadProducts(refresh: true),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // Add top padding for AppBar when useSafeArea is false
                SliverToBoxAdapter(
                  child: SizedBox(height: context.highValue * 1.5),
                ),
                SliverToBoxAdapter(child: _buildSearchBar(context)),
                // Icon buttons for Sort by / Filters (scrolls away with content)
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _showFiltersBar
                        ? _buildActionButtons(context)
                        : const SizedBox.shrink(),
                  ),
                ),
                // Active filter chips (scrolls away with content)
                if (_hasChipWorthyFilters())
                  SliverToBoxAdapter(
                    child: OsmeaComponents.padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: _configHelper.getDouble(
                          'product_list_view.component_spacing.horizontal',
                          context.spacing20,
                        ),
                        vertical: _configHelper.getDouble(
                          'product_list_view.component_spacing.vertical',
                          context.spacing12,
                        ),
                      ),
                      child: _buildActiveFilterChips(context),
                    ),
                  ),
                // Product grid
                _buildProductGridSliver(context),
              ],
            ),
          ),
        ),
        // Scroll to top button
        if (_showScrollToTop)
          Positioned(
            bottom: context.spacing24,
            right: context.spacing24,
            child: Material(
              color: _configHelper.getColor(
                'product_list_view.scroll_to_top.backgroundColor',
                OsmeaColors.black,
              ),
              shape: const CircleBorder(),
              elevation: _configHelper.getDouble(
                'product_list_view.scroll_to_top.elevation',
                8.0,
              ),
              shadowColor: _configHelper.getColor(
                'product_list_view.scroll_to_top.shadowColor',
                OsmeaColors.black,
              ).withOpacity(
                _configHelper.getDouble(
                  'product_list_view.scroll_to_top.shadowOpacity',
                  0.4,
                ),
              ),
              child: InkWell(
                onTap: _scrollToTop,
                borderRadius: BorderRadius.circular(context.spacing32),
                child: Container(
                  width: context.width48,
                  height: context.height48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _configHelper.getColor(
                          'product_list_view.scroll_to_top.shadowColor',
                          OsmeaColors.black,
                        ).withOpacity(
                          _configHelper.getDouble(
                            'product_list_view.scroll_to_top.shadowOpacity',
                            0.3,
                          ),
                        ),
                        blurRadius: _configHelper.getDouble(
                          'product_list_view.scroll_to_top.shadowBlur',
                          context.blurRadius12,
                        ),
                        offset: context.offsetVerticalCustom(
                          _configHelper.getDouble(
                            'product_list_view.scroll_to_top.shadowOffset',
                            context.spacing4,
                          ),
                        ),
                        spreadRadius: _configHelper.getDouble(
                          'product_list_view.scroll_to_top.shadowSpread',
                          1.0,
                        ),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: _configHelper.getColor(
                      'product_list_view.scroll_to_top.iconColor',
                      OsmeaColors.white,
                    ),
                    size: context.iconSizeNormal,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    // Match HomeView's SearchBarWidget styling/config.
    final searchConfig = _configHelper.getObject('home_view.search');
    final placeholder =
        searchConfig?['placeholder'] as String? ??
        context.t.homeView.widgets.search.placeholder;
    final variant = searchConfig?['variant'] as String? ?? 'outlined';

    return OsmeaComponents.padding(
      padding: EdgeInsets.fromLTRB(
        context.spacing20,
        context.spacing16,
        context.spacing20,
        context.spacing16,
      ),
      child: OsmeaComponents.searchbar(
        controller: _searchController,
        focusNode: _searchFocusNode,
        hint: placeholder,
        size: TextFieldSize.medium,
        searchbarStyle: SearchbarStyle.minimal,
        searchbarVariant: variant == 'outlined'
            ? SearchbarVariant.outlined
            : SearchbarVariant.borderless,
        state: TextFieldState.enabled,
        showSearchIcon: true,
        showClearButton: true,
        // User requested: don't show past searches.
        showSuggestions: false,
        backgroundColor: OsmeaColors.white,
        borderColor: OsmeaColors.pewter,
        focusColor: _configHelper.getSearchViewFocusColor(OsmeaColors.black),
        textColor: OsmeaColors.thunder,
        hintColor: OsmeaColors.pewter,
        suggestionProvider: null,
        onChanged: (query) {
          final q = query.trim();
          // Match SearchView-like behavior: don't search for 1-char queries,
          // and debounce live filtering to avoid too many refreshes.
          if (q == _lastAppliedSearch) return;
          _searchDebounceTimer?.cancel();
          _searchDebounceTimer = Timer(
            const Duration(milliseconds: 350),
            () {
              // If user cleared input, clear filter immediately.
              if (q.isEmpty) {
                _applySearch('');
                return;
              }
              if (q.length < 2) return;
              _applySearch(q);
            },
          );
        },
        onSearch: (query) {
          _applySearch(query);
        },
        onSubmitted: (query) {
          _applySearch(query);
        },
        onClear: () {
          _searchController.clear();
          _applySearch('');
        },
      ),
    );
  }

  void _applySearch(String query) {
    final q = query.trim();
    _lastAppliedSearch = q;
    if (q.isEmpty) {
      widget.viewModel.updateFilter(search: null);
      return;
    }

    widget.viewModel.updateFilter(search: q);
  }

  /// Builds icon buttons for Sort by / Filters
  Widget _buildActionButtons(BuildContext context) {
    final hasActiveFilters = widget.viewModel.filters.hasActiveFilters;

    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: _configHelper.getDouble(
          'product_list_view.component_spacing.horizontal',
          context.spacing20,
        ),
        vertical: _configHelper.getDouble(
          'product_list_view.component_spacing.vertical',
          context.spacing12,
        ),
      ),
      child: OsmeaComponents.row(
        children: [
          // Sort button
          Expanded(
            child: _buildModernActionButton(
              context: context,
              icon: Icons.sort_rounded,
              label: context.t.productListView.actions.sort,
              onPressed: () => _showSortBottomSheet(context),
              hasBadge: false,
            ),
          ),
          OsmeaComponents.sizedBox(
            width: _configHelper.getDouble(
              'product_list_view.component_spacing.action_buttons_spacing',
              context.spacing12,
            ),
          ),
          // Filter button
          Expanded(
            child: _buildModernActionButton(
              context: context,
              icon: Icons.tune_rounded,
              label: context.t.productListView.actions.filters,
              onPressed: () => _showFiltersBottomSheet(context),
              hasBadge: hasActiveFilters,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a modern action button with icon and label
  Widget _buildModernActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool hasBadge,
  }) {
    final backgroundColor = _configHelper.getColor(
      'product_list_view.action_buttons.backgroundColor',
      OsmeaColors.white,
    );
    final borderColor = _configHelper.getColor(
      'product_list_view.action_buttons.borderColor',
      OsmeaColors.silver,
    );
    final textColor = _configHelper.getColor(
      'product_list_view.action_buttons.textColor',
      OsmeaColors.thunder,
    );
    final iconColor = _configHelper.getColor(
      'product_list_view.action_buttons.iconColor',
      OsmeaColors.thunder,
    );
    final badgeColor = _configHelper.getColor(
      'product_list_view.action_buttons.badgeColor',
      OsmeaColors.black,
    );
    final badgeBorderColor = _configHelper.getColor(
      'product_list_view.action_buttons.badgeBorderColor',
      OsmeaColors.white,
    );
    final borderRadius = _configHelper.getDouble(
      'product_list_view.action_buttons.borderRadius',
      context.spacing12,
    );
    final borderWidth = _configHelper.getDouble(
      'product_list_view.action_buttons.borderWidth',
      1.0,
    );
    final shadowColor = _configHelper.getColor(
      'product_list_view.action_buttons.shadowColor',
      OsmeaColors.black,
    );
    final shadowOpacity = _configHelper.getDouble(
      'product_list_view.action_buttons.shadowOpacity',
      0.04,
    );
    final shadowBlur = _configHelper.getDouble(
      'product_list_view.action_buttons.shadowBlur',
      context.blurRadius8,
    );
    final shadowOffset = _configHelper.getDouble(
      'product_list_view.action_buttons.shadowOffset',
      context.spacing2,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing12,
            vertical: context.spacing10,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(shadowOpacity),
                blurRadius: shadowBlur,
                offset: context.offsetVerticalCustom(shadowOffset),
                spreadRadius: 0,
              ),
            ],
          ),
          child: OsmeaComponents.row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: iconColor,
                    size: context.iconSizeNormal,
                  ),
                  if (hasBadge)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: badgeBorderColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              OsmeaComponents.sizedBox(width: context.spacing6),
              OsmeaComponents.text(
                label,
                textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows sort bottom sheet
  void _showSortBottomSheet(BuildContext context) {
    widget.viewModel.resetDialogInit();

    final bottomSheetBgColor = _configHelper.getColor(
      'product_list_view.bottom_sheet.backgroundColor',
      OsmeaColors.white,
    );

    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.medium,
      title: context.t.productListView.sort.title,
      subtitle: context.t.productListView.sort.subtitle,
      backgroundColor: bottomSheetBgColor,
      actionBarBackgroundColor: bottomSheetBgColor,
      leftAction: _buildCancelButton(context),
      rightAction: _buildApplyButton(context),
      child: ProductListFiltersWidget(
        viewModel: widget.viewModel,
        showOnlySort: true,
      ),
    ).then((_) {
      widget.viewModel.resetDialogInit();
    });
  }

  /// Shows filters bottom sheet
  void _showFiltersBottomSheet(BuildContext context) {
    widget.viewModel.resetDialogInit();

    final bottomSheetBgColor = _configHelper.getColor(
      'product_list_view.bottom_sheet.backgroundColor',
      OsmeaColors.white,
    );

    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.large,
      title: context.t.productListView.filters.title,
      subtitle: context.t.productListView.filters.subtitle,
      backgroundColor: bottomSheetBgColor,
      actionBarBackgroundColor: bottomSheetBgColor,
      leftAction: _buildCancelButton(context),
      rightAction: BlocBuilder<ProductListViewModel, ProductListState>(
        bloc: widget.viewModel,
        builder: (context, state) {
          return _buildApplyButton(context);
        },
      ),
      child: ProductListFiltersWidget(
        viewModel: widget.viewModel,
        showOnlySort: false,
      ),
    ).then((_) {
      widget.viewModel.resetDialogInit();
    });
  }

  /// Builds Apply button with config colors
  Widget _buildApplyButton(BuildContext context) {
    final backgroundColor = _configHelper.getColor(
      'product_list_view.bottom_sheet.apply_button_background',
      OsmeaColors.black,
    );
    final textColor = _configHelper.getColor(
      'product_list_view.bottom_sheet.apply_button_text_color',
      OsmeaColors.white,
    );

    return OsmeaComponents.button(
      text: context.t.productListView.filters.apply,
      onPressed: () {
        widget.viewModel.applyFilters();
        Navigator.pop(context);
      },
      variant: ButtonVariant.primary,
      size: ButtonSize.small,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  /// Builds Cancel button with config colors
  Widget _buildCancelButton(BuildContext context) {
    final textColor = _configHelper.getColor(
      'product_list_view.bottom_sheet.cancel_button_text_color',
      OsmeaColors.black,
    );

    return OsmeaComponents.button(
      text: context.t.productListView.filters.cancel,
      onPressed: () {
        Navigator.pop(context);
      },
      variant: ButtonVariant.ghost,
      size: ButtonSize.small,
      textColor: textColor,
    );
  }

  /// Check if there are filters that will show chips (excluding orderBy which doesn't show a chip)
  bool _hasChipWorthyFilters() {
    final filters = widget.viewModel.filters;
    return (filters.selectedCategories != null &&
            filters.selectedCategories!.isNotEmpty) ||
        (filters.selectedTags != null && filters.selectedTags!.isNotEmpty) ||
        (filters.selectedAttributes != null &&
            filters.selectedAttributes!.isNotEmpty) ||
        filters.onSale == true ||
        filters.featured == true ||
        filters.stockStatus != null ||
        filters.minPrice != null ||
        filters.maxPrice != null;
  }

  /// Builds active filter chips
  Widget _buildActiveFilterChips(BuildContext context) {
    final filters = widget.viewModel.filters;
    final chips = <Widget>[];

    debugPrint('🔍 _buildActiveFilterChips: Building chips');
    debugPrint('  - selectedCategories: ${filters.selectedCategories}');
    debugPrint('  - onSale: ${filters.onSale}');
    debugPrint('  - featured: ${filters.featured}');
    debugPrint('  - stockStatus: ${filters.stockStatus}');

    // Price range filter chips - REMOVED as requested

    // Category filter chips
    if (filters.selectedCategories != null &&
        filters.selectedCategories!.isNotEmpty) {
      // Get category names from state
      for (final categoryId in filters.selectedCategories!) {
        final category = widget.state.categories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () =>
              const ListProductCategoriesResponseModel(id: null, name: null),
        );

        // Only show chip if category name is available (categories are loaded)
        // Skip if category name is null and we're still loading
        if (category.name == null && widget.state.isLoadingFilterOptions) {
          continue; // Skip this chip until categories are loaded
        }

        final categoryName = category.name ?? context.t.productListView.widgets.chips.categoryFallback.replaceAll('{categoryId}', categoryId.toString());
        final categoryChipBgColor = _configHelper.getColor(
          'product_list_view.filter_chips.category.backgroundColor',
          OsmeaColors.black,
        );
        final categoryChipTextColor = _configHelper.getColor(
          'product_list_view.filter_chips.category.textColor',
          OsmeaColors.white,
        );
        chips.add(
          OsmeaComponents.padding(
            padding: EdgeInsets.only(
              right: _configHelper.getDouble(
                'product_list_view.component_spacing.filter_chips_spacing',
                context.spacing8,
              ),
            ),
            child: OsmeaComponents.chips(
              text: categoryName,
              variant: ChipsVariant.primary,
              style: ChipsStyle.normal,
              selected: true,
              closable: true,
              backgroundColor: categoryChipBgColor,
              textColor: categoryChipTextColor,
              onClose: () {
                final newSelectedCategories = List<int>.from(
                  filters.selectedCategories!,
                );
                newSelectedCategories.remove(categoryId);
                widget.viewModel.updateFilter(
                  selectedCategories: newSelectedCategories.isEmpty
                      ? null
                      : newSelectedCategories,
                );
              },
            ),
          ),
        );
      }
    }

    if (filters.onSale == true) {
      final onSaleChipBgColor = _configHelper.getColor(
        'product_list_view.filter_chips.on_sale.backgroundColor',
        OsmeaColors.black,
      );
      final onSaleChipTextColor = _configHelper.getColor(
        'product_list_view.filter_chips.on_sale.textColor',
        OsmeaColors.white,
      );
      chips.add(
        OsmeaComponents.padding(
          padding: EdgeInsets.only(
            right: _configHelper.getDouble(
              'product_list_view.component_spacing.filter_chips_spacing',
              context.spacing8,
            ),
          ),
          child: OsmeaComponents.chips(
            text: context.t.productListView.widgets.chips.onSale,
            variant: ChipsVariant.primary,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            backgroundColor: onSaleChipBgColor,
            textColor: onSaleChipTextColor,
            onClose: () {
              widget.viewModel.updateFilter(onSale: null);
            },
          ),
        ),
      );
    }

    if (filters.featured == true) {
      final featuredChipBgColor = _configHelper.getColor(
        'product_list_view.filter_chips.featured.backgroundColor',
        OsmeaColors.white,
      );
      final featuredChipTextColor = _configHelper.getColor(
        'product_list_view.filter_chips.featured.textColor',
        OsmeaColors.thunder,
      );
      chips.add(
        OsmeaComponents.padding(
          padding: EdgeInsets.only(
            right: _configHelper.getDouble(
              'product_list_view.component_spacing.filter_chips_spacing',
              context.spacing8,
            ),
          ),
          child: OsmeaComponents.chips(
            text: context.t.productListView.widgets.chips.featured,
            variant: ChipsVariant.secondary,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            backgroundColor: featuredChipBgColor,
            textColor: featuredChipTextColor,
            onClose: () {
              widget.viewModel.updateFilter(featured: null);
            },
          ),
        ),
      );
    }

    if (filters.stockStatus != null) {
      final stockChipBgColor = _configHelper.getColor(
        'product_list_view.filter_chips.stock_status.backgroundColor',
        OsmeaColors.white,
      );
      final stockChipTextColor = _configHelper.getColor(
        'product_list_view.filter_chips.stock_status.textColor',
        OsmeaColors.thunder,
      );
      chips.add(
        OsmeaComponents.padding(
          padding: EdgeInsets.only(
            right: _configHelper.getDouble(
              'product_list_view.component_spacing.filter_chips_spacing',
              context.spacing8,
            ),
          ),
          child: OsmeaComponents.chips(
            text: _formatStockStatus(filters.stockStatus!),
            variant: ChipsVariant.info,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            backgroundColor: stockChipBgColor,
            textColor: stockChipTextColor,
            onClose: () {
              widget.viewModel.updateFilter(stockStatus: null);
            },
          ),
        ),
      );
    }

    debugPrint('🔍 _buildActiveFilterChips: Built ${chips.length} chips');

    if (chips.isEmpty) {
      debugPrint(
        '⚠️ _buildActiveFilterChips: No chips to display, returning SizedBox.shrink()',
      );
      return const SizedBox.shrink();
    }

    debugPrint(
      '✅ _buildActiveFilterChips: Returning chip list with ${chips.length} chips',
    );

    return Container(
      padding: EdgeInsets.symmetric(vertical: context.spacing8),
      child: OsmeaComponents.singleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: OsmeaComponents.row(
          children: [
            ...chips,
            // Clear all button
            Builder(
              builder: (context) {
                final clearAllIconColor = _configHelper.getColor(
                  'product_list_view.filter_chips.clear_all.iconColor',
                  OsmeaColors.pewter,
                );
                return OsmeaComponents.padding(
                  padding: context.onlyLeftPaddingLow,
                  child: OsmeaComponents.chips(
                    text: context.t.productListView.widgets.chips.clearAll,
                    variant: ChipsVariant.neutral,
                    style: ChipsStyle.outlined,
                    icon: Icon(
                      Icons.close,
                      size: context.iconSizeExtraSmall,
                      color: clearAllIconColor,
                    ),
                    iconPosition: ChipsIconPosition.start,
                    onTap: () => widget.viewModel.clearFilters(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Formats stock status for display
  String _formatStockStatus(String status) {
    switch (status.toLowerCase()) {
      case 'instock':
        return context.t.productListView.widgets.stockStatus.inStock;
      case 'outofstock':
        return context.t.productListView.widgets.stockStatus.outOfStock;
      case 'onbackorder':
        return context.t.productListView.widgets.stockStatus.onBackorder;
      default:
        return status;
    }
  }

  /// Builds product grid - same layout as home recommended section
  Widget _buildProductGridSliver(BuildContext context) {
    final state = widget.state;
    final bool isTablet = context.allWidth >= 768;
    final double crossAxisSpacing = _configHelper.getDouble(
      'product_list_view.grid.crossAxisSpacing',
      context.spacing8,
    );
    final double mainAxisSpacing = _configHelper.getDouble(
      'product_list_view.grid.mainAxisSpacing',
      context.spacing8,
    );
    final int columnsTablet = _configHelper.getInt(
      'product_list_view.grid.columns_tablet',
      3,
    );
    final int columnsMobile = _configHelper.getInt(
      'product_list_view.grid.columns_mobile',
      2,
    );
    final double estimatedCardHeight = _configHelper.getDouble(
      'product_list_view.grid.estimatedCardHeight',
      280.0,
    );

    // Calculate card width similar to recommended section
    final double horizontalPadding = _configHelper.getDouble(
      'product_list_view.component_spacing.grid_padding',
      context.spacing12,
    ) * 2;
    final double cardWidth =
        (context.allWidth - horizontalPadding - crossAxisSpacing) /
        (isTablet ? columnsTablet : columnsMobile);
    final double childAspectRatio = cardWidth / estimatedCardHeight;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: _configHelper.getDouble(
          'product_list_view.component_spacing.grid_padding',
          context.spacing12,
        ),
        vertical: _configHelper.getDouble(
          'product_list_view.component_spacing.grid_spacing',
          context.spacing8,
        ),
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? columnsTablet : columnsMobile,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= state.products.length) {
              if (state.hasMore) {
                // Load more trigger
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.viewModel.loadMore();
                });
                return OsmeaComponents.center(
                  child: OsmeaComponents.loading(
                    type: LoadingType.circularFade,
                    size: context.iconSizeExtraHigh,
                    color: _configHelper.getColor(
                      'product_list_view.empty_view.iconBackgroundColor',
                      OsmeaColors.black,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }

            final product = state.products[index];
            final productId = product.id ?? 0;

            return StaggeredAnimation(
              index: index,
              child: ClipRect(
                child: BlocBuilder<WishlistViewModel, WishlistState>(
                  bloc: GetIt.I<WishlistViewModel>(),
                  builder: (context, wishlistState) {
                    final wishlistVm = GetIt.I<WishlistViewModel>();
                    final currentIsSaved = wishlistVm.isSaved(productId);

                    final Set<ProductCardBadge> badges = {};
                    // Flash sale badge for products list (on sale items)
                    if (product.onSale == true) {
                      badges.add(ProductCardBadge.flashSale);
                    }
                    // Week star is handled inside ProductCardWidget via config
                    // (product_card.badges.week_star.product_ids)

                    return ProductCardWidget(
                      product: product,
                      isSaved: currentIsSaved,
                      badges: badges,
                      allowWeekStarBadge: true,
                      onWishlistTap: () async {
                        try {
                          final wasSaved = wishlistVm.isSaved(productId);

                          // Create WishlistItem from current product
                          final wishlistItem = WishlistItem(
                            id: productId,
                            name: product.name,
                            imageUrl: (product.images?.isNotEmpty ?? false)
                                ? product.images!.first.src
                                : null,
                            regularPrice: product.prices?.regularPrice,
                            salePrice: product.prices?.salePrice,
                            currencyCode: product.prices?.currencyCode,
                            currencyDecimalSeparator:
                                product.prices?.currencyDecimalSeparator,
                            currencyThousandSeparator:
                                product.prices?.currencyThousandSeparator,
                            currencyMinorUnit: product.prices?.currencyMinorUnit,
                            onSale: product.onSale == true,
                          );

                          // Toggle wishlist using WishlistViewModel
                          await wishlistVm.toggle(wishlistItem);

                          final isNowSaved = wishlistVm.isSaved(productId);

                          // Show snackbar based on action
                          if (context.mounted) {
                            if (isNowSaved && !wasSaved) {
                              context.showSnackbar(
                                message: 'Added to favorites',
                                type: SnackbarType.success,
                              );
                            } else if (!isNowSaved && wasSaved) {
                              context.showSnackbar(
                                message: 'Removed from favorites',
                                type: SnackbarType.info,
                              );
                            }
                          }
                        } catch (e) {
                          debugPrint('❌ Failed to toggle wishlist: $e');
                          if (context.mounted) {
                            context.showSnackbar(
                              message: 'Failed to update favorites',
                              type: SnackbarType.error,
                            );
                          }
                        }
                      },
                      onAddToCart: () async {
                        await addToCartFromProductCard(
                          context,
                          productId: productId,
                        );
                      },
                      onTap: () => context.push('/product-detail/$productId'),
                    );
                  },
                ),
              ),
            );
          },
          childCount: state.products.length + (state.hasMore ? 1 : 0),
        ),
      ),
    );
  }
}
