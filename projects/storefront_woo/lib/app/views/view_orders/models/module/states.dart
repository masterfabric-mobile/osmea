/*
 * OrdersState
 * -----------
 * States for the orders view model.
 * Simple Dart classes without freezed.
 */

/// Base class for all orders states
abstract class OrdersState {}

/// Initial state when the orders view is first loaded
class OrdersInitialState extends OrdersState {}

/// Loading state when orders are being fetched
class OrdersLoadingState extends OrdersState {}

/// Loaded state when orders are successfully fetched
class OrdersLoadedState extends OrdersState {
  final List<OrderItem> orders;

  OrdersLoadedState({required this.orders});
}

/// Order detail loaded state
class OrderDetailLoadedState extends OrdersState {
  final OrderItem order;

  OrderDetailLoadedState({required this.order});
}

/// Error state when orders fetching fails
class OrdersErrorState extends OrdersState {
  final String message;

  OrdersErrorState({required this.message});
}

/// Simple order item model for states
class OrderItem {
  final int? orderId;
  final String orderKey;
  final String? orderNumber;
  final String? status;
  final String? dateCreated;
  final String? dateModified;
  final double? total;
  final String? currencyCode;
  final String? currencySymbol;
  final dynamic billingAddress;
  final dynamic shippingAddress;
  final List<dynamic>? lineItems;
  final String? paymentMethod;
  final String? customerNote;

  OrderItem({
    this.orderId,
    required this.orderKey,
    this.orderNumber,
    this.status,
    this.dateCreated,
    this.dateModified,
    this.total,
    this.currencyCode,
    this.currencySymbol,
    this.billingAddress,
    this.shippingAddress,
    this.lineItems,
    this.paymentMethod,
    this.customerNote,
  });
}

