/*
 * CheckoutState
 * -------------
 * States for the checkout view model.
 * Supports 4-step wizard: Address -> Shipping -> Payment -> Summary
 */

/// Simple line-item model for checkout UI.
class CheckoutLineItem {
  final String? key;
  final int? id;
  final String? name;
  final int quantity;
  final String? imageUrl;
  final dynamic lowStockRemaining;
  final bool backordersAllowed;
  final bool showBackorderBadge;
  final Map<String, dynamic>? extensions;
  final CheckoutDeliveryProfile deliveryProfile;

  const CheckoutLineItem({
    this.key,
    this.id,
    this.name,
    this.quantity = 1,
    this.imageUrl,
    this.lowStockRemaining,
    this.backordersAllowed = false,
    this.showBackorderBadge = false,
    this.extensions,
    this.deliveryProfile = const CheckoutDeliveryProfile(),
  });
}

/// Per-item delivery modifiers to make estimates product-specific.
class CheckoutDeliveryProfile {
  final int minAdditionalDays;
  final int maxAdditionalDays;
  final String? reason;

  const CheckoutDeliveryProfile({
    this.minAdditionalDays = 0,
    this.maxAdditionalDays = 0,
    this.reason,
  });
}

/// Checkout step enum
enum CheckoutStep {
  address,   // Step 1: Billing & Shipping Address
  shipping,  // Step 2: Shipping Method Selection
  payment,   // Step 3: Payment Method Selection
  summary,   // Step 4: Order Summary & Confirmation
}

/// Shipping method model
class ShippingMethod {
  final String id;
  final String title;
  final String? description;
  final double cost;
  final String? deliveryTime; // e.g., "2-3 business days"
  final bool isSelected;

  const ShippingMethod({
    required this.id,
    required this.title,
    this.description,
    required this.cost,
    this.deliveryTime,
    this.isSelected = false,
  });

  ShippingMethod copyWith({
    String? id,
    String? title,
    String? description,
    double? cost,
    String? deliveryTime,
    bool? isSelected,
  }) {
    return ShippingMethod(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// Payment method model
class PaymentMethod {
  final String id;
  final String title;
  final String? description;
  final String? icon; // Icon name or asset path
  final bool isSelected;
  final bool enabled;

  const PaymentMethod({
    required this.id,
    required this.title,
    this.description,
    this.icon,
    this.isSelected = false,
    this.enabled = true,
  });

  PaymentMethod copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    bool? isSelected,
    bool? enabled,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
      enabled: enabled ?? this.enabled,
    );
  }
}

/// Base class for all checkout states
abstract class CheckoutState {}

/// Initial state when the checkout view is first loaded
class CheckoutInitialState extends CheckoutState {}

/// Loading state when checkout data is being loaded
class CheckoutLoadingState extends CheckoutState {}

/// Loaded state when checkout form is ready
class CheckoutLoadedState extends CheckoutState {
  // Current step in the wizard
  final CheckoutStep currentStep;
  
  // Price & currency info
  final double subtotalAmount;
  final double shippingCost;
  final double totalAmount;
  final String? currencySymbol;
  final String? currencyCode;

  // Cart items (for per-product estimated delivery)
  final List<CheckoutLineItem> lineItems;
  
  // Saved addresses
  final Map<String, dynamic>? savedBillingAddress;
  final Map<String, dynamic>? savedShippingAddress;
  
  // Address data (filled in step 1)
  final Map<String, dynamic>? billingAddress;
  final Map<String, dynamic>? shippingAddress;
  final String? billingEmail;
  final bool sameAsBilling;
  
  // Shipping methods (shown in step 2)
  final List<ShippingMethod> shippingMethods;
  final String? selectedShippingMethodId;
  
  // Payment methods (shown in step 3)
  final List<PaymentMethod> paymentMethods;
  final String? selectedPaymentMethodId;
  
  // Step validation flags
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
    this.savedBillingAddress,
    this.savedShippingAddress,
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

  /// Calculate total including shipping
  double get calculatedTotal => subtotalAmount + shippingCost;

  /// Get selected shipping method
  ShippingMethod? get selectedShippingMethod {
    if (selectedShippingMethodId == null) return null;
    try {
      return shippingMethods.firstWhere((m) => m.id == selectedShippingMethodId);
    } catch (_) {
      return null;
    }
  }

  /// Get selected payment method
  PaymentMethod? get selectedPaymentMethod {
    if (selectedPaymentMethodId == null) return null;
    try {
      return paymentMethods.firstWhere((m) => m.id == selectedPaymentMethodId);
    } catch (_) {
      return null;
    }
  }

  /// Check if can proceed to next step
  bool get canProceedToShipping => isAddressStepValid;
  bool get canProceedToPayment => isAddressStepValid && isShippingStepValid;
  bool get canProceedToSummary => canProceedToPayment && isPaymentStepValid;
  bool get canCompleteOrder => canProceedToSummary;

  CheckoutLoadedState copyWith({
    CheckoutStep? currentStep,
    double? subtotalAmount,
    double? shippingCost,
    double? totalAmount,
    String? currencySymbol,
    String? currencyCode,
    List<CheckoutLineItem>? lineItems,
    Map<String, dynamic>? savedBillingAddress,
    Map<String, dynamic>? savedShippingAddress,
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
    bool clearSelectedShippingMethod = false,
    bool clearSelectedPaymentMethod = false,
  }) {
    return CheckoutLoadedState(
      currentStep: currentStep ?? this.currentStep,
      subtotalAmount: subtotalAmount ?? this.subtotalAmount,
      shippingCost: shippingCost ?? this.shippingCost,
      totalAmount: totalAmount ?? this.totalAmount,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyCode: currencyCode ?? this.currencyCode,
      lineItems: lineItems ?? this.lineItems,
      savedBillingAddress: savedBillingAddress ?? this.savedBillingAddress,
      savedShippingAddress: savedShippingAddress ?? this.savedShippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingEmail: billingEmail ?? this.billingEmail,
      sameAsBilling: sameAsBilling ?? this.sameAsBilling,
      shippingMethods: shippingMethods ?? this.shippingMethods,
      selectedShippingMethodId: clearSelectedShippingMethod ? null : (selectedShippingMethodId ?? this.selectedShippingMethodId),
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethodId: clearSelectedPaymentMethod ? null : (selectedPaymentMethodId ?? this.selectedPaymentMethodId),
      isAddressStepValid: isAddressStepValid ?? this.isAddressStepValid,
      isShippingStepValid: isShippingStepValid ?? this.isShippingStepValid,
      isPaymentStepValid: isPaymentStepValid ?? this.isPaymentStepValid,
    );
  }
}

/// Error state when checkout fails
class CheckoutErrorState extends CheckoutState {
  final String message;
  final CheckoutStep? failedAtStep;

  CheckoutErrorState({
    required this.message,
    this.failedAtStep,
  });
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
  final List<CheckoutLineItem> lineItems;
  final Map<String, dynamic>? shippingAddress;

  CheckoutOrderCompletedState({
    required this.orderId,
    required this.orderKey,
    required this.status,
    required this.totalAmount,
    this.currencySymbol,
    this.currencyCode,
    this.lineItems = const [],
    this.shippingAddress,
  });
}

