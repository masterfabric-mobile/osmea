import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_list_widget.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
// Single source of truth: WishlistViewModel

class WishlistView
    extends MasterViewHydratedCubit<WishlistViewModel, WishlistState> {
  WishlistView({
    super.key,
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),

    required super.goRoute,
    Map<String, dynamic>? arguments,
  }) : super(
         arguments: arguments ?? const {'saved': true},
         coreAppBar: (context, cubit) => PreferredSize(
           preferredSize: Size.fromHeight(kToolbarHeight),
           child: BlocBuilder<WishlistViewModel, WishlistState>(
             bloc: cubit,
             builder: (context, state) {
               final count = state is WishlistLoadedState ? state.items.length : 0;
               final hasItems = count > 0;
               
               return OsmeaComponents.appBar(
                 title: OsmeaComponents.text(
                   count > 0 ? 'Favourites ($count)' : 'Favourites',
                   variant: OsmeaTextVariant.headlineMedium,
                   color: OsmeaColors.black,
                   fontWeight: FontWeight.w600,
                 ),
                 backgroundColor: OsmeaColors.white,
                 foregroundColor: OsmeaColors.black,
                 elevation: 0,
                 surfaceTintColor: OsmeaColors.transparent,
                 shadowColor: OsmeaColors.transparent,
                 leading: OsmeaComponents.iconButton(
                   icon: Icon(Icons.arrow_back_ios_new, color: OsmeaColors.black),
                   onPressed: () {
                     if (context.canPop()) {
                       context.pop();
                     } else {
                       context.go('/home');
                     }
                   },
                   backgroundColor: OsmeaColors.transparent,
                 ),
                 actions: [
                   AppBarAction(
                     icon: Icon(Icons.category_outlined, color: OsmeaColors.black),
                     onPressed: () {
                       context.push('/favorite-categories');
                     },
                     tooltip: 'Favorite Categories',
                   ),
                   if (hasItems)
                     AppBarAction(
                       icon: Icon(Icons.delete_outline, color: OsmeaColors.black),
                       onPressed: () async {
                             final confirmed = await OsmeaComponents.showPopup<bool>(
                               context: context,
                               variant: PopupVariant.dialog,
                               title: 'Remove all favorites?',
                               subtitle:
                                   'Are you sure you want to remove all items from your favorites? This action cannot be undone.',
                               padding: context.paddingNormal,
                               child: OsmeaComponents.column(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   OsmeaComponents.row(
                                     children: [
                                       OsmeaComponents.expanded(
                                         child: OsmeaComponents.button(
                                           text: 'Cancel',
                                           variant: ButtonVariant.outlined,
                                           onPressed: () =>
                                               Navigator.of(context).pop(false),
                                         ),
                                       ),
                                       OsmeaComponents.sizedBox(width: context.spacing8),
                                       OsmeaComponents.expanded(
                                         child: OsmeaComponents.button(
                                           text: 'Remove All',
                                           variant: ButtonVariant.primary,
                                           onPressed: () =>
                                               Navigator.of(context).pop(true),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ],
                               ),
                             );
                             
                             if (confirmed == true) {
                               final previousState = state is WishlistLoadedState
                                   ? state
                                   : null;
                               final previousItems = previousState?.items ?? [];
                               
                               cubit.clearAll();
                               
                               if (previousItems.isNotEmpty) {
                                 context.showSnackbar(
                                   title: 'All favorites removed',
                                   message: 'All items were removed from your favorites',
                                   type: SnackbarType.error,
                                   style: SnackbarStyle.minimal,
                                   position: SnackbarPosition.bottom,
                                   animation: SnackbarAnimation.slide,
                                   actionLabel: 'Undo',
                                   onAction: () {
                                     // Restore all items
                                     for (final item in previousItems) {
                                       cubit.add(item);
                                     }
                                   },
                                 );
                               }
                             }
                           },
                           tooltip: 'Remove all',
                         ),
                 ],
                 centerTitle: false,
               );
             },
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
    // Handle initial state - show loading or trigger initial load
    if (state is WishlistInitialState) {
      // Trigger initial load if not already loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.initial();
      });
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is WishlistLoadingState) {
      return UnifiedLoadingWidget(goRoute: goRoute);
    }

    if (state is WishlistErrorState) {
      return buildError(
        state.message,
        onRetry: () => viewModel.syncFromServer(),
      );
    }

    if (state is WishlistSuccessState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.snackbarSuccess(state.message);
      });
      return WishlistListWidget(
        items: state.previousState.items,
        viewModel: viewModel,
      );
    }

    if (state is WishlistActionPromptState) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final result = await OsmeaComponents.showPopup(
          context: context,
          variant: PopupVariant.dialog,
          title: 'Add to cart?',
          subtitle: 'Choose what to do with this saved item.',
          padding: context.paddingNormal,
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
                        Navigator.of(context).pop('add_keep');
                        // addItemToCartFromWishlist will preserve the wishlist state
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
                        Navigator.of(context).pop('add_remove');
                        viewModel.addItemToCartAndRemoveFromWishlist(state.item.id);
                      },
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              OsmeaComponents.button(
                text: 'Cancel',
                variant: ButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop('cancel'),
              ),
            ],
          ),
        );
        // Only restore previous state if user cancelled (not if they added to cart)
        if (result == 'cancel' || result == null) {
          viewModel.restorePrevious(state.previousState);
        }
      });
      return WishlistListWidget(
        items: state.previousState.items,
        viewModel: viewModel,
      );
    }

    // Handle WishlistLoadedState - this is the main state for displaying items
    if (state is WishlistLoadedState) {
      debugPrint('💖 WishlistView: Rendering ${state.items.length} items');
      return WishlistListWidget(items: state.items, viewModel: viewModel);
    }

    // Fallback: if state is not recognized, show empty list
    debugPrint('⚠️ WishlistView: Unknown state type: ${state.runtimeType}');
    debugPrint('⚠️ WishlistView: State details: $state');
    return WishlistListWidget(
      items: const <WishlistItem>[],
      viewModel: viewModel,
    );
  }
}
