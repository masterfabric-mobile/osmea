import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_error_widget.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_list_widget.dart';
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
    // Handle initial state - show loading or trigger initial load
    if (state is WishlistInitialState) {
      // Trigger initial load if not already loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.initial();
      });
      return const Center(child: CircularProgressIndicator());
    }

    if (state is WishlistLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is WishlistErrorState) {
      return WishlistErrorWidget(message: state.message, viewModel: viewModel);
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
