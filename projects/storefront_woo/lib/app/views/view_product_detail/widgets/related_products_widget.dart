/*
 * Related Products Widget
 * -----------------------
 * Widget for displaying related products section at the bottom of product detail
 * Shows "Buna Bakanlar Buna da Baktı" (People who viewed this also viewed) style products
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/freezed_model/response/list_all_products_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_api/abstract/product_service.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';

/// Related products widget
class RelatedProductsWidget extends StatefulWidget {
  final int currentProductId;
  final Function(String path) goRoute;

  const RelatedProductsWidget({
    super.key,
    required this.currentProductId,
    required this.goRoute,
  });

  @override
  State<RelatedProductsWidget> createState() => _RelatedProductsWidgetState();
}

class _RelatedProductsWidgetState extends State<RelatedProductsWidget> {
  List<ListAllProductsResponseModel> _relatedProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRelatedProducts();
  }

  Future<void> _loadRelatedProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final productService = GetIt.I<ProductService>();
      final configHelper = AssetConfigHelper();
      final apiVersion = configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Load random products (excluding current product)
      final allProducts = await productService.listAllProducts(
        apiVersion: apiVersion,
        page: 1,
        perPage: 20,
        status: 'publish',
        stockStatus: 'instock',
      );

      // Filter out current product and get random 4 products
      final filteredProducts = allProducts
          .where((p) => p.id != widget.currentProductId)
          .toList()
        ..shuffle();

      setState(() {
        _relatedProducts = filteredProducts.take(4).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('⚠️ Failed to load related products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return OsmeaComponents.padding(
        padding: EdgeInsets.symmetric(horizontal: context.spacing16),
        child: OsmeaComponents.sizedBox(
          height: context.height160 + context.spacing10 + context.height80,
        ),
      );
    }

    if (_relatedProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return OsmeaComponents.padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing16),
      child: OsmeaComponents.column(
        crossAxisAlignment: context.crossStart,
        children: [
          OsmeaComponents.sizedBox(height: context.spacing16),
          // Section title - Related Products / People Also Viewed
          OsmeaComponents.text(
            'Related Products',
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.w700,
              color: OsmeaColors.black,
              letterSpacing: -0.3,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            'People Also Viewed',
            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
              fontWeight: FontWeight.w400,
              color: OsmeaColors.grayMaterial[500] ?? OsmeaColors.pewter,
              letterSpacing: 0,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          // Horizontal scrollable products
          SizedBox(
            height: context.height160 + context.spacing10 + context.height80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _relatedProducts.length,
              itemBuilder: (context, index) {
                final product = _relatedProducts[index];
                final productId = product.id ?? 0;
                
                // Direct check without BlocBuilder to prevent blocking
                final wishlistVm = GetIt.I<WishlistViewModel>();
                final isSaved = wishlistVm.isSaved(productId);
                
                return OsmeaComponents.container(
                  margin: EdgeInsets.only(
                    right: index < _relatedProducts.length - 1
                        ? context.spacing12
                        : 0,
                  ),
                  width: (context.allWidth - (context.spacing16 * 2) - context.spacing12) / 2,
                  child: StaggeredAnimation(
                    index: index,
                    child: ProductCardWidget(
                      product: product,
                      isSaved: isSaved,
                      onWishlistTap: () async {
                        final item = WishlistItem(
                          id: productId,
                          name: product.name,
                          imageUrl: (product.images?.isNotEmpty ?? false)
                              ? product.images!.first.src
                              : null,
                          regularPrice: product.prices?.regularPrice,
                          salePrice: product.prices?.salePrice,
                          currencyCode: product.prices?.currencyCode,
                          currencyDecimalSeparator: product.prices?.currencyDecimalSeparator,
                          currencyThousandSeparator: product.prices?.currencyThousandSeparator,
                          currencyMinorUnit: product.prices?.currencyMinorUnit,
                          onSale: product.onSale == true,
                        );
                        await wishlistVm.toggle(item);
                      },
                      onTap: () {
                        // Navigate to product detail - use push to stay in navigation stack
                        context.push('/product-detail/$productId');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
        ],
      ),
    );
  }
}
