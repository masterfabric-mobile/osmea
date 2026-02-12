/*
 * CheckoutViewModel
 * -----------------
 * Checkout flow: Address -> Shipping -> Payment -> Summary -> Place order in Supabase.
 */

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/app/models/product.dart';
import 'package:storefront_supabase/app/models/user_address.dart';
import 'package:storefront_supabase/app/views/view_checkout/models/states.dart';

@injectable
class CheckoutViewModel extends BaseViewModelCubit<CheckoutState> {
  CheckoutViewModel(this._supabaseClient) : super(CheckoutInitialState());

  final SupabaseClient _supabaseClient;
  final Map<String, dynamic> _arguments = {};

  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  void loadCheckout() => _loadCheckout();
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
  
  void selectBillingAddress(String? addressId) => _selectBillingAddress(addressId);
  void selectShippingAddress(String? addressId) => _selectShippingAddress(addressId);
  void selectShippingMethod(String methodId) => _selectShippingMethod(methodId);
  void proceedToPayment() => _proceedToPayment();
  void selectPaymentMethod(String methodId) => _selectPaymentMethod(methodId);
  void proceedToSummary() => _proceedToSummary();
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

  Future<void> _loadCheckout() async {
    try {
      emit(CheckoutLoadingState());
      final userId = _supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(CheckoutErrorState(message: 'Please sign in to checkout.'));
        return;
      }

      final totalAmount = (_arguments['totalAmount'] as num?)?.toDouble() ?? 0.0;
      final currencySymbol = _arguments['currencySymbol'] as String?;
      final currencyCode = _arguments['currencyCode'] as String?;

      final response = await _supabaseClient
          .from('cart')
          .select('id, quantity, variant_id, products(*, product_images(*))')
          .eq('user_id', userId);

      final lineItems = <CheckoutLineItem>[];
      for (final itemData in (response as List)) {
        if (itemData['products'] != null) {
          final product = Product.fromJson(itemData['products'] as Map<String, dynamic>);
          final qty = itemData['quantity'] as int;
          final unitPrice = product.effectivePrice;
          lineItems.add(CheckoutLineItem(
            key: itemData['id'] as String,
            productId: product.id,
            name: product.name,
            quantity: qty,
            imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls.first : null,
            unitPrice: unitPrice,
          ));
        }
      }

      final shippingMethods = _getDefaultShippingMethods();
      final paymentMethods = _getDefaultPaymentMethods();

      // Load user addresses
      List<UserAddress>? userAddresses;
      try {
        final addressesResponse = await _supabaseClient
            .from('user_addresses')
            .select()
            .eq('user_id', userId)
            .order('is_default', ascending: false)
            .order('created_at', ascending: false);
        
        userAddresses = (addressesResponse as List)
            .map((json) => UserAddress.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error loading user addresses: $e');
      }

      emit(CheckoutLoadedState(
        currentStep: CheckoutStep.address,
        subtotalAmount: totalAmount,
        shippingCost: 0.0,
        totalAmount: totalAmount,
        currencySymbol: currencySymbol,
        currencyCode: currencyCode,
        lineItems: lineItems,
        userAddresses: userAddresses,
        shippingMethods: shippingMethods,
        paymentMethods: paymentMethods,
        isAddressStepValid: false,
        isShippingStepValid: false,
        isPaymentStepValid: false,
      ));
    } catch (e) {
      debugPrint('CheckoutViewModel loadCheckout error: $e');
      emit(CheckoutErrorState(message: 'Failed to load checkout. Please try again.'));
    }
  }

  List<ShippingMethod> _getDefaultShippingMethods() {
    return const [
      ShippingMethod(
        id: 'standard',
        title: 'Standard Shipping',
        description: 'Delivery to your address',
        cost: 29.90,
        deliveryTime: '3-5 business days',
      ),
      ShippingMethod(
        id: 'express',
        title: 'Express Shipping',
        description: 'Fast delivery',
        cost: 59.90,
        deliveryTime: '1-2 business days',
      ),
      ShippingMethod(
        id: 'free',
        title: 'Free Shipping',
        description: 'Free on orders over \$100',
        cost: 0.0,
        deliveryTime: '5-7 business days',
      ),
    ];
  }

  List<PaymentMethod> _getDefaultPaymentMethods() {
    return const [
      PaymentMethod(id: 'bank', title: 'Bank Transfer', description: 'Direct bank transfer', icon: 'account_balance', enabled: true),
      PaymentMethod(id: 'cod', title: 'Cash on Delivery', description: 'Pay when you receive', icon: 'payments', enabled: true),
      PaymentMethod(id: 'card', title: 'Credit Card', description: 'Pay with card', icon: 'credit_card', enabled: false),
    ];
  }

  void _selectBillingAddress(String? addressId) {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    
    // If addressId is null, clear selection
    if (addressId == null) {
      emit(s.copyWith(
        selectedBillingAddressId: null,
        billingAddress: null,
      ));
      return;
    }
    
    // If clicking the same address, deselect it
    if (s.selectedBillingAddressId == addressId) {
      emit(s.copyWith(
        selectedBillingAddressId: null,
        billingAddress: null,
      ));
      return;
    }
    
    // Select new address
    if (s.userAddresses == null) return;
    
    UserAddress? selectedAddress;
    try {
      selectedAddress = s.userAddresses!.firstWhere((a) => a.id == addressId);
    } catch (_) {
      // Address not found, return without changing state
      return;
    }
    
    emit(s.copyWith(
      selectedBillingAddressId: addressId,
      billingAddress: selectedAddress.toCheckoutMap(),
      billingEmail: _supabaseClient.auth.currentUser?.email,
    ));
  }

  void _selectShippingAddress(String? addressId) {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    
    // If addressId is null, clear selection
    if (addressId == null) {
      emit(s.copyWith(
        selectedShippingAddressId: null,
        shippingAddress: null,
      ));
      return;
    }
    
    // If clicking the same address, deselect it
    if (s.selectedShippingAddressId == addressId) {
      emit(s.copyWith(
        selectedShippingAddressId: null,
        shippingAddress: null,
      ));
      return;
    }
    
    // Select new address
    if (s.userAddresses == null) return;
    
    UserAddress? selectedAddress;
    try {
      selectedAddress = s.userAddresses!.firstWhere((a) => a.id == addressId);
    } catch (_) {
      // Address not found, return without changing state
      return;
    }
    
    emit(s.copyWith(
      selectedShippingAddressId: addressId,
      shippingAddress: selectedAddress.toCheckoutMap(),
    ));
  }

  void _updateAddressAndProceed({
    required String billingEmail,
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> shippingAddress,
    required bool sameAsBilling,
  }) {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    emit(s.copyWith(
      currentStep: CheckoutStep.shipping,
      billingEmail: billingEmail,
      billingAddress: billingAddress,
      shippingAddress: shippingAddress,
      sameAsBilling: sameAsBilling,
      isAddressStepValid: true,
    ));
  }

  void _selectShippingMethod(String methodId) {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    ShippingMethod? method;
    try {
      method = s.shippingMethods.firstWhere((m) => m.id == methodId);
    } catch (_) {
      return;
    }
    emit(s.copyWith(
      selectedShippingMethodId: methodId,
      shippingCost: method.cost,
      totalAmount: s.subtotalAmount + method.cost,
    ));
  }

  void _proceedToPayment() {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    if (s.selectedShippingMethodId == null) return;
    emit(s.copyWith(currentStep: CheckoutStep.payment, isShippingStepValid: true));
  }

  void _selectPaymentMethod(String methodId) {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    final found = s.paymentMethods.any((m) => m.id == methodId && m.enabled);
    if (!found) return;
    emit(s.copyWith(selectedPaymentMethodId: methodId));
  }

  void _proceedToSummary() {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    if (s.selectedPaymentMethodId == null) return;
    emit(s.copyWith(currentStep: CheckoutStep.summary, isPaymentStepValid: true));
  }

  void _goToStep(CheckoutStep step) {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    if (step == CheckoutStep.shipping && !s.isAddressStepValid) return;
    if (step == CheckoutStep.payment && !s.isShippingStepValid) return;
    emit(s.copyWith(currentStep: step));
  }

  Future<void> _processOrder({
    required String billingEmail,
    required Map<String, dynamic> billingAddress,
    required Map<String, dynamic> shippingAddress,
  }) async {
    final s = state;
    if (s is! CheckoutLoadedState) return;
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(CheckoutErrorState(message: 'Please sign in to place order.'));
      return;
    }

    try {
      emit(CheckoutProcessingOrderState());

      final orderNumber = 'ORD-${DateTime.now().millisecondsSinceEpoch}';
      final subtotal = s.subtotalAmount;
      final shippingCost = s.shippingCost;
      final total = subtotal + shippingCost;
      final paymentMethod = s.selectedPaymentMethodId ?? 'bank';

      final orderRow = await _supabaseClient.from('orders').insert({
        'user_id': userId,
        'order_number': orderNumber,
        'status': 'pending',
        'subtotal': subtotal,
        'tax': 0,
        'shipping_cost': shippingCost,
        'total': total,
        'shipping_address': jsonEncode(shippingAddress),
        'billing_address': jsonEncode(billingAddress),
        'payment_method': paymentMethod,
        'payment_status': 'pending',
      }).select('id').single();

      final orderId = orderRow['id'] as String;

      for (final item in s.lineItems) {
        await _supabaseClient.from('order_items').insert({
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': item.name ?? 'Product',
          'quantity': item.quantity,
          'unit_price': item.unitPrice,
          'subtotal': item.subtotal,
        });
      }

      await _supabaseClient.from('cart').delete().eq('user_id', userId);

      emit(CheckoutOrderCompletedState(
        orderId: orderId,
        orderNumber: orderNumber,
        status: 'pending',
        totalAmount: total,
        currencySymbol: s.currencySymbol,
        currencyCode: s.currencyCode,
        lineItems: s.lineItems,
        shippingAddress: shippingAddress,
      ));
    } catch (e) {
      debugPrint('CheckoutViewModel processOrder error: $e');
      emit(CheckoutErrorState(
        message: 'Failed to place order. Please try again.',
        failedAtStep: CheckoutStep.summary,
      ));
    }
  }
}
