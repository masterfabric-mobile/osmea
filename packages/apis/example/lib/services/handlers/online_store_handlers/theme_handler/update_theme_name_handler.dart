import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/theme/abstract/theme_service.dart';
import 'package:apis/network/remote/online_store/theme/freezed_model/request/update_theme_name_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📝 UPDATE THEME NAME ************************
///**************************************************************

class UpdateThemeNameHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle PUT requests for updating theme name
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final themeId = params['theme_id'];
    final name = params['name'];
    
    // Validate required parameters
    if (themeId == null || themeId.isEmpty) {
      return {
        "status": "error",
        "message": "Theme ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (name == null || name.isEmpty) {
      return {
        "status": "error",
        "message": "Theme name is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "theme": {
          "id": int.tryParse(themeId),
          "name": name
        }
      };

      // Convert to proper request model
      final updateRequest = UpdateThemeNameRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<ThemeService>().updateThemeName(
        apiVersion: ApiNetwork.apiVersion,
        themeId: themeId,
        body: updateRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Theme name updated successfully",
        "theme": response.theme?.toJson(),
        "params": {
          "theme_id": themeId,
          "name": name,
          "updated_at": response.theme?.updatedAt,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to update theme name: ${e.toString()}",
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
        hint: 'The ID of the theme to update',
        isRequired: true,
      ),
      const ApiField(
        name: 'name',
        label: 'Name',
        hint: 'The new name for the theme',
        isRequired: true,
      ),
    ],
  };
}
