/*
 * OrdersViewModel
 * ---------------
 * ViewModel for the orders view following OSMEA architecture.
 * Uses Bloc pattern with events and states from core package.
 * Integrates with APIs package for order operations.
 */

import 'package:flutter/foundation.dart';
import 'package:apis/network/remote/woocommerce/store_api/order_api/abstract/order_service.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_orders/models/module/states.dart';

@injectable
class OrdersViewModel extends BaseViewModelHydratedCubit<OrdersState> {
  OrdersViewModel() : super(OrdersInitialState());

  // Dependencies
  final OrderService _orderService = GetIt.I<OrderService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  // Arguments holder for route/widget inputs
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Local storage for orders list
  final List<OrderItem> _orders = [];
  OrderItem? _currentOrder;

  List<OrderItem> get orders => List.unmodifiable(_orders);
  OrderItem? get currentOrder => _currentOrder;

  // Public trigger functions - HydratedCubit pattern
  void loadOrder(String orderKey) => _loadOrder(orderKey);
  void loadOrdersList() => _loadOrdersList();

  // Private methods - HydratedCubit pattern
  Future<void> _loadOrder(String orderKey) async {
    try {
      debugPrint('📦 OrdersViewModel: Loading order with key: $orderKey');
      emit(OrdersLoadingState());

      final apiVersion = _configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      debugPrint('📦 OrdersViewModel: Calling getOrder API...');
      final orderResponse = await _orderService.getOrder(
        apiVersion: apiVersion,
        orderKey: orderKey,
      );

      debugPrint('📦 OrdersViewModel: Order loaded successfully');
      debugPrint('📦 OrdersViewModel: Order ID: ${orderResponse.id}');
      debugPrint('📦 OrdersViewModel: Order Status: ${orderResponse.status}');

      // Convert API response to OrderItem
      final totals = orderResponse.totals;
      final totalPrice = totals?.totalPrice != null
          ? double.tryParse(totals!.totalPrice!) ?? 0.0
          : 0.0;

      final orderItem = OrderItem(
        orderId: orderResponse.id,
        orderKey: orderKey,
        orderNumber: orderResponse.id?.toString(),
        status: orderResponse.status,
        dateCreated: null, // Not available in Store API
        dateModified: null, // Not available in Store API
        total: totalPrice,
        currencyCode: totals?.currencyCode,
        currencySymbol: totals?.currencySymbol,
        billingAddress: orderResponse.billingAddress,
        shippingAddress: orderResponse.shippingAddress,
        lineItems: orderResponse.items?.map((item) => {
              'name': item.name,
              'quantity': item.quantity,
              'price': item.prices?.price != null
                  ? double.tryParse(item.prices!.price!) ?? 0.0
                  : 0.0,
            }).toList(),
        paymentMethod: null, // Not available in Store API
        customerNote: null, // Not available in Store API
      );

      _currentOrder = orderItem;

      emit(OrderDetailLoadedState(order: orderItem));
    } catch (e) {
      debugPrint('❌ OrdersViewModel: Error loading order: $e');
      emit(OrdersErrorState(message: 'Failed to load order: $e'));
    }
  }

  Future<void> _loadOrdersList() async {
    try {
      debugPrint('📦 OrdersViewModel: Loading orders list...');
      emit(OrdersLoadingState());

      // Note: WooCommerce Store API doesn't have a list orders endpoint
      // Orders are typically accessed by order key
      // For now, we'll just show a message that orders can be accessed by key
      // In a real app, you might need to use the WooCommerce REST API (not Store API)
      // or maintain a local list of order keys

      debugPrint('⚠️ OrdersViewModel: Store API does not support listing orders');
      debugPrint('⚠️ OrdersViewModel: Orders must be accessed by order key');

      // For now, emit empty list
      // In production, you might want to:
      // 1. Store order keys locally after checkout
      // 2. Use WooCommerce REST API (requires authentication)
      // 3. Fetch orders from a custom endpoint

      _orders.clear();
      emit(OrdersLoadedState(orders: []));
    } catch (e) {
      debugPrint('❌ OrdersViewModel: Error loading orders list: $e');
      emit(OrdersErrorState(message: 'Failed to load orders: $e'));
    }
  }

  @override
  OrdersState? fromJson(Map<String, dynamic> json) {
    return null; // State will be reconstructed from API
  }

  @override
  Map<String, dynamic>? toJson(OrdersState state) {
    return null; // No need to persist orders state
  }
}

