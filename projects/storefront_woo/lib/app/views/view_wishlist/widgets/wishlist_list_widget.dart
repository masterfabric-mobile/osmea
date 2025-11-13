import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_empty_widget.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_item_widget.dart';

class WishlistListWidget extends StatelessWidget {
  final List<WishlistItem> items;
  final WishlistViewModel viewModel;

  const WishlistListWidget({
    super.key,
    required this.items,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const WishlistEmptyWidget();
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing16,
        vertical: context.spacing12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return WishlistItemWidget(
          item: item,
          viewModel: viewModel,
        );
      },
      separatorBuilder: (_, __) => OsmeaComponents.divider(),
      itemCount: items.length,
    );
  }
}




