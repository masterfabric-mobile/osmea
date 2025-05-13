import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_cancel_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/update_order_request.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/create_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_count_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_list_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/get_single_order_response.dart';
import 'package:apis/network/remote/orders/order/freezed_model/response/update_order_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_order_service.g.dart';

@RestApi()
@Injectable(as: OrderService)

/// 🏭 Factory for dependency injection
abstract class OrderServiceClient implements OrderService {
  @factoryMethod
  factory OrderServiceClient(Dio dio) => _OrderServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @POST('/api/{api_version}/orders.json')
  Future<CreateOrderResponse> createOrder({
    @Path('api_version') required String apiVersion,
    @Body() required CreateOrderRequest model,
  });

  @override
  @GET('/api/{api_version}/orders/{order_id}.json')
  Future<GetSingleOrderResponse> getSingleOrder({
    @Path('api_version') required String apiVersion,
    @Path('order_id') required String orderId,
  });

  @override
  @PUT('/api/{api_version}/orders/{order_id}.json')
  Future<UpdateOrderResponse> updateOrder({
    @Path('api_version') required String apiVersion,
    @Path('order_id') required String orderId,
    @Body() required UpdateOrderRequest model,
  });

  @override
  @DELETE('/api/{api_version}/orders/{order_id}.json')
  Future<void> deleteOrder({
    @Path('api_version') required String apiVersion,
    @Path('order_id') required String orderId,
  });

  @override
  @GET('/api/{api_version}/orders.json')
  Future<GetListOrderResponse> getListOrders({
    @Path('api_version') required String apiVersion,
    @Query('ids') String? ids,
    @Query('name') String? name,
    @Query('limit') int? limit,
    @Query('since_id') String? since_id,
    @Query('created_at_min') String? created_at_min,
    @Query('created_at_max') String? created_at_max,
    @Query('updated_at_min') String? updated_at_min,
    @Query('updated_at_max') String? updated_at_max,
    @Query('processed_at_min') String? processed_at_min,
    @Query('processed_at_max') String? processed_at_max,
    @Query('attribution_app_id') String? attribution_app_id,
    @Query('status') String? status,
    @Query('financial_status') String? financial_status,
    @Query('fulfillment_status') String? fulfillment_status,
    @Query('fields') String? fields,
  });

  @override
  @GET('/api/{api_version}/orders/count.json')
  Future<GetCountOrderResponse> getCountOrders({
    @Path('api_version') required String apiVersion,
    @Query('since_id') String? since_id,
    @Query('created_at_min') String? created_at_min,
    @Query('created_at_max') String? created_at_max,
    @Query('updated_at_min') String? updated_at_min,
    @Query('updated_at_max') String? updated_at_max,
    @Query('processed_at_min') String? processed_at_min,
    @Query('processed_at_max') String? processed_at_max,
    @Query('attribution_app_id') String? attribution_app_id,
    @Query('status') String? status,
    @Query('financial_status') String? financial_status,
    @Query('fulfillment_status') String? fulfillment_status,
  });

  @override
  @POST('/api/{api_version}/orders/{order_id}/cancel.json')
  Future<CreateCancelOrderRequest> createCancelOrder({
    @Path('api_version') required String apiVersion,
    @Path('order_id') required String orderId,
    @Body() required CreateCancelOrderRequest model,
  });
}
