import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_discounted_item_request.dart'
    as create_request;
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_discounted_item_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateDraftOrderDiscountedItemHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? draftOrderId = params['draft_order_id'];
        final String? lineItemTitle = params['line_item_title'];
        final String? lineItemPrice = params['line_item_price'];
        final int? lineItemQuantity = params['line_item_quantity'] != null
            ? int.tryParse(params['line_item_quantity']!)
            : null;
        final String? discountDescription = params['discount_description'];
        final String? discountValueType = params['discount_value_type'];
        final String? discountValue = params['discount_value'];
        final String? discountAmount =
            params['discount_amount']; // Add amount if needed
        final String? discountTitle =
            params['discount_title']; // Add title if needed

        if (draftOrderId == null ||
            draftOrderId.isEmpty ||
            lineItemTitle == null ||
            lineItemTitle.isEmpty ||
            lineItemPrice == null ||
            lineItemPrice.isEmpty ||
            lineItemQuantity == null ||
            discountDescription == null ||
            discountDescription.isEmpty ||
            discountValueType == null ||
            discountValueType.isEmpty ||
            discountValue == null ||
            discountValue.isEmpty) {
          return {
            "status": "error",
            "message":
                "Draft Order ID, Line Item Title, Price, Quantity, Discount Description, Value Type, and Value are required.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = create_request.CreateDraftOrderDiscountedItemRequest(
            draftOrder: create_request.DraftOrder(
              lineItems: [
                create_request.LineItem(
                  title: lineItemTitle,
                  price: lineItemPrice,
                  quantity: lineItemQuantity,
                  appliedDiscount: create_request.AppliedDiscount(
                    description: discountDescription,
                    valueType: discountValueType,
                    value: discountValue,
                    amount: discountAmount,
                    title: discountTitle,
                  ),
                ),
              ],
            ),
          );

          final CreateDraftOrderDiscountedItemResponse response = await GetIt.I
              .get<DraftOrderService>()
              .createDraftOrderDiscountedItem(
                apiVersion: apiVersion,
                model: model,
              );

          return {
            "status": "success",
            "message": "Draft order item with discount created successfully",
            "draft_order": response.draftOrder?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          print("Error creating draft order item with discount: $e");
          return {
            "status": "error",
            "message":
                "Failed to create draft order item with discount: ${e.toString()}",
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
            name: 'draft_order_id',
            label: 'Draft Order ID',
            hint: 'Enter the ID of the draft order',
          ),
          const ApiField(
            name: 'line_item_title',
            label: 'Line Item Title',
            hint: 'Enter the title of the line item',
          ),
          const ApiField(
            name: 'line_item_price',
            label: 'Line Item Price',
            hint: 'Enter the price of the line item',
          ),
          const ApiField(
            name: 'line_item_quantity',
            label: 'Line Item Quantity',
            hint: 'Enter the quantity of the line item',
          ),
          const ApiField(
            name: 'discount_description',
            label: 'Discount Description',
            hint: 'Enter the description of the discount',
          ),
          const ApiField(
            name: 'discount_value_type',
            label: 'Discount Value Type',
            hint: 'Enter the type of discount value (e.g., fixed_amount)',
          ),
          const ApiField(
            name: 'discount_value',
            label: 'Discount Value',
            hint: 'Enter the discount value',
          ),
          // You might also need to add fields for 'discount_amount' and 'discount_title'
          // depending on your exact requirements and how you want to expose them.
        ],
      };
}
