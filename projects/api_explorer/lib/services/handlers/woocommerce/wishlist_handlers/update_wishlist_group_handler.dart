import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:apis/network/remote/woocommerce/wishlist/freezed_model/request/update_wishlist_group_request.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:api_explorer/services/api_service_registry.dart';

///*******************************************************************
///*************** 🔄 UPDATE WISHLIST GROUP HANDLER ****************
///*******************************************************************

class UpdateWishlistGroupHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'PATCH') {
      return {
        "status": "error",
        "message": "Method $method not supported for Update Wishlist Group API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate required parameters
    if (!params.containsKey('group_id') || params['group_id']!.isEmpty) {
      return {
        "status": "error",
        "message": "Group ID is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    if (!params.containsKey('name') || params['name']!.isEmpty) {
      return {
        "status": "error",
        "message": "Group name is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Parse group ID - convert string to int for API call
      final groupIdString = params['group_id']!;
      final groupId = int.tryParse(groupIdString);
      if (groupId == null) {
        return {
          "status": "error",
          "message": "Group ID must be a valid integer, received: $groupIdString",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      // Parse parameters
      final name = params['name']!;
      final description = params['description'];

      // Create update request
      final updateData = UpdateWishlistGroupRequest(
        name: name,
        description: description,
      );

      final response = await GetIt.I<WooWishlistService>().updateGroup(
        namespace: 'masterfabric-wishlist',
        apiVersion: 'v1',
        groupId: groupId,
        request: updateData,
      );

      // Check if the update was successful using the standard WishlistApiResponse structure
      if (response.success == true) {
        // If we have data, use it; otherwise create a response with the input values
        final groupData = response.data != null ? {
          "id": response.data!.id,
          "name": response.data!.name,
          "description": response.data!.description,
          "created_at": response.data!.createdAt,
        } : {
          "id": groupId,
          "name": name,
          "description": description,
        };

        return {
          "status": "success",
          "message": response.message ?? "Wishlist group updated successfully",
          "group": groupData,
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        return {
          "status": "error",
          "message": response.message ?? "Failed to update wishlist group",
          "error_code": response.errorCode,
          "errors": response.errors,
          "params": params,
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to update wishlist group: ${e.toString()}",
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['PATCH'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PATCH': [
          const ApiField(
            name: 'group_id',
            label: 'Group ID',
            hint: 'ID of the wishlist group to update',
            isRequired: true,
            type: ApiFieldType.number,
          ),
          const ApiField(
            name: 'name',
            label: 'Group Name',
            hint: 'New name for the wishlist group',
            isRequired: true,
          ),
          const ApiField(
            name: 'description',
            label: 'Description',
            hint: 'New description for the group',
          ),
        ],
      };
}