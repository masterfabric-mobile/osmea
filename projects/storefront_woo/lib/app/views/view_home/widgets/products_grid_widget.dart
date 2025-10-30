/*
 * ProductsGridWidget
 * -----------------
 * Products grid widget for home view.
 * Displays products in a responsive grid using OSMEA Sizer helpers.
 */

import 'package:flutter/material.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_home/models/module/states.dart';
import 'package:storefront_woo/app/views/view_home/widgets/product_card_widget.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/product_detail_view.dart';

/// Products grid widget
class ProductsGridWidget extends StatelessWidget {
  final HomeLoadedState state;
  final HomeViewModel viewModel;
  final bool embedded; // if true, grid is shrink-wrapped and non-scrollable

  const ProductsGridWidget({
    super.key,
    required this.state,
    required this.viewModel,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    if (state.products.isEmpty) {
      return OsmeaComponents.center(
        child: OsmeaComponents.column(
          mainAxisAlignment: context.centerMain,
          children: [
            Icon(
              Icons.search_off,
              size: context.iconSizeExtraHigh,
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              'No products found',
              textStyle: OsmeaTextStyle.titleMedium(context),
              color: OsmeaColors.pewter,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              'Try adjusting your search or filters',
              textStyle: OsmeaTextStyle.bodyMedium(context),
              color: OsmeaColors.pewter,
            ),
          ],
        ),
      );
    }

    // Responsive grid using OSMEA Sizer helpers
    final bool isTablet = context.allWidth >= 768;
    final int crossAxisCount = isTablet ? 3 : 2;
    // Optimized aspect ratio to prevent overflow - more vertical space
    final double childAspectRatio = isTablet ? 0.68 : 0.58;
    final double crossAxisSpacing = context.spacing12;
    final double mainAxisSpacing = context.spacing12;

    final grid = GridView.builder(
      padding: context.paddingNormal,
      physics: embedded ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: embedded,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        final product = state.products[index];
        return ProductCardWidget(
          product: product,
          onWishlistTap: () {
            // Delegate to HomeViewModel which uses WishlistCubit
            viewModel.addProductToWishlist(product.id ?? 0);
          },
          onTap: () => _navigateToProductDetail(context, viewModel, product),
        );
      },
    );

    if (embedded) return grid;

    return RefreshIndicator(
      onRefresh: () async => viewModel.refreshProducts(),
      child: grid,
    );
  }

  void _navigateToProductDetail(
    BuildContext context,
    HomeViewModel viewModel,
    ListAllProductsResponseModel product,
  ) {
    // Select the product in the view model to store it
    viewModel.selectProduct(product);

    // Navigate to product detail view
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailView(
          productId: product.id ?? 0,
          arguments: const {'productDetail': true},
          goRoute: (path) {
            if (path.contains('home')) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}
