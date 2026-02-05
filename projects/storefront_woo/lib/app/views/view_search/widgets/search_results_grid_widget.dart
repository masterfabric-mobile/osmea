import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/utils/cart_add_helper.dart';
// Animation helpers are now imported from core

class SearchResultsGridWidget extends StatefulWidget {
  final List<dynamic> products;

  const SearchResultsGridWidget({super.key, required this.products});

  @override
  State<SearchResultsGridWidget> createState() => _SearchResultsGridWidgetState();
}

class _SearchResultsGridWidgetState extends State<SearchResultsGridWidget> {
  static const int _columnCount = 2; // Fixed to 2 columns

  @override
  Widget build(BuildContext context) {
    // Calculate item width based on column count
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = context.spacing20 * 2;
    final spacing = 15.0;
    final totalSpacing = spacing * (_columnCount - 1);
    final itemWidth = (screenWidth - horizontalPadding - totalSpacing) / _columnCount;

    return Column(
      children: [
        // Product grid with Wrap for proper alignment
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              context.spacing20,
              0,
              context.spacing20,
              context.height16,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: spacing,
                runSpacing: 16,
                alignment: WrapAlignment.start,
                children: widget.products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final productId = product.id ?? 0;

                  // Direct check without BlocBuilder to prevent blocking
                  final wishlistVm = GetIt.I<WishlistViewModel>();
                  final isSaved = wishlistVm.isSaved(productId);

                  return StaggeredAnimation(
                    index: index,
                    child: SizedBox(
                      width: itemWidth,
                      child: ProductCardWidget(
                        product: product,
                        isSaved: isSaved,
                        onWishlistTap: () {
                          // Use shared HomeViewModel for wishlist to keep messages/state in sync
                          GetIt.I<HomeViewModel>().addProductToWishlist(productId);
                        },
                        onAddToCart: () async {
                          await addToCartFromProductCard(
                            context,
                            productId: productId,
                          );
                        },
                        onTap: () => context.push('/product-detail/${product.id ?? 0}'),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
