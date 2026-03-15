/*
 * Related Products Widget
 * -----------------------
 * Widget for displaying related products section at the bottom of product detail
 * Shows "Buna Bakanlar Buna da Baktı" (People who viewed this also viewed) style products
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/widgets/product_card_widget.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/favorites_view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/module/states.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Related products widget
class RelatedProductsWidget extends StatefulWidget {
  final String currentProductId;
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
  List<Product> _relatedProducts = [];
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

      final supabaseClient = Supabase.instance.client;

      // Load random products (excluding current product)
      // Since Supabase doesn't have random function easily exposed via API, 
      // we'll fetch latest products and shuffle client side for now.
      final response = await supabaseClient
          .from('products')
          .select('*, product_images(image_url, is_primary, sort_order)')
          .eq('is_active', true)
          .limit(20);

      final allProducts = (response as List)
          .map((data) => Product.fromJson(data as Map<String, dynamic>))
          .toList();

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
            context.resources.relatedProducts,
            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
              fontWeight: FontWeight.w700,
              color: OsmeaColors.black,
              letterSpacing: -0.3,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing4),
          OsmeaComponents.text(
            context.resources.peopleAlsoViewed,
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
                final productId = product.id;
                return BlocBuilder<FavoritesViewModel, FavoritesState>(
                  bloc: GetIt.I<FavoritesViewModel>(),
                  builder: (context, favState) {
                    bool isSaved = false;
                    if (favState is FavoritesLoadedState) {
                      isSaved = (favState).favoriteProducts.any((p) => p.id == productId);
                    }
                    final wishlistVm = GetIt.I<FavoritesViewModel>();
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
                                ? await wishlistVm.removeFavorite(productId)
                                : await wishlistVm.addFavorite(
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
                            // Add to cart
                          },
                          onTap: () {
                            context.push('/product-detail/$productId');
                          },
                        ),
                      ),
                    );
                  },
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
