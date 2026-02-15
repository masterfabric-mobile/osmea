/*
 * ProductListContentWidget
 * ------------------------
 * Main content widget for product list view.
 * Displays products in a grid with pull-to-refresh and infinite scroll.
 * Includes top bar with Sort and Filter buttons.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/product_list_view_model.dart';
import 'package:storefront_supabase/app/views/view_product_list/models/module/states.dart';
import 'package:storefront_supabase/app/widgets/product_card_widget.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/favorites_view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/add_to_cart_popup.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:storefront_supabase/app/views/view_product_list/widgets/product_list_filters_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:osmea_components/src/components/bottom_sheet/bottom_sheet.dart';

class ProductListContentWidget extends StatefulWidget {
  final ProductListLoadedState state;
  final ProductListViewModel viewModel;

  const ProductListContentWidget({
    super.key,
    required this.state,
    required this.viewModel,
  });

  @override
  State<ProductListContentWidget> createState() => _ProductListContentWidgetState();
}

class _ProductListContentWidgetState extends State<ProductListContentWidget> {
  final ScrollController _scrollController = ScrollController();

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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        widget.state.hasMore) {
      widget.viewModel.loadMore();
    }
  }

  void _showSortBottomSheet(BuildContext context) {
    widget.viewModel.initFilterDialog();

    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.medium,
      title: 'Sort by',
      subtitle: 'Select how you want to sort the products',
      backgroundColor: OsmeaColors.white,
      actionBarBackgroundColor: OsmeaColors.white,
      leftAction: OsmeaComponents.button(
        text: 'Cancel',
        onPressed: () => Navigator.pop(context),
        variant: ButtonVariant.ghost,
        size: ButtonSize.small,
        textColor: OsmeaColors.black,
      ),
      rightAction: OsmeaComponents.button(
        text: 'Apply',
        onPressed: () {
          widget.viewModel.applyFilters();
          Navigator.pop(context);
        },
        variant: ButtonVariant.primary,
        size: ButtonSize.small,
        backgroundColor: OsmeaColors.black,
        textColor: OsmeaColors.white,
      ),
      child: ProductListFiltersWidget(
        viewModel: widget.viewModel,
        showOnlySort: true,
      ),
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    widget.viewModel.initFilterDialog();

    OsmeaBottomSheetHelpers.showModal(
      context: context,
      size: BottomSheetSize.large,
      title: 'Filters',
      subtitle: 'Filter products by categories, price, and more',
      backgroundColor: OsmeaColors.white,
      actionBarBackgroundColor: OsmeaColors.white,
      leftAction: OsmeaComponents.button(
        text: 'Cancel',
        onPressed: () => Navigator.pop(context),
        variant: ButtonVariant.ghost,
        size: ButtonSize.small,
        textColor: OsmeaColors.black,
      ),
      rightAction: OsmeaComponents.button(
        text: 'Apply',
        onPressed: () {
          widget.viewModel.applyFilters();
          Navigator.pop(context);
        },
        variant: ButtonVariant.primary,
        size: ButtonSize.small,
        backgroundColor: OsmeaColors.black,
        textColor: OsmeaColors.white,
      ),
      child: ProductListFiltersWidget(
        viewModel: widget.viewModel,
        showOnlySort: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If empty state
    if (widget.state.products.isEmpty) {
      return Stack(
        children: [
          // Filter buttons at top even if empty (to clear filters)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildActionButtons(context),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.resources.noProducts),
                const SizedBox(height: 16),
                if (widget.viewModel.filters.hasActiveFilters)
                  ElevatedButton(
                    onPressed: () => widget.viewModel.clearFilters(),
                    child: const Text('Clear Filters'),
                  ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildActionButtons(context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => widget.viewModel.loadProducts(refresh: true),
            child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(context.spacing16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.58,
                crossAxisSpacing: context.spacing12,
                mainAxisSpacing: context.spacing12,
              ),
              itemCount: widget.state.products.length + (widget.state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= widget.state.products.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final product = widget.state.products[index];
                final productId = product.id;

                return BlocBuilder<FavoritesViewModel, FavoritesState>(
                  bloc: GetIt.I<FavoritesViewModel>(),
                  builder: (context, favState) {
                    final favVm = GetIt.I<FavoritesViewModel>();
                    bool isSaved = false;
                    if (favState is FavoritesLoadedState) {
                      isSaved = favState.favoriteProducts.any((p) => p.id == productId);
                    }

                    return ProductCardWidget(
                      product: product,
                      isSaved: isSaved,
                      onWishlistTap: () async {
                        final wasSaved = isSaved;
                        if (!wasSaved && Supabase.instance.client.auth.currentUser == null) {
                          if (!context.mounted) return;
                          context.snackbarWarning(
                            context.resources.loginToAddToFavorites,
                            duration: context.durationLong,
                            style: SnackbarStyle.minimal,
                            position: SnackbarPosition.bottom,
                          );
                          return;
                        }
                        final success = wasSaved
                            ? await favVm.removeFavorite(productId)
                            : await favVm.addFavorite(
                                productId,
                                productForOptimisticUpdate: wasSaved ? null : product,
                              );
                        if (!context.mounted) return;
                        if (success) {
                          final addedMsg = context.resources.addedToFavorites;
                          final removedMsg = context.resources.removedFromFavorites;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!context.mounted) return;
                            if (wasSaved) {
                              context.showSnackbar(
                                message: removedMsg,
                                type: SnackbarType.info,
                                style: SnackbarStyle.minimal,
                                position: SnackbarPosition.bottom,
                                duration: context.durationLong,
                              );
                            } else {
                              context.snackbarSuccess(
                                addedMsg,
                                duration: context.durationLong,
                                style: SnackbarStyle.minimal,
                                position: SnackbarPosition.bottom,
                              );
                            }
                          });
                        }
                      },
                      onAddToCart: () async {
                        showAddToCartSuccessPopup(context);
                      },
                      onTap: () => context.push('/product-detail/$productId'),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final hasActiveFilters = widget.viewModel.filters.hasActiveFilters;

    return Container(
      color: OsmeaColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing20,
        vertical: context.spacing12,
      ),
      child: OsmeaComponents.row(
        children: [
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
            border: Border.all(color: OsmeaColors.silver, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: OsmeaColors.black.withValues(alpha: 0.04),
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
                          color: OsmeaColors.black,
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
}