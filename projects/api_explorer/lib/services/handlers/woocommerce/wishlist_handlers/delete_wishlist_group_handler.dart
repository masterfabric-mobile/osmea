import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:api_explorer/services/api_service_registry.dart';

///*******************************************************************
///*************** 🗑️ DELETE WISHLIST GROUP HANDLER ****************
///*******************************************************************

class DeleteWishlistGroupHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported for Delete Wishlist Group API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate required parameter
    if (!params.containsKey('group_id') || params['group_id']!.isEmpty) {
      return {
        "status": "error",
        "message": "Group ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Parse group ID
      final groupId = int.tryParse(params['group_id']!);
      if (groupId == null) {
        return {
          "status": "error",
          "message": "Group ID must be a valid integer",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      final response = await GetIt.I<WooWishlistService>().deleteGroup(
        namespace: 'masterfabric-wishlist',
        apiVersion: 'v1',
        groupId: groupId,
      );

      // Check if the deletion was successful
      if (response.success == true) {
        return {
          "status": "success",
          "message": response.message ?? "Wishlist group deleted successfully",
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        return {
          "status": "error",
          "message": response.message ?? "Failed to delete wishlist group",
          "error_code": response.errorCode,
          "errors": response.errors,
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to delete wishlist group: ${e.toString()}",
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
            name: 'group_id',
            label: 'Group ID',
            hint: 'ID of the wishlist group to delete',
            isRequired: true,
            type: ApiFieldType.number,
          ),
        ],
      };
}