import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/theme/abstract/theme_service.dart';
import 'package:apis/network/remote/online_store/theme/freezed_model/request/publish_unpublished_theme_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🚀 PUBLISH UNPUBLISHED THEME ****************
///**************************************************************

class PublishUnpublishedThemeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for publishing themes
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final themeId = params['theme_id'];
    
    // Validate required parameters
    if (themeId == null || themeId.isEmpty) {
      return {
        "status": "error",
        "message": "Theme ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "theme": {
          "id": int.tryParse(themeId),
          "role": "main"
        }
      };

      // Convert to proper request model
      final publishRequest = PublishUnpublishedThemeRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<ThemeService>().publishUnpublishedTheme(
        apiVersion: ApiNetwork.apiVersion,
        themeId: themeId,
        body: publishRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Theme published successfully",
        "theme": response.theme?.toJson(),
        "params": {
          "theme_id": themeId,
          "role": "main",
          "updated_at": response.theme?.updatedAt,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to publish theme: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'PUT': [
      const ApiField(
        name: 'theme_id',
        label: 'Theme ID',
        hint: 'The ID of the theme to publish',
        isRequired: true,
      ),
    ],
  };
}
