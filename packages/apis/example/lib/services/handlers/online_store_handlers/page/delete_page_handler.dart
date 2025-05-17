import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/page/abstract/page_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🗑️ DELETE PAGE ******************************
///**************************************************************

class DeletePageHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle DELETE requests for deleting pages
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only DELETE is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final pageId = params['page_id'];
    
    // Validate required parameters
    if (pageId == null || pageId.isEmpty) {
      return {
        "status": "error",
        "message": "Page ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method to delete the page
      await GetIt.I<PageService>().deletePage(
        apiVersion: ApiNetwork.apiVersion,
        pageId: pageId,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Page deleted successfully",
        "params": {
          "page_id": pageId,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to delete page: ${e.toString()}",
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
        name: 'page_id',
        label: 'Page ID',
        hint: 'The ID of the page to delete',
        isRequired: true,
      ),
    ],
  };
}
