import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/inventory/inventory_level/abstract/inventory_level_service.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/inventory_item_at_location_request.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/inventory_item_at_location_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_inventory_level_service.g.dart';

@RestApi()
@Injectable(as: InventoryLevelService)

/// 🌐 InventoryLevelService
abstract class InventoryLevelServiceClient implements InventoryLevelService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory InventoryLevelServiceClient(Dio dio) =>
      _InventoryLevelServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔑 🔍 Adjusts the inventory level for an item at a location.
  @POST('/api/{api_version}/inventory_levels/adjust.json')
  Future<InventoryItemAtLocationResponse> inventoryItemAtLocation({
    @Path('api_version') required String apiVersion,
    @Body() required InventoryItemAtLocationRequest model,

  });
}