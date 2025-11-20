/*
 * CartView
 * --------
 * Cart view for the storefront app following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_widgets.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_app_bar_widget.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_auth_required_widget.dart';

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
  }) : super(coreAppBar: (context, viewModel) => const CartAppBarWidget()) {
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
      // Checkout functionality removed - just show message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: OsmeaColors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      });
      // Show loading while handling
      return CartAuthRequiredWidget(message: state.message);
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

    // Loading state
    if (state is CartLoadingState) {
      return LoadingScreen(
        goRoute: goRoute,
        loadingType: LoadingModelType.dataLoading,
        loadingSteps: ['Loading cart...'],
      );
    }

    // Loaded state
    if (state is CartLoadedState) {
      return CartContentWidget(viewModel: viewModel, state: state);
    }

    // Initial state
    return LoadingScreen(
      goRoute: goRoute,
      loadingType: LoadingModelType.dataLoading,
      loadingSteps: ['Loading cart...'],
    );
  }
}
