/*
 * CheckoutView
 * ------------
 * Checkout view for the storefront app following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_checkout/models/checkout_view_model.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:storefront_woo/app/views/view_checkout/widgets/checkout_widgets.dart';

/// CheckoutView displays the checkout form with billing/shipping addresses and payment
class CheckoutView extends MasterViewHydratedCubit<CheckoutViewModel, CheckoutState> {
  CheckoutView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             _buildCheckoutAppBar(context, viewModel),
       ) {
    debugPrint('💳 CheckoutView: Constructor called');
  }

  @override
  void initialContent(CheckoutViewModel viewModel, BuildContext context) {
    debugPrint('💳 CheckoutView: initialContent called');
    // Set arguments to ViewModel
    viewModel.setArguments(arguments);
    // Load checkout data
    viewModel.loadCheckoutData();
  }

  @override
  Widget viewContent(
    BuildContext context,
    CheckoutViewModel viewModel,
    CheckoutState state,
  ) {
    debugPrint(
      '💳 CheckoutView: viewContent called with state: ${state.runtimeType}',
    );

    // Handle success state - navigate to orders with order key
    if (state is CheckoutSuccessState) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('💳 CheckoutView: Order placed successfully, navigating to orders...');
        debugPrint('💳 CheckoutView: Order Key: ${state.orderKey}');
        // Navigate to orders page with order key
        context.go('/orders/${state.orderKey}');
      });
      return buildLoading();
    }

    return _buildBody(context, viewModel, state);
  }

  Widget _buildBody(
    BuildContext context,
    CheckoutViewModel viewModel,
    CheckoutState state,
  ) {
    // Error state
    if (state is CheckoutErrorState) {
      return buildError(state.message, onRetry: () => viewModel.loadCheckoutData());
    }

    // Loading state
    if (state is CheckoutLoadingState || state is CheckoutInitialState) {
      return buildLoading();
    }

    // Processing state
    if (state is CheckoutProcessingState) {
      return buildLoading();
    }

    // Loaded state
    if (state is CheckoutLoadedState) {
      return CheckoutFormWidget(
        state: state,
        viewModel: viewModel,
      );
    }

    // Default - show loading
    return buildLoading();
  }

  /// Build checkout app bar
  static PreferredSizeWidget _buildCheckoutAppBar(
    BuildContext context,
    CheckoutViewModel viewModel,
  ) {
    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        'Checkout',
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      leading: OsmeaComponents.iconButton(
        onPressed: () => context.go('/cart'),
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back to Cart',
      ),
      variant: AppBarVariant.standard,
      size: AppBarSize.standard,
    );
  }
}

