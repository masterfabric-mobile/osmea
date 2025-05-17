import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_risk_request.dart'
    as create_risk;

import 'package:apis/network/remote/orders/order/freezed_model/response/get_single_order_risk_response.dart'
    as get_risk;
import 'package:apis/network/remote/orders/order/freezed_model/request/update_order_risk_request.dart'
    as update_risk;
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class OrderRiskHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    final String apiVersion = params['api_version'] ?? ApiNetwork.apiVersion;

    switch (method) {
      case 'POST':
        return _handleCreateOrderRisk(apiVersion, params);
      case 'GET':
        return _handleGetSingleOrderRisk(apiVersion, params);
      case 'PUT':
        return _handleUpdateOrderRisk(apiVersion, params);
      default:
        return {
          "error": "Method $method not supported for Order Risk API",
        };
    }
  }

  Future<Map<String, dynamic>> _handleCreateOrderRisk(
      String apiVersion, Map<String, String> params) async {
    final String? orderIdStr = params['order_id'];
    final String? message = params['message'];
    final String? recommendation = params['recommendation'];
    final String? scoreStr = params['score'];
    final String? source = params['source'];
    final String? causeCancelStr = params['cause_cancel'];
    final String? displayStr = params['display'];

    if (orderIdStr == null ||
        orderIdStr.isEmpty ||
        message == null ||
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
            "Order ID, message, recommendation, score, and source are required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final int? orderId = int.tryParse(orderIdStr);
      final double? score = double.tryParse(scoreStr);
      final bool? causeCancel = causeCancelStr?.toLowerCase() == 'true';
      final bool? display = displayStr?.toLowerCase() == 'true';

      if (orderId == null || score == null) {
        return {
          "status": "error",
          "message": "Invalid number format for order ID or score",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      final model = create_risk.CreateOrderRiskRequest(
        risk: create_risk.Risk(
          message: message,
          recommendation: recommendation,
          score: score,
          source: source,
          causeCancel: causeCancel,
          display: display,
        ),
      );

      final response = await GetIt.I.get<OrderService>().createOrderRisk(
          apiVersion: apiVersion, model: model, orderId: orderId.toString());

      return response.toJson();
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to create order risk: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  Future<Map<String, dynamic>> _handleGetSingleOrderRisk(
      String apiVersion, Map<String, String> params) async {
    final String? riskIdStr = params['risk_id'];
    final String? orderIdStr = params['order_id'];

    if (riskIdStr == null ||
        riskIdStr.isEmpty ||
        orderIdStr == null ||
        orderIdStr.isEmpty) {
      return {
        "status": "error",
        "message": "Risk ID and Order ID are required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final int? riskId = int.tryParse(riskIdStr);
      final int? orderId = int.tryParse(orderIdStr);

      if (riskId == null || orderId == null) {
        return {
          "status": "error",
          "message": "Invalid number format for Risk ID or Order ID",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      final get_risk.GetSingleOrderRiskResponse response = await GetIt.I
          .get<OrderService>()
          .getSingleOrderRisk(
              apiVersion: apiVersion,
              riskId: riskId.toString(),
              orderId: orderId.toString());

      return response.toJson();
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to get single order risk: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  Future<Map<String, dynamic>> _handleUpdateOrderRisk(
      String apiVersion, Map<String, String> params) async {
    final String? orderId = params['order_id'];
    final String? riskId = params['risk_id'];
    final String? message = params['message'];
    final String? recommendation = params['recommendation'];
    final String? source = params['source'];
    final String? causeCancelStr = params['cause_cancel'];
    final String? scoreStr = params['score'];

    if (orderId == null ||
        orderId.isEmpty ||
        riskId == null ||
        riskId.isEmpty ||
        message == null ||
        message.isEmpty ||
        recommendation == null ||
        recommendation.isEmpty ||
        source == null ||
        source.isEmpty ||
        scoreStr == null ||
        scoreStr.isEmpty) {
      return {
        "status": "error",
        "message":
            "Order ID, Risk ID, message, recommendation, source, and score are required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final int? score = int.tryParse(scoreStr);
      final bool? causeCancel = causeCancelStr?.toLowerCase() == 'true';

      if (score == null) {
        return {
          "status": "error",
          "message": "Invalid number format for score",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      final update_risk.UpdateOrderRiskRequest model =
          update_risk.UpdateOrderRiskRequest(
        risk: update_risk.Risk(
          id: null, // ID will be in the path
          message: message,
          recommendation: recommendation,
          source: source,
          causeCancel: causeCancel,
          score: score.toInt(), // Update'te score int olarak tanımlanmış
        ),
      );

      final response = await GetIt.I.get<OrderService>().updateOrderRisk(
            apiVersion: apiVersion,
            orderId: orderId,
            riskId: riskId,
            model: model,
          );

      return response.toJson();
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to update order risk: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET', 'POST', 'PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(name: 'order_id', label: 'Order ID', hint: 'Order ID'),
          const ApiField(
              name: 'message', label: 'Message', hint: 'Risk message'),
          const ApiField(
              name: 'recommendation',
              label: 'Recommendation',
              hint: 'Risk recommendation'),
          const ApiField(
              name: 'score', label: 'Score', hint: 'Risk score (double)'),
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
        'GET': [
          const ApiField(name: 'risk_id', label: 'Risk ID', hint: 'Risk ID'),
          const ApiField(name: 'order_id', label: 'Order ID', hint: 'Order ID'),
        ],
        'PUT': [
          const ApiField(name: 'order_id', label: 'Order ID', hint: 'Order ID'),
          const ApiField(name: 'risk_id', label: 'Risk ID', hint: 'Risk ID'),
          const ApiField(
              name: 'message', label: 'Message', hint: 'Risk message'),
          const ApiField(
              name: 'recommendation',
              label: 'Recommendation',
              hint: 'Risk recommendation'),
          const ApiField(name: 'source', label: 'Source', hint: 'Risk source'),
          const ApiField(name: 'score', label: 'Score', hint: 'Risk score'),
          const ApiField(
              name: 'cause_cancel',
              label: 'Cause Cancel',
              hint: '(Optional) true or false'),
        ],
      };
}
