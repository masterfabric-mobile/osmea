import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
// Single source of truth: WishlistViewModel

class WishlistView
    extends MasterViewHydratedCubit<WishlistViewModel, WishlistState> {
  WishlistView({
    super.key,
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    super.backgroundColor = OsmeaColors.white,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
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
                Icons.error_outline,
                size: 44,
                color: OsmeaColors.pewter,
              ),
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.text(
              'Unable to Load Saved Items',
              textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                fontWeight: FontWeight.w700,
                color: OsmeaColors.thunder,
              ),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing8),
            OsmeaComponents.text(
          state.message,
              textStyle: OsmeaTextStyle.bodyMedium(
                context,
              ).copyWith(color: OsmeaColors.pewter),
              textAlign: TextAlign.center,
            ),
            OsmeaComponents.sizedBox(height: context.spacing16),
            OsmeaComponents.button(
              text: 'Try Again',
              variant: ButtonVariant.primary,
              onPressed: () => viewModel.syncFromServer(),
            ),
          ],
        ),
      );
    }

    if (state is WishlistSuccessState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.snackbarSuccess(state.message);
      });
      return _buildList(context, viewModel, state.previousState.items);
    }

    if (state is WishlistActionPromptState) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await OsmeaComponents.showPopup(
          context: context,
          variant: PopupVariant.dialog,
          title: 'Add to cart?',
          subtitle: 'Choose what to do with this saved item.',
          padding: EdgeInsets.all(context.spacing16),
          child: OsmeaComponents.column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.row(
                children: [
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.button(
                      text: 'Add & keep saved',
                      variant: ButtonVariant.primary,
                      onPressed: () {
                        Navigator.of(context).pop();
                        viewModel.addItemToCartFromWishlist(state.item.id);
                      },
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              OsmeaComponents.row(
                children: [
                  OsmeaComponents.expanded(
                    child: OsmeaComponents.button(
                      text: 'Add & remove from saved',
                      variant: ButtonVariant.secondary,
                      onPressed: () {
                        Navigator.of(context).pop();
                        viewModel.addItemToCartFromWishlist(state.item.id);
                        viewModel.remove(state.item.id);
                      },
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              OsmeaComponents.button(
                text: 'Cancel',
                variant: ButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        viewModel.restorePrevious(state.previousState);
      });
      return _buildList(context, viewModel, state.previousState.items);
    }

    final items = state is WishlistLoadedState
        ? state.items
        : const <WishlistItem>[];
    return _buildList(context, viewModel, items);
  }

  Widget _buildList(
    BuildContext context,
    WishlistViewModel viewModel,
    List<WishlistItem> items,
  ) {
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
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing12,
        vertical: context.spacing10,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return OsmeaComponents.container(
          padding: EdgeInsets.all(context.spacing10),
          decoration: BoxDecoration(
            color: OsmeaColors.white,
            borderRadius: BorderRadius.circular(context.radiusNormal),
            border: Border.all(
              color: OsmeaColors.silver.withValues(alpha: 0.3),
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
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 56,
                        height: 56,
                        color: OsmeaColors.pewter.withValues(alpha: 0.06),
                        child: Icon(
                          Icons.image_outlined,
                          color: OsmeaColors.pewter,
                        ),
                      ),
              ),
              OsmeaComponents.sizedBox(width: context.spacing10),

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
                width: 76,
                child: OsmeaComponents.row(
                  mainAxisAlignment: context.spaceBetween,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: OsmeaComponents.iconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: OsmeaColors.nordicBlue,
                        ),
                        variant: ButtonVariant.ghost,
                        backgroundColor: OsmeaColors.nordicBlue.withValues(
                          alpha: 0.08,
                        ),
                        onPressed: () => viewModel.promptAddToCartOptions(item),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: OsmeaComponents.iconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: OsmeaColors.nordicBlue,
                        ),
                        variant: ButtonVariant.ghost,
                        backgroundColor: OsmeaColors.nordicBlue.withValues(
                          alpha: 0.08,
                        ),
                        onPressed: () {
                          // Remove from wishlist
                          viewModel.remove(item.id);
                          // Show red snackbar with Undo to re-add
                          context.showSnackbar(
                            title: 'Removed from favorites',
                            message: 'Item was removed from your favorites',
                            type: SnackbarType.error,
                            style: SnackbarStyle.minimal,
                            position: SnackbarPosition.bottom,
                            animation: SnackbarAnimation.slide,
                            actionLabel: 'Undo',
                            onAction: () => viewModel.toggle(item),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => OsmeaComponents.padding(
        padding: EdgeInsets.symmetric(horizontal: context.spacing12),
        child: OsmeaComponents.divider(
          color: OsmeaColors.silver.withValues(alpha: 0.2),
        ),
      ),
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