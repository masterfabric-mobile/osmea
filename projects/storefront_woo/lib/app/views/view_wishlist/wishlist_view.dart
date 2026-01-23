import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/wishlist_view_model.dart';
import 'package:storefront_woo/app/views/view_wishlist/models/module/states.dart';
import 'package:storefront_woo/app/views/view_wishlist/widgets/wishlist_list_widget.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:storefront_woo/gen/translations.g.dart';
// Single source of truth: WishlistViewModel

/// Get popup color from config
Color _getPopupColorFromConfig(String key, Color fallback) {
  try {
    final configHelper = AssetConfigHelper();
    final colorString = configHelper.getString(
      'dialog_popup_configuration.$key',
    );
    if (colorString.isNotEmpty && colorString.startsWith('#')) {
      final hexString = colorString.substring(1);
      if (hexString.length == 6) {
        return Color(int.parse('FF$hexString', radix: 16));
      } else if (hexString.length == 8) {
        return Color(int.parse(hexString, radix: 16));
      }
    }
  } catch (e) {
    debugPrint('⚠️ Failed to load popup color $key: $e');
  }
  return fallback;
}

/// Get popup button color from config
Color _getPopupButtonColorFromConfig(String key, Color fallback) {
  try {
    final configHelper = AssetConfigHelper();
    final colorString = configHelper.getString(
      'dialog_popup_configuration.buttons.$key',
    );
    if (colorString.isNotEmpty && colorString.startsWith('#')) {
      final hexString = colorString.substring(1);
      if (hexString.length == 6) {
        return Color(int.parse('FF$hexString', radix: 16));
      } else if (hexString.length == 8) {
        return Color(int.parse(hexString, radix: 16));
      }
    }
  } catch (e) {
    debugPrint('⚠️ Failed to load popup button color $key: $e');
  }
  return fallback;
}

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
         coreAppBar: (BuildContext context, WishlistViewModel cubit) => PreferredSize(
           preferredSize: Size.fromHeight(kToolbarHeight),
           child: BlocBuilder<WishlistViewModel, WishlistState>(
             bloc: cubit,
             builder: (context, state) {
               final count = state is WishlistLoadedState
                   ? state.items.length
                   : 0;
               final hasItems = count > 0;

               final configHelper = AssetConfigHelper();
               final appBarConfig = configHelper.getObject(
                 'wishlist_view.app_bar',
               );
               final title = appBarConfig?['title'] as String? ?? context.t.wishlistView.appBar.title;
               final titleWithCount =
                   appBarConfig?['titleWithCount'] as String? ??
                   context.t.wishlistView.appBar.titleWithCount;
               final appBarTitle = count > 0
                   ? titleWithCount.replaceAll('{count}', count.toString())
                   : title;
               final backgroundColor = configHelper.getColor(
                 'wishlist_view.app_bar.backgroundColor',
                 OsmeaColors.white,
               );
               final foregroundColor = configHelper.getColor(
                 'wishlist_view.app_bar.foregroundColor',
                 OsmeaColors.black,
               );
               final titleColor = configHelper.getColor(
                 'wishlist_view.app_bar.titleColor',
                 OsmeaColors.black,
               );
               final iconColor = configHelper.getColor(
                 'wishlist_view.app_bar.iconColor',
                 OsmeaColors.black,
               );
               final elevation = configHelper.getDouble(
                 'wishlist_view.app_bar.elevation',
                 0.0,
               );
               final surfaceTintColor = configHelper.getColor(
                 'wishlist_view.app_bar.surfaceTintColor',
                 OsmeaColors.transparent,
               );
               final shadowColor = configHelper.getColor(
                 'wishlist_view.app_bar.shadowColor',
                 OsmeaColors.transparent,
               );

               return OsmeaComponents.appBar(
                 title: OsmeaComponents.text(
                   appBarTitle,
                   variant: OsmeaTextVariant.headlineMedium,
                   color: titleColor,
                   fontWeight: FontWeight.w600,
                 ),
                 backgroundColor: backgroundColor,
                 foregroundColor: foregroundColor,
                 elevation: elevation,
                 surfaceTintColor: surfaceTintColor,
                 shadowColor: shadowColor,
                 leading: OsmeaComponents.iconButton(
                   icon: Icon(Icons.arrow_back, color: iconColor),
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
                   // Add collection button
                   AppBarAction(
                     icon: Icon(Icons.add, color: iconColor),
                     onPressed: () => _showCreateCollectionDialog(context, cubit),
                     tooltip: 'Create new collection',
                   ),
                   if (hasItems)
                     AppBarAction(
                       icon: Icon(Icons.delete_outline, color: iconColor),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          barrierDismissible: true,
                          builder: (dialogContext) => OsmeaComponents.popup(
                            variant: PopupVariant.dialog,
                            title: context.t.wishlistView.removeAll.dialog.title,
                            subtitle: context.t.wishlistView.removeAll.dialog.subtitle,
                            padding: context.paddingNormal,
                            backgroundColor: OsmeaColors.white,
                            titleStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                              color: OsmeaColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            subtitleStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                              color: OsmeaColors.black,
                            ),
                            showCloseButton: true,
                            closeButtonIcon: Icon(
                              Icons.close,
                              color: OsmeaColors.black,
                              size: 20,
                            ),
                            child: OsmeaComponents.column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OsmeaComponents.row(
                                  children: [
                                    OsmeaComponents.expanded(
                                      child: OsmeaComponents.button(
                                        text: context.t.wishlistView.removeAll.dialog.cancel,
                                        variant: ButtonVariant.outlined,
                                        borderColor: OsmeaColors.black,
                                        textColor: OsmeaColors.black,
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(false),
                                      ),
                                    ),
                                    OsmeaComponents.sizedBox(
                                      width: context.spacing8,
                                    ),
                                    OsmeaComponents.expanded(
                                      child: OsmeaComponents.button(
                                        text: context.t.wishlistView.removeAll.dialog.confirm,
                                        variant: ButtonVariant.primary,
                                        backgroundColor: OsmeaColors.black,
                                        textColor: OsmeaColors.white,
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(true),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                               title: context.t.wishlistView.removeAll.snackbar.title,
                               message: context.t.wishlistView.removeAll.snackbar.message,
                               type: SnackbarType.error,
                               style: SnackbarStyle.minimal,
                               position: SnackbarPosition.bottom,
                               animation: SnackbarAnimation.slide,
                               actionLabel: context.t.wishlistView.removeAll.snackbar.undo,
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
                       tooltip: context.t.wishlistView.appBar.removeAllTooltip,
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
        // Get popup colors from config
        final configHelper = AssetConfigHelper();
        final popupBgColor = _getPopupColorFromConfig(
          'popup.backgroundColor',
          OsmeaColors.white,
        );
        final popupTitleColor = _getPopupColorFromConfig(
          'popup.titleColor',
          const Color(0xFF1976D2),
        );
        final popupSubtitleColor = _getPopupColorFromConfig(
          'popup.subtitleColor',
          OsmeaColors.grayMaterial[400]!,
        );
        final popupElevation = configHelper.getDouble(
          'dialog_popup_configuration.popup.elevation',
          8.0,
        );

        final result = await OsmeaComponents.showPopup(
          context: context,
          variant: PopupVariant.dialog,
          title: context.t.wishlistView.addToCart.dialog.title,
          subtitle: context.t.wishlistView.addToCart.dialog.subtitle,
          backgroundColor: popupBgColor,
          titleStyle: OsmeaTextStyle.titleMedium(
            context,
          ).copyWith(color: popupTitleColor, fontWeight: FontWeight.w600),
          subtitleStyle: OsmeaTextStyle.bodyMedium(
            context,
          ).copyWith(color: popupSubtitleColor),
          elevation: popupElevation,
          padding: context.paddingNormal,
          child: OsmeaComponents.column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OsmeaComponents.row(
                children: [
                  OsmeaComponents.expanded(
                    child: Builder(
                      builder: (context) {
                        final primaryBgColor = _getPopupButtonColorFromConfig(
                          'primary.backgroundColor',
                          OsmeaColors.black,
                        );
                        final primaryTextColor = _getPopupButtonColorFromConfig(
                          'primary.textColor',
                          OsmeaColors.white,
                        );

                        return OsmeaComponents.button(
                          text: context.t.wishlistView.addToCart.dialog.addKeepSaved,
                          variant: ButtonVariant.primary,
                          backgroundColor: primaryBgColor,
                          textColor: primaryTextColor,
                          onPressed: () {
                            Navigator.of(context).pop('add_keep');
                            // addItemToCartFromWishlist will preserve the wishlist state
                            viewModel.addItemToCartFromWishlist(state.item.id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              OsmeaComponents.row(
                children: [
                  OsmeaComponents.expanded(
                    child: Builder(
                      builder: (context) {
                        final secondaryBgColor = _getPopupButtonColorFromConfig(
                          'secondary.backgroundColor',
                          OsmeaColors.white,
                        );
                        final secondaryTextColor =
                            _getPopupButtonColorFromConfig(
                              'secondary.textColor',
                              OsmeaColors.black,
                            );
                        final secondaryBorderColor =
                            _getPopupButtonColorFromConfig(
                              'secondary.borderColor',
                              OsmeaColors.black,
                            );

                        return OsmeaComponents.button(
                          text: context.t.wishlistView.addToCart.dialog.addRemoveFromSaved,
                          variant: ButtonVariant.outlined,
                          backgroundColor: secondaryBgColor,
                          textColor: secondaryTextColor,
                          borderColor: secondaryBorderColor,
                          onPressed: () {
                            Navigator.of(context).pop('add_remove');
                            viewModel.addItemToCartAndRemoveFromWishlist(
                              state.item.id,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              OsmeaComponents.sizedBox(height: context.spacing8),
              Builder(
                builder: (context) {
                  final ghostTextColor = _getPopupButtonColorFromConfig(
                    'ghost.textColor',
                    OsmeaColors.black,
                  );

                  return OsmeaComponents.button(
                    text: context.t.wishlistView.addToCart.dialog.cancel,
                    variant: ButtonVariant.ghost,
                    textColor: ghostTextColor,
                    onPressed: () => Navigator.of(context).pop('cancel'),
                  );
                },
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

  /// Show dialog for creating a new wishlist collection
  static void _showCreateCollectionDialog(
    BuildContext context,
    WishlistViewModel viewModel,
  ) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create New Collection',
          style: OsmeaTextStyle.titleLarge(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Collection Name',
                    hintText: 'Enter collection name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Collection name is required';
                    }
                    return null;
                  },
                  autofocus: true,
                ),
                SizedBox(height: context.spacing16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter collection description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop();
                await viewModel.createGroup(
                  nameController.text.trim(),
                  description: descriptionController.text.trim().isEmpty
                      ? null
                      : descriptionController.text.trim(),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: OsmeaColors.black,
              foregroundColor: OsmeaColors.white,
            ),
            child: Text(
              'Create',
              style: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
