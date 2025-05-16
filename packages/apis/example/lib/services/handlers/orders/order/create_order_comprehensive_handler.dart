import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_comprehensive_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateOrderComprehensiveHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        // Order Fields
        final String? totalTaxStr = params['total_tax'];
        final String? currency = params['currency'];

        // Line Item Fields (Assuming one for simplicity)
        final String? lineItemTitle = params['line_item_title'];
        final String? lineItemPriceStr = params['line_item_price'];
        final String? lineItemGrams = params['line_item_grams'];
        final String? lineItemQuantityStr = params['line_item_quantity'];

        // Tax Line Fields for the Line Item (Assuming one for simplicity)
        final String? taxLinePriceStr = params['tax_line_price'];
        final String? taxLineRateStr = params['tax_line_rate'];
        final String? taxLineTitle = params['tax_line_title'];

        // Transaction Fields (Assuming one for simplicity)
        final String? transactionKind = params['transaction_kind'];
        final String? transactionStatus = params['transaction_status'];
        final String? transactionAmountStr = params['transaction_amount'];

        if (currency == null ||
            currency.isEmpty ||
            totalTaxStr == null ||
            totalTaxStr.isEmpty ||
            lineItemTitle == null ||
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
            taxLineTitle.isEmpty ||
            transactionKind == null ||
            transactionKind.isEmpty ||
            transactionStatus == null ||
            transactionStatus.isEmpty ||
            transactionAmountStr == null ||
            transactionAmountStr.isEmpty) {
          return {
            "status": "error",
            "message": "All required fields must be provided",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final double? totalTax = double.tryParse(totalTaxStr);
          final double? lineItemPrice = double.tryParse(lineItemPriceStr);
          final int? lineItemQuantity = int.tryParse(lineItemQuantityStr);
          final double? taxLinePrice = double.tryParse(taxLinePriceStr);
          final double? taxLineRate = double.tryParse(taxLineRateStr);
          final double? transactionAmount =
              double.tryParse(transactionAmountStr);

          if (totalTax == null ||
              lineItemPrice == null ||
              lineItemQuantity == null ||
              taxLinePrice == null ||
              taxLineRate == null ||
              transactionAmount == null) {
            return {
              "status": "error",
              "message": "Invalid number format for numerical fields",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final model = CreateOrderComprehensiveRequest(
            order: Order(
              totalTax: totalTax,
              currency: currency,
              lineItems: [
                LineItem(
                  title: lineItemTitle,
                  price: lineItemPrice,
                  grams: lineItemGrams,
                  quantity: lineItemQuantity,
                  taxLines: [
                    TaxLine(
                      price: taxLinePrice,
                      rate: taxLineRate,
                      title: taxLineTitle,
                    ),
                  ],
                ),
              ],
              transactions: [
                Transaction(
                  kind: transactionKind,
                  status: transactionStatus,
                  amount: transactionAmount,
                ),
              ],
            ),
          );

          final response = await GetIt.I
              .get<OrderService>()
              .createOrderComprehensive(apiVersion: apiVersion, model: model);

          return {
            "status": "success",
            "message": "Comprehensive order created successfully",
            "order": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to create comprehensive order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Create Comprehensive Order API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
              name: 'total_tax', label: 'Total Tax', hint: 'Total Tax'),
          const ApiField(name: 'currency', label: 'Currency', hint: 'Currency'),
          const ApiField(
              name: 'line_item_title',
              label: 'Line Item Title',
              hint: 'Line Item Title'),
          const ApiField(
              name: 'line_item_price',
              label: 'Line Item Price',
              hint: 'Line Item Price'),
          const ApiField(
              name: 'line_item_grams',
              label: 'Line Item Grams',
              hint: 'Line Item Grams'),
          const ApiField(
              name: 'line_item_quantity',
              label: 'Line Item Quantity',
              hint: 'Line Item Quantity'),
          const ApiField(
              name: 'tax_line_price',
              label: 'Tax Line Price',
              hint: 'Tax Line Price'),
          const ApiField(
              name: 'tax_line_rate',
              label: 'Tax Line Rate',
              hint: 'Tax Line Rate'),
          const ApiField(
              name: 'tax_line_title',
              label: 'Tax Line Title',
              hint: 'Tax Line Title'),
          const ApiField(
              name: 'transaction_kind',
              label: 'Transaction Kind',
              hint: 'Transaction Kind'),
          const ApiField(
              name: 'transaction_status',
              label: 'Transaction Status',
              hint: 'Transaction Status'),
          const ApiField(
              name: 'transaction_amount',
              label: 'Transaction Amount',
              hint: 'Transaction Amount'),
        ],
      };
}
