import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/theme/abstract/theme_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 GET SINGLE THEME *************************
///**************************************************************

class GetSingleThemeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for retrieving a theme
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract required parameters
    final themeId = params['theme_id'];
    
    // Extract optional parameters
    final fields = params['fields'];

    // Validate required parameters
    if (themeId == null || themeId.isEmpty) {
      return {
        "status": "error",
        "message": "Theme ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Call the API method
      final response = await GetIt.I<ThemeService>().getSingleTheme(
        apiVersion: ApiNetwork.apiVersion,
        themeId: themeId,
        fields: fields,
      );

      // Process the theme data based on fields parameter
      Map<String, dynamic>? themeData;
      if (fields == null || fields.isEmpty) {
        // Return full theme object if no fields specified
        themeData = response.theme?.toJson();
      } else {
        // Filter the response to only include requested fields
        final json = response.theme?.toJson() ?? {};
        final filteredJson = <String, dynamic>{};
        final fieldsList = fields.split(',').map((f) => f.trim()).toList();
        
        for (final field in fieldsList) {
          if (json.containsKey(field)) {
            filteredJson[field] = json[field];
          }
        }
        
        themeData = filteredJson;
      }

      // Return success response
      return {
        "status": "success",
        "message": "Theme retrieved successfully",
        "theme": themeData,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve theme: ${e.toString()}",
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
        name: 'theme_id',
        label: 'Theme ID',
        hint: 'The ID of the theme to retrieve',
        isRequired: true,
      ),
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include in the response',
      ),
    ],
  };
}
