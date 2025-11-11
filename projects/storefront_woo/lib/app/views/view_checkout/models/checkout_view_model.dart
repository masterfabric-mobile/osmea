/*
 * CheckoutViewModel
 * -----------------
 * ViewModel for the checkout view following OSMEA architecture.
 * Uses Bloc pattern with events and states from core package.
 * Integrates with APIs package for checkout operations.
 */

import 'package:flutter/foundation.dart';
import 'package:apis/network/remote/woocommerce/store_api/checkout_data_api/abstract/checkout_data_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/checkout_order_api/abstract/checkout_order_service.dart';
import 'package:apis/network/remote/woocommerce/store_api/checkout_data_api/freezed_model/request/update_checkout_data_request_model.dart'
    as update_checkout_data_request_model;
import 'package:apis/network/remote/woocommerce/store_api/checkout_order_api/freezed_model/request/process_payment_and_order_request_model.dart'
    as process_payment_and_order_request_model;
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_woo/app/views/view_checkout/models/module/states.dart';
import 'package:apis/apis.dart';

@injectable
class CheckoutViewModel extends BaseViewModelHydratedCubit<CheckoutState> {
  CheckoutViewModel() : super(CheckoutInitialState());

  // Dependencies
  final CheckoutDataService _checkoutDataService = GetIt.I<CheckoutDataService>();
  final CheckoutOrderService _checkoutOrderService = GetIt.I<CheckoutOrderService>();
  final AssetConfigHelper _configHelper = AssetConfigHelper();

  // Arguments holder for route/widget inputs
  final Map<String, dynamic> _arguments = {};
  void setArguments(Map<String, dynamic> args) {
    _arguments
      ..clear()
      ..addAll(args);
  }

  Map<String, dynamic> get arguments => Map.unmodifiable(_arguments);

  // Public trigger functions - HydratedCubit pattern
  void loadCheckoutData() => _loadCheckoutData();
  void updateCheckoutData({
    String? billingFirstName,
    String? billingLastName,
    String? billingEmail,
    String? billingPhone,
    String? billingAddress1,
    String? billingAddress2,
    String? billingCity,
    String? billingState,
    String? billingPostcode,
    String? billingCountry,
    String? shippingFirstName,
    String? shippingLastName,
    String? shippingAddress1,
    String? shippingAddress2,
    String? shippingCity,
    String? shippingState,
    String? shippingPostcode,
    String? shippingCountry,
    String? paymentMethod,
    String? orderNotes,
  }) => _updateCheckoutData(
        billingFirstName: billingFirstName,
        billingLastName: billingLastName,
        billingEmail: billingEmail,
        billingPhone: billingPhone,
        billingAddress1: billingAddress1,
        billingAddress2: billingAddress2,
        billingCity: billingCity,
        billingState: billingState,
        billingPostcode: billingPostcode,
        billingCountry: billingCountry,
        shippingFirstName: shippingFirstName,
        shippingLastName: shippingLastName,
        shippingAddress1: shippingAddress1,
        shippingAddress2: shippingAddress2,
        shippingCity: shippingCity,
        shippingState: shippingState,
        shippingPostcode: shippingPostcode,
        shippingCountry: shippingCountry,
        paymentMethod: paymentMethod,
        orderNotes: orderNotes,
      );
  void processPaymentAndOrder({
    String? billingEmail,
    String? paymentMethod,
  }) => _processPaymentAndOrder(
        billingEmail: billingEmail,
        paymentMethod: paymentMethod,
      );

  // Private methods - HydratedCubit pattern
  Future<void> _loadCheckoutData() async {
    try {
      debugPrint('💳 CheckoutViewModel: Loading checkout data...');
      emit(CheckoutLoadingState());

      final apiVersion = _configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      debugPrint('💳 CheckoutViewModel: Calling getCheckoutData API...');
      final checkoutData = await _checkoutDataService.getCheckoutData(
        apiVersion: apiVersion,
        orderKey: null, // Get current checkout data
      );

      debugPrint('💳 CheckoutViewModel: Checkout data loaded successfully');
      debugPrint('💳 CheckoutViewModel: Order Key: ${checkoutData.orderKey}');
      debugPrint('💳 CheckoutViewModel: Payment Method: ${checkoutData.paymentMethod}');

      // Extract address data from checkout data
      final billingAddress = checkoutData.billingAddress;
      final shippingAddress = checkoutData.shippingAddress;

      emit(CheckoutLoadedState(
        checkoutData: checkoutData,
        billingFirstName: billingAddress?.firstName,
        billingLastName: billingAddress?.lastName,
        billingEmail: billingAddress?.email,
        billingPhone: billingAddress?.phone,
        billingAddress1: billingAddress?.address1,
        billingAddress2: billingAddress?.address2,
        billingCity: billingAddress?.city,
        billingState: billingAddress?.state,
        billingPostcode: billingAddress?.postcode,
        billingCountry: billingAddress?.country,
        shippingFirstName: shippingAddress?.firstName,
        shippingLastName: shippingAddress?.lastName,
        shippingAddress1: shippingAddress?.address1,
        shippingAddress2: shippingAddress?.address2,
        shippingCity: shippingAddress?.city,
        shippingState: shippingAddress?.state,
        shippingPostcode: shippingAddress?.postcode,
        shippingCountry: shippingAddress?.country,
        paymentMethod: checkoutData.paymentMethod,
        orderNotes: checkoutData.customerNote,
      ));
    } catch (e) {
      debugPrint('❌ CheckoutViewModel: Error loading checkout data: $e');
      emit(CheckoutErrorState(message: 'Failed to load checkout data: $e'));
    }
  }

  Future<void> _updateCheckoutData({
    String? billingFirstName,
    String? billingLastName,
    String? billingEmail,
    String? billingPhone,
    String? billingAddress1,
    String? billingAddress2,
    String? billingCity,
    String? billingState,
    String? billingPostcode,
    String? billingCountry,
    String? shippingFirstName,
    String? shippingLastName,
    String? shippingAddress1,
    String? shippingAddress2,
    String? shippingCity,
    String? shippingState,
    String? shippingPostcode,
    String? shippingCountry,
    String? paymentMethod,
    String? orderNotes,
  }) async {
    try {
      debugPrint('💳 CheckoutViewModel: Updating checkout data...');

      final apiVersion = _configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Get current state
      final currentState = state;
      if (currentState is! CheckoutLoadedState) {
        debugPrint('⚠️ CheckoutViewModel: Cannot update - not in loaded state');
        return;
      }

      // Build billing address
      final billingAddress = update_checkout_data_request_model.IngAddress(
        firstName: billingFirstName ?? currentState.billingFirstName,
        lastName: billingLastName ?? currentState.billingLastName,
        email: billingEmail ?? currentState.billingEmail,
        phone: billingPhone ?? currentState.billingPhone,
        address1: billingAddress1 ?? currentState.billingAddress1,
        address2: billingAddress2 ?? currentState.billingAddress2,
        city: billingCity ?? currentState.billingCity,
        state: billingState ?? currentState.billingState,
        postcode: billingPostcode ?? currentState.billingPostcode,
        country: billingCountry ?? currentState.billingCountry,
      );

      // Build shipping address
      final shippingAddress = update_checkout_data_request_model.IngAddress(
        firstName: shippingFirstName ?? currentState.shippingFirstName,
        lastName: shippingLastName ?? currentState.shippingLastName,
        address1: shippingAddress1 ?? currentState.shippingAddress1,
        address2: shippingAddress2 ?? currentState.shippingAddress2,
        city: shippingCity ?? currentState.shippingCity,
        state: shippingState ?? currentState.shippingState,
        postcode: shippingPostcode ?? currentState.shippingPostcode,
        country: shippingCountry ?? currentState.shippingCountry,
      );

      // Build update request
      final updateRequest = update_checkout_data_request_model.UpdateCheckoutDataRequestModel(
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod ?? currentState.paymentMethod,
        orderNotes: orderNotes ?? currentState.orderNotes,
      );

      debugPrint('💳 CheckoutViewModel: Calling updateCheckoutData API...');
      await _checkoutDataService.updateCheckoutData(
        apiVersion: apiVersion,
        requestData: updateRequest,
      );

      debugPrint('💳 CheckoutViewModel: Checkout data updated successfully');

      // Reload checkout data to get latest state
      await _loadCheckoutData();
    } catch (e) {
      debugPrint('❌ CheckoutViewModel: Error updating checkout data: $e');
      emit(CheckoutErrorState(message: 'Failed to update checkout data: $e'));
    }
  }

  Future<void> _processPaymentAndOrder({
    String? billingEmail,
    String? paymentMethod,
  }) async {
    try {
      debugPrint('💳 CheckoutViewModel: Processing payment and order...');
      emit(CheckoutProcessingState());

      final apiVersion = _configHelper.getString(
        'woocommerce_configuration.version',
        'v1',
      );

      // Get current state
      final currentState = state;
      if (currentState is! CheckoutLoadedState) {
        debugPrint('⚠️ CheckoutViewModel: Cannot process - not in loaded state');
        emit(CheckoutErrorState(message: 'Checkout data not loaded'));
        return;
      }

      // Get cart token for order key
      final cartToken = await _getCartToken();
      if (cartToken == null || cartToken.isEmpty) {
        debugPrint('⚠️ CheckoutViewModel: No cart token found');
        emit(CheckoutErrorState(message: 'Cart token not found'));
        return;
      }

      // Build billing address
      final billingAddress = process_payment_and_order_request_model.IngAddress(
        firstName: currentState.billingFirstName,
        lastName: currentState.billingLastName,
        email: billingEmail ?? currentState.billingEmail,
        phone: currentState.billingPhone,
        address1: currentState.billingAddress1,
        address2: currentState.billingAddress2,
        city: currentState.billingCity,
        state: currentState.billingState,
        postcode: currentState.billingPostcode,
        country: currentState.billingCountry,
      );

      // Build shipping address
      final shippingAddress = process_payment_and_order_request_model.IngAddress(
        firstName: currentState.shippingFirstName,
        lastName: currentState.shippingLastName,
        address1: currentState.shippingAddress1,
        address2: currentState.shippingAddress2,
        city: currentState.shippingCity,
        state: currentState.shippingState,
        postcode: currentState.shippingPostcode,
        country: currentState.shippingCountry,
      );

      // Build process payment request
      final processRequest = process_payment_and_order_request_model.ProcessPaymentAndOrderRequestModel(
        key: cartToken, // Use cart token as order key
        billingEmail: billingEmail ?? currentState.billingEmail,
        billingAddress: billingAddress,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod ?? currentState.paymentMethod ?? 'bacs',
        paymentData: null,
      );

      debugPrint('💳 CheckoutViewModel: Calling processPaymentAndOrder API...');
      final result = await _checkoutOrderService.processPaymentAndOrder(
        apiVersion: apiVersion,
        requestData: processRequest,
      );

      debugPrint('💳 CheckoutViewModel: Payment and order processed successfully');
      debugPrint('💳 CheckoutViewModel: Order Key: ${result.orderKey}');
      debugPrint('💳 CheckoutViewModel: Order ID: ${result.orderId}');

      emit(CheckoutSuccessState(
        orderKey: result.orderKey ?? '',
        orderId: result.orderId,
        orderNumber: result.orderId?.toString(),
        message: 'Order placed successfully!',
      ));
    } catch (e) {
      debugPrint('❌ CheckoutViewModel: Error processing payment and order: $e');
      emit(CheckoutErrorState(message: 'Failed to process payment: $e'));
    }
  }


  /// Gets cart token from storage
  Future<String?> _getCartToken() async {
    try {
      final wooCartToken = await WooCartTokenStorage.loadCartToken();
      if (wooCartToken != null && wooCartToken.cartToken.isNotEmpty) {
        return wooCartToken.cartToken;
      }
      return null;
    } catch (e) {
      debugPrint('⚠️ CheckoutViewModel: Could not get cart token: $e');
      return null;
    }
  }

  @override
  CheckoutState? fromJson(Map<String, dynamic> json) {
    return null; // State will be reconstructed from API
  }

  @override
  Map<String, dynamic>? toJson(CheckoutState state) {
    return null; // No need to persist checkout state
  }
}

