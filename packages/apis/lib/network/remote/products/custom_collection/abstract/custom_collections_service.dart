import 'package:apis/network/remote/products/custom_collection/freezed_model/response/list_all_custom_collections_response.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/response/specific_custom_collections_response.dart';

abstract class CustomCollectionsService {
  // 📋 List all custom collections
  Future<ListAllCustomCollectionsResponse> listAllCustomCollections({
    required String apiVersion,
    int? limit,
    String? fields,
    String? updatedAtMin,
    String? updatedAtMax,
    String? publishedAtMin,
    String? publishedAtMax,
    String? handle,
    String? ids,
    String? title,
    String? since_id,
    String? product_id,
    String? published_status,
  });

  // 📋 Get specific custom collection by ID
  Future<SpecificCustomCollectionsResponse> specificCustomCollections({
    required String apiVersion,
    required int custom_collection_id,
    String? fields,
  });
}