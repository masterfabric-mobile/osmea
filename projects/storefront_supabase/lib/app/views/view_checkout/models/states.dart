/*
 * CheckoutState
 * -------------
 * States for the checkout view. 4 steps: Address -> Shipping -> Payment -> Summary
 */

/// Line item for checkout/order summary
class CheckoutLineItem {
  final String? key;
  final String? productId;
  final String? name;
  final int quantity;
  final String? imageUrl;
  final double unitPrice;

  const CheckoutLineItem({
    this.key,
    this.productId,
    this.name,
    this.quantity = 1,
    this.imageUrl,
    this.unitPrice = 0.0,
  });

  double get subtotal => unitPrice * quantity;
}

enum CheckoutStep {
  address,
  shipping,
  payment,
  summary,
}

class ShippingMethod {
  final String id;
  final String title;
  final String? description;
  final double cost;
  final String? deliveryTime;

  const ShippingMethod({
    required this.id,
    required this.title,
    this.description,
    required this.cost,
    this.deliveryTime,
  });
}

class PaymentMethod {
  final String id;
  final String title;
  final String? description;
  final String? icon;
  final bool enabled;

  const PaymentMethod({
    required this.id,
    required this.title,
    this.description,
    this.icon,
    this.enabled = true,
  });
}

abstract class CheckoutState {}

class CheckoutInitialState extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {}

class CheckoutLoadedState extends CheckoutState {
  final CheckoutStep currentStep;
  final double subtotalAmount;
  final double shippingCost;
  final double totalAmount;
  final String? currencySymbol;
  final String? currencyCode;
  final List<CheckoutLineItem> lineItems;
  final Map<String, dynamic>? billingAddress;
  final Map<String, dynamic>? shippingAddress;
  final String? billingEmail;
  final bool sameAsBilling;
  final List<ShippingMethod> shippingMethods;
  final String? selectedShippingMethodId;
  final List<PaymentMethod> paymentMethods;
  final String? selectedPaymentMethodId;
  final bool isAddressStepValid;
  final bool isShippingStepValid;
  final bool isPaymentStepValid;

  CheckoutLoadedState({
    this.currentStep = CheckoutStep.address,
    required this.subtotalAmount,
    this.shippingCost = 0.0,
    required this.totalAmount,
    this.currencySymbol,
    this.currencyCode,
    this.lineItems = const [],
    this.billingAddress,
    this.shippingAddress,
    this.billingEmail,
    this.sameAsBilling = true,
    this.shippingMethods = const [],
    this.selectedShippingMethodId,
    this.paymentMethods = const [],
    this.selectedPaymentMethodId,
    this.isAddressStepValid = false,
    this.isShippingStepValid = false,
    this.isPaymentStepValid = false,
  });

  double get calculatedTotal => subtotalAmount + shippingCost;

  ShippingMethod? get selectedShippingMethod {
    if (selectedShippingMethodId == null) return null;
    try {
      return shippingMethods.firstWhere((m) => m.id == selectedShippingMethodId);
    } catch (_) {
      return null;
    }
  }

  PaymentMethod? get selectedPaymentMethod {
    if (selectedPaymentMethodId == null) return null;
    try {
      return paymentMethods.firstWhere((m) => m.id == selectedPaymentMethodId);
    } catch (_) {
      return null;
    }
  }

  CheckoutLoadedState copyWith({
    CheckoutStep? currentStep,
    double? subtotalAmount,
    double? shippingCost,
    double? totalAmount,
    String? currencySymbol,
    String? currencyCode,
    List<CheckoutLineItem>? lineItems,
    Map<String, dynamic>? billingAddress,
    Map<String, dynamic>? shippingAddress,
    String? billingEmail,
    bool? sameAsBilling,
    List<ShippingMethod>? shippingMethods,
    String? selectedShippingMethodId,
    List<PaymentMethod>? paymentMethods,
    String? selectedPaymentMethodId,
    bool? isAddressStepValid,
    bool? isShippingStepValid,
    bool? isPaymentStepValid,
    bool clearSelectedShipping = false,
    bool clearSelectedPayment = false,
  }) {
    return CheckoutLoadedState(
      currentStep: currentStep ?? this.currentStep,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      shippingCost: shippingCost ?? this.shippingCost,
      totalAmount: totalAmount ?? this.totalAmount,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyCode: currencyCode ?? this.currencyCode,
      lineItems: lineItems ?? this.lineItems,
      billingAddress: billingAddress ?? this.billingAddress,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingEmail: billingEmail ?? this.billingEmail,
      sameAsBilling: sameAsBilling ?? this.sameAsBilling,
      shippingMethods: shippingMethods ?? this.shippingMethods,
      selectedShippingMethodId:
          clearSelectedShipping ? null : (selectedShippingMethodId ?? this.selectedShippingMethodId),
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethodId:
          clearSelectedPayment ? null : (selectedPaymentMethodId ?? this.selectedPaymentMethodId),
      isAddressStepValid: isAddressStepValid ?? this.isAddressStepValid,
      isShippingStepValid: isShippingStepValid ?? this.isShippingStepValid,
      isPaymentStepValid: isPaymentStepValid ?? this.isPaymentStepValid,
    );
  }
}

class CheckoutErrorState extends CheckoutState {
  final String message;
  final CheckoutStep? failedAtStep;

  CheckoutErrorState({required this.message, this.failedAtStep});
}

class CheckoutProcessingOrderState extends CheckoutState {}

class CheckoutOrderCompletedState extends CheckoutState {
  final String orderId;
  final String orderNumber;
  final String status;
  final double totalAmount;
  final String? currencySymbol;
  final String? currencyCode;
  final List<CheckoutLineItem> lineItems;
  final Map<String, dynamic>? shippingAddress;

  CheckoutOrderCompletedState({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    this.currencySymbol,
    this.currencyCode,
    this.lineItems = const [],
    this.shippingAddress,
  });
}
