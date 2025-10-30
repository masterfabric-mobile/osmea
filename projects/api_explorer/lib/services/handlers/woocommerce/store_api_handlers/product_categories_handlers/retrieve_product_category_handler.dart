import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:apis/apis.dart';

class StoreRetrieveProductCategoryHandler extends ApiRequestHandler {
  String get serviceName => 'Retrieve Product Category';

  String get serviceDescription =>
      'Retrieve a single product category by ID from WooCommerce store';

  String get serviceCategory => 'WooCommerce Store API';

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'api_version',
            label: 'API Version',
            hint: 'e.g., v1',
            isRequired: true,
          ),
          const ApiField(
            name: 'category_id',
            label: 'Category ID',
            hint: 'ID of the category to retrieve',
            isRequired: true,
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'jwt_token',
            label: 'JWT Token (Optional)',
            hint: 'JWT authentication token (auto-loaded from storage if empty)',
            isRequired: false,
          ),
        ],
      };

  Map<String, List<ApiField>> get optionalFields => {
        'GET': [
          const ApiField(
            name: 'context',
            label: 'Context',
            hint: 'view or edit (default: view)',
          ),
        ],
      };

  String get documentation => '''
# Retrieve Product Category API

Retrieve a single product category by ID from your WooCommerce store.

## Endpoint

- **Method**: GET
- **Endpoint**: `/wp-json/wc/store/{api_version}/products/categories/{category_id}`
- **Description**: Retrieve a single product category by ID

## Parameters

### Required Parameters
- **api_version**: API version (e.g., "v1")
- **category_id**: ID of the category to retrieve

### Optional Parameters
- **context**: Response context (view, edit)

## Example Response

```json
{
  "id": 15,
  "name": "Clothing",
  "slug": "clothing",
  "description": "Clothing products including shirts, pants, and accessories",
  "parent": 0,
  "count": 42,
  "image": {
    "id": 123,
    "src": "https://example.com/wp-content/uploads/category-image.jpg",
    "name": "category-image.jpg",
    "alt": "Clothing category"
  },
  "review_count": 0,
  "permalink": "https://example.com/product-category/clothing/"
}
```

## Usage Examples

### Retrieve category by ID
```
GET /wp-json/wc/store/v1/products/categories/15
```

### Retrieve category with edit context
```
GET /wp-json/wc/store/v1/products/categories/15?context=edit
```

## Error Responses

### Category not found
```json
{
  "code": "woocommerce_rest_invalid_id",
  "message": "Invalid ID.",
  "data": {
    "status": 404
  }
}
```

### Invalid category ID
```json
{
  "code": "woocommerce_rest_invalid_id",
  "message": "Invalid ID.",
  "data": {
    "status": 404
  }
}
```
''';

  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    try {
      final apiVersion = params['api_version']!;
      final categoryId = params['category_id']!;

      // 🔐 Auto-fetch JWT token from local storage
      String? jwtToken = params['jwt_token'];
      if (jwtToken == null || jwtToken.isEmpty) {
        try {
          debugPrint('🔍 Loading JWT token from storage...');
          final storedJwt = await WooJwtTokenStorage.loadToken();
          jwtToken = storedJwt?.accessToken;
          
          if (jwtToken != null && jwtToken.isNotEmpty) {
            debugPrint('🔐 JWT token loaded from storage: ${jwtToken.length > 20 ? jwtToken.substring(0, 20) + "..." : jwtToken}');
          } else {
            debugPrint('⚠️ No JWT token found in storage');
          }
        } catch (e) {
          debugPrint('❌ Could not load JWT token from storage: $e');
        }
      }

      // JWT token is optional - just log if missing
      if (jwtToken == null || jwtToken.isEmpty) {
        debugPrint('⚠️ JWT token not provided - continuing without authentication');
      } else {
        debugPrint('🔐 JWT token available for authenticated request');
      }

      debugPrint('🔍 Starting retrieve product category:');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - Category ID: $categoryId');
      debugPrint('  - JWT Token Available: ${jwtToken != null && jwtToken.isNotEmpty}');

      // Get the service from GetIt
      final service = GetIt.I<StoreProductCategoriesService>();

      if (method == 'GET') {
        // Parse and validate category ID
        final categoryIdInt = int.tryParse(categoryId);
        if (categoryIdInt == null) {
          return {
            'success': false,
            'error': 'Invalid category_id. Must be a number.',
          };
        }

        final context = params['context'];

        // Call the service
        final category = await service.retrieveProductCategory(
          apiVersion: apiVersion,
          categoryId: categoryIdInt,
          context: context,
        );

        return {
          'success': true,
          'data': category.toJson(),
          'message': 'Product category retrieved successfully',
          'auth_info': {
            'jwt_token_source': params.containsKey('jwt_token') && params['jwt_token']!.isNotEmpty ? 'manual' : 'auto_storage',
            'jwt_token_available': jwtToken != null && jwtToken.isNotEmpty,
          },
          'params': params,
          'timestamp': DateTime.now().toIso8601String(),
        };
      }

      return {
        'success': false,
        'error': 'Unsupported method: $method',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to handle request: $e',
      };
    }
  }
}
