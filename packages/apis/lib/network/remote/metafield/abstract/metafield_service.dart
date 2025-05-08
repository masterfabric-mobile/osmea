import 'package:apis/network/remote/metafield/freezed_model/request/create_metafield_request.dart';
import 'package:apis/network/remote/metafield/freezed_model/response/create_metafield_response.dart';

abstract class MetafieldService {
  /// 📦 Retrieves a list of metafields from the API.
  Future<CreateMetafieldResponse> createMetafield({
    required String apiVersion,
    required CreateMetafieldRequest model,
    required String ownerResource,
    required String ownerId,
  });


}