/*
 * Product Detail Widgets
 * ----------------------
 * Main content widget for product detail view following OSMEA architecture.
 * Uses OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/action_section.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_images_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_info_section_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/add_to_cart_popup.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';

/// Main content widget for product detail view
class ProductDetailContentWidget extends StatelessWidget {
  final ProductDetailViewModel viewModel;
  final ProductDetailLoadedState state;
  final Function(String path) goRoute;

  const ProductDetailContentWidget({
    super.key,
    required this.viewModel,
    required this.state,
    required this.goRoute,
  });

  @override
  Widget build(BuildContext context) {
    final productId = state.product.id ?? 0;

    // Use BlocBuilder to reactively listen to WishlistViewModel changes
    return BlocBuilder<WishlistViewModel, WishlistState>(
      bloc: GetIt.I<WishlistViewModel>(),
      buildWhen: (previous, current) {
        // Rebuild when state changes from Initial/Loading to Loaded
        if (previous is! WishlistLoadedState &&
            current is WishlistLoadedState) {
          return true; // State just loaded, rebuild to show saved status
        }
        // Rebuild when state changes between Loaded states (item added/removed)
        if (previous is WishlistLoadedState && current is WishlistLoadedState) {
          final prevSaved = previous.items.any((e) => e.id == productId);
          final currSaved = current.items.any((e) => e.id == productId);
          return prevSaved != currSaved;
        }
        return false; // Don't rebuild for other state changes
      },
      builder: (context, wishlistState) {
        final wishlistVm = GetIt.I<WishlistViewModel>();
        final isInWishlist = wishlistVm.isSaved(productId);

        return Stack(
          children: [
            OsmeaComponents.singleChildScrollView(
              padding: EdgeInsets.only(bottom: context.dynamicHeight(0.10)),
              child: OsmeaComponents.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product images with overlay actions
                  ProductImagesWidget(
                    imageUrls: state.imageUrls,
                    viewModel: viewModel,
                    goRoute: goRoute,
                    withOverlays: true,
                    isInWishlist: isInWishlist,
                    productId: productId,
                  ),

                  // Product info section
                  ProductInfoSectionWidget(viewModel: viewModel, state: state),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing16,
                    vertical: context.spacing10,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: OsmeaColors.black.withValues(alpha: 0.06),
                        blurRadius: context.blurRadius12,
                        offset: context.offsetVerticalCustom(-context.spacing6),
                      ),
                    ],
                  ),
                  child: ActionSection(
                    isInWishlist: isInWishlist,
                    onToggleWishlist: () {
                      viewModel.addProductToWishlistFire(productId);
                    },
                    isInCart: state.isInCart,
                    onAddToCart: () async {
                      // Check if all required attributes are selected before adding
                      final product = state.product;
                      if (product.attributes != null &&
                          product.attributes!.isNotEmpty) {
                        final Set<String> requiredAttributes = {};
                        for (final attr in product.attributes!) {
                          if (attr is Map<String, dynamic>) {
                            final name = (attr['name'] ?? attr['label'] ?? '')
                                .toString();
                            List<String> options = [];
                            final rawOptions = attr['options'];
                            final rawTerms = attr['terms'];

                            if (rawOptions is List && rawOptions.isNotEmpty) {
                              options = rawOptions
                                  .map((e) => e.toString())
                                  .toList();
                            } else if (rawTerms is List &&
                                rawTerms.isNotEmpty) {
                              options = rawTerms
                                  .map(
                                    (e) => e is Map
                                        ? (e['name'] ?? e['value'] ?? '')
                                              .toString()
                                        : e.toString(),
                                  )
                                  .where((e) => e.isNotEmpty)
                                  .toList();
                            }

                            if (options.isNotEmpty) {
                              requiredAttributes.add(name);
                            }
                          }
                        }

                        final Set<String> missingAttributes = requiredAttributes
                            .where(
                              (attr) =>
                                  !state.selectedAttributes.containsKey(attr) ||
                                  state.selectedAttributes[attr] == null ||
                                  state.selectedAttributes[attr]!.isEmpty,
                            )
                            .toSet();

                        if (missingAttributes.isNotEmpty) {
                          // Show snackbar using OsmeaComponents
                          context.snackbarError(
                            'Please select all options',
                            duration: context.durationLong,
                          );

                          // Highlight missing attributes
                          final currentState = viewModel.state;
                          if (currentState is ProductDetailLoadedState) {
                            viewModel.stateChanger(
                              currentState.copyWith(
                                highlightedAttributes: missingAttributes,
                              ),
                            );

                            // Reset highlighting after 2 seconds
                            Future.delayed(context.durationLong, () {
                              final stateAfterDelay = viewModel.state;
                              if (stateAfterDelay is ProductDetailLoadedState) {
                                viewModel.stateChanger(
                                  stateAfterDelay.copyWith(
                                    highlightedAttributes: {},
                                  ),
                                );
                              }
                            });
                          }
                          return;
                        }
                      }

                      // Add product to cart
                      await viewModel.addProductToCart(
                        state.product.id ?? 0,
                        quantity: state.selectedQuantity,
                      );

                      // Check if add was successful (check state)
                      final currentState = viewModel.state;
                      if (currentState is ProductDetailLoadedState &&
                          currentState.isInCart) {
                        // Show success popup with cart token for navigation
                        final cartToken = await viewModel
                            .getCartTokenForNavigation();
                        showAddToCartSuccessPopup(
                          context,
                          cartToken: cartToken,
                        );
                      }
                    },
                    selectedQuantity: state.selectedQuantity,
                    onUpdateQuantity: (q) => viewModel.updateQuantityFire(q),
                    onShare: () {},
                    showWishlistAndShare: false,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
