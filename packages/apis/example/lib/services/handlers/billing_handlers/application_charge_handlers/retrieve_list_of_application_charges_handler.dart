import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/application_charge/abstract/application_charge_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:dio/dio.dart';

class RetrieveListOfApplicationChargesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'GET') {
        // Parse parameters and ensure empty strings are treated as null
        final fieldsParam = params['fields'] as String?;
        String? fields = (fieldsParam?.isEmpty ?? true) ? null : fieldsParam;

        String? sinceId = params['since_id'] as String?;
        if (sinceId?.isEmpty ?? true) {
          sinceId = null; // Convert empty string to null
        }

        print('🔧 Parameters: fields=$fields, since_id=$sinceId');
        
        // APPROACH 1: When fields parameter is provided, make a direct API call
        if (fields != null && fields.isNotEmpty) {
          return await _handleFieldFiltering(fields, sinceId);
        }
        
        // APPROACH 2: Normal path without field filtering
        return await _handleStandardRequest(sinceId);
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use GET instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('❌ Error: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to fetch application charges: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }
  
  // APPROACH 1: Handle field filtering by making a direct API call
  Future<Map<String, dynamic>> _handleFieldFiltering(String fields, String? sinceId) async {
    print('📌 Using direct API call for field filtering: fields=$fields');
    
    final baseUrl = ApiNetwork.baseUrl;
    final apiVersion = ApiNetwork.apiVersion;
    final shopifyToken = ApiNetwork.shopifyAccessToken;
    
    // Build URL with query parameters
    String url = '$baseUrl/api/$apiVersion/application_charges.json?fields=$fields';

    // Only add since_id if it has a meaningful value
    if (sinceId != null && sinceId.isNotEmpty) {
      url += '&since_id=$sinceId';
    }
    
    print('🔗 Making request to: $url');
    
    // Make direct API call
    try {
      final dio = Dio();
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Shopify-Access-Token': shopifyToken,
          },
        ),
      );
      
      print('✅ Response status: ${response.statusCode}');
      
      if (response.data is Map) {
        final data = Map<String, dynamic>.from(response.data as Map);
        
        return {
          "status": "success",
          "appliedFilters": {
            "fields": fields,
            "since_id": sinceId,
          },
          "data": data,
          "count": (data['application_charges'] as List?)?.length ?? 0,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        throw Exception('Unexpected response format: ${response.data}');
      }
    } catch (e) {
      print('❌ Direct API error: $e');
      throw e;  // Re-throw to be caught by the outer handler
    }
  }
  
  // APPROACH 2: Standard request using the model
  Future<Map<String, dynamic>> _handleStandardRequest(String? sinceId) async {
    print('📌 Using standard model-based approach');
    
    final service = GetIt.I.get<GetApplicationChargesService>();
    final response = await service.getApplicationCharges(
      apiVersion: ApiNetwork.apiVersion,
      sinceId: sinceId,
    );
    
    print('📊 Received ${response.applicationCharges?.length ?? 0} charges');
    
    return {
      "status": "success",
      "appliedFilters": {
        "fields": null,
        "since_id": sinceId, // Consistently use snake_case in JSON response
      },
      "data": {
        "application_charges": response.applicationCharges?.map((c) => c.toJson()).toList() ?? [],
      },
      "count": response.applicationCharges?.length ?? 0,
      "timestamp": DateTime.now().toIso8601String(),
    };
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'GET': [
      const ApiField(
        name: 'fields',
        label: 'Fields',
        hint: 'Comma-separated list of fields to include (e.g., id,name,price)',
        isRequired: false,
      ),
      const ApiField(
        name: 'since_id',
        label: 'Since ID',
        hint: 'Show charges after this ID (for pagination)',
        isRequired: false,
      ),
    ],
  };
}