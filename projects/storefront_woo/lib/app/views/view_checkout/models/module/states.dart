/*
 * CheckoutState
 * -------------
 * States for the checkout view model.
 * Simple Dart classes without freezed.
 */

/// Base class for all checkout states
abstract class CheckoutState {}

/// Initial state when the checkout view is first loaded
class CheckoutInitialState extends CheckoutState {}

/// Loading state when checkout data is being fetched
class CheckoutLoadingState extends CheckoutState {}

/// Loaded state when checkout data is successfully fetched
class CheckoutLoadedState extends CheckoutState {
  final dynamic checkoutData; // ListCheckoutDataResponseModel
  final String? billingFirstName;
  final String? billingLastName;
  final String? billingEmail;
  final String? billingPhone;
  final String? billingAddress1;
  final String? billingAddress2;
  final String? billingCity;
  final String? billingState;
  final String? billingPostcode;
  final String? billingCountry;
  final String? shippingFirstName;
  final String? shippingLastName;
  final String? shippingAddress1;
  final String? shippingAddress2;
  final String? shippingCity;
  final String? shippingState;
  final String? shippingPostcode;
  final String? shippingCountry;
  final String? paymentMethod;
  final String? orderNotes;

  CheckoutLoadedState({
    required this.checkoutData,
    this.billingFirstName,
    this.billingLastName,
    this.billingEmail,
    this.billingPhone,
    this.billingAddress1,
    this.billingAddress2,
    this.billingCity,
    this.billingState,
    this.billingPostcode,
    this.billingCountry,
    this.shippingFirstName,
    this.shippingLastName,
    this.shippingAddress1,
    this.shippingAddress2,
    this.shippingCity,
    this.shippingState,
    this.shippingPostcode,
    this.shippingCountry,
    this.paymentMethod,
    this.orderNotes,
  });
}

/// Processing state when payment and order is being processed
class CheckoutProcessingState extends CheckoutState {}

/// Success state when payment and order is successfully processed
class CheckoutSuccessState extends CheckoutState {
  final String orderKey;
  final int? orderId;
  final String? orderNumber;
  final String message;

  CheckoutSuccessState({
    required this.orderKey,
    this.orderId,
    this.orderNumber,
    this.message = 'Order placed successfully!',
  });
}

/// Error state when checkout operation fails
class CheckoutErrorState extends CheckoutState {
  final String message;

  CheckoutErrorState({required this.message});
}

