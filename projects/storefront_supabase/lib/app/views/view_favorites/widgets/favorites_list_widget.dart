import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/views/view_favorites/models/view_model.dart';
import 'package:storefront_supabase/app/views/view_favorites/widgets/favorites_item_widget.dart';

/// Woo-style favorites list: scroll view with optional top section, then item rows and dividers.
class FavoritesListWidget extends StatelessWidget {
  final List<Product> items;
  final FavoritesViewModel viewModel;
  final void Function(String path) goRoute;
  final Widget? topSection;

  const FavoritesListWidget({
    super.key,
    required this.items,
    required this.viewModel,
    required this.goRoute,
    this.topSection,
  });

  @override
  Widget build(BuildContext context) {
    final configHelper = AssetConfigHelper();
    final horizontalPadding = configHelper.getDouble(
      'favorites_view.component_spacing.horizontal',
      context.spacing12,
    );
    final verticalPadding = configHelper.getDouble(
      'favorites_view.component_spacing.vertical',
      context.spacing8,
    );
    final dividerColor = configHelper.getColor(
      'favorites_view.divider.color',
      OsmeaColors.silver,
    );
    final dividerHeight = configHelper.getDouble(
      'favorites_view.divider.height',
      context.height1,
    );

    final bottomPadding = MediaQuery.of(context).padding.bottom + 56 + 24;
    // Woo-style: SingleChildScrollView + Column so whole page scrolls, no overflow
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: verticalPadding,
        bottom: bottomPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topSection != null) ...[
            topSection!,
            OsmeaComponents.sizedBox(height: context.spacing12),
            OsmeaComponents.divider(color: dividerColor, height: dividerHeight),
            OsmeaComponents.sizedBox(height: context.spacing12),
          ],
          ...List.generate(items.length, (i) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FavoritesItemWidget(
                  product: items[i],
                  viewModel: viewModel,
                  goRoute: goRoute,
                ),
                if (i < items.length - 1)
                  OsmeaComponents.divider(
                    color: dividerColor,
                    height: dividerHeight,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
