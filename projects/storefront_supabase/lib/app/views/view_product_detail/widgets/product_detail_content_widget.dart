/*
 * Product Detail Content Widget
 * -----------------------------
 * Main content widget for product detail view following OSMEA architecture.
 * Uses OsmeaComponents for consistent UI.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_product_detail/models/states.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/action_section.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/product_images_widget.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/product_name_price_widget.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/product_sections_list_widget.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/attribute_selection_modal.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/related_products_widget.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/states.dart';

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
    final productId = state.product.id;

    // Direct check without BlocBuilder to prevent blocking
    final wishlistVm = GetIt.I<FavoritesViewModel>();
    // Check if saved
    bool isInWishlist = false;
    if (wishlistVm.state is FavoritesLoadedState) {
        isInWishlist = (wishlistVm.state as FavoritesLoadedState).favoriteProducts.any((p) => p.id == productId);
    }

    final configHelper = AssetConfigHelper();
    final orderedComponents = _buildOrderedComponents(context, configHelper, isInWishlist, productId);

    return Stack(
          children: [
            OsmeaComponents.singleChildScrollView(
              padding: EdgeInsets.only(
                bottom: context.dynamicHeight(0.08),
                top: context.spacing4,
              ),
              child: OsmeaComponents.column(
                crossAxisAlignment: context.crossStart,
                children: [
                  // Add spacing between components
                  ...orderedComponents.expand((widget) => [
                    widget,
                    OsmeaComponents.sizedBox(height: context.spacing16),
                  ]).toList()..removeLast(), // Remove last spacing
                  OsmeaComponents.sizedBox(height: context.spacing24),
                ],
              ),
            ),

            // Elegant bottom bar - refined and clean
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: OsmeaComponents.container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing12,
                    vertical: context.spacing12,
                  ),
                  decoration: BoxDecoration(
                    color: OsmeaColors.white,
                    border: Border(
                      top: BorderSide(
                        color: OsmeaColors.black.withValues(alpha: 0.1),
                        width: 0.5,
                      ),
                    ),
                  ),
                child: ActionSection(
                    isInWishlist: isInWishlist,
                    onToggleWishlist: () {
                      viewModel.addProductToWishlistFire(productId);
                    },
                    isInCart: state.isInCart,
                    product: state.product,
                    onAddToCart: () async {
                      // Check if all required attributes are selected before adding
                      final product = state.product;
                      // Group variants to check required attributes
                      final Map<String, Set<String>> attributes = {};
                      for (final variant in product.variants) {
                        attributes.putIfAbsent(variant.name, () => {}).add(variant.value);
                      }
                      
                      final Set<String> requiredAttributes = attributes.keys.toSet();
                      
                      final Set<String> missingAttributes = requiredAttributes
                          .where(
                            (attr) =>
                                !state.selectedAttributes.containsKey(attr) ||
                                state.selectedAttributes[attr] == null ||
                                state.selectedAttributes[attr]!.isEmpty,
                          )
                          .toSet();

                      if (missingAttributes.isNotEmpty) {
                        // Show step-by-step attribute selection modal
                        showDialog(
                          context: context,
                          barrierColor: OsmeaColors.black.withValues(alpha: 0.5),
                          builder: (modalContext) => AttributeSelectionModal(
                            viewModel: viewModel,
                            state: state,
                            missingAttributes: missingAttributes,
                            onComplete: (selectedAttributes) async {
                              // Update state with selected attributes first
                              final currentState = viewModel.state;
                              if (currentState is ProductDetailLoadedState) {
                                for (final entry in selectedAttributes.entries) {
                                  await viewModel.setSelectedAttribute(
                                    entry.key,
                                    entry.value,
                                  );
                                }
                                
                                // Retry adding to cart - viewmodel will handle showing popup via state
                                await viewModel.addProductToCart(
                                  state.product.id,
                                  quantity: state.detailPageQuantity, // Use detailPageQuantity
                                );
                              }
                            },
                          ),
                        );
                        return;
                      }

                      // Add product to cart - viewmodel will handle showing popup via state
                      await viewModel.addProductToCart(
                        state.product.id,
                        quantity: state.detailPageQuantity, // Use detailPageQuantity
                      );
                    },
                    onShare: () {}, // No share implementation yet
                    showWishlistAndShare: false, // Moved to image overlay
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
    String productId,
  ) {
    final List<_ProductDetailComponent> components = [];

    // Images - always first (order_id 0)
    if (_isEnabled(configHelper, 'images')) {
      components.add(
        _ProductDetailComponent(
          orderId: 0,
          widget: ProductImagesWidget(
            imageUrls: state.product.imageUrls,
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

    // Sections list (Attributes, Description, Reviews) - modern expandable list
    components.add(
      _ProductDetailComponent(
        orderId: _getOrderId(configHelper, 'sections'),
        widget: ProductSectionsListWidget(
          viewModel: viewModel,
          state: state,
          goRoute: goRoute,
        ),
        name: 'sections',
      ),
    );

    // Related products section - at the bottom
    if (_isEnabled(configHelper, 'related_products')) {
      components.add(
        _ProductDetailComponent(
          orderId: _getOrderId(configHelper, 'related_products'),
          widget: RelatedProductsWidget(
            currentProductId: productId,
            goRoute: goRoute,
          ),
          name: 'related_products',
        ),
      );
    }

    // Sort by orderID (images always first with order_id 0)
    components.sort((a, b) => a.orderId.compareTo(b.orderId));

    // Convert to widgets list
    return components.map((c) => c.widget).toList();
  }
}