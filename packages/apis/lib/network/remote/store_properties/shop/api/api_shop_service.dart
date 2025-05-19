import 'package:apis/apis.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:injectable/injectable.dart';
import 'package:apis/network/remote/store_properties/shop/freezed_model/retrieves_the_shop_configuration_response.dart';
import 'package:apis/network/remote/store_properties/shop/abstract/shop_service.dart';

part 'api_shop_service.g.dart';

@RestApi()
@Injectable(as: ShopService)
abstract class ShopServiceClient implements ShopService {
  @factoryMethod
  factory ShopServiceClient(Dio dio) => _ShopServiceClient(
        dio,
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🏪 Retrieve the shop's configuration
  @override
  @GET('/api/{api_version}/shop.json')
  Future<RetrievesTheShopConfigurationResponse> retrieveShopConfiguration({
    @Path('api_version') required String apiVersion,
    @Query('fields') String? fields,
  });
}
