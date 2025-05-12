import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/shipping_zone/abstract/shipping_zone_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:example/services/api_service_registry.dart';

///**************************************************************
///************** 🚚 LIST SHIPPING ZONES HANDLER ***************
///**************************************************************

class ReceiveListOfShippingZonesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final response =
          await GetIt.I<ShippingZoneService>().receiveListOfShippingZones(
        apiVersion: ApiNetwork.apiVersion,
      );

      return {
        "status": "success",
        "data": response.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve shipping zones: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [],
      };
}
