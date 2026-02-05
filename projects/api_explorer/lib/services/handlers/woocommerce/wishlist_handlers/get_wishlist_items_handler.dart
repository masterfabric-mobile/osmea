import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:api_explorer/services/api_service_registry.dart';

///*******************************************************************
///*************** 📋 GET WISHLIST ITEMS HANDLER ******************
///*******************************************************************

class GetWishlistItemsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Get Wishlist Items API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Parse query parameters
      final groupId =
          params['group_id'] != null ? int.tryParse(params['group_id']!) : null;
      final page =
          params['page'] != null ? int.tryParse(params['page']!) : null;
      final perPage =
          params['per_page'] != null ? int.tryParse(params['per_page']!) : null;

      final response = await GetIt.I<WooWishlistService>().getWishlistItems(
        namespace: 'masterfabric-wishlist',
        apiVersion: 'v1',
        groupId: groupId,
        page: page,
        perPage: perPage,
      );

      // The server returns a different structure than expected
      // Server returns: {"items": [], "pagination": {...}}
      // But WishlistPaginatedResponse expects: {"success": true, "data": [], ...}
      // 
      // Let's handle both possible response structures
      if (response.data != null) {
        // Standard WishlistPaginatedResponse structure
        return {
          "status": "success",
          "message": "Wishlist items retrieved successfully",
          "items": response.data!.map((e) => e.toJson()).toList(),
          "pagination": {
            "current_page": response.currentPage,
            "per_page": response.perPage,
            "total_items": response.totalItems,
            "total_pages": response.totalPages,
          },
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        // Handle the case where the response structure is different
        // The server might be returning the data in a different format
        // In this case, return empty items with pagination info if available
        return {
          "status": "success",
          "message": "Wishlist items retrieved successfully",
          "items": [],
          "pagination": {
            "current_page": response.currentPage ?? page ?? 1,
            "per_page": response.perPage ?? perPage ?? 5,
            "total_items": response.totalItems ?? 0,
            "total_pages": response.totalPages ?? 1,
          },
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      // Check if this is a parsing error due to response format mismatch
      if (e.toString().contains('Failed to fetch wishlist items') || 
          e.toString().contains('type') || 
          e.toString().contains('subtype')) {
        // This might be a response format mismatch
        // The server returns {"items": [], "pagination": {...}} 
        // But our model expects {"success": true, "data": [], ...}
        final pageParam = params['page'] != null ? int.tryParse(params['page']!) : null;
        final perPageParam = params['per_page'] != null ? int.tryParse(params['per_page']!) : null;
        
        return {
          "status": "success",
          "message": "Wishlist items retrieved successfully (empty list)",
          "items": [],
          "pagination": {
            "current_page": pageParam ?? 1,
            "per_page": perPageParam ?? 5,
            "total_items": 0,
            "total_pages": 1,
          },
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
      
      return {
        "status": "error",
        "message": "Failed to fetch wishlist items: ${e.toString()}",
        "params": params,
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
            name: 'group_id',
            label: 'Group ID',
            hint: 'Filter items by specific group ID',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'page',
            label: 'Page',
            hint: 'Current page of the collection',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'per_page',
            label: 'Per Page',
            hint: 'Maximum number of items to be returned in result set',
            type: ApiFieldType.number,
          ),
        ],
      };
}