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
    // Load wishlist items from server (or local storage if not authenticated)
    viewModel.initial();
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
        horizontal: context.spacing16,
        vertical: context.spacing12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key('wishlist_item_${item.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: context.spacing20),
            decoration: BoxDecoration(
              color: OsmeaColors.red,
              borderRadius: BorderRadius.circular(context.radiusNormal),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.delete_outline,
                  color: OsmeaColors.white,
                  size: 24,
                ),
                SizedBox(width: context.spacing8),
                Text(
                  'Remove',
                  style: OsmeaTextStyle.bodyMedium(context).copyWith(
                    color: OsmeaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (direction) async {
            // Show confirmation dialog
            return await showDialog<bool>(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text('Remove from favorites?'),
                  content: Text('Are you sure you want to remove this item from your favorites?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: TextButton.styleFrom(
                        foregroundColor: OsmeaColors.red,
                      ),
                      child: Text('Remove'),
                    ),
                  ],
                );
              },
            ) ?? false;
          },
          onDismissed: (direction) {
            // Remove from wishlist
            viewModel.remove(item.id);
            // Show snackbar with Undo
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
          child: Container(
          padding: EdgeInsets.all(context.spacing12),
          decoration: BoxDecoration(
            color: OsmeaColors.white,
            borderRadius: BorderRadius.circular(context.radiusNormal),
            border: Border.all(
              color: OsmeaColors.silver.withOpacity(0.3),
              width: 1,
            ),
            // No shadow - removed as requested
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image - larger and better styled
              ClipRRect(
                borderRadius: BorderRadius.circular(context.radiusLow),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                        item.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: OsmeaColors.pewter.withOpacity(0.1),
                            child: Icon(
                              Icons.image_outlined,
                              color: OsmeaColors.pewter,
                              size: 32,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 80,
                            height: 80,
                            color: OsmeaColors.pewter.withOpacity(0.1),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                OsmeaColors.nordicBlue,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: OsmeaColors.pewter.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(context.radiusLow),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          color: OsmeaColors.pewter,
                          size: 32,
                        ),
                      ),
              ),
              SizedBox(width: context.spacing12),

              // Title + price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name ?? 'Product',
                      style: OsmeaTextStyle.titleSmall(context).copyWith(
                        color: OsmeaColors.thunder,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.spacing6),
                    _buildSubtitle(context, item),
                  ],
                ),
              ),

              SizedBox(width: context.spacing8),

              // Actions - better styled
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cart button - square corners
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: OsmeaColors.nordicBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4), // Square corners
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        size: 18,
                        color: OsmeaColors.nordicBlue,
                      ),
                      onPressed: () => viewModel.promptAddToCartOptions(item),
                    ),
                  ),
                  SizedBox(width: context.spacing8),
                  // Favorite button - always filled and blue in wishlist, square corners
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: OsmeaColors.nordicBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4), // Square corners
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.favorite,
                        size: 18,
                        color: OsmeaColors.nordicBlue,
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
            ],
          ),
        ),
        );
      },
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 1,
        color: OsmeaColors.silver.withOpacity(0.3),
        indent: context.spacing16,
        endIndent: context.spacing16,
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
            _formatPrice(item.salePrice, item.currencyCode),
            style: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.nordicBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: context.spacing6),
          Text(
            _formatPrice(item.regularPrice, item.currencyCode),
            style: OsmeaTextStyle.bodySmall(context).copyWith(
              color: OsmeaColors.pewter,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
    }

    return Text(
      _formatPrice(item.regularPrice, item.currencyCode),
      style: OsmeaTextStyle.bodyMedium(
        context,
      ).copyWith(color: OsmeaColors.thunder, fontWeight: FontWeight.w600),
    );
  }

  /// Formats price using PriceInfoCurrencyHelper
  String _formatPrice(String? priceString, String? currencyCode) {
    if (priceString == null || priceString.isEmpty) {
      return PriceInfoCurrencyHelper.getDefaultPrice();
    }

    // Clean price string (remove currency symbols, spaces, etc.)
    final cleanPrice = priceString.replaceAll(RegExp(r'[^\d.,]'), '');
    final parsedPrice = double.tryParse(cleanPrice) ?? 0.0;

    return PriceInfoCurrencyHelper.formatPrice(
      parsedPrice,
      currencyCode: currencyCode,
      decimalPlaces: 2,
    );
  }
}