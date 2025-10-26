import 'package:apis/apis.dart';
import 'package:apis/network/remote/woocommerce/store_api/cart_api/abstract/cart_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:api_explorer/services/api_service_registry.dart';

///*******************************************************************
//******************* 🛒 GET CART HANDLER ***************************
///*******************************************************************

class GetCartHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Get Cart API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
    try {
      // Try to get JWT token from storage if available (optional)
      String? jwtToken;
      try {
        final token = await WooJwtTokenStorage.loadToken();
        if (token?.accessToken != null && token!.accessToken.isNotEmpty) {
          jwtToken = 'Bearer ${token.accessToken}';
        }
      } catch (e) {
        // JWT token is optional, continue without it
      }

      final response = await GetIt.I<CartService>().getCart(
        apiVersion: WooNetwork.apiVersion,
        jwtToken: jwtToken,
      );

      return {
        "status": "success",
        "cart": response.toJson(),
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to fetch cart: ${e.toString()}",
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          // No additional parameters required for Store API Cart GET
          // The API version is handled automatically
        ],
      };
}
