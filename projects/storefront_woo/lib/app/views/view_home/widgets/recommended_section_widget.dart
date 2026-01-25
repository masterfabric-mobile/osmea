/*
 * RecommendedSectionWidget
 * ------------------------
 * "Recommended for you" product carousel section.
 * Loads from app config.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/utils/cart_add_helper.dart';
// Animation helpers are now imported from core
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:storefront_woo/gen/translations.g.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';

/// Recommended section widget
class RecommendedSectionWidget extends StatelessWidget {
  final AssetConfigHelper configHelper;
  final List<ListAllProductsResponseModel> allProducts;
  final HomeViewModel viewModel;

  const RecommendedSectionWidget({
    super.key,
    required this.configHelper,
    required this.allProducts,
    required this.viewModel,
  });

  /// Loads recommended section configuration
  Map<String, dynamic>? _loadRecommendedConfig() {
    try {
      return configHelper.getObject('home_view.recommended');
    } catch (e) {
      debugPrint('⚠️ Failed to load recommended config: $e');
      return null;
    }
  }

  /// Filters products based on recommended config
  /// Optimized to prevent blocking during build
  List<ListAllProductsResponseModel> _getRecommendedProducts() {
    // Use cached config to avoid repeated lookups
    final config = _loadRecommendedConfig();
    if (config == null) {
      // Default: show first 4 products (for home view)
      // Use take() which is lazy and efficient
      return allProducts.take(4).toList();
    }

    // Check if specific product IDs are provided
    final productIds = config['product_ids'] as List<dynamic>?;
    if (productIds != null && productIds.isNotEmpty) {
      // Convert to Set for O(1) lookup instead of O(n)
      final ids = productIds.map((e) => e as int).toSet();
      return allProducts.where((p) => ids.contains(p.id)).toList();
    }

    // If no specific IDs, show first 4 products (for home view)
    final limit = config['limit'] as int? ?? 4;
    return allProducts.take(limit).toList();
  }

  /// Gets horizontal padding from config
  double _getHorizontalPadding() {
    try {
      final config = _loadRecommendedConfig();
      final paddingConfig = config?['padding'] as Map<String, dynamic>?;
      if (paddingConfig != null) {
        final horizontal = (paddingConfig['horizontal'] as num?)?.toDouble();
        if (horizontal != null && horizontal > 0) {
          return horizontal;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load horizontal padding: $e');
    }
    // Default from component_spacing
    return configHelper.getDouble('home_view.component_spacing.horizontal', 20.0);
  }

  /// Gets title to content spacing from config
  double _getTitleSpacing() {
    return configHelper.getDouble('home_view.component_spacing.title_to_content', 16.0);
  }

  /// Get color from config
  Color _getColorFromConfig(String key, Color fallback) {
    try {
      final colorString = configHelper.getString('home_view.recommended.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load recommended color $key: $e');
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final config = _loadRecommendedConfig();
    final sectionTitle = config?['title'] as String? ?? context.t.homeView.widgets.recommended.title;
    final showSection = config?['enabled'] as bool? ?? true;

    if (!showSection) return const SizedBox.shrink();

    final recommendedProducts = _getRecommendedProducts();
    if (recommendedProducts.isEmpty) return const SizedBox.shrink();

    final horizontalPadding = _getHorizontalPadding();

    return OsmeaComponents.column(
      crossAxisAlignment: context.crossStart,
      children: [
        // Section header with "See all" button
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: OsmeaComponents.row(
            mainAxisAlignment: context.spaceBetween,
            crossAxisAlignment: context.crossCenter,
            children: [
              OsmeaComponents.text(
                sectionTitle,
                textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                  fontSize: context.fontSizeNormal * context.textScaleFactor,
                  fontWeight: FontWeight.w600, // Semi Bold
                  height: context.lineHeightTight, // line height 20px
                  letterSpacing: -0.2,
                  color: _getColorFromConfig('titleColor', OsmeaColors.black),
                ),
              ),
              // See all button
              GestureDetector(
                onTap: () {
                  context.push('/products');
                },
                child: OsmeaComponents.text(
                  context.t.homeView.widgets.recommended.seeAll,
                  textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                    fontSize:
                        context.fontSizeExtraSmallMedium *
                        context.textScaleFactor,
                    fontWeight: FontWeight.w500,
                    color: _getColorFromConfig('seeAllColor', OsmeaColors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        OsmeaComponents.sizedBox(height: _getTitleSpacing()),
        // Product grid - 2 columns (no padding, spacing handled by parent)
        OsmeaComponents.padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Wrap(
            spacing: context.spacing16,
            runSpacing: context.height16,
            children: recommendedProducts.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              // Use RepaintBoundary to isolate each card and prevent unnecessary repaints
              return RepaintBoundary(
                child: StaggeredAnimation(
                  index: index,
                  child: SizedBox(
                    width:
                        (context.allWidth -
                            (horizontalPadding * 2) -
                            context.spacing16) /
                        2,
                    child: Builder(
                      builder: (context) {
                        final productId = product.id ?? 0;
                        final wishlistVm = GetIt.I<WishlistViewModel>();
                        final isSaved = wishlistVm.isSaved(productId);

                        return ProductCardWidget(
                          product: product,
                          isSaved: isSaved,
                          badges: {
                            if (index == 0) ProductCardBadge.weekStar,
                          },
                          onWishlistTap: () async {
                            await viewModel.addProductToWishlist(productId);
                          },
                          onAddToCart: () async {
                            await addToCartFromProductCard(
                              context,
                              productId: productId,
                            );
                          },
                          onTap: () {
                            viewModel.selectProduct(product);
                            context.push('/product-detail/$productId');
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

}
