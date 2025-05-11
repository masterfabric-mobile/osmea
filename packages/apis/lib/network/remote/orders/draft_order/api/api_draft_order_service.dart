import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/get_draft_order_count_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_custom_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_discounted_item_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_percent_discount_item_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_simple_product_variant_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_with_discount_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_invoice_customized_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_invoice_default_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/update_draft_order_complete_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/update_draft_order_modify_existing_request.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_custom_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_discounted_item_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_percent_discount_item_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_simple_product_variant_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_with_discount_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_invoice_customized_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_invoice_default_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/get_draft_order_list_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/get_draft_order_single_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/update_draft_order_complete_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/update_draft_order_modify_existing_response.dart';
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

  @override
  @POST('/api/{api_version}/draft_orders/{draft_order_id}/send_invoice.json')
  Future<CreateInvoiceCustomizedResponse> createInvoiceCustomized({
    @Path('api_version') required String apiVersion,
    @Path('draft_order_id') required String draftOrderId,
    @Body() required CreateInvoiceCustomizedRequest model,
  });

  @override
  @POST('/api/{api_version}/draft_orders/{draft_order_id}/send_invoice.json')
  Future<CreateInvoiceDefaultResponse> createInvoiceDefault({
    @Path('api_version') required String apiVersion,
    @Path('draft_order_id') required String draftOrderId,
    @Body() required CreateInvoiceDefaultRequest model,
  });

  @override
  @PUT('/api/{api_version}/draft_orders/{draft_order_id}.json')
  Future<UpdateDraftOrderModifyExistingResponse>
      updateDraftOrderModifyExisting({
    @Path('api_version') required String apiVersion,
    @Path('draft_order_id') required String draftOrderId,
    @Body() required UpdateDraftOrderModifyExistingRequest model,
  });
  @override
  @PUT('/api/{api_version}/draft_orders/{draft_order_id}/complete.json')
  Future<UpdateDraftOrderCompleteResponse> updateDraftOrderComplete({
    @Path('api_version') required String apiVersion,
    @Path('draft_order_id') required String draftOrderId,
    @Body() required UpdateDraftOrderCompleteRequest model,
  });

  @override
  @POST('/api/{api_version}/draft_orders.json')
  Future<CreateDraftOrderResponse> createDraftOrder({
    @Path('api_version') required String apiVersion,
    @Body() required CreateDraftOrderRequest model,
  });

  @override
  @GET('/api/{api_version}/draft_orders/count.json')
  Future<GetDraftOrderCountResponse> getDraftOrderCount({
    @Path('api_version') required String apiVersion,
    @Query('since_id') String? since_id,
    @Query('status') String? status,
    @Query('updated_at_min') String? updated_at_min,
    @Query('updated_at_max') String? updated_at_max,
  });

  @override
  @GET('/api/{api_version}/draft_orders/{draft_order_id}.json')
  Future<GetDraftOrderSingleResponse> getDraftOrderSingle({
    @Path('api_version') required String apiVersion,
    @Path('draft_order_id') required String draftOrderId,
  });

  @override
  @GET('/api/{api_version}/draft_orders.json')
  Future<GetDraftOrderListResponse> getDraftOrderList({
    @Path('api_version') required String apiVersion,
    @Query('since_id') String? since_id,
    @Query('status') String? status,
    @Query('updated_at_min') String? updated_at_min,
    @Query('updated_at_max') String? updated_at_max,
  });

  @override
  @DELETE('/api/{api_version}/draft_orders/{draft_order_id}.json')
  Future<void> deleteDraftOrder({
    @Path('api_version') required String apiVersion,
    @Path('draft_order_id') required String draftOrderId,
  });
}
