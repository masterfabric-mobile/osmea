import 'package:apis/network/remote/orders/order/freezed_model/request/create_cancel_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_close_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_comprehensive_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_fulfill_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_partially_paid_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_risk_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_sending_order_confirmation_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_with_pending_customer_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_with_product_id_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_with_tax_lines_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_without_order_receipt_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_reopen_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/update_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/update_order_risk_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_cancel_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_close_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_comprehensive_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_fulfill_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_partially_paid_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_risk_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_sending_order_confirmation_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_with_pending_customer_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_with_product_id_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_with_tax_lines_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_without_order_receipt_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_reopen_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_count_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_list_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_list_order_risks_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_single_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_single_order_risk_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/update_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/update_order_risk_response.dart';

abstract class OrderService {
  Future<CreateOrderResponse> createOrder({
    required String apiVersion,
    required CreateOrderRequest model,
  });

  Future<CreateOrderWithTaxLinesResponse> createOrderWithTaxLines({
    required String apiVersion,
    required CreateOrderWithTaxLinesRequest model,
  });

  Future<CreateOrderPartiallyPaidResponse> createOrderPartiallyPaid({
    required String apiVersion,
    required CreateOrderPartiallyPaidRequest model,
  });

  Future<CreateOrderComprehensiveResponse> createOrderComprehensive({
    required String apiVersion,
    required CreateOrderComprehensiveRequest model,
  });

  Future<CreateOrderWithProductIdResponse> createOrderWithProductId({
    required String apiVersion,
    required CreateOrderWithProductIdRequest model,
  });

  Future<CreateOrderWithoutOrderReceiptResponse>
      createOrderWithoutOrderReceipt({
    required String apiVersion,
    required CreateOrderWithoutOrderReceiptRequest model,
  });

  Future<CreateOrderSendingOrderConfirmationResponse>
      createOrderSendingOrderConfirmation({
    required String apiVersion,
    required CreateOrderSendingOrderConfirmationRequest model,
  });

  Future<CreateOrderFulfillResponse> createOrderFulfill({
    required String apiVersion,
    required CreateOrderFulfillRequest model,
  });

  Future<CreateOrderRiskResponse> createOrderRisk({
    required String apiVersion,
    required String orderId,
    required CreateOrderRiskRequest model,
  });

  Future<CreateOrderWithPendingCustomerResponse>
      createOrderWithPendingCustomer({
    required String apiVersion,
    required CreateOrderWithPendingCustomerRequest model,
  });

  Future<GetListOrderRisksResponse> getListOrderRisks({
    required String apiVersion,
    required String orderId,
  });

  Future<GetSingleOrderRiskResponse> getSingleOrderRisk({
    required String apiVersion,
    required String orderId,
    required String riskId,
  });

  Future<UpdateOrderRiskResponse> updateOrderRisk({
    required String apiVersion,
    required String orderId,
    required String riskId,
    required UpdateOrderRiskRequest model,
  });

  Future<GetSingleOrderResponse> getSingleOrder({
    required String apiVersion,
    required String orderId,
  });

  Future<GetListOrderResponse> getListOrders(
      {required String apiVersion,
      String? ids,
      String? name,
      int? limit,
      String? since_id,
      String? created_at_min,
      String? created_at_max,
      String? updated_at_min,
      String? updated_at_max,
      String? processed_at_min,
      String? processed_at_max,
      String? attribution_app_id,
      String? status,
      String? financial_status,
      String? fulfillment_status,
      String? fields});

  Future<GetCountOrderResponse> getCountOrders({
    required String apiVersion,
    String? created_at_min,
    String? created_at_max,
    String? updated_at_min,
    String? updated_at_max,
    String? status,
    String? financial_status,
    String? fulfillment_status,
  });

  Future<UpdateOrderResponse> updateOrder({
    required String apiVersion,
    required String orderId,
    required UpdateOrderRequest model,
  });

  Future<CreateCancelOrderResponse> createCancelOrder({
    required String apiVersion,
    required String orderId,
    required CreateCancelOrderRequest model,
  });

  Future<CreateCloseOrderResponse> createCloseOrder({
    required String apiVersion,
    required String orderId,
    required CreateCloseOrderRequest model,
  });

  Future<CreateReopenOrderResponse> createReopenOrder({
    required String apiVersion,
    required String orderId,
    required CreateReopenOrderRequest model,
  });

  Future<void> deleteOrderRisk({
    required String apiVersion,
    required String orderId,
    required String riskId,
  });

  Future<void> deleteOrder({
    required String apiVersion,
    required String orderId,
  });
}
