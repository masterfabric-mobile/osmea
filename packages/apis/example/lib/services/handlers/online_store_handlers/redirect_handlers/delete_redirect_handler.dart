import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/redirect/abstract/redirect_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🗑️ DELETE REDIRECT **************************
///**************************************************************

class DeleteRedirectHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle DELETE requests for deleting redirects
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only DELETE is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final redirectId = params['redirect_id'];
    
    // Validate required parameters
    if (redirectId == null || redirectId.isEmpty) {
      return {
        "status": "error",
        "message": "Redirect ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method to delete the redirect
      await GetIt.I<RedirectService>().deleteRedirect(
        apiVersion: ApiNetwork.apiVersion,
        redirectId: redirectId,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Redirect deleted successfully",
        "params": {
          "redirect_id": redirectId,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to delete redirect: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'DELETE': [
      const ApiField(
        name: 'redirect_id',
        label: 'Redirect ID',
        hint: 'The ID of the redirect to delete',
        isRequired: true,
      ),
    ],
  };
}
