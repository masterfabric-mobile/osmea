import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/theme/abstract/theme_service.dart';
import 'package:apis/network/remote/online_store/theme/freezed_model/request/create_theme_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🎨 CREATE THEME *****************************
///**************************************************************

class CreateThemeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle POST requests for theme creation
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final name = params['name'];
    final src = params['src']; // URL to theme file
    final role = params['role'] ?? 'unpublished';
    
    // Validate required parameters
    if (name == null || name.isEmpty) {
      return {
        "status": "error",
        "message": "Theme name is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (src == null || src.isEmpty) {
      return {
        "status": "error",
        "message": "Theme source URL is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Create the request using the JSON structure that matches the API
      final requestJson = {
        "theme": {
          "name": name,
          "src": src,
          "role": role
        }
      };

      // Convert to proper request model
      final themeRequest = CreateThemeRequest.fromJson(requestJson);

      // Call the API method
      final response = await GetIt.I<ThemeService>().createTheme(
        apiVersion: ApiNetwork.apiVersion,
        body: themeRequest,
      );

      // Return success response
      return {
        "status": "success",
        "message": "Theme created successfully",
        "theme": response.theme?.toJson(),
        "params": {
          "name": name,
          "src": src,
          "role": role,
          "created_at": response.theme?.createdAt,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to create theme: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'POST': [
      const ApiField(
        name: 'name',
        label: 'Name',
        hint: 'The name of the theme',
        isRequired: true,
      ),
      const ApiField(
        name: 'src',
        label: 'Source URL',
        hint: 'URL of the theme file (ZIP format)',
        isRequired: true,
      ),
      const ApiField(
        name: 'role',
        label: 'Role',
        hint: 'The role of the theme (main, unpublished, demo)',
      ),
    ],
  };
}
