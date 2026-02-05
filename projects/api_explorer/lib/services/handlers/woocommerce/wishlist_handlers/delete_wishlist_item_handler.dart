import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/delete_wishlist_item_request.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:api_explorer/services/api_service_registry.dart';

///*******************************************************************
///*************** 🗑️ DELETE WISHLIST ITEM HANDLER *****************
///*******************************************************************

class DeleteWishlistItemHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported for Delete Wishlist Item API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Check if we have item_id (delete by ID) or product_id + group_id (delete by product)
      if (params.containsKey('item_id') && params['item_id']!.isNotEmpty) {
        // Delete by item ID
        final itemId = int.tryParse(params['item_id']!);
        if (itemId == null) {
          return {
            "status": "error",
            "message": "Item ID must be a valid integer",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        final response = await GetIt.I<WooWishlistService>().deleteItemById(
          namespace: 'masterfabric-wishlist',
          apiVersion: 'v1',
          itemId: itemId,
        );

        // Check if the deletion was successful
        if (response.success == true) {
          return {
            "status": "success",
            "message": response.message ?? "Wishlist item deleted successfully (by ID)",
            "params": params,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else {
          return {
            "status": "error",
            "message": response.message ?? "Failed to delete wishlist item",
            "error_code": response.errorCode,
            "errors": response.errors,
            "params": params,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      } else if (params.containsKey('product_id') && 
                 params.containsKey('group_id') &&
                 params['product_id']!.isNotEmpty && 
                 params['group_id']!.isNotEmpty) {
        // Delete by product ID and group ID
        final productId = int.tryParse(params['product_id']!);
        if (productId == null) {
          return {
            "status": "error",
            "message": "Product ID must be a valid integer",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        final groupId = int.tryParse(params['group_id']!);
        if (groupId == null) {
          return {
            "status": "error",
            "message": "Group ID must be a valid integer",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        final deleteRequest = DeleteWishlistItemRequest(
          productId: productId,
          groupId: groupId,
        );

        final response = await GetIt.I<WooWishlistService>().deleteItemByProduct(
          namespace: 'masterfabric-wishlist',
          apiVersion: 'v1',
          request: deleteRequest,
        );

        // Check if the deletion was successful
        if (response.success == true) {
          return {
            "status": "success",
            "message": response.message ?? "Wishlist item deleted successfully (by product)",
            "params": params,
            "timestamp": DateTime.now().toIso8601String(),
          };
        } else {
          return {
            "status": "error",
            "message": response.message ?? "Failed to delete wishlist item",
            "error_code": response.errorCode,
            "errors": response.errors,
            "params": params,
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
      } else {
        return {
          "status": "error",
          "message": "Either 'item_id' or both 'product_id' and 'group_id' are required",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to delete wishlist item: ${e.toString()}",
        "params": params,
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
            name: 'item_id',
            label: 'Item ID',
            hint: 'ID of the wishlist item to delete (use this OR product_id + group_id)',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'product_id',
            label: 'Product ID',
            hint: 'ID of the product to remove (use with group_id)',
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'group_id',
            label: 'Group ID',
            hint: 'ID of the group to remove product from (use with product_id)',
            type: ApiFieldType.number,
          ),
        ],
      };
}