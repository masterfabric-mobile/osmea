/*
 * SearchResultsGridWidget (Supabase)
 * -----------------------------------
 * Grid of product cards for search results. Same UI as storefront_woo.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/widgets/product_card_widget.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/favorites_view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/module/states.dart';
import 'package:storefront_supabase/app/views/view_product_detail/widgets/add_to_cart_popup.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchResultsGridWidget extends StatelessWidget {
  final List<dynamic> products;

  const SearchResultsGridWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    const int columnCount = 2;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = context.spacing20 * 2;
    const spacing = 15.0;
    final totalSpacing = spacing * (columnCount - 1);
    final itemWidth =
        (screenWidth - horizontalPadding - totalSpacing) / columnCount;

    final productList = products.whereType<Product>().toList();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        context.spacing20,
        0,
        context.spacing20,
        context.spacing16,
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: spacing,
          runSpacing: 16,
          alignment: WrapAlignment.start,
          children: productList.map((product) {
            final productId = product.id;
            final favVm = GetIt.I<FavoritesViewModel>();
            bool isSaved = false;
            if (favVm.state is FavoritesLoadedState) {
              isSaved = (favVm.state as FavoritesLoadedState)
                  .favoriteProducts
                  .any((p) => p.id == productId);
            }

            return SizedBox(
              width: itemWidth,
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
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
