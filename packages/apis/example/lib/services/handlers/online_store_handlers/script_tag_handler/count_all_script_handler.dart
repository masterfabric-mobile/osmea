import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/script_tag/abstract/script_tag_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🔢 COUNT ALL SCRIPT TAGS ********************
///**************************************************************

class CountAllScriptHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for counting script tags
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional filter parameters
    final src = params['src'];

    try {
      // Call the API method
      final response = await GetIt.I<ScriptTagService>().countAllScriptTags(
        apiVersion: ApiNetwork.apiVersion,
        src: src,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Script tags counted successfully",
        "count": response.count,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to count script tags: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'GET': [
      const ApiField(
        name: 'src',
        label: 'Source URL',
        hint: 'Filter script tags by source URL',
      ),
    ],
  };
}
