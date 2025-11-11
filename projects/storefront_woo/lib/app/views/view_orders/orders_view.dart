/*
 * OrdersView
 * ----------
 * Orders view for the storefront app following OSMEA architecture.
 * Uses MasterViewHydratedCubit pattern with HydratedBloc state management.
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:storefront_woo/app/views/view_orders/models/orders_view_model.dart';
import 'package:storefront_woo/app/views/view_orders/models/module/states.dart';
import 'package:storefront_woo/app/views/view_orders/widgets/orders_widgets.dart';

/// OrdersView displays order history and order details
class OrdersView extends MasterViewHydratedCubit<OrdersViewModel, OrdersState> {
  OrdersView({
    super.key,
    super.arguments,
    super.currentView,
    super.snackBarFunction,
    super.navbarSpacer = const SpacerVisibility.disabled(),
    super.footerSpacer = const SpacerVisibility.disabled(),
    required super.goRoute,
  }) : super(
         coreAppBar: (context, viewModel) =>
             _buildOrdersAppBar(context, viewModel),
       ) {
    debugPrint('📦 OrdersView: Constructor called');
  }

  @override
  void initialContent(OrdersViewModel viewModel, BuildContext context) {
    debugPrint('📦 OrdersView: initialContent called');
    // Set arguments to ViewModel
    viewModel.setArguments(arguments);
    
    // Check if orderKey is provided in arguments (for order detail)
    final orderKey = arguments['orderKey'] as String?;
    if (orderKey != null && orderKey.isNotEmpty) {
      debugPrint('📦 OrdersView: Loading order detail with key: $orderKey');
      viewModel.loadOrder(orderKey);
    } else {
      debugPrint('📦 OrdersView: Loading orders list');
      viewModel.loadOrdersList();
    }
  }

  @override
  Widget viewContent(
    BuildContext context,
    OrdersViewModel viewModel,
    OrdersState state,
  ) {
    debugPrint(
      '📦 OrdersView: viewContent called with state: ${state.runtimeType}',
    );

    // Error state
    if (state is OrdersErrorState) {
      return buildError(state.message, onRetry: () {
        final orderKey = arguments['orderKey'] as String?;
        if (orderKey != null && orderKey.isNotEmpty) {
          viewModel.loadOrder(orderKey);
        } else {
          viewModel.loadOrdersList();
        }
      });
    }

    // Loading state
    if (state is OrdersLoadingState || state is OrdersInitialState) {
      return buildLoading();
    }

    // Order detail loaded state
    if (state is OrderDetailLoadedState) {
      return OrderDetailWidget(
        order: state.order,
      );
    }

    // Orders list loaded state
    if (state is OrdersLoadedState) {
      return OrdersListWidget(
        orders: state.orders,
        onOrderTap: (orderKey) {
          // Navigate to order detail
          context.go('/orders/$orderKey');
        },
      );
    }

    // Default - show loading
    return buildLoading();
  }

  /// Build orders app bar
  static PreferredSizeWidget _buildOrdersAppBar(
    BuildContext context,
    OrdersViewModel viewModel,
  ) {
    final orderKey = viewModel.arguments['orderKey'] as String?;
    final isDetailView = orderKey != null && orderKey.isNotEmpty;

    return OsmeaComponents.appBar(
      title: OsmeaComponents.text(
        isDetailView ? 'Order Details' : 'My Orders',
        textStyle: OsmeaTextStyle.titleLarge(context),
      ),
      leading: OsmeaComponents.iconButton(
        onPressed: () {
          if (isDetailView) {
            context.go('/orders');
          } else {
            context.go('/home');
          }
        },
        icon: const Icon(Icons.arrow_back),
        tooltip: isDetailView ? 'Back to Orders' : 'Back to Home',
      ),
      variant: AppBarVariant.standard,
      size: AppBarSize.standard,
    );
  }
}

