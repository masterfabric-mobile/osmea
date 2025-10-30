import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_categories_api/abstract/store_product_categories_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:apis/apis.dart';

class StoreListProductCategoriesHandler extends ApiRequestHandler {
  String get serviceName => 'List Product Categories';

  String get serviceDescription =>
      'Retrieve a list of product categories from WooCommerce store';

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
          const ApiField(
            name: 'page',
            label: 'Page',
            hint: 'Current page of the collection (default: 1)',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'per_page',
            label: 'Per Page',
            hint:
                'Maximum number of items to be returned (default: 10, max: 100)',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'search',
            label: 'Search',
            hint: 'Search by category name',
          ),
          const ApiField(
            name: 'exclude',
            label: 'Exclude',
            hint: 'Ensure result set excludes specific IDs (comma-separated)',
          ),
          const ApiField(
            name: 'include',
            label: 'Include',
            hint: 'Limit result set to specific IDs (comma-separated)',
          ),
          const ApiField(
            name: 'offset',
            label: 'Offset',
            hint: 'Offset the result set by a specific number of items',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'order',
            label: 'Order',
            hint: 'Order sort attribute ascending or descending (default: asc)',
          ),
          const ApiField(
            name: 'orderby',
            label: 'Order By',
            hint: 'Sort collection by object attribute (default: name)',
          ),
          const ApiField(
            name: 'hide_empty',
            label: 'Hide Empty',
            hint:
                'Whether to hide resources not assigned to any products (default: false)',
            type: ApiFieldType.boolean,
          ),
          const ApiField(
            name: 'parent',
            label: 'Parent',
            hint: 'Limit result set to resources assigned to a specific parent',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'product',
            label: 'Product ID',
            hint:
                'Limit result set to resources assigned to a specific product',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'slug',
            label: 'Slug',
            hint: 'Limit result set to resources with a specific slug',
          ),
        ],
      };

  String get documentation => '''
# List Product Categories API

Retrieve a paginated list of product categories from your WooCommerce store.

## Endpoint

- **Method**: GET
- **Endpoint**: `/wp-json/wc/store/{api_version}/products/categories`
- **Description**: Retrieve a list of product categories

## Parameters

### Required Parameters
- **api_version**: API version (e.g., "v1")

### Optional Parameters
- **context**: Response context (view, edit)
- **page**: Current page number (default: 1)
- **per_page**: Items per page (default: 10, max: 100)
- **search**: Search term
- **exclude**: Exclude specific IDs (comma-separated)
- **include**: Include specific IDs (comma-separated)
- **offset**: Offset value
- **order**: Sort order (asc, desc)
- **orderby**: Sort by attribute (name, count, etc.)
- **hide_empty**: Hide empty categories (true/false)
- **parent**: Parent category ID
- **product**: Product ID
- **slug**: Category slug

## Example Response

```json
[
  {
    "id": 15,
    "name": "Clothing",
    "slug": "clothing",
    "description": "Clothing products",
    "parent": 0,
    "count": 42,
    "image": null,
    "review_count": 0,
    "permalink": "https://example.com/product-category/clothing/"
  },
  {
    "id": 16,
    "name": "Electronics",
    "slug": "electronics",
    "description": "Electronic products",
    "parent": 0,
    "count": 25,
    "image": null,
    "review_count": 0,
    "permalink": "https://example.com/product-category/electronics/"
  }
]
```

## Usage Examples

### List all categories
```
GET /wp-json/wc/store/v1/products/categories
```

### Search categories
```
GET /wp-json/wc/store/v1/products/categories?search=clothing
```

### Get categories with pagination
```
GET /wp-json/wc/store/v1/products/categories?page=2&per_page=20
```

### Get categories by parent
```
GET /wp-json/wc/store/v1/products/categories?parent=15
```
''';

  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    try {
      final apiVersion = params['api_version']!;

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

      debugPrint('📋 Starting list product categories:');
      debugPrint('  - API Version: $apiVersion');
      debugPrint('  - JWT Token Available: ${jwtToken != null && jwtToken.isNotEmpty}');

      // Get the service from GetIt
      final service = GetIt.I<StoreProductCategoriesService>();

      if (method == 'GET') {
        // Parse parameters
        final context = params['context'];
        final page =
            params['page'] != null ? int.tryParse(params['page']!) : null;
        final perPage = params['per_page'] != null
            ? int.tryParse(params['per_page']!)
            : null;
        final search = params['search'];
        final exclude = params['exclude']
            ?.split(',')
            .map(int.tryParse)
            .where((e) => e != null)
            .cast<int>()
            .toList();
        final include = params['include']
            ?.split(',')
            .map(int.tryParse)
            .where((e) => e != null)
            .cast<int>()
            .toList();
        final offset =
            params['offset'] != null ? int.tryParse(params['offset']!) : null;
        final order = params['order'];
        final orderby = params['orderby'];
        final hideEmpty = params['hide_empty']?.toLowerCase() == 'true';
        final parent =
            params['parent'] != null ? int.tryParse(params['parent']!) : null;
        final product =
            params['product'] != null ? int.tryParse(params['product']!) : null;
        final slug = params['slug'];

        // Call the service
        final categories = await service.listProductCategories(
          apiVersion: apiVersion,
          context: context,
          page: page,
          perPage: perPage,
          search: search,
          exclude: exclude,
          include: include,
          offset: offset,
          order: order,
          orderby: orderby,
          hideEmpty: hideEmpty,
          parent: parent,
          product: product,
          slug: slug,
        );

        return {
          'success': true,
          'data': categories.map((category) => category.toJson()).toList(),
          'message': 'Product categories retrieved successfully',
          'count': categories.length,
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
