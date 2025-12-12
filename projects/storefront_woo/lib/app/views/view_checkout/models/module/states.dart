/*
 * CheckoutState
 * -------------
 * States for the checkout view model.
 */

/// Base class for all checkout states
abstract class CheckoutState {}

/// Initial state when the checkout view is first loaded
class CheckoutInitialState extends CheckoutState {}

/// Loading state when checkout data is being loaded
class CheckoutLoadingState extends CheckoutState {}

/// Loaded state when checkout form is ready
class CheckoutLoadedState extends CheckoutState {
  final double totalAmount;
  final String? currencySymbol;
  final String? currencyCode;
  final Map<String, dynamic>? savedBillingAddress;
  final Map<String, dynamic>? savedShippingAddress;

  CheckoutLoadedState({
    required this.totalAmount,
    this.currencySymbol,
    this.currencyCode,
    this.savedBillingAddress,
    this.savedShippingAddress,
  });
}

/// Error state when checkout fails
class CheckoutErrorState extends CheckoutState {
  final String message;

  CheckoutErrorState({required this.message});
}

/// Processing order state
class CheckoutProcessingOrderState extends CheckoutState {}

/// Order completed successfully
class CheckoutOrderCompletedState extends CheckoutState {
  final int orderId;
  final String orderKey;
  final String status;
  final double totalAmount;
  final String? currencySymbol;
  final String? currencyCode;

  CheckoutOrderCompletedState({
    required this.orderId,
    required this.orderKey,
    required this.status,
    required this.totalAmount,
    this.currencySymbol,
    this.currencyCode,
  });
}

