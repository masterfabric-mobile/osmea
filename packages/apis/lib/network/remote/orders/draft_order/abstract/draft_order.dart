import 'package:apis/network/remote/orders/draft_order/freezed_model/get_draft_order_count_response.dart';
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

abstract class DraftOrderService {
  Future<CreateDraftOrderPercentDiscountItemResponse>
      createDraftOrderPercentDiscountItem({
    required String apiVersion,
    required CreateDraftOrderPercentDiscountItemRequest model,
  });
  Future<CreateDraftOrderSimpleProductVariantResponse>
      createDraftOrderSimpleProductVariant({
    required String apiVersion,
    required CreateDraftOrderSimpleProductVariantRequest model,
  });

  Future<CreateDraftOrderWithDiscountResponse> createDraftOrderWithDiscount({
    required String apiVersion,
    required CreateDraftOrderWithDiscountRequest model,
  });

  Future<CreateDraftOrderCustomResponse> createDraftOrderCustom({
    required String apiVersion,
    required CreateDraftOrderCustomRequest model,
  });
  Future<CreateDraftOrderDiscountedItemResponse>
      createDraftOrderDiscountedItem({
    required String apiVersion,
    required CreateDraftOrderDiscountedItemRequest model,
  });

  Future<CreateInvoiceCustomizedResponse> createInvoiceCustomized({
    required String apiVersion,
    required String draftOrderId,
    required CreateInvoiceCustomizedRequest model,
  });

  Future<CreateInvoiceDefaultResponse> createInvoiceDefault({
    required String apiVersion,
    required String draftOrderId,
    required CreateInvoiceDefaultRequest model,
  });

  Future<UpdateDraftOrderModifyExistingResponse>
      updateDraftOrderModifyExisting({
    required String apiVersion,
    required String draftOrderId,
    required UpdateDraftOrderModifyExistingRequest model,
  });

  Future<UpdateDraftOrderCompleteResponse> updateDraftOrderComplete({
    required String apiVersion,
    required String draftOrderId,
    required UpdateDraftOrderCompleteRequest model,
  });

  Future<CreateDraftOrderResponse> createDraftOrder({
    required String apiVersion,
    required CreateDraftOrderRequest model,
  });

  Future<GetDraftOrderCountResponse> getDraftOrderCount({
    required String apiVersion,
    String? since_id,
    String? status,
    String? updated_at_max,
    String? updated_at_min,
  });

  Future<GetDraftOrderSingleResponse> getDraftOrderSingle({
    required String apiVersion,
    required String draftOrderId,
  });

  Future<GetDraftOrderListResponse> getDraftOrderList({
    required String apiVersion,
    String? since_id,
    String? status,
    String? updated_at_max,
    String? updated_at_min,
  });
}
