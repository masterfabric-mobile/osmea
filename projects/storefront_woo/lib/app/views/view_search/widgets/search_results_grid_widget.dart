import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/widgets/product_card_widget.dart';
import 'package:storefront_woo/app/views/view_home/models/home_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';

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
        children: products.map((product) {
          final productId = product.id ?? 0;

          // Use BlocBuilder to reactively listen to WishlistViewModel changes
          return BlocBuilder<WishlistViewModel, WishlistState>(
            bloc: GetIt.I<WishlistViewModel>(),
            buildWhen: (previous, current) {
              // Always rebuild when transitioning to LoadedState from any other state
              if (previous is! WishlistLoadedState &&
                  current is WishlistLoadedState) {
                return true; // State just loaded, rebuild to show saved status
              }
              // Rebuild when state changes between Loaded states (item added/removed)
              if (previous is WishlistLoadedState &&
                  current is WishlistLoadedState) {
                final prevSaved = previous.items.any((e) => e.id == productId);
                final currSaved = current.items.any((e) => e.id == productId);
                return prevSaved != currSaved;
              }
              // Also rebuild if previous was LoadedState and current is not (shouldn't happen, but safe)
              if (previous is WishlistLoadedState &&
                  current is! WishlistLoadedState) {
                return true;
              }
              return false; // Don't rebuild for other state changes
            },
            builder: (context, wishlistState) {
              final wishlistVm = GetIt.I<WishlistViewModel>();
              // Always check current state, even if it's not LoadedState yet
              final isSaved = wishlistVm.isSaved(productId);

              return SizedBox(
                width: (MediaQuery.of(context).size.width - 55) / 2,
                child: ProductCardWidget(
                  product: product,
                  isSaved: isSaved,
                  onWishlistTap: () {
                    // Use shared HomeViewModel for wishlist to keep messages/state in sync
                    GetIt.I<HomeViewModel>().addProductToWishlist(productId);
                  },
                  onTap: () =>
                      context.push('/product-detail/${product.id ?? 0}'),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
