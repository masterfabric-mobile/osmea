/*
 * Product Detail Widgets
 * ----------------------
 * Main content widget for product detail view following OSMEA architecture.
 * Uses OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/action_section.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_images_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_name_price_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_attributes_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_description_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_reviews_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/add_to_cart_popup.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';

/// Component model with orderID
class _ProductDetailComponent {
  final int orderId;
  final Widget widget;
  final String name;

  _ProductDetailComponent({
    required this.orderId,
    required this.widget,
    required this.name,
  });
}

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

    // Direct check without BlocBuilder to prevent blocking
    final wishlistVm = GetIt.I<WishlistViewModel>();
    final isInWishlist = wishlistVm.isSaved(productId);

    final configHelper = AssetConfigHelper();
    final orderedComponents = _buildOrderedComponents(context, configHelper, isInWishlist, productId);

        return Stack(
          children: [
            OsmeaComponents.singleChildScrollView(
              padding: EdgeInsets.only(bottom: context.dynamicHeight(0.10)),
              child: OsmeaComponents.column(
                crossAxisAlignment: context.crossStart,
                children: orderedComponents,
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
                    onShare: () => _shareProduct(context, state),
                    showWishlistAndShare: false,
                  ),
                ),
              ),
            ),
          ],
        );
  }

  /// Loads component orderID from config
  int _getOrderId(AssetConfigHelper configHelper, String componentName) {
    try {
      final config = configHelper.getObject('product_detail_view.$componentName');
      return config?['order_id'] as int? ?? 999;
    } catch (e) {
      debugPrint('⚠️ Failed to load order_id for $componentName: $e');
      return 999;
    }
  }

  /// Checks if component is enabled
  bool _isEnabled(AssetConfigHelper configHelper, String componentName) {
    try {
      final config = configHelper.getObject('product_detail_view.$componentName');
      return config?['enabled'] as bool? ?? true;
    } catch (e) {
      debugPrint('⚠️ Failed to load enabled for $componentName: $e');
      return true;
    }
  }

  /// Builds all components sorted by orderID
  List<Widget> _buildOrderedComponents(
    BuildContext context,
    AssetConfigHelper configHelper,
    bool isInWishlist,
    int productId,
  ) {
    final List<_ProductDetailComponent> components = [];

    // Images - always first (order_id 0)
    if (_isEnabled(configHelper, 'images')) {
      components.add(
        _ProductDetailComponent(
          orderId: 0,
          widget: ProductImagesWidget(
            imageUrls: state.imageUrls,
            viewModel: viewModel,
            goRoute: goRoute,
            withOverlays: true,
            isInWishlist: isInWishlist,
            productId: productId,
            productName: state.product.name,
          ),
          name: 'images',
        ),
      );
    }

    // Name and Price
    if (_isEnabled(configHelper, 'name_and_price')) {
      components.add(
        _ProductDetailComponent(
          orderId: _getOrderId(configHelper, 'name_and_price'),
          widget: ProductNamePriceWidget(state: state),
          name: 'name_and_price',
        ),
      );
    }

    // Attributes
    if (_isEnabled(configHelper, 'attributes') &&
        state.product.attributes != null &&
        state.product.attributes!.isNotEmpty) {
      components.add(
        _ProductDetailComponent(
          orderId: _getOrderId(configHelper, 'attributes'),
          widget: ProductAttributesWidget(
            viewModel: viewModel,
            state: state,
          ),
          name: 'attributes',
        ),
      );
    }

    // Description
    if (_isEnabled(configHelper, 'description') &&
        state.product.description?.isNotEmpty == true) {
      components.add(
        _ProductDetailComponent(
          orderId: _getOrderId(configHelper, 'description'),
          widget: ProductDescriptionWidget(
            viewModel: viewModel,
            state: state,
          ),
          name: 'description',
        ),
      );
    }

    // Reviews
    if (_isEnabled(configHelper, 'reviews')) {
      components.add(
        _ProductDetailComponent(
          orderId: _getOrderId(configHelper, 'reviews'),
          widget: ProductReviewsWidget(state: state),
          name: 'reviews',
        ),
      );
    }

    // Sort by orderID (images always first with order_id 0)
    components.sort((a, b) => a.orderId.compareTo(b.orderId));

    // Convert to widgets list
    return components.map((c) => c.widget).toList();
  }

  /// Shares product information
  Future<void> _shareProduct(BuildContext context, ProductDetailLoadedState state) async {
    try {
      final product = state.product;
      final productId = product.id ?? 0;
      final productName = product.name ?? 'Product';
      
      // Construct shareable text with product name and URL
      final shareText = '$productName\n\n/product-detail/$productId';
      
      // Share using ApplicationShareHelper
      final success = await ApplicationShareHelper.shareText(
        shareText,
        subject: productName,
      );
      
      if (success) {
        debugPrint('✅ Product shared successfully: $productName');
      } else {
        debugPrint('⚠️ Failed to share product');
        if (context.mounted) {
          context.snackbarError('Failed to share product');
        }
      }
    } catch (e) {
      debugPrint('❌ Error sharing product: $e');
      if (context.mounted) {
        context.snackbarError('Error sharing product');
      }
    }
  }
}
