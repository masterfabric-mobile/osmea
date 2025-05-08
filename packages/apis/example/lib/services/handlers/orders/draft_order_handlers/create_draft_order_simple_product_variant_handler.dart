import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_simple_product_variant_request.dart'
    as create_request;
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_simple_product_variant_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateDraftOrderSimpleProductVariantHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        final int? variantId = params['variant_id'] != null
            ? int.tryParse(params['variant_id']!)
            : null;
        final int? quantity = params['quantity'] != null
            ? int.tryParse(params['quantity']!)
            : null;

        if (variantId == null || quantity == null) {
          return {
            "status": "error",
            "message": "Variant ID, and Quantity are required.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model =
              create_request.CreateDraftOrderSimpleProductVariantRequest(
            draftOrder: create_request.DraftOrder(
              lineItems: [
                create_request.LineItem(
                  variantId: variantId,
                  quantity: quantity,
                ),
              ],
            ),
          );

          final CreateDraftOrderSimpleProductVariantResponse response =
              await GetIt.I
                  .get<DraftOrderService>()
                  .createDraftOrderSimpleProductVariant(
                    apiVersion: apiVersion,
                    model: model,
                  );

          return {
            "status": "success",
            "message":
                "Draft order item with product variant created successfully",
            "draft_order": response.draftOrder?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to create draft order item with product variant: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Create Draft Order Item API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'variant_id',
            label: 'Variant ID',
            hint: 'Enter the ID of the product variant',
          ),
          const ApiField(
            name: 'quantity',
            label: 'Quantity',
            hint: 'Enter the quantity of the product variant',
          ),
        ],
      };
}
