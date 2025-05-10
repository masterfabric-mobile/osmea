import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/create_draft_order_request.dart'
    as create_request;
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/update_draft_order_modify_existing_request.dart'
    as update_request;
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/create_draft_order_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/get_draft_order_list_response.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/update_draft_order_modify_existing_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

import 'package:get_it/get_it.dart';

class CreateDraftOrderHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'GET':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? draftOrderId = params['id'];
        final String? status = params['status'];

        if (draftOrderId != null && draftOrderId.isNotEmpty) {
          try {
            final response =
                await GetIt.I.get<DraftOrderService>().getDraftOrderSingle(
                      apiVersion: apiVersion,
                      draftOrderId: draftOrderId,
                    );

            return {
              "status": "success",
              "draft_order": response.draftOrder?.toJson(),
              "timestamp": DateTime.now().toIso8601String(),
            };
          } catch (e) {
            return {
              "status": "error",
              "message": "Failed to fetch draft order: ${e.toString()}",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }
        } else {
          try {
            final GetDraftOrderListResponse response =
                await GetIt.I.get<DraftOrderService>().getDraftOrderList(
                      apiVersion: apiVersion,
                      status: status,
                    );

            return {
              "status": "success",
              "draft_orders":
                  response.draftOrders?.map((order) => order.toJson()).toList(),
              "timestamp": DateTime.now().toIso8601String(),
            };
          } catch (e) {
            return {
              "status": "error",
              "message":
                  "An error occurred while fetching the draft order list: ${e.toString()}",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }
        }
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? email = params['email'];

        final List<create_request.LineItem> lineItems = [];
        int i = 0;
        while (params.containsKey('line_item_${i}_title')) {
          final String? title = params['line_item_${i}_title'];
          final String? price = params['line_item_${i}_price'];
          final int? quantity =
              int.tryParse(params['line_item_${i}_quantity'] ?? '1');

          if (title != null && price != null && quantity != null) {
            lineItems.add(
              create_request.LineItem(
                title: title,
                price: price,
                quantity: quantity,
              ),
            );
          }
          i++;
        }

        if (email == null || email.isEmpty || lineItems.isEmpty) {
          return {
            "status": "error",
            "message": "Email and at least one Line Item are required.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = create_request.CreateDraftOrderRequest(
            draftOrder: create_request.DraftOrder(
              email: email,
              lineItems: lineItems,
            ),
          );

          final CreateDraftOrderResponse response =
              await GetIt.I.get<DraftOrderService>().createDraftOrder(
                    apiVersion: apiVersion,
                    model: model,
                  );

          return {
            "status": "success",
            "message": "Draft order created successfully",
            "draft_order": response.draftOrder?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to create draft order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      case 'PUT':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final int? draftOrderId = params['draft_order_id'] != null
            ? int.tryParse(params['draft_order_id']!)
            : null;
        final String? note = params['note'];
        final String? email = params['email'];
        final int? lineItemId = params['line_item_id'] != null
            ? int.tryParse(params['line_item_id']!)
            : null;
        final String? lineItemTitle = params['line_item_title'];
        final int? lineItemQuantity = params['line_item_quantity'] != null
            ? int.tryParse(params['line_item_quantity']!)
            : null;
        final String? shippingAddressZip = params['shipping_address_zip'];
        final String? discountDescription = params['discount_description'];

        if (draftOrderId == null) {
          return {
            "status": "error",
            "message": "Draft Order ID is required for updating.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final model = update_request.UpdateDraftOrderModifyExistingRequest(
            draftOrder: update_request.DraftOrder(
              id: draftOrderId,
              note: note,
              email: email,
              lineItems: lineItemId != null &&
                      lineItemTitle != null &&
                      lineItemQuantity != null
                  ? [
                      update_request.LineItem(
                        id: lineItemId,
                        title: lineItemTitle,
                        quantity: lineItemQuantity,
                      ),
                    ]
                  : null,
              shippingAddress: shippingAddressZip != null
                  ? update_request.ShippingAddress(zip: shippingAddressZip)
                  : null,
              appliedDiscount: discountDescription != null
                  ? update_request.AppliedDiscount(
                      description: discountDescription)
                  : null,
            ),
          );

          final UpdateDraftOrderModifyExistingResponse response = await GetIt.I
              .get<DraftOrderService>()
              .updateDraftOrderModifyExisting(
                apiVersion: apiVersion,
                draftOrderId: draftOrderId.toString(),
                model: model,
              );

          return {
            "status": "success",
            "message": "Draft order updated successfully",
            "draft_order": response.draftOrder?.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to update draft order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      case 'DELETE':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? draftOrderIdToDelete = params['draft_order_id'];

        if (draftOrderIdToDelete == null || draftOrderIdToDelete.isEmpty) {
          return {
            "status": "error",
            "message": "Draft Order ID is required for deleting.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          await GetIt.I.get<DraftOrderService>().deleteDraftOrder(
                apiVersion: apiVersion,
                draftOrderId: draftOrderIdToDelete,
              );

          return {
            "status": "success",
            "message": "Draft order deleted successfully",
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to delete draft order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      default:
        return {
          "error": "Method $method not supported for Draft Order API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST', 'GET', 'PUT', 'DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'Enter the customer\'s email address',
          ),
          const ApiField(
            name: 'line_item_0_title',
            label: 'Line Item Title (1)',
            hint: 'Enter the title of the first line item',
          ),
          const ApiField(
            name: 'line_item_0_price',
            label: 'Line Item Price (1)',
            hint: 'Enter the price of the first line item',
          ),
          const ApiField(
            name: 'line_item_0_quantity',
            label: 'Line Item Quantity (1)',
            hint: 'Enter the quantity of the first line item',
          ),
        ],
        'GET': [],
        'PUT': [
          const ApiField(
            name: 'draft_order_id',
            label: 'Draft Order ID',
            hint: 'Enter the ID of the draft order to update',
          ),
          const ApiField(
            name: 'note',
            label: 'Note',
            hint: 'Enter a note for the draft order',
          ),
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'Enter the email for the draft order',
          ),
          const ApiField(
            name: 'line_item_id',
            label: 'Line Item ID',
            hint: 'Enter the ID of the line item to update',
          ),
          const ApiField(
            name: 'line_item_title',
            label: 'Line Item Title',
            hint: 'Enter the updated title of the line item',
          ),
          const ApiField(
            name: 'line_item_quantity',
            label: 'Line Item Quantity',
            hint: 'Enter the updated quantity of the line item',
          ),
          const ApiField(
            name: 'shipping_address_zip',
            label: 'Shipping Address Zip',
            hint: 'Enter the updated shipping address zip code',
          ),
          const ApiField(
            name: 'discount_description',
            label: 'Discount Description',
            hint: 'Enter the updated discount description',
          ),
        ],
        'DELETE': [
          const ApiField(
            name: 'draft_order_id',
            label: 'Draft Order ID',
            hint: 'Enter the ID of the draft order to delete',
          ),
        ],
      };

  Map<String, List<ApiField>> get optionalFields => {
        'POST': [
          const ApiField(
            name: 'taxes_included',
            label: 'Taxes Included',
            type: ApiFieldType.boolean,
            hint: 'Indicate if taxes are included in the line item prices',
          ),
          const ApiField(
            name: 'currency',
            label: 'Currency',
            hint: 'Enter the currency code (e.g., USD)',
          ),
          const ApiField(
              name: 'note',
              label: 'Note',
              hint: 'Enter a note for the draft order'),
          const ApiField(
            name: 'tax_exempt',
            label: 'Tax Exempt',
            type: ApiFieldType.boolean,
            hint: 'Indicate if the draft order is tax exempt',
          ),
          const ApiField(
              name: 'name',
              label: 'Name',
              hint: 'Enter a name for the draft order'),
          const ApiField(
            name: 'allow_discount_codes_in_checkout',
            label: 'Allow Discount Codes in Checkout',
            type: ApiFieldType.boolean,
            hint: 'Indicate if discount codes can be used at checkout',
          ),
          const ApiField(
            name: 'b2b',
            label: 'B2B',
            type: ApiFieldType.boolean,
            hint: 'Indicate if this is a B2B draft order',
          ),
          const ApiField(
              name: 'status',
              label: 'Status',
              hint: 'Set the initial status of the draft order'),
          const ApiField(
              name: 'tags',
              label: 'Tags',
              hint: 'Enter comma-separated tags for the draft order'),
          const ApiField(
              name: 'total_price',
              label: 'Total Price',
              hint: 'Set the total price of the draft order'),
          const ApiField(
              name: 'subtotal_price',
              label: 'Subtotal Price',
              hint: 'Set the subtotal price of the draft order'),
          const ApiField(
              name: 'total_tax',
              label: 'Total Tax',
              hint: 'Set the total tax for the draft order'),
          // Add more line item fields as needed with index
        ],
        'GET': [
          const ApiField(
            name: 'id',
            label: 'Draft Order ID',
            hint: 'Enter the ID of the draft order to retrieve',
          ),
          const ApiField(
            name: 'api_version',
            label: 'API Version',
            hint: 'Enter the Shopify API version (e.g., 2022-10)',
          ),
          const ApiField(
            name: 'status',
            label: 'Status',
            hint: 'Filter draft orders by status',
          ),
          const ApiField(
            name: 'limit',
            label: 'Limit',
            hint: 'Limit the number of results returned',
            type: ApiFieldType.number,
          )
        ],
        'PUT': [
          const ApiField(
            name: 'note',
            label: 'Note',
            hint: 'Enter a note for the draft order',
          ),
          const ApiField(
            name: 'email',
            label: 'Email',
            hint: 'Enter the email for the draft order',
          ),
          const ApiField(
            name: 'line_item_id',
            label: 'Line Item ID',
            hint: 'Enter the ID of the line item to update',
          ),
          const ApiField(
            name: 'line_item_title',
            label: 'Line Item Title',
            hint: 'Enter the updated title of the line item',
          ),
          const ApiField(
            name: 'line_item_quantity',
            label: 'Line Item Quantity',
            hint: 'Enter the updated quantity of the line item',
          ),
          const ApiField(
            name: 'shipping_address_zip',
            label: 'Shipping Address Zip',
            hint: 'Enter the updated shipping address zip code',
          ),
          const ApiField(
            name: 'discount_description',
            label: 'Discount Description',
            hint: 'Enter the updated discount description',
          ),
        ],
      };
}
