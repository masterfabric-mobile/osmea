import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_risk_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateOrderRiskHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;
        final String orderId = params['order_id'] ?? '';
        if (orderId.isEmpty) {
          return {
            "status": "error",
            "message": "Order ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        final String? message = params['message'];
        final String? recommendation = params['recommendation'];
        final String? scoreStr = params['score'];
        final String? source = params['source'];
        final String? causeCancelStr = params['cause_cancel'];
        final String? displayStr = params['display'];

        if (message == null ||
            message.isEmpty ||
            recommendation == null ||
            recommendation.isEmpty ||
            scoreStr == null ||
            scoreStr.isEmpty ||
            source == null ||
            source.isEmpty) {
          return {
            "status": "error",
            "message":
                "Message, recommendation, score, and source are required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final double? score = double.tryParse(scoreStr);
          final bool? causeCancel = causeCancelStr?.toLowerCase() == 'true';
          final bool? display = displayStr?.toLowerCase() == 'true';

          if (score == null) {
            return {
              "status": "error",
              "message": "Invalid number format for score",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final model = CreateOrderRiskRequest(
            risk: Risk(
              message: message,
              recommendation: recommendation,
              score: score,
              source: source,
              causeCancel: causeCancel,
              display: display,
            ),
          );

          final response = await GetIt.I.get<OrderService>().createOrderRisk(
              apiVersion: apiVersion, orderId: orderId, model: model);

          return {
            "status": "success",
            "message": "Order risk created successfully",
            "risk": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to create order risk: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error": "Method $method not supported for Create Order Risk API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
              name: 'message', label: 'Message', hint: 'Risk message'),
          const ApiField(name: "order_id", label: 'Order ID', hint: 'Order ID'),
          const ApiField(
              name: 'recommendation',
              label: 'Recommendation',
              hint: 'Risk recommendation'),
          const ApiField(name: 'score', label: 'Score', hint: 'Risk score'),
          const ApiField(name: 'source', label: 'Source', hint: 'Risk source'),
          const ApiField(
              name: 'cause_cancel',
              label: 'Cause Cancel',
              hint: '(Optional) true or false'),
          const ApiField(
              name: 'display',
              label: 'Display',
              hint: '(Optional) true or false'),
        ],
      };
}
