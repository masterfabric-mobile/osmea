/*
 * CartView
 * --------
 * Cart view for the storefront app following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_cart/models/cart_view_model.dart';
import 'package:storefront_woo/app/views/view_cart/models/module/states.dart';
import 'package:storefront_woo/app/views/view_cart/widgets/cart_widgets.dart';

/// CartView displays the shopping cart with items and checkout functionality
class CartView extends MasterViewHydratedCubit<CartViewModel, CartState> {
  CartView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             _buildCartAppBar(context, viewModel),
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

    // Handle auth required state for checkout
    if (state is CartAuthRequiredState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('🔒 Auth required for checkout, navigating to auth screen');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: OsmeaColors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
        // Navigate to auth with return path
        context.push('/auth?returnTo=/cart');
      });
      // Show loading while navigating
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Center(
            child: CircularProgressIndicator(color: OsmeaColors.nordicBlue),
          ),
        ),
      );
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
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CartErrorWidget(
            message: state.message,
            onRetry: () => viewModel.loadCart(),
          ),
        ),
      );
    }

    // Loading state
    if (state is CartLoadingState) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: const CartLoadingWidget(),
        ),
      );
    }

    // Loaded state
    if (state is CartLoadedState) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CartContentWidget(viewModel: viewModel, state: state),
        ),
      );
    }

    // Initial state
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: const CartLoadingWidget(),
      ),
    );
  }
}

/// Builds cart app bar following OSMEA standards
PreferredSizeWidget _buildCartAppBar(
  BuildContext context,
  CartViewModel? viewModel,
) {
  return AppBar(
    title: OsmeaComponents.text(
      'Shopping Cart',
      color: OsmeaColors.thunder,
      textStyle: OsmeaTextStyle.titleLarge(context),
    ),
    backgroundColor: OsmeaColors.paperWhite,
    elevation: 0,
    foregroundColor: OsmeaColors.thunder,
    leading: OsmeaComponents.iconButton(
      onPressed: () => context.go('/home'),
      icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
    ),
    actions: [
      // Clear cart button
      OsmeaComponents.iconButton(
        onPressed: () {
          // TODO: Implement clear cart functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Clear cart feature coming soon!'),
              backgroundColor: Colors.blue,
            ),
          );
        },
        icon: Icon(Icons.clear_all, color: OsmeaColors.thunder),
        tooltip: 'Clear Cart',
      ),
    ],
  );
}
