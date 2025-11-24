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
        // Toggle buttons for Sort by / Filters
        _buildToggleButtons(context),
        
        // Active filter chips
        if (viewModel.filters.hasActiveFilters)
          OsmeaComponents.padding(
            padding: EdgeInsets.fromLTRB(
              context.paddingNormal.left,
              0,
              context.paddingNormal.right,
              context.spacing8,
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

  /// Builds toggle buttons for Sort by / Filters
  Widget _buildToggleButtons(BuildContext context) {
    return OsmeaComponents.container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showSortBottomSheet(context),
              child: OsmeaComponents.container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.transparent,
                ),
                child: Center(
                  child: OsmeaComponents.text(
                    'Sort by',
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: OsmeaColors.thunder,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _showFiltersBottomSheet(context),
              child: OsmeaComponents.container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: OsmeaColors.thunder,
                ),
                child: Center(
                  child: OsmeaComponents.text(
                    'Filters',
                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
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
      child: ProductListFiltersWidget(viewModel: viewModel, showOnlySort: false),
    ).then((_) {
      viewModel.resetDialogInit();
    });
  }

  /// Builds empty view using OSMEA components
  Widget _buildEmptyView(BuildContext context) {
    return OsmeaComponents.center(
      child: OsmeaComponents.singleChildScrollView(
        child: OsmeaComponents.column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            OsmeaComponents.container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: OsmeaColors.nordicBlue.withOpacity(0.1),
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

    // Price range filter chips
    if (filters.minPrice != null && filters.minPrice!.isNotEmpty) {
      chips.add(
        OsmeaComponents.padding(
          padding: EdgeInsets.only(right: context.spacing8),
          child: OsmeaComponents.chips(
            text: 'Min: ${_formatPriceChip(filters.minPrice!)}',
            variant: ChipsVariant.warning,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            onClose: () {
              viewModel.updateFilter(minPrice: null);
            },
          ),
        ),
      );
    }

    if (filters.maxPrice != null && filters.maxPrice!.isNotEmpty) {
      chips.add(
        OsmeaComponents.padding(
          padding: EdgeInsets.only(right: context.spacing8),
          child: OsmeaComponents.chips(
            text: 'Max: ${_formatPriceChip(filters.maxPrice!)}',
            variant: ChipsVariant.warning,
            style: ChipsStyle.normal,
            selected: true,
            closable: true,
            onClose: () {
              viewModel.updateFilter(maxPrice: null);
            },
          ),
        ),
      );
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
          padding: EdgeInsets.only(right: context.spacing8),
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
          padding: EdgeInsets.only(right: context.spacing8),
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

  /// Formats price for chip display
  String _formatPriceChip(String price) {
    // Try to parse as double and format nicely
    // Use PriceInfoCurrencyHelper.parsePriceToDouble to properly handle formatted strings
    final parsed = PriceInfoCurrencyHelper.parsePriceToDouble(price);
    if (parsed != null) {
      // Remove trailing zeros
      return parsed.toStringAsFixed(
        parsed.truncateToDouble() == parsed ? 0 : 2,
      );
    }
    return price;
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
      padding: context.paddingNormal,
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
