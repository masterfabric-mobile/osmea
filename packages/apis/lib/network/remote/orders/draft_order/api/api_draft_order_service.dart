import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_custom_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_discounted_item_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_percent_discount_item_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_simple_product_variant_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_with_discount_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_custom_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_discounted_item_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_percent_discount_item_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_simple_product_variant_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_with_discount_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_draft_order_service.g.dart';

@RestApi()
@Injectable(as: DraftOrderService)
abstract class DraftOrderServiceClient implements DraftOrderService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory DraftOrderServiceClient(Dio dio) => _DraftOrderServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @POST('/api/{api_version}/draft_orders.json')
  Future<CreateDraftOrderPercentDiscountItemResponse>
      createDraftOrderPercentDiscountItem({
    @Path('api_version') required String apiVersion,
    @Body() required CreateDraftOrderPercentDiscountItemRequest model,
  });

  @override
  @POST('/api/{api_version}/draft_orders.json')
  Future<CreateDraftOrderSimpleProductVariantResponse>
      createDraftOrderSimpleProductVariant({
    @Path('api_version') required String apiVersion,
    @Body() required CreateDraftOrderSimpleProductVariantRequest model,
  });

  @override
  @POST('/api/{api_version}/draft_orders.json')
  Future<CreateDraftOrderWithDiscountResponse> createDraftOrderWithDiscount({
    @Path('api_version') required String apiVersion,
    @Body() required CreateDraftOrderWithDiscountRequest model,
  });
  @override
  @POST('/api/{api_version}/draft_orders.json')
  Future<CreateDraftOrderCustomResponse> createDraftOrderCustom({
    @Path('api_version') required String apiVersion,
    @Body() required CreateDraftOrderCustomRequest model,
  });
  @override
  @POST('/api/{api_version}/draft_orders.json')
  Future<CreateDraftOrderDiscountedItemResponse>
      createDraftOrderDiscountedItem({
    @Path('api_version') required String apiVersion,
    @Body() required CreateDraftOrderDiscountedItemRequest model,
  });
}
