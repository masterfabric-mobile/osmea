import 'package:apis/network/remote/orders/order/freezed_model/request/create_cancel_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/update_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_count_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_list_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_single_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/update_order_response.dart';

abstract class OrderService {
  Future<CreateOrderResponse> createOrder({
    required String apiVersion,
    required CreateOrderRequest model,
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

  Future<CreateCancelOrderRequest> createCancelOrder({
    required String apiVersion,
    required String orderId,
    required CreateCancelOrderRequest model,
  });

  Future<void> deleteOrder({
    required String apiVersion,
    required String orderId,
  });
}
