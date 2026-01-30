import 'package:apis/network/remote/woocommerce/wishlist/abstract/woo_wishlist_service.dart';
import 'package:api_explorer/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:api_explorer/services/api_service_registry.dart';

///*******************************************************************
///************* 📋 GET ALL WISHLIST GROUPS HANDLER *****************
///*******************************************************************

class GetAllWishlistGroupsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Get All Wishlist Groups API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      // Parse query parameters
      final page =
          params['page'] != null ? int.tryParse(params['page']!) : null;
      final perPage =
          params['per_page'] != null ? int.tryParse(params['per_page']!) : null;

      final response = await GetIt.I<WooWishlistService>().getAllGroups(
        namespace: 'masterfabric-wishlist',
        apiVersion: 'v1',
        page: page,
        perPage: perPage,
      );

      // Handle the wrapper response structure
      final responseJson = response.toJson();
      final groups = (responseJson['groups'] as List<dynamic>?)
          ?.map((group) => group as Map<String, dynamic>)
          .toList() ?? [];

      return {
        "status": "success",
        "groups": groups,
        "total": groups.length,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to fetch wishlist groups: ${e.toString()}",
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