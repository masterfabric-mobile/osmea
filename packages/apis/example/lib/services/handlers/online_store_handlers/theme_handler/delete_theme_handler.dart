import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/theme/abstract/theme_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🗑️ DELETE THEME ****************************
///**************************************************************

class DeleteThemeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle DELETE requests for deleting themes
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only DELETE is allowed.",
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
      // Call the API method to delete the theme
      await GetIt.I<ThemeService>().deleteTheme(
        apiVersion: ApiNetwork.apiVersion,
        themeId: themeId,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Theme deleted successfully",
        "params": {
          "theme_id": themeId,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to delete theme: ${e.toString()}",
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
        name: 'theme_id',
        label: 'Theme ID',
        hint: 'The ID of the theme to delete',
        isRequired: true,
      ),
    ],
  };
}
