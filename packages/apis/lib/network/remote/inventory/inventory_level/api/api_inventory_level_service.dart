import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/inventory/inventory_level/abstract/inventory_level_service.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/inventory_item_at_location_request.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/inventory_item_to_location_request.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/request/set_inventory_location_request.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/inventory_item_at_location_response.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/inventory_item_to_location_response.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/list_inventory_levels_single_location_response.dart';
import 'package:apis/network/remote/inventory/inventory_level/freezed_model/response/set_inventory_location_response.dart';
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

  /// 🔑 🔍 Connects an inventory item to a location
  @POST('/api/{api_version}/inventory_levels/connect.json')
  Future<InventoryItemToLocationResponse> inventoryItemToLocation({
    @Path('api_version') required String apiVersion,
    @Body() required InventoryItemToLocationRequest model,
  });

  /// 🔑 🔍 Sets the inventory level for an inventory item at a location
  @POST('/api/{api_version}/inventory_levels/set.json')
  Future<SetInventoryLocationResponse> setInventoryLocation({
    @Path('api_version') required String apiVersion,
    @Body() required SetInventoryLocationRequest model,
  });

  /// 🔑 🔍 Retrieves a list of inventory levels for a single location
  @GET('/api/{api_version}/inventory_levels.json')
  Future<ListInventoryLevelsSingleLocationResponse> listInventoryLevelsSingleLocation({
    @Path('api_version') required String apiVersion,
    @Query('location_ids') required String locationId,
    @Query('limit') int? limit,
    @Query('updated_at_min') String? updatedAtMin,
  });
}