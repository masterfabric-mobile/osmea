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
}
