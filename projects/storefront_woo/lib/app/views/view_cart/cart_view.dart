/*
 * CartView
 * --------
 * Cart view for the storefront app following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_content_widget.dart';
import 'package:storefront_woo/app/utils/unified_loading_widget.dart';

/// CartView displays the shopping cart with items and checkout functionality
class CartView extends MasterViewHydratedCubit<CartViewModel, CartState> {
  CartView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.appBarPadding = const AppBarPaddingVisibility.disabled(),
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    super.verticalPadding = const PaddingVisibility.disabled(),
    super.horizontalPadding = const PaddingVisibility.enabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
           title: OsmeaComponents.text(
             'Shopping Cart',
             color: OsmeaColors.thunder,
             textStyle: OsmeaTextStyle.titleLarge(context),
           ),
           backgroundColor: OsmeaColors.paperWhite,
           elevation: 0,
           foregroundColor: OsmeaColors.thunder,
           variant: AppBarVariant.standard,
           size: AppBarSize.standard,
           leading: OsmeaComponents.iconButton(
             onPressed: () => context.go('/home'),
             icon: Icon(
               Icons.arrow_back,
               color: OsmeaColors.thunder,
               size: context.iconSizeNormal,
             ),
           ),
           actions: [
             AppBarAction(
               type: AppBarActionType.refresh,
               icon: Icon(
                 Icons.refresh,
                 color: OsmeaColors.thunder,
                 size: context.iconSizeNormal,
               ),
               onPressed: () => viewModel.loadCart(),
               tooltip: 'Refresh cart',
             ),
           ],
         ),
       ) {
    debugPrint('🛒 CartView: Constructor called');
  }

  @override
  void initialContent(CartViewModel viewModel, BuildContext context) {
    debugPrint('🛒 CartView: initialContent called');
    // Set arguments to ViewModel
    viewModel.setArguments(arguments);
    // Load cart - token will be taken from arguments or storage
    viewModel.loadCart(cartToken: arguments['cartToken'] as String?);
  }

  @override
  Widget viewContent(
    BuildContext context,
    CartViewModel viewModel,
    CartState state,
  ) {
    debugPrint(
      '🛒 CartView: viewContent called with state: ${state.runtimeType}',
    );

    // Handle auth required state (removed checkout functionality)
    if (state is CartAuthRequiredState) {
      _showAuthRequiredMessage(context, state.message);
      return _buildAuthRequiredLoading(context);
    }

    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    CartViewModel viewModel,
    CartState state,
  ) {
    // Error state
    if (state is CartErrorState) {
      return ErrorHandlingView(
        goRoute: goRoute,
        customRetryFunction: () async {
          viewModel.loadCart();
          return true;
        },
      );
    }

    // Use BlocBuilder to listen to state changes and preserve loaded state during loading
    return BlocBuilder<CartViewModel, CartState>(
      bloc: viewModel,
      builder: (context, currentState) {
        // Get the loaded state - prefer currentState if it's loaded, otherwise use lastLoadedState or state parameter
        CartLoadedState? loadedState;
        if (currentState is CartLoadedState) {
          loadedState = currentState;
        } else if (state is CartLoadedState) {
          // Use the state parameter if currentState is loading but we have loaded state from parameter
          loadedState = state;
        } else if (viewModel.lastLoadedState != null) {
          // Use last loaded state from viewModel when currentState is loading
          loadedState = viewModel.lastLoadedState;
        }

        // If we have a loaded state, show content with overlay
        if (loadedState != null) {
          final isLoading = currentState is CartLoadingState;
          return _buildCartContentWithRefresh(
            context,
            viewModel,
            loadedState,
            isLoading: isLoading,
          );
        }

        // Loading state or initial state - show full screen loading
        return UnifiedLoadingWidget(
          goRoute: goRoute,
          loadingSteps: ['Loading cart...'],
        );
      },
    );
  }

  Widget _buildCartContentWithRefresh(
    BuildContext context,
    CartViewModel viewModel,
    CartLoadedState state, {
    bool isLoading = false,
  }) {
    return BlocBuilder<CartViewModel, CartState>(
      bloc: viewModel,
      builder: (context, currentState) {
        final isCurrentlyLoading = isLoading || currentState is CartLoadingState;
        
        return Stack(
          children: [
            // Cart content
            RefreshIndicator(
              onRefresh: () => viewModel.refreshCart(),
              color: OsmeaColors.nordicBlue,
              backgroundColor: OsmeaColors.white,
              strokeWidth: 2.0,
              displacement: 40,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: CartContentWidget(viewModel: viewModel, state: state),
              ),
            ),
            // Loading overlay when refreshing
            if (isCurrentlyLoading)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Container(
                    color: OsmeaColors.white.withValues(alpha: 0.7),
                    child: OsmeaComponents.center(
                      child: OsmeaComponents.container(
                        padding: EdgeInsets.all(context.spacing24),
                        decoration: BoxDecoration(
                          color: OsmeaColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: OsmeaComponents.loading(
                          type: LoadingType.circularFade,
                          size: context.iconSizeLarge,
                          color: OsmeaColors.nordicBlue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Shows authentication required message via Osmea Snackbar
  void _showAuthRequiredMessage(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.snackbarWarning(message, duration: context.durationLong);
    });
  }

  /// Builds loading widget for authentication required state
  Widget _buildAuthRequiredLoading(BuildContext context) {
    return SafeArea(
      child: OsmeaComponents.container(
        padding: context.onlyBottomPaddingNormal,
        child: OsmeaComponents.center(
          child: OsmeaComponents.loading(
            type: LoadingType.circularFade,
            size: context.iconSizeLarge,
            color: OsmeaColors.nordicBlue,
          ),
        ),
      ),
    );
  }
}
