import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
// Animation helpers are now imported from core

class SearchResultsGridWidget extends StatelessWidget {
  final List<dynamic> products;

  const SearchResultsGridWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    // Use Wrap widget exactly like Recommended section for same spacing behavior
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        context.spacing20,
        context.height16,
        context.spacing20,
        0,
      ), // Same padding as Recommended section
      child: Wrap(
        spacing: 15, // Same as Recommended section horizontal spacing
        runSpacing: 16, // Same as Recommended section vertical spacing
        children: products.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          final productId = product.id ?? 0;

          // Direct check without BlocBuilder to prevent blocking
          final wishlistVm = GetIt.I<WishlistViewModel>();
          final isSaved = wishlistVm.isSaved(productId);

          return StaggeredAnimation(
            index: index,
            child: SizedBox(
              width: (MediaQuery.of(context).size.width - 55) / 2,
              child: ProductCardWidget(
                product: product,
                isSaved: isSaved,
                onWishlistTap: () {
                  // Use shared HomeViewModel for wishlist to keep messages/state in sync
                  GetIt.I<HomeViewModel>().addProductToWishlist(productId);
                },
                onTap: () => context.push('/product-detail/${product.id ?? 0}'),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
