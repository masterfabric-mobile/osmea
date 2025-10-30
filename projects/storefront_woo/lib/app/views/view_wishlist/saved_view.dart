import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
// Single source of truth: WishlistViewModel
import 'package:get_it/get_it.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';

class WishlistView
    extends MasterViewHydratedCubit<WishlistViewModel, WishlistState> {
  WishlistView({
    super.key,
    required super.goRoute,
    Map<String, dynamic>? arguments,
  }) : super(
         arguments: arguments ?? const {'saved': true},
         coreAppBar: (context, cubit) => PreferredSize(
           preferredSize: Size.fromHeight(kToolbarHeight),
           child: OsmeaComponents.appBar(
             title: OsmeaComponents.text(
               'Favourites',
               variant: OsmeaTextVariant.headlineMedium,
               color: OsmeaColors.black,
               fontWeight: FontWeight.w600,
             ),
             backgroundColor: OsmeaColors.white,
             foregroundColor: OsmeaColors.black,
             elevation: 0,
             surfaceTintColor: OsmeaColors.transparent,
             shadowColor: OsmeaColors.transparent,
             leading: IconButton(
               icon: Icon(Icons.arrow_back_ios_new, color: OsmeaColors.black),
               onPressed: () => Navigator.of(context).maybePop(),
             ),
             centerTitle: false,
           ),
         ),
       );

  @override
  void initialContent(WishlistViewModel viewModel, BuildContext context) {
    // Pass widget-level arguments to ViewModel for consistency with other views
    viewModel.setArguments(arguments);
    viewModel.syncFromServer();
  }

  @override
  Widget viewContent(
    BuildContext context,
    WishlistViewModel viewModel,
    WishlistState state,
  ) {
    if (state is WishlistLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is WishlistErrorState) {
      return Center(
        child: OsmeaComponents.text(
          state.message,
          textStyle: OsmeaTextStyle.bodyMedium(context),
        ),
      );
    }

    final items = state is WishlistLoadedState
        ? state.items
        : const <WishlistItem>[];
    if (items.isEmpty) {
      return Center(
        child: OsmeaComponents.column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OsmeaComponents.container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: OsmeaColors.pewter.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 44,
                color: OsmeaColors.pewter,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              'No Saved Items!',
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.w700,
                color: OsmeaColors.thunder,
              ),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
              "You don't have any saved items.\nGo to home and add some.",
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(color: OsmeaColors.pewter),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.button(
              text: 'Browse products',
              variant: ButtonVariant.primary,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(context.spacing16),
      itemBuilder: (context, index) {
        final item = items[index];
        return OsmeaComponents.container(
          padding: EdgeInsets.all(context.spacing12),
          decoration: BoxDecoration(
            color: OsmeaColors.white,
            borderRadius: BorderRadius.circular(context.radiusNormal),
            border: Border.all(
              color: OsmeaColors.silver.withOpacity(0.5),
              width: context.borderWidth,
            ),
          ),
          child: OsmeaComponents.row(
            crossAxisAlignment: context.crossCenter,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(context.radiusLow),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 64,
                        height: 64,
                        color: OsmeaColors.pewter.withOpacity(0.06),
                        child: Icon(
                          Icons.image_outlined,
                          color: OsmeaColors.pewter,
                        ),
                      ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing12),

              // Title + price
              OsmeaComponents.expanded(
                child: OsmeaComponents.column(
                  crossAxisAlignment: context.crossStart,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OsmeaComponents.text(
                      item.name ?? 'Product',
                      textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                        color: OsmeaColors.thunder,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    OsmeaComponents.sizedBox(height: context.spacing6),
                    _buildSubtitle(context, item),
                  ],
                ),
              ),

              OsmeaComponents.sizedBox(width: context.spacing8),

              // Actions - tighter width to avoid row overflow on small screens
              SizedBox(
                width: 80,
                child: OsmeaComponents.row(
                  mainAxisAlignment: context.spaceBetween,
                  children: [
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: OsmeaComponents.iconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: OsmeaColors.nordicBlue,
                        ),
                        variant: ButtonVariant.ghost,
                        backgroundColor: OsmeaColors.nordicBlue.withValues(
                          alpha: 0.08,
                        ),
                        onPressed: () => _addToCart(context, item.id),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: OsmeaComponents.iconButton(
                        icon: Icon(Icons.favorite, color: OsmeaColors.red),
                        variant: ButtonVariant.ghost,
                        backgroundColor: OsmeaColors.red.withValues(
                          alpha: 0.08,
                        ),
                        onPressed: () => viewModel.remove(item.id),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) =>
          OsmeaComponents.sizedBox(height: context.spacing8),
      itemCount: items.length,
    );
  }

  Widget _buildSubtitle(BuildContext context, WishlistItem item) {
    final hasSale =
        item.onSale &&
        item.salePrice != null &&
        item.salePrice!.isNotEmpty &&
        item.salePrice != item.regularPrice;

    if (hasSale) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            PriceInfoCurrencyHelper.formatPrice(
              double.tryParse(
                    item.salePrice!.replaceAll(RegExp(r'[^\d.,]'), ''),
                  ) ??
                  0,
              currencyCode: item.currencyCode,
              decimalPlaces: 2,
            ),
            style: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.nordicBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: context.spacing6),
          Text(
            PriceInfoCurrencyHelper.formatPrice(
              double.tryParse(
                    (item.regularPrice ?? '').replaceAll(
                      RegExp(r'[^\d.,]'),
                      '',
                    ),
                  ) ??
                  0,
              currencyCode: item.currencyCode,
              decimalPlaces: 2,
            ),
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    }

    return Text(
      PriceInfoCurrencyHelper.formatPrice(
        double.tryParse(
              (item.regularPrice ?? '').replaceAll(RegExp(r'[^\d.,]'), ''),
            ) ??
            0,
        currencyCode: item.currencyCode,
        decimalPlaces: 2,
      ),
      style: OsmeaTextStyle.bodyMedium(
        context,
      ).copyWith(color: OsmeaColors.thunder, fontWeight: FontWeight.w600),
    );
  }
}

extension on WishlistView {
  Future<void> _addToCart(BuildContext context, int productId) async {
    final cartVm = GetIt.I<CartViewModel>();
    cartVm.addItemToCart(productId, quantity: 1);
  }
}
