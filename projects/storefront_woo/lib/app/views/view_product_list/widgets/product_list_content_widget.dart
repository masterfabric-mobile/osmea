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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/freezed_model/response/list_product_categories_response_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_woo/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
import 'package:storefront_woo/app/views/view_product_list/widgets/product_list_filters_widget.dart';
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';

/// Main content widget for product list view
class ProductListContentWidget extends StatelessWidget {
  final ProductListLoadedState state;
  final ProductListViewModel viewModel;

  const ProductListContentWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '📦 ProductListContentWidget: Building with ${state.products.length} products',
    );
    debugPrint('📦 ProductListContentWidget: State type: ${state.runtimeType}');
    debugPrint(
      '📦 ProductListContentWidget: Has active filters: ${viewModel.filters.hasActiveFilters}',
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

    return OsmeaComponents.column(
      children: [
        // Icon buttons for Sort by / Filters
        _buildActionButtons(context),

        // Active filter chips
        if (viewModel.filters.hasActiveFilters)
          OsmeaComponents.padding(
            padding: EdgeInsets.only(
              left: context.spacing20,
              right: context.spacing20,
              bottom: context.spacing8,
            ),
            child: _buildActiveFilterChips(context),
          ),
        // Product grid
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  state.hasMore) {
                viewModel.loadMore();
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async => viewModel.loadProducts(refresh: true),
              child: _buildProductGrid(context),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds icon buttons for Sort by / Filters
  Widget _buildActionButtons(BuildContext context) {
    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing12,
      ),
      child: OsmeaComponents.row(
        mainAxisAlignment: context.spaceBetween,
        children: [
          OsmeaComponents.iconButton(
            onPressed: () => _showSortBottomSheet(context),
            icon: Icon(
              Icons.sort,
              color: OsmeaColors.thunder,
              size: context.iconSizeNormal,
            ),
            backgroundColor: OsmeaColors.transparent,
            tooltip: 'Sort by',
          ),
          OsmeaComponents.iconButton(
            onPressed: () => _showFiltersBottomSheet(context),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.filter_list,
                  color: OsmeaColors.thunder,
                  size: context.iconSizeNormal,
                ),
                if (viewModel.filters.hasActiveFilters)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: OsmeaColors.nordicBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            backgroundColor: OsmeaColors.transparent,
            tooltip: 'Filters',
          ),
        ],
      ),
    );
  }

  /// Shows sort bottom sheet
  void _showSortBottomSheet(BuildContext context) {
    viewModel.resetDialogInit();

    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.medium,
      title: 'Sort by',
      backgroundColor: OsmeaColors.white,
      child: ProductListFiltersWidget(viewModel: viewModel, showOnlySort: true),
    ).then((_) {
      viewModel.resetDialogInit();
    });
  }

  /// Shows filters bottom sheet
  void _showFiltersBottomSheet(BuildContext context) {
    viewModel.resetDialogInit();

    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.large,
      title: 'Filters',
      backgroundColor: OsmeaColors.white,
      child: ProductListFiltersWidget(
        viewModel: viewModel,
        showOnlySort: false,
      ),
    ).then((_) {
      viewModel.resetDialogInit();
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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 40,
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
            if (viewModel.filters.hasActiveFilters) ...[
              OsmeaComponents.sizedBox(height: context.spacing16),
              OsmeaComponents.button(
                text: 'Clear all filters',
                onPressed: () => viewModel.clearFilters(),
                variant: ButtonVariant.outlined,
                size: ButtonSize.medium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds active filter chips
  Widget _buildActiveFilterChips(BuildContext context) {
    final filters = viewModel.filters;
    final chips = <Widget>[];

    // Price range filter chips - REMOVED as requested

    // Category filter chips
    if (filters.selectedCategories != null &&
        filters.selectedCategories!.isNotEmpty) {
      // Get category names from state
      final state = viewModel.state;
      for (final categoryId in filters.selectedCategories!) {
        final category = state.categories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () =>
              const ListProductCategoriesResponseModel(id: null, name: null),
        );

        final categoryName = category.name ?? 'Category $categoryId';
        chips.add(
          OsmeaComponents.padding(
            padding: context.onlyRightPaddingLow,
            child: OsmeaComponents.chips(
              text: categoryName,
              variant: ChipsVariant.primary,
              style: ChipsStyle.normal,
              selected: true,
              closable: true,
              onClose: () {
                final newSelectedCategories = List<int>.from(
                  filters.selectedCategories!,
                );
                newSelectedCategories.remove(categoryId);
                viewModel.updateFilter(
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
          padding: context.onlyRightPaddingLow,
          child: OsmeaComponents.chips(
            text: 'On Sale',
            variant: ChipsVariant.primary,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            onClose: () {
              viewModel.updateFilter(onSale: null);
            },
          ),
        ),
      );
    }

    if (filters.featured == true) {
      chips.add(
        OsmeaComponents.padding(
          padding: context.onlyRightPaddingLow,
          child: OsmeaComponents.chips(
            text: 'Featured',
            variant: ChipsVariant.secondary,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            onClose: () {
              viewModel.updateFilter(featured: null);
            },
          ),
        ),
      );
    }

    if (filters.stockStatus != null) {
      chips.add(
        OsmeaComponents.padding(
          padding: context.onlyRightPaddingLow,
          child: OsmeaComponents.chips(
            text: _formatStockStatus(filters.stockStatus!),
            variant: ChipsVariant.info,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            onClose: () {
              viewModel.updateFilter(stockStatus: null);
            },
          ),
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return OsmeaComponents.singleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: OsmeaComponents.row(children: chips),
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
    final bool isTablet = context.allWidth >= 768;
    final double crossAxisSpacing = 15;
    final double mainAxisSpacing = 16;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing12,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        childAspectRatio: isTablet ? 0.68 : 0.58,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: state.products.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          if (state.hasMore) {
            // Load more trigger
            WidgetsBinding.instance.addPostFrameCallback((_) {
              viewModel.loadMore();
            });
            return OsmeaComponents.center(
              child: OsmeaComponents.loading(
                type: LoadingType.circularFade,
                size: 32,
                color: OsmeaColors.nordicBlue,
              ),
            );
          }
          return const SizedBox.shrink();
        }

        final product = state.products[index];
        final productId = product.id ?? 0;

        return BlocBuilder<WishlistViewModel, WishlistState>(
          bloc: GetIt.I<WishlistViewModel>(),
          buildWhen: (previous, current) {
            if (previous is! WishlistLoadedState &&
                current is WishlistLoadedState) {
              return true;
            }
            if (previous is WishlistLoadedState &&
                current is WishlistLoadedState) {
              final prevSaved = previous.items.any((e) => e.id == productId);
              final currSaved = current.items.any((e) => e.id == productId);
              return prevSaved != currSaved;
            }
            return false;
          },
          builder: (context, wishlistState) {
            final wishlistVm = GetIt.I<WishlistViewModel>();
            final isSaved = wishlistVm.isSaved(productId);

            return ProductCardWidget(
              product: product,
              isSaved: isSaved,
              onWishlistTap: () {
                GetIt.I<HomeViewModel>().addProductToWishlist(productId);
              },
              onTap: () => context.push('/product-detail/$productId'),
            );
          },
        );
      },
    );
  }
}
