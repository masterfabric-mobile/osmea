/*
 * ProductListContentWidget
 * ------------------------
 * Main content widget for product list view.
 * Displays products in a grid with pull-to-refresh and infinite scroll.
 * Includes filter chips at the top for active filters.
 */

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/list_product_categories_response_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/product_list_filters_widget.dart';
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > 300;
    if (shouldShow != _showScrollToTop) {
      setState(() {
        _showScrollToTop = shouldShow;
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
        '⚠️ ProductListContentWidget: Products list is empty, showing empty view',
      );
      return _buildEmptyView(context);
    }

    debugPrint(
      '✅ ProductListContentWidget: Showing product grid with ${state.products.length} products',
    );

    return Stack(
      children: [
        OsmeaComponents.column(
          children: [
            // Add top padding for AppBar when useSafeArea is false
            SizedBox(height: context.highValue * 1.5),
            // Icon buttons for Sort by / Filters
            _buildActionButtons(context),

            // Active filter chips
            if (_hasChipWorthyFilters())
              OsmeaComponents.padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing20,
                  vertical: context.spacing12,
                ),
                child: _buildActiveFilterChips(context),
              ),
            // Product grid
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      widget.state.hasMore) {
                    widget.viewModel.loadMore();
                  }
                  return false;
                },
                child: RefreshIndicator(
                  onRefresh: () async =>
                      widget.viewModel.loadProducts(refresh: true),
                  child: _buildProductGrid(context),
                ),
              ),
            ),
          ],
        ),
        // Scroll to top button
        if (_showScrollToTop)
          Positioned(
            bottom: context.spacing24,
            right: context.spacing24,
            child: Material(
              color: OsmeaColors.nordicBlue,
              shape: const CircleBorder(),
              elevation: 8,
              shadowColor: OsmeaColors.nordicBlue.withOpacity(0.4),
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
                        color: OsmeaColors.nordicBlue.withOpacity(0.3),
                        blurRadius: context.blurRadius12,
                        offset: context.offsetVerticalCustom(context.spacing4),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    color: OsmeaColors.white,
                    size: context.iconSizeNormal,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds icon buttons for Sort by / Filters
  Widget _buildActionButtons(BuildContext context) {
    final hasActiveFilters = widget.viewModel.filters.hasActiveFilters;

    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing12,
      ),
      child: OsmeaComponents.row(
        children: [
          // Sort button
          Expanded(
            child: _buildModernActionButton(
              context: context,
              icon: Icons.sort_rounded,
              label: 'Sort',
              onPressed: () => _showSortBottomSheet(context),
              hasBadge: false,
            ),
          ),
          OsmeaComponents.sizedBox(width: context.spacing12),
          // Filter button
          Expanded(
            child: _buildModernActionButton(
              context: context,
              icon: Icons.tune_rounded,
              label: 'Filters',
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.spacing12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.spacing12,
            vertical: context.spacing10,
          ),
          decoration: BoxDecoration(
            color: OsmeaColors.white,
            borderRadius: BorderRadius.circular(context.spacing12),
            border: Border.all(color: OsmeaColors.silver, width: 1),
            boxShadow: [
              BoxShadow(
                color: OsmeaColors.black.withOpacity(0.04),
                blurRadius: context.blurRadius8,
                offset: context.offsetVerticalCustom(context.spacing2),
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
                    color: OsmeaColors.thunder,
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
                          color: OsmeaColors.nordicBlue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: OsmeaColors.white,
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
                  color: OsmeaColors.thunder,
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

    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.medium,
      title: 'Sort by',
      backgroundColor: OsmeaColors.white,
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

    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.large,
      title: 'Filters',
      backgroundColor: OsmeaColors.white,
      child: ProductListFiltersWidget(
        viewModel: widget.viewModel,
        showOnlySort: false,
      ),
    ).then((_) {
      widget.viewModel.resetDialogInit();
    });
  }

  /// Builds empty view using OSMEA components
  Widget _buildEmptyView(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.column(
          mainAxisAlignment: context.centerMain,
          crossAxisAlignment: context.crossCenter,
          children: [
            OsmeaComponents.container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: context.iconSizeExtraHigh,
                color: OsmeaColors.nordicBlue,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              'No products found',
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                color: OsmeaColors.thunder,
              ),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              'Try adjusting your filters or search terms',
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(color: OsmeaColors.pewter),
              textAlign: TextAlign.center,
            ),
            if (widget.viewModel.filters.hasActiveFilters) ...[
              OsmeaComponents.sizedBox(height: context.spacing16),
              OsmeaComponents.button(
                text: 'Clear all filters',
                onPressed: () => widget.viewModel.clearFilters(),
                variant: ButtonVariant.outlined,
                size: ButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
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

        final categoryName = category.name ?? 'Category $categoryId';
        chips.add(
          OsmeaComponents.padding(
            padding: EdgeInsets.only(right: context.spacing8),
            child: OsmeaComponents.chips(
              text: categoryName,
              variant: ChipsVariant.primary,
              style: ChipsStyle.normal,
              selected: true,
              closable: true,
              backgroundColor: OsmeaColors.nordicBlue,
              textColor: OsmeaColors.white,
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
      chips.add(
        OsmeaComponents.padding(
          padding: EdgeInsets.only(right: context.spacing8),
          child: OsmeaComponents.chips(
            text: 'On Sale',
            variant: ChipsVariant.primary,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            backgroundColor: OsmeaColors.nordicBlue,
            textColor: OsmeaColors.white,
            onClose: () {
              widget.viewModel.updateFilter(onSale: null);
            },
          ),
        ),
      );
    }

    if (filters.featured == true) {
      chips.add(
        OsmeaComponents.padding(
          padding: EdgeInsets.only(right: context.spacing8),
          child: OsmeaComponents.chips(
            text: 'Featured',
            variant: ChipsVariant.secondary,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            onClose: () {
              widget.viewModel.updateFilter(featured: null);
            },
          ),
        ),
      );
    }

    if (filters.stockStatus != null) {
      chips.add(
        OsmeaComponents.padding(
          padding: EdgeInsets.only(right: context.spacing8),
          child: OsmeaComponents.chips(
            text: _formatStockStatus(filters.stockStatus!),
            variant: ChipsVariant.info,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
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
            OsmeaComponents.padding(
              padding: context.onlyLeftPaddingLow,
              child: OsmeaComponents.chips(
                text: 'Clear all',
                variant: ChipsVariant.neutral,
                style: ChipsStyle.outlined,
                icon: Icon(
                  Icons.close,
                  size: context.iconSizeExtraSmall,
                  color: OsmeaColors.pewter,
                ),
                iconPosition: ChipsIconPosition.start,
                onTap: () => widget.viewModel.clearFilters(),
              ),
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
        return 'In Stock';
      case 'outofstock':
        return 'Out of Stock';
      case 'onbackorder':
        return 'On Backorder';
      default:
        return status;
    }
  }

  /// Builds product grid - same layout as home recommended section
  Widget _buildProductGrid(BuildContext context) {
    final state = widget.state;
    final bool isTablet = context.allWidth >= 768;
    final double crossAxisSpacing = context.spacing8;
    final double mainAxisSpacing = context.spacing8;

    // Calculate card width similar to recommended section
    final double horizontalPadding = context.spacing12 * 2;
    final double cardWidth =
        (context.allWidth - horizontalPadding - crossAxisSpacing) /
        (isTablet ? 3 : 2);
    final double estimatedCardHeight = 280;
    final double childAspectRatio = cardWidth / estimatedCardHeight;

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing8,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: state.products.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
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
                color: OsmeaColors.nordicBlue,
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final product = state.products[index];
        final productId = product.id ?? 0;

        // Direct check without BlocBuilder to prevent blocking
        final wishlistVm = GetIt.I<WishlistViewModel>();
        final isSaved = wishlistVm.isSaved(productId);

        return ClipRect(
          child: ProductCardWidget(
            product: product,
            isSaved: isSaved,
            onWishlistTap: () {
              GetIt.I<HomeViewModel>().addProductToWishlist(productId);
            },
            onTap: () => context.push('/product-detail/$productId'),
          ),
        );
      },
    );
  }
}
