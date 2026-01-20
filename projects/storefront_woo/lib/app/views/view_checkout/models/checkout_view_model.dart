/*
 * CheckoutViewModel
 * -----------------
 * ViewModel for the checkout view following OSMEA architecture.
 * Supports 3-step wizard: Address -> Shipping -> Payment
 */

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:apis/network/remote/woocommerce/store_api/checkout_data_api/abstract/checkout_data_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/checkout_data_api/freezed_model/request/process_payment_and_order_request_model.dart' as request_model;
import 'package:apis/network/remote/woocommerce/store_api/checkout_data_api/freezed_model/response/process_order_and_payment_response_model.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/freezed_model/response/get_cart_response.dart';
import 'package:apis/models/cart/woo_cart_token.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';

@injectable
class CheckoutViewModel extends BaseViewModelHydratedCubit<CheckoutState> {
  CheckoutViewModel() : super(CheckoutInitialState());

  // Dependencies
  final CheckoutDataService _checkoutDataService = GetIt.I<CheckoutDataService>();
  final CartService _cartService = GetIt.I<CartService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  // Arguments holder
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Public trigger functions
  void loadCheckout() => _loadCheckout();
  
  /// Update address data and proceed to shipping step
  void updateAddressAndProceed({
    required String billingEmail,
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> shippingAddress,
    required bool sameAsBilling,
  }) => _updateAddressAndProceed(
        billingEmail: billingEmail,
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
        sameAsBilling: sameAsBilling,
      );

  /// Select a shipping method
  void selectShippingMethod(String methodId) => _selectShippingMethod(methodId);

  /// Proceed to payment step
  void proceedToPayment() => _proceedToPayment();

  /// Select a payment method
  void selectPaymentMethod(String methodId) => _selectPaymentMethod(methodId);

  /// Navigate to a specific step
  void goToStep(CheckoutStep step) => _goToStep(step);

  void processOrder({
    required String billingEmail,
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> shippingAddress,
  }) => _processOrder(
        billingEmail: billingEmail,
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
      );

  // Private implementation
  Future<void> _loadCheckout() async {
    try {
      emit(CheckoutLoadingState());

      debugPrint('🛒 CheckoutViewModel: Loading checkout data...');

      // Get API version from config (needed for cart fetch)
      final apiVersion = _configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Ensure cart token exists so we can fetch items.
      await _ensureCartToken(apiVersion);

      // Get cart total from arguments
      final totalAmount = _arguments['totalAmount'] as double? ?? 0.0;
      final currencySymbol = _arguments['currencySymbol'] as String?;
      final currencyCode = _arguments['currencyCode'] as String?;

      // Try to load saved addresses from user profile (future enhancement)
      Map<String, dynamic>? savedBillingAddress;
      Map<String, dynamic>? savedShippingAddress;

      try {
        final authCubit = GetIt.I<AuthCubit>();
        final authState = authCubit.state;
        if (authState is AuthAuthenticatedState && authState.userData != null) {
          debugPrint('✅ CheckoutViewModel: User authenticated, could load saved addresses');
        }
      } catch (e) {
        debugPrint('⚠️ CheckoutViewModel: Could not load saved addresses: $e');
      }

      // Default shipping methods (can be fetched from API in future)
      final shippingMethods = _getDefaultShippingMethods();

      // Default payment methods (can be fetched from API in future)
      final paymentMethods = _getDefaultPaymentMethods();

      // Fetch cart items for per-product estimated delivery in checkout.
      List<CheckoutLineItem> lineItems = const [];
      try {
        final cart = await _cartService.getCart(apiVersion: apiVersion);
        lineItems = _mapCartToCheckoutLineItems(cart);
      } catch (e) {
        debugPrint('⚠️ CheckoutViewModel: Could not fetch cart items: $e');
      }

      emit(CheckoutLoadedState(
        currentStep: CheckoutStep.address,
        subtotalAmount: totalAmount,
        shippingCost: 0.0,
        totalAmount: totalAmount,
        currencySymbol: currencySymbol,
        currencyCode: currencyCode,
        lineItems: lineItems,
        savedBillingAddress: savedBillingAddress,
        savedShippingAddress: savedShippingAddress,
        shippingMethods: shippingMethods,
        paymentMethods: paymentMethods,
        isAddressStepValid: false,
        isShippingStepValid: false,
      ));
    } catch (e) {
      debugPrint('❌ CheckoutViewModel: Error loading checkout: $e');
      emit(CheckoutErrorState(
        message: 'Failed to load checkout. Please try again.',
      ));
    }
  }

  List<CheckoutLineItem> _mapCartToCheckoutLineItems(GetCartResponse cart) {
    final items = cart.items ?? const <GetCartResponseItem>[];
    return items.map((it) {
      final img = (it.images?.isNotEmpty ?? false)
          ? (it.images!.first.thumbnail ?? it.images!.first.src)
          : null;
      return CheckoutLineItem(
        key: it.key,
        id: it.id,
        name: it.name,
        quantity: it.quantity ?? 1,
        imageUrl: img,
        lowStockRemaining: it.lowStockRemaining,
        backordersAllowed: it.backordersAllowed ?? false,
        showBackorderBadge: it.showBackorderBadge ?? false,
        // Store API cart item "extensions" is currently an empty model here.
        extensions: null,
        deliveryProfile: _buildDeliveryProfile(it),
      );
    }).toList();
  }

  CheckoutDeliveryProfile _buildDeliveryProfile(GetCartResponseItem it) {
    // Otherwise, derive a per-product modifier from stock/backorder signals.
    final qty = it.quantity ?? 1;
    final showBackorder = it.showBackorderBadge ?? false;
    final backordersAllowed = it.backordersAllowed ?? false;

    int? lowStock;
    final lsr = it.lowStockRemaining;
    if (lsr is int) {
      lowStock = lsr;
    } else if (lsr is String) {
      lowStock = int.tryParse(lsr);
    }

    // Defaults: no extra days
    var minAdd = 0;
    var maxAdd = 0;
    String? reason;

    if (showBackorder || backordersAllowed) {
      minAdd = 2;
      maxAdd = 5;
      reason = 'Backorder';
    } else if (lowStock != null && lowStock <= 0) {
      minAdd = 1;
      maxAdd = 3;
      reason = 'Low stock';
    }

    // Bigger quantities can take slightly longer to consolidate.
    if (qty >= 3) {
      minAdd += 1;
      maxAdd += 1;
      reason = reason ?? 'Quantity';
    }

    return CheckoutDeliveryProfile(
      minAdditionalDays: minAdd,
      maxAdditionalDays: maxAdd,
      reason: reason,
    );
  }

  /// Get default shipping methods
  List<ShippingMethod> _getDefaultShippingMethods() {
    return [
      const ShippingMethod(
        id: 'flat_rate',
        title: 'Standard Shipping',
        description: 'Delivery to your address',
        cost: 29.90,
        deliveryTime: '3-5 business days',
      ),
      const ShippingMethod(
        id: 'express',
        title: 'Express Shipping',
        description: 'Fast delivery',
        cost: 59.90,
        deliveryTime: '1-2 business days',
      ),
      const ShippingMethod(
        id: 'free_shipping',
        title: 'Free Shipping',
        description: 'Free delivery on orders over ₺500',
        cost: 0.0,
        deliveryTime: '5-7 business days',
      ),
    ];
  }

  /// Get default payment methods
  List<PaymentMethod> _getDefaultPaymentMethods() {
    return [
      const PaymentMethod(
        id: 'bacs',
        title: 'Bank Transfer',
        description: 'Direct bank transfer (EFT/Havale)',
        icon: 'account_balance',
        enabled: true,
      ),
      const PaymentMethod(
        id: 'cod',
        title: 'Cash on Delivery',
        description: 'Pay when you receive your order',
        icon: 'payments',
        enabled: true,
      ),
      // Credit card can be enabled when Stripe/iyzico is integrated
      const PaymentMethod(
        id: 'credit_card',
        title: 'Credit Card',
        description: 'Pay securely with your card',
        icon: 'credit_card',
        enabled: false, // Disabled until payment gateway is integrated
      ),
    ];
  }

  /// Update address and proceed to shipping step
  void _updateAddressAndProceed({
    required String billingEmail,
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> shippingAddress,
    required bool sameAsBilling,
  }) {
    final currentState = state;
    if (currentState is! CheckoutLoadedState) return;

    debugPrint('🛒 CheckoutViewModel: Address validated, proceeding to shipping');

    emit(currentState.copyWith(
      currentStep: CheckoutStep.shipping,
      billingEmail: billingEmail,
      billingAddress: billingAddress,
      shippingAddress: shippingAddress,
      sameAsBilling: sameAsBilling,
      isAddressStepValid: true,
    ));
  }

  /// Select shipping method
  void _selectShippingMethod(String methodId) {
    final currentState = state;
    if (currentState is! CheckoutLoadedState) return;

    final selectedMethod = currentState.shippingMethods
        .where((m) => m.id == methodId)
        .firstOrNull;

    if (selectedMethod == null) return;

    debugPrint('🛒 CheckoutViewModel: Selected shipping method: ${selectedMethod.title}');

    emit(currentState.copyWith(
      selectedShippingMethodId: methodId,
      shippingCost: selectedMethod.cost,
      totalAmount: currentState.subtotalAmount + selectedMethod.cost,
    ));
  }

  /// Proceed to payment step
  void _proceedToPayment() {
    final currentState = state;
    if (currentState is! CheckoutLoadedState) return;

    if (currentState.selectedShippingMethodId == null) {
      debugPrint('⚠️ CheckoutViewModel: No shipping method selected');
      return;
    }

    debugPrint('🛒 CheckoutViewModel: Proceeding to payment step');

    emit(currentState.copyWith(
      currentStep: CheckoutStep.payment,
      isShippingStepValid: true,
    ));
  }

  /// Select payment method
  void _selectPaymentMethod(String methodId) {
    final currentState = state;
    if (currentState is! CheckoutLoadedState) return;

    final selectedMethod = currentState.paymentMethods
        .where((m) => m.id == methodId && m.enabled)
        .firstOrNull;

    if (selectedMethod == null) return;

    debugPrint('🛒 CheckoutViewModel: Selected payment method: ${selectedMethod.title}');

    emit(currentState.copyWith(
      selectedPaymentMethodId: methodId,
    ));
  }

  /// Proceed to summary step
  void proceedToSummary() => _proceedToSummary();

  void _proceedToSummary() {
    final currentState = state;
    if (currentState is! CheckoutLoadedState) return;

    if (currentState.selectedPaymentMethodId == null) {
      debugPrint('⚠️ CheckoutViewModel: No payment method selected');
      return;
    }

    debugPrint('🛒 CheckoutViewModel: Proceeding to summary step');

    emit(currentState.copyWith(
      currentStep: CheckoutStep.summary,
      isPaymentStepValid: true,
    ));
  }

  /// Navigate to a specific step
  void _goToStep(CheckoutStep step) {
    final currentState = state;
    if (currentState is! CheckoutLoadedState) return;

    // Validate step navigation
    if (step == CheckoutStep.shipping && !currentState.isAddressStepValid) {
      debugPrint('⚠️ CheckoutViewModel: Cannot go to shipping, address not valid');
      return;
    }
    if (step == CheckoutStep.payment && !currentState.isShippingStepValid) {
      debugPrint('⚠️ CheckoutViewModel: Cannot go to payment, shipping not valid');
      return;
    }

    debugPrint('🛒 CheckoutViewModel: Navigating to step: ${step.name}');

    emit(currentState.copyWith(currentStep: step));
  }

  @override
  CheckoutState? fromJson(Map<String, dynamic> json) {
    return null;
  }

  /// Process order with selected payment method
  Future<void> _processOrder({
    required String billingEmail,
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> shippingAddress,
  }) async {
    final currentState = state;
    final selectedPaymentMethodId = currentState is CheckoutLoadedState 
        ? currentState.selectedPaymentMethodId 
        : 'bacs';

    try {
      emit(CheckoutProcessingOrderState());

      debugPrint('🛒 CheckoutViewModel: Processing order...');

      // Get API version from config
      final apiVersion = _configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Ensure cart token exists
      await _ensureCartToken(apiVersion);

      // Normalize state codes
      final normalizedBillingState = _normalizeStateCode(
        billingAddress['state'] as String?,
        billingAddress['city'] as String?,
      );
      final normalizedShippingState = _normalizeStateCode(
        shippingAddress['state'] as String?,
        shippingAddress['city'] as String?,
      );

      // Check if shipping address is empty
      final isShippingEmpty = (shippingAddress['first_name'] as String? ?? '').isEmpty &&
          (shippingAddress['last_name'] as String? ?? '').isEmpty &&
          (shippingAddress['address_1'] as String? ?? '').isEmpty;

      final effectiveShippingAddress = isShippingEmpty ? billingAddress : shippingAddress;
      final effectiveShippingState = isShippingEmpty ? normalizedBillingState : normalizedShippingState;

      // Convert addresses to IngAddress format
      final billingIngAddress = request_model.IngAddress(
        firstName: billingAddress['first_name'] as String?,
        lastName: billingAddress['last_name'] as String?,
        company: billingAddress['company'] as String?,
        address1: billingAddress['address_1'] as String?,
        address2: billingAddress['address_2'] as String?,
        city: billingAddress['city'] as String?,
        state: normalizedBillingState,
        postcode: billingAddress['postcode'] as String?,
        country: billingAddress['country'] as String?,
        email: billingEmail,
        phone: billingAddress['phone'] as String?,
      );

      final shippingIngAddress = request_model.IngAddress(
        firstName: effectiveShippingAddress['first_name'] as String?,
        lastName: effectiveShippingAddress['last_name'] as String?,
        company: effectiveShippingAddress['company'] as String?,
        address1: effectiveShippingAddress['address_1'] as String?,
        address2: effectiveShippingAddress['address_2'] as String?,
        city: effectiveShippingAddress['city'] as String?,
        state: effectiveShippingState,
        postcode: effectiveShippingAddress['postcode'] as String?,
        country: effectiveShippingAddress['country'] as String? ?? billingAddress['country'] as String?,
        email: billingEmail,
        phone: effectiveShippingAddress['phone'] as String? ?? billingAddress['phone'] as String?,
      );

      // Create request model with selected payment method
      final request = request_model.ProcessPaymentAndOrderRequestModel(
        orderId: null,
        status: null,
        orderKey: null,
        orderNumber: null,
        customerId: null,
        billingAddress: billingIngAddress,
        shippingAddress: shippingIngAddress,
        paymentMethod: selectedPaymentMethodId ?? 'bacs',
        customerNote: null,
        shippingLines: null,
        paymentResult: null,
        additionalFields: null,
        experimentalCart: null,
        extensions: null,
      );

      debugPrint('🛒 CheckoutViewModel: Sending order request with payment method: $selectedPaymentMethodId');

      // Process payment and create order
      ProcessPaymentAndOrderResponseModel response;
      try {
        response = await _checkoutDataService.processPaymentAndOrder(
          apiVersion: apiVersion,
          requestData: request,
        );
        debugPrint('🛒 CheckoutViewModel: ✅ Order processed successfully!');
        debugPrint('🛒 Order ID: ${response.orderId}');
        debugPrint('🛒 Order Key: ${response.orderKey}');
        debugPrint('🛒 Status: ${response.status}');
        debugPrint('🛒 Response experimentalCart type: ${response.experimentalCart?.runtimeType}');
      } catch (parseError, parseStack) {
        debugPrint('❌ CheckoutViewModel: Error parsing API response: $parseError');
        debugPrint('❌ Parse stack trace: $parseStack');
        // Re-throw to be caught by outer catch block
        rethrow;
      }

      final totalAmount = _arguments['totalAmount'] as double? ?? 0.0;
      final shippingCost = currentState is CheckoutLoadedState 
          ? currentState.shippingCost 
          : 0.0;
      final currencySymbol = _arguments['currencySymbol'] as String?;
      final currencyCode = _arguments['currencyCode'] as String?;

      emit(CheckoutOrderCompletedState(
        orderId: response.orderId ?? 0,
        orderKey: response.orderKey ?? '',
        status: response.status ?? 'pending',
        totalAmount: totalAmount + shippingCost,
        currencySymbol: currencySymbol,
        currencyCode: currencyCode,
      ));
    } catch (e, stackTrace) {
      debugPrint('❌ CheckoutViewModel: Error processing order: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      debugPrint('❌ Stack trace: $stackTrace');

      String errorMessage = 'Failed to process order. Please try again.';
      bool isEmailError = false;

      if (e is DioException) {
        debugPrint('❌ DioException details:');
        debugPrint('   - Status code: ${e.response?.statusCode}');
        debugPrint('   - Status message: ${e.response?.statusMessage}');
        debugPrint('   - Response data type: ${e.response?.data?.runtimeType}');
        
        if (e.response?.statusCode == 500) {
          debugPrint('❌ Server returned 500 Internal Server Error');
          if (e.response?.data != null) {
            try {
              debugPrint('❌ Response data: ${e.response!.data}');
              if (e.response!.data is Map<String, dynamic>) {
                final data = e.response!.data as Map<String, dynamic>;
                debugPrint('❌ Response data keys: ${data.keys.toList()}');
                
                // Check if error is related to PHPMailer/email sending
                final errorData = data['data'] as Map<String, dynamic>?;
                if (errorData != null) {
                  final errorInfo = errorData['error'] as Map<String, dynamic>?;
                  if (errorInfo != null) {
                    final errorMsg = errorInfo['message'] as String? ?? '';
                    debugPrint('❌ Error message from server: $errorMsg');
                    
                    // Check if it's a PHPMailer/email error
                    if (errorMsg.contains('PHPMailer') || 
                        errorMsg.contains('mail()') ||
                        errorMsg.contains('wp_mail') ||
                        errorMsg.contains('WC_Email')) {
                      isEmailError = true;
                      debugPrint('✅ Detected email sending error - order might still be created');
                      
                      // Try to extract order ID from error stack trace or check if order exists
                      // The order might have been created before the email error
                      // We'll treat this as a partial success
                    }
                  }
                }
                
                final apiMsg = data['message'] as String?;
                if (apiMsg != null && apiMsg.isNotEmpty && !isEmailError) {
                  errorMessage = apiMsg;
                }
              } else if (e.response!.data is String) {
                debugPrint('❌ Response data (string): ${e.response!.data}');
                final dataStr = e.response!.data as String;
                if (dataStr.contains('PHPMailer') || dataStr.contains('mail()')) {
                  isEmailError = true;
                  debugPrint('✅ Detected email sending error from string response');
                } else {
                  errorMessage = 'Server error: $dataStr';
                }
              }
            } catch (logError) {
              debugPrint('❌ Error logging response data: $logError');
            }
          }
          
          // If it's an email error, treat as partial success
          if (isEmailError) {
            debugPrint('⚠️ Email sending failed but order might be created. Checking order status...');
            // Note: In a real scenario, you might want to verify the order was created
            // by checking the order ID or making a separate API call
            // For now, we'll show a warning but still treat it as an error
            errorMessage = 'Sipariş oluşturuldu ancak onay e-postası gönderilemedi. Lütfen siparişlerinizi kontrol edin.';
          } else {
            errorMessage = 'Sunucu hatası (500). Lütfen daha sonra tekrar deneyin.';
          }
        } else if (e.response?.data is Map<String, dynamic>) {
          final data = e.response!.data as Map<String, dynamic>;
          final apiMsg = data['message'] as String?;
          if (apiMsg != null && apiMsg.isNotEmpty) {
            errorMessage = apiMsg;
            if (apiMsg.contains('state') || apiMsg.contains('durum')) {
              errorMessage = 'İl/eyalet kodu geçersiz. Lütfen geçerli bir il seçin (örn: TR34, TR06).';
            }
          }
        }
      } else if (e is FormatException || e.toString().contains('fromJson') || e.toString().contains('parsing')) {
        debugPrint('❌ JSON parsing error detected');
        errorMessage = 'Sipariş yanıtı işlenirken bir hata oluştu. Lütfen tekrar deneyin.';
      }

      emit(CheckoutErrorState(
        message: errorMessage,
        failedAtStep: CheckoutStep.payment,
      ));
    }
  }

  /// Ensure cart token exists
  Future<void> _ensureCartToken(String apiVersion) async {
    try {
      final existingToken = await WooCartTokenStorage.loadCartToken();
      if (existingToken != null && existingToken.cartToken.isNotEmpty) {
        if (existingToken.expiresAt != null &&
            DateTime.now().isAfter(existingToken.expiresAt!)) {
          await WooCartTokenStorage.clearCartToken();
        } else {
          return;
        }
      }

      await _cartService.getCart(apiVersion: apiVersion);
      final cartToken = await WooCartTokenStorage.loadCartToken();
      if (cartToken == null || cartToken.cartToken.isEmpty) {
        throw Exception('Cart token could not be retrieved');
      }
    } catch (e) {
      debugPrint('❌ Error ensuring cart token: $e');
    }
  }

  /// Normalize state code
  String? _normalizeStateCode(String? state, String? city) {
    if (state == null || state.isEmpty) {
      return _getStateCodeFromCity(city);
    }

    if (state.toUpperCase().startsWith('TR') && state.length >= 4) {
      final code = state.toUpperCase().substring(0, 4);
      if (code.length == 4 && int.tryParse(code.substring(2)) != null) {
        return code;
      }
    }

    return _getStateCodeFromCityOrState(state, city);
  }

  String? _getStateCodeFromCity(String? city) {
    if (city == null || city.isEmpty) return null;
    final cityLower = city.toLowerCase().trim();
    if (cityLower.contains('istanbul') || cityLower.contains('i̇stanbul')) return 'TR34';
    if (cityLower.contains('ankara')) return 'TR06';
    if (cityLower.contains('izmir') || cityLower.contains('i̇zmir')) return 'TR35';
    if (cityLower.contains('esenler')) return 'TR34';
    return null;
  }

  String? _getStateCodeFromCityOrState(String? state, String? city) {
    if (state == null || state.isEmpty) {
      return _getStateCodeFromCity(city);
    }

    final stateLower = state.toLowerCase().trim();
    final cityLower = city?.toLowerCase().trim() ?? '';

    final stateMap = {
      'istanbul': 'TR34',
      'i̇stanbul': 'TR34',
      'ankara': 'TR06',
      'izmir': 'TR35',
      'i̇zmir': 'TR35',
      'esenler': 'TR34',
    };

    if (stateMap.containsKey(stateLower)) {
      return stateMap[stateLower];
    }
    if (cityLower.isNotEmpty && stateMap.containsKey(cityLower)) {
      return stateMap[cityLower];
    }

    for (final entry in stateMap.entries) {
      if (stateLower.contains(entry.key) || cityLower.contains(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }

  @override
  Map<String, dynamic>? toJson(CheckoutState state) {
    return null;
  }
}

