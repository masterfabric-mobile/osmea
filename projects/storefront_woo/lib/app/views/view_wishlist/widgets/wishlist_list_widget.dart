import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
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
      // Navigate to empty view route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/empty/wishlist?actionPath=/home');
      });
      // Return empty container while navigating
      return const SizedBox.shrink();
    }

    return OsmeaComponents.singleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing8,
      ),
      child: OsmeaComponents.column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            WishlistItemWidget(item: items[i], viewModel: viewModel),
            if (i < items.length - 1)
              OsmeaComponents.divider(
                color: OsmeaColors.platinum,
                height: context.height1,
              ),
          ],
        ],
      ),
    );
  }
}
