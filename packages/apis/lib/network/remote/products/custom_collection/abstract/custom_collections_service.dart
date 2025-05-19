import 'package:apis/network/remote/products/custom_collection/freezed_model/request/create_custom_collection_request.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/request/create_unpublished_custom_collection_request.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/response/count_custom_collections_response.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/response/create_custom_collection_response.dart';
import 'package:apis/network/remote/products/custom_collection/freezed_model/response/create_unpublished_custom_collection_response.dart';
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

  // 📋 Count Custom Collections Response
  Future<CountCustomCollectionsResponse> countCustomCollections({
    required String apiVersion,
    String? title,
    String? updatedAtMin,
    String? updatedAtMax,
    String? publishedAtMin,
    String? publishedAtMax,
    String? product_id,
    String? published_status,
  });

  // ➕ Create Custom Collection
  Future<CreateCustomCollectionResponse> createCustomCollection({
    required String apiVersion,
    required CreateCustomCollectionRequest model
  });

  // ➕ Create Unpublished Custom Collection
  Future<CreateUnpublishedCustomCollectionResponse> createUnpublishedCustomCollection({
    required String apiVersion,
    required CreateUnpublishedCustomCollectionRequest model
  });
}