import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_with_tax_lines_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateOrderWithTaxLinesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        final String? lineItemTitle = params['line_item_title'];
        final String? lineItemPriceStr = params['line_item_price'];
        final String? lineItemGrams = params['line_item_grams'];
        final String? lineItemQuantityStr = params['line_item_quantity'];

        final String? taxLinePriceStr = params['tax_line_price'];
        final String? taxLineRateStr = params['tax_line_rate'];
        final String? taxLineTitle = params['tax_line_title'];

        if (lineItemTitle == null ||
            lineItemTitle.isEmpty ||
            lineItemPriceStr == null ||
            lineItemPriceStr.isEmpty ||
            lineItemGrams == null ||
            lineItemGrams.isEmpty ||
            lineItemQuantityStr == null ||
            lineItemQuantityStr.isEmpty ||
            taxLinePriceStr == null ||
            taxLinePriceStr.isEmpty ||
            taxLineRateStr == null ||
            taxLineRateStr.isEmpty ||
            taxLineTitle == null ||
            taxLineTitle.isEmpty) {
          return {
            "status": "error",
            "message": "All line item and tax line fields are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final double? lineItemPrice = double.tryParse(lineItemPriceStr);
          final int? lineItemQuantity = int.tryParse(lineItemQuantityStr);
          final double? taxLinePrice = double.tryParse(taxLinePriceStr);
          final double? taxLineRate = double.tryParse(taxLineRateStr);

          if (lineItemPrice == null ||
              lineItemQuantity == null ||
              taxLinePrice == null ||
              taxLineRate == null) {
            return {
              "status": "error",
              "message": "Invalid number format for price or quantity",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final model = CreateOrderWithTaxLinesRequest(
            order: Order(
              lineItems: [
                LineItem(
                  title: lineItemTitle,
                  price: lineItemPrice,
                  grams: lineItemGrams,
                  quantity: lineItemQuantity,
                ),
              ],
              taxLines: [
                TaxLine(
                  price: taxLinePrice,
                  rate: taxLineRate,
                  title: taxLineTitle,
                ),
              ],
            ),
          );

          final response =
              await GetIt.I.get<OrderService>().createOrderWithTaxLines(
                    apiVersion: apiVersion,
                    model: model,
                  );

          return {
            "status": "success",
            "message": "Order created successfully with tax lines",
            "order": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to create order with tax lines: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Create Order API",
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
            name: 'line_item_grams',
            label: 'Line Item Grams',
            hint: 'Enter the grams of the line item',
          ),
          const ApiField(
            name: 'line_item_quantity',
            label: 'Line Item Quantity',
            hint: 'Enter the quantity of the line item',
          ),
          const ApiField(
            name: 'tax_line_price',
            label: 'Tax Line Price',
            hint: 'Enter the price of the tax line',
          ),
          const ApiField(
            name: 'tax_line_rate',
            label: 'Tax Line Rate',
            hint: 'Enter the rate of the tax line',
          ),
          const ApiField(
            name: 'tax_line_title',
            label: 'Tax Line Title',
            hint: 'Enter the title of the tax line',
          ),
        ],
      };
}
