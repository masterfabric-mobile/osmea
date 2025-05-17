import 'package:apis/apis.dart';
import 'package:apis/network/remote/online_store/theme/abstract/theme_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 📋 LIST ALL THEMES **************************
///**************************************************************

class ListThemesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    // Only handle GET requests for listing themes
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Extract optional parameters
    final fields = params['fields'];

    try {
      // Call the API method
      final response = await GetIt.I<ThemeService>().listAllThemes(
        apiVersion: ApiNetwork.apiVersion,
        fields: fields,
      );

      // Process the response based on fields parameter
      List<Map<String, dynamic>> themesData;
      if (fields == null || fields.isEmpty) {
        // Return full theme objects if no fields specified
        themesData = response.themes?.map((theme) => theme.toJson()).toList() ?? [];
      } else {
        // Filter the response to only include requested fields
        themesData = response.themes?.map((theme) {
          final json = theme.toJson();
          final filteredJson = <String, dynamic>{};
          final fieldsList = fields.split(',').map((f) => f.trim()).toList();
          
          for (final field in fieldsList) {
            if (json.containsKey(field)) {
              filteredJson[field] = json[field];
            }
          }
          
          return filteredJson;
        }).toList() ?? [];
      }

      // Return success response
      return {
        "status": "success",
        "message": "Themes retrieved successfully",
        "themes": themesData,
        "count": response.themes?.length ?? 0,
        "filtered_by_fields": fields != null && fields.isNotEmpty,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      // Handle errors
      return {
        "status": "error",
        "message": "Failed to retrieve themes: ${e.toString()}",
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
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include in the response',
      ),
    ],
  };
}
