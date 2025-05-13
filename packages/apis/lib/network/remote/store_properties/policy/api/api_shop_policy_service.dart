import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/store_properties/policy/abstract/shop_policy_service.dart';
import 'package:apis/network/remote/store_properties/policy/freezed_model/retrieves_list_of_shop_policies_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_shop_policy_service.g.dart';

@RestApi()
@Injectable(as: ShopPolicyService)
abstract class ShopPolicyServiceClient implements ShopPolicyService {
  @factoryMethod
  factory ShopPolicyServiceClient(Dio dio) => _ShopPolicyServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔍 Retrieve list of shop policies
  @GET('/api/{api_version}/policies.json')
  Future<RetrievesListOfShopPoliciesResponse> retrieveListOfShopPolicies({
    @Path('api_version') required String apiVersion,
  });
}
