import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/draft_order/abstract/draft_order.dart';
import 'package:apis/network/remote/orders/draft_order/freezed_model/request/update_draft_order_complete_request.dart'
    as update_request;
import 'package:apis/network/remote/orders/draft_order/freezed_model/response/update_draft_order_complete_response.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class UpdateDraftOrderCompleteHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'PUT':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String? draftOrderId =
            params['id']; // Assuming 'id' in path parameters

        if (draftOrderId == null || draftOrderId.isEmpty) {
          return {
            "status": "error",
            "message": "Draft Order ID is required for update.",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          // Construct the request body from parameters
          final model = update_request.UpdateDraftOrderCompleteRequest(
            draftOrder: update_request.DraftOrder(
              id: int.tryParse(draftOrderId),
              note: params['note'],
              email: params['email'],
              taxesIncluded: params['taxes_included']?.toLowerCase() == 'true',
              currency: params['currency'],
              invoiceSentAt: params['invoice_sent_at'],
              taxExempt: params['tax_exempt']?.toLowerCase() == 'true',
              completedAt: params['completed_at'],
              status: params['status'],
              lineItems: _parseLineItems(params),
              shippingAddress: _parseShippingAddress(params),
              billingAddress: _parseBillingAddress(params),
              appliedDiscount: _parseAppliedDiscount(params),
              shippingLine: _parseShippingLine(params),
              tags: params['tags'],
              noteAttributes: _parseNoteAttributes(params),
              customer: _parseCustomer(params),
              useCustomerDefaultAddress:
                  params['use_customer_default_address']?.toLowerCase() ==
                      'true',
            ),
          );

          final UpdateDraftOrderCompleteResponse response =
              await GetIt.I.get<DraftOrderService>().updateDraftOrderComplete(
                    apiVersion: apiVersion,
                    draftOrderId: draftOrderId,
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

      default:
        return {
          "error": "Method $method not supported for Update Draft Order API",
        };
    }
  }

  List<update_request.LineItem>? _parseLineItems(Map<String, String> params) {
    // Implement logic to parse line items from params if needed
    // This is a placeholder, you'll likely need a more complex way to handle lists
    if (params.containsKey('line_item_title')) {
      return [
        update_request.LineItem(
          title: params['line_item_title'],
          price: params['line_item_price'],
          quantity: int.tryParse(params['line_item_quantity'] ?? '1'),
          variantId: int.tryParse(params['line_item_variant_id'] ?? ''),
          productId: int.tryParse(params['line_item_product_id'] ?? ''),
          sku: params['line_item_sku'],
          appliedDiscount: _parseAppliedDiscount(params),
        ),
      ];
    }
    return null;
  }

  update_request.AppliedDiscount? _parseAppliedDiscount(
      Map<String, String> params) {
    if (params.containsKey('applied_discount_value')) {
      return update_request.AppliedDiscount(
        description: params['applied_discount_description'],
        value: params['applied_discount_value'],
        title: params['applied_discount_title'],
        amount: params['applied_discount_amount'],
        valueType: params['applied_discount_value_type'],
      );
    }
    return null;
  }

  update_request.IngAddress? _parseShippingAddress(Map<String, String> params) {
    if (params.containsKey('shipping_address_first_name')) {
      return update_request.IngAddress(
        firstName: params['shipping_address_first_name'],
        address1: params['shipping_address_address1'],
        phone: params['shipping_address_phone'],
        city: params['shipping_address_city'],
        zip: params['shipping_address_zip'],
        province: params['shipping_address_province'],
        country: params['shipping_address_country'],
        lastName: params['shipping_address_last_name'],
      );
    }
    return null;
  }

  update_request.IngAddress? _parseBillingAddress(Map<String, String> params) {
    if (params.containsKey('billing_address_first_name')) {
      return update_request.IngAddress(
        firstName: params['billing_address_first_name'],
        address1: params['billing_address_address1'],
        phone: params['billing_address_phone'],
        city: params['billing_address_city'],
        zip: params['billing_address_zip'],
        province: params['billing_address_province'],
        country: params['billing_address_country'],
        lastName: params['billing_address_last_name'],
      );
    }
    return null;
  }

  update_request.ShippingLine? _parseShippingLine(Map<String, String> params) {
    if (params.containsKey('shipping_line_title')) {
      return update_request.ShippingLine(
        title: params['shipping_line_title'],
        price: params['shipping_line_price'],
        custom: params['shipping_line_custom']?.toLowerCase() == 'true',
      );
    }
    return null;
  }

  List<update_request.NoteAttribute>? _parseNoteAttributes(
      Map<String, String> params) {
    if (params.containsKey('note_attribute_name')) {
      return [
        update_request.NoteAttribute(
          name: params['note_attribute_name'],
          value: params['note_attribute_value'],
        ),
      ];
    }
    return null;
  }

  update_request.Customer? _parseCustomer(Map<String, String> params) {
    if (params.containsKey('customer_id')) {
      return update_request.Customer(
        id: int.tryParse(params['customer_id']!),
        email: params['customer_email'],
        firstName: params['customer_first_name'],
        lastName: params['customer_last_name'],
        phone: params['customer_phone'],
      );
    }
    return null;
  }

  @override
  List<String> get supportedMethods => ['PUT'];
  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'id',
            label: 'Draft Order ID',
            hint: 'Enter the ID of the draft order to update',
          ),
        ],
      };

  Map<String, List<ApiField>> get optionalFields => {
        'PUT': [
          const ApiField(
              name: 'note',
              label: 'Note',
              hint: 'Enter a note for the draft order'),
          const ApiField(
              name: 'email',
              label: 'Email',
              hint: 'Enter the customer\'s email address'),
          const ApiField(
              name: 'taxes_included',
              label: 'Taxes Included',
              type: ApiFieldType.boolean,
              hint: 'Indicate if taxes are included in the line item prices'),
          const ApiField(
              name: 'currency',
              label: 'Currency',
              hint: 'Enter the currency code (e.g., USD)'),
          const ApiField(
              name: 'invoice_sent_at',
              label: 'Invoice Sent At',
              hint: 'Specify when the invoice was sent (ISO 8601 format)'),
          const ApiField(
              name: 'tax_exempt',
              label: 'Tax Exempt',
              type: ApiFieldType.boolean,
              hint: 'Indicate if the draft order is tax exempt'),
          const ApiField(
              name: 'completed_at',
              label: 'Completed At',
              hint:
                  'Specify when the draft order was completed (ISO 8601 format)'),
          const ApiField(
              name: 'status',
              label: 'Status',
              hint:
                  'Set the status of the draft order (e.g., open, completed)'),
          // Line Item Fields (example for a single item)
          const ApiField(
              name: 'line_item_id',
              label: 'Line Item ID',
              hint: 'ID of the line item to update'),
          const ApiField(
              name: 'line_item_variant_id',
              label: 'Line Item Variant ID',
              hint: 'Variant ID of the line item'),
          const ApiField(
              name: 'line_item_product_id',
              label: 'Line Item Product ID',
              hint: 'Product ID of the line item'),
          const ApiField(
              name: 'line_item_title',
              label: 'Line Item Title',
              hint: 'Title of the line item'),
          const ApiField(
              name: 'line_item_variant_title',
              label: 'Line Item Variant Title',
              hint: 'Variant title of the line item'),
          const ApiField(
              name: 'line_item_sku',
              label: 'Line Item SKU',
              hint: 'SKU of the line item'),
          const ApiField(
              name: 'line_item_quantity',
              label: 'Line Item Quantity',
              type: ApiFieldType.number,
              hint: 'Quantity of the line item'),
          const ApiField(
              name: 'line_item_price',
              label: 'Line Item Price',
              hint: 'Price of the line item'),
          // Applied Discount Fields
          const ApiField(
              name: 'applied_discount_description',
              label: 'Applied Discount Description',
              hint: 'Description of the applied discount'),
          const ApiField(
              name: 'applied_discount_value',
              label: 'Applied Discount Value',
              hint: 'Value of the applied discount'),
          const ApiField(
              name: 'applied_discount_title',
              label: 'Applied Discount Title',
              hint: 'Title of the applied discount'),
          const ApiField(
              name: 'applied_discount_amount',
              label: 'Applied Discount Amount',
              hint: 'Amount of the applied discount'),
          const ApiField(
              name: 'applied_discount_value_type',
              label: 'Applied Discount Value Type',
              hint:
                  'Type of the applied discount value (e.g., fixed_amount, percentage)'),
          // Shipping Address Fields
          const ApiField(
              name: 'shipping_address_first_name',
              label: 'Shipping First Name',
              hint: 'First name for the shipping address'),
          const ApiField(
              name: 'shipping_address_address1',
              label: 'Shipping Address 1',
              hint: 'Address line 1 for the shipping address'),
          const ApiField(
              name: 'shipping_address_phone',
              label: 'Shipping Phone',
              hint: 'Phone number for the shipping address'),
          const ApiField(
              name: 'shipping_address_city',
              label: 'Shipping City',
              hint: 'City for the shipping address'),
          const ApiField(
              name: 'shipping_address_zip',
              label: 'Shipping ZIP',
              hint: 'ZIP code for the shipping address'),
          const ApiField(
              name: 'shipping_address_province',
              label: 'Shipping Province',
              hint: 'Province for the shipping address'),
          const ApiField(
              name: 'shipping_address_country',
              label: 'Shipping Country',
              hint: 'Country for the shipping address'),
          const ApiField(
              name: 'shipping_address_last_name',
              label: 'Shipping Last Name',
              hint: 'Last name for the shipping address'),
          // Billing Address Fields
          const ApiField(
              name: 'billing_address_first_name',
              label: 'Billing First Name',
              hint: 'First name for the billing address'),
          const ApiField(
              name: 'billing_address_address1',
              label: 'Billing Address 1',
              hint: 'Address line 1 for the billing address'),
          const ApiField(
              name: 'billing_address_phone',
              label: 'Billing Phone',
              hint: 'Phone number for the billing address'),
          const ApiField(
              name: 'billing_address_city',
              label: 'Billing City',
              hint: 'City for the billing address'),
          const ApiField(
              name: 'billing_address_zip',
              label: 'Billing ZIP',
              hint: 'ZIP code for the billing address'),
          const ApiField(
              name: 'billing_address_province',
              label: 'Billing Province',
              hint: 'Province for the billing address'),
          const ApiField(
              name: 'billing_address_country',
              label: 'Billing Country',
              hint: 'Country for the billing address'),
          const ApiField(
              name: 'billing_address_last_name',
              label: 'Billing Last Name',
              hint: 'Last name for the billing address'),
          // Shipping Line Fields
          const ApiField(
              name: 'shipping_line_title',
              label: 'Shipping Title',
              hint: 'Title of the shipping line'),
          const ApiField(
              name: 'shipping_line_price',
              label: 'Shipping Price',
              hint: 'Price of the shipping line'),
          const ApiField(
              name: 'shipping_line_custom',
              label: 'Shipping Custom',
              type: ApiFieldType.boolean,
              hint: 'Indicate if the shipping line is custom'),
          // Note Attributes Fields (example for a single attribute)
          const ApiField(
              name: 'note_attribute_name',
              label: 'Note Attribute Name',
              hint: 'Name of the note attribute'),
          const ApiField(
              name: 'note_attribute_value',
              label: 'Note Attribute Value',
              hint: 'Value of the note attribute'),
          // Customer Fields
          const ApiField(
              name: 'customer_id',
              label: 'Customer ID',
              type: ApiFieldType.number,
              hint: 'ID of the customer'),
          const ApiField(
              name: 'customer_email',
              label: 'Customer Email',
              hint: 'Email of the customer'),
          const ApiField(
              name: 'customer_first_name',
              label: 'Customer First Name',
              hint: 'First name of the customer'),
          const ApiField(
              name: 'customer_last_name',
              label: 'Customer Last Name',
              hint: 'Last name of the customer'),
          const ApiField(
              name: 'customer_phone',
              label: 'Customer Phone',
              hint: 'Phone number of the customer'),
          const ApiField(
              name: 'use_customer_default_address',
              label: 'Use Customer Default Address',
              type: ApiFieldType.boolean,
              hint:
                  'Indicate if the customer\'s default address should be used'),
          const ApiField(
              name: 'tags',
              label: 'Tags',
              hint: 'Comma-separated list of tags for the draft order'),
        ],
      };
}
