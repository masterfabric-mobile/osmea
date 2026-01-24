/*
 * ProductDetailView
 * -----------------
 * A product detail view following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:apis/utils/api_error_utils.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/product_detail_view_model.dart';
import 'package:storefront_woo/app/views/view_product_detail/models/module/states.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_detail_widgets.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_detail_error_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/product_detail_skeleton_widget.dart';
import 'package:storefront_woo/app/views/view_product_detail/widgets/add_to_cart_popup.dart';
import 'package:osmea_components/src/utils/toast_extensions.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';
import 'package:storefront_woo/gen/translations.g.dart';

/// ProductDetailView displays detailed information about a single product
class ProductDetailView
    extends
        MasterViewHydratedCubit<ProductDetailViewModel, ProductDetailState> {
  final int productId;

  ProductDetailView({
    super.key,
    required this.productId,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.extendBody = false,
    super.extendBodyBehindAppBar = false,
    super.arguments,
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             productDetailCoreAppBar(context, viewModel, arguments),
       );

  @override
  void initialContent(ProductDetailViewModel viewModel, BuildContext context) {
    // Set arguments to ViewModel
    viewModel.setArguments(arguments);
    // Initialize wishlist and load product - ViewModel handles wishlist sync internally
    viewModel.initializeWithProduct(productId);
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailState state,
  ) {
    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    ProductDetailViewModel viewModel,
    ProductDetailState state,
  ) {
    // Success state (e.g., wishlist added)
    if (state is ProductDetailSuccessState) {
      // Don't show toast/snackbar if coming from favorites/saved page
      final currentRoute = GoRouterState.of(context).uri.path;
      final isOnSavedPage = currentRoute.contains('/saved') || 
                           currentRoute.contains('/wishlist') || 
                           currentRoute.contains('/favorites');
      
      // Also check arguments for 'saved' flag (when navigating from wishlist)
      final isFromWishlist = arguments['saved'] == true || 
                            arguments['fromWishlist'] == true;
      
      // Check GoRouter location history to see if we came from favorites
      bool isFromSavedRoute = false;
      try {
        final router = GoRouter.of(context);
        final location = router.routerDelegate.currentConfiguration.uri.path;
        isFromSavedRoute = location.contains('/saved') || 
                          location.contains('/wishlist') || 
                          location.contains('/favorites');
      } catch (e) {
        // If we can't check router, try ModalRoute
        final modalRoute = ModalRoute.of(context);
        if (modalRoute != null) {
          final previousRoute = modalRoute.settings.arguments;
          if (previousRoute is Map) {
            isFromSavedRoute = (previousRoute['saved'] == true) || 
                             (previousRoute['fromWishlist'] == true);
          }
          // Also check route name if available
          final routeName = modalRoute.settings.name;
          if (routeName != null && (routeName.contains('/saved') || 
                                    routeName.contains('/wishlist') || 
                                    routeName.contains('/favorites'))) {
            isFromSavedRoute = true;
          }
        }
      }
      
      // Check if Navigator can pop and previous route was favorites
      bool cameFromFavorites = false;
      if (Navigator.of(context).canPop()) {
        try {
          final previousRoute = ModalRoute.of(context)?.settings.name ?? '';
          cameFromFavorites = previousRoute.contains('/saved') || 
                             previousRoute.contains('/wishlist') || 
                             previousRoute.contains('/favorites');
        } catch (e) {
          // Ignore errors
        }
      }
      
      // Only show toast if we're not on the saved page and not coming from wishlist
      // Also check if we're currently viewing favorites page (even if route doesn't show it)
      final shouldShowSnackbar = !isOnSavedPage && 
                                 !isFromWishlist && 
                                 !isFromSavedRoute && 
                                 !cameFromFavorites;
      
      if (shouldShowSnackbar) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.toastSuccess(state.message);
        });
      }
      
      return ProductDetailContentWidget(
        viewModel: viewModel,
        state: state.previousState,
        goRoute: goRoute,
      );
    }
    // ✅ Auth required state - navigate to auth screen
    if (state is ProductDetailAuthRequiredState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('🔒 Auth required, navigating to auth screen');
        context.snackbarWarning(state.message, duration: context.durationLong);
        // Reset to previous state to prevent infinite loop
        viewModel.loadProduct(productId);
        // Navigate to auth
        context.push('/auth');
      });
      // Show previous state while navigating
      if (state.previousState != null) {
        return ProductDetailContentWidget(
          viewModel: viewModel,
          state: state.previousState!,
          goRoute: goRoute,
        );
      }
      // Fallback to loading
      return buildUnifiedLoading(goRoute: goRoute);
    }

    // Error state
    if (state is ProductDetailErrorState) {
      // If error is related to adding to cart (400 error), show snackbar and recover to previous state
      final errorMessage = state.message.toLowerCase();
      final isAddToCartError =
          errorMessage.contains('failed to add') ||
          errorMessage.contains('add to cart') ||
          errorMessage.contains('400') ||
          errorMessage.contains('bad response');

      if (isAddToCartError && state.previousState != null) {
        // Show snackbar and recover to previous state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Use ApiErrorUtils to get user-friendly error message
          final userFriendlyMessage = ApiErrorUtils.getErrorMessage(
            state.message,
          );
          context.snackbarError(
            context.t.productDetailView.error.failedToAddToCart.replaceAll('{message}', userFriendlyMessage),
            duration: context.durationVeryLong,
          );
          // Recover to previous state
          viewModel.stateChanger(state.previousState!);
        });
        // Show previous state while snackbar is shown
        return ProductDetailContentWidget(
          viewModel: viewModel,
          state: state.previousState!,
          goRoute: goRoute,
        );
      }

      // For other errors, show error widget
      return ProductDetailErrorWidget(
        message: state.message,
        onRetry: () => viewModel.loadProduct(productId),
      );
    }

    // Loading state
    if (state is ProductDetailLoadingState) {
      // Show skeleton loading instead of unified loading
      return const ProductDetailSkeletonWidget();
    }

    // Loaded state
    if (state is ProductDetailLoadedState) {
      // Check if we should show add to cart popup
      if (state.shouldShowAddToCartPopup) {
        // Reset the flag immediately to prevent multiple popups
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // Get cart token
          final cartToken = await viewModel.getCartTokenForNavigation();
          
          // Show bottom sheet
          if (context.mounted) {
            showAddToCartSuccessPopup(
              context,
              cartToken: cartToken,
            );
          }
          
          // Reset flag after showing popup
          final currentState = viewModel.state;
          if (currentState is ProductDetailLoadedState) {
            viewModel.stateChanger(
              currentState.copyWith(shouldShowAddToCartPopup: false),
            );
          }
        });
      }
      
      return ProductDetailContentWidget(
        viewModel: viewModel,
        state: state,
        goRoute: goRoute,
      );
    }

    // Initial state - show skeleton loading
    return const ProductDetailSkeletonWidget();
  }
}

/// Returns a coreAppBar for the product detail view following OSMEA standards
PreferredSizeWidget productDetailCoreAppBar(
  BuildContext context, [
  ProductDetailViewModel? viewModel,
  Map<String, dynamic>? arguments,
]) {
  final configHelper = AssetConfigHelper();
  
  // Get appBar colors from config
  Color getAppBarColor(String key, Color fallback) {
    try {
      final colorString = configHelper.getString('product_detail_view.appBar.$key');
      if (colorString.isNotEmpty && colorString.startsWith('#')) {
        final hexString = colorString.substring(1);
        if (hexString.length == 6) {
          return Color(int.parse('FF$hexString', radix: 16));
        } else if (hexString.length == 8) {
          return Color(int.parse(hexString, radix: 16));
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to load appBar color $key: $e');
    }
    return fallback;
  }
  
  final backgroundColor = getAppBarColor('backgroundColor', OsmeaColors.white);
  final titleColor = getAppBarColor('titleColor', OsmeaColors.black);
  final iconColor = getAppBarColor('iconColor', OsmeaColors.black);
  final elevation = configHelper.getDouble('product_detail_view.appBar.elevation', 0.0);
  
  return OsmeaComponents.appBar(
    title: OsmeaComponents.text(
      context.t.productDetailView.appBar.title,
      color: titleColor,
      textStyle: OsmeaTextStyle.titleLarge(context),
    ),
    backgroundColor: backgroundColor,
    elevation: elevation,
    leading: OsmeaComponents.iconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(Icons.arrow_back, color: iconColor),
    ),
    actions: const [], // Cart icon removed
  );
}
