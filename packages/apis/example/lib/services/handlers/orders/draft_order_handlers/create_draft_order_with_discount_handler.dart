import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';

import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_with_discount_request.dart'
    as create_request;
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_with_discount_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateDraftOrderWithDiscountHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? lineItemTitle = params['line_item_title'];
        final String? lineItemPrice = params['line_item_price'];
        final int? lineItemQuantity = params['line_item_quantity'] != null
            ? int.tryParse(params['line_item_quantity']!)
            : null;
        final String? discountDescription = params['discount_description'];
        final String? discountValueType = params['discount_value_type'];
        final String? discountValue = params['discount_value'];
        final int? customerId = params['customer_id'] != null
            ? int.tryParse(params['customer_id']!)
            : null;
        final bool? useCustomerDefaultAddress =
            params['use_customer_default_address']?.toLowerCase() == 'true';

        if (lineItemTitle == null ||
            lineItemTitle.isEmpty ||
            lineItemPrice == null ||
            lineItemPrice.isEmpty ||
            lineItemQuantity == null ||
            discountDescription == null ||
            discountDescription.isEmpty ||
            discountValueType == null ||
            discountValueType.isEmpty ||
            discountValue == null ||
            discountValue.isEmpty ||
            customerId == null) {
          return {
            "status": "error",
            "message":
                "Line Item Title, Price, Quantity, Discount Description, Value Type, Value, and Customer ID are required.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = create_request.CreateDraftOrderWithDiscountRequest(
            draftOrder: create_request.DraftOrder(
              lineItems: [
                create_request.LineItem(
                  title: lineItemTitle,
                  price: lineItemPrice,
                  quantity: lineItemQuantity,
                ),
              ],
              appliedDiscount: create_request.AppliedDiscount(
                description: discountDescription,
                valueType: discountValueType,
                value: discountValue,
              ),
              customer: create_request.Customer(id: customerId),
              useCustomerDefaultAddress: useCustomerDefaultAddress ?? false,
            ),
          );

          final CreateDraftOrderWithDiscountResponse response = await GetIt.I
              .get<DraftOrderService>()
              .createDraftOrderWithDiscount(
                apiVersion: apiVersion,
                model: model,
              );

          return {
            "status": "success",
            "message": "Draft order with discount created successfully",
            "draft_order": response.draftOrder?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message":
                "Failed to create draft order with discount: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Create Draft Order API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
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
            hint:
                'Enter the type of discount value (e.g., fixed_amount, percentage)',
          ),
          const ApiField(
            name: 'discount_value',
            label: 'Discount Value',
            hint: 'Enter the discount value',
          ),
          const ApiField(
            name: 'customer_id',
            label: 'Customer ID',
            hint: 'Enter the ID of the customer',
          ),
        ],
      };
}
