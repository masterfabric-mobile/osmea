import 'package:apis/network/remote/metafield/freezed_model/request/create_metafield_request.dart';
import 'package:apis/network/remote/metafield/freezed_model/response/create_metafield_response.dart';
import 'package:apis/network/remote/metafield/freezed_model/response/get_specific_metafield_response.dart';
import 'package:apis/network/remote/metafield/freezed_model/response/list_metafields_response.dart';

abstract class MetafieldService {
  /// 📦 Retrieves a list of metafields from the API.
  Future<CreateMetafieldResponse> createMetafield({
    required String apiVersion,
    required CreateMetafieldRequest model,
    required String ownerResource,
    required String ownerId,
  });

  /// 📦 Retrieves a list of metafields from the API.
  Future<ListMetafieldsResponse> listMetafields({
    required String apiVersion,
    required String ownerResource,
    required String ownerId,
    String? createdAtMax,
    String? createdAtMin,
    String? fields,
    String? key,
    int? limit,
    String? namespace,
    String? sinceId,
    String? type,
    String? updatedAtMax,
    String? updatedAtMin,
  });

  /// 📦 Retrieves a specific metafield from the API.
  Future<GetSpecificMetafieldResponse> getSpecificMetafield({
    required String apiVersion,
    required String ownerResource,
    required String ownerId,
    required String metafieldId,
    String? fields,
  });
}
