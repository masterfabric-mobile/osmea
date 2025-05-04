import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/inventory/inventory_item/abstract/inventory_item_service.dart';
import 'package:apis/network/remote/inventory/inventory_item/freezed_model/request/update_inventory_item_sku_request.dart';
import 'package:apis/network/remote/inventory/inventory_item/freezed_model/response/inventory_item_by_id_response.dart';
import 'package:apis/network/remote/inventory/inventory_item/freezed_model/response/update_inventory_item_sku_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_inventory_item_service.g.dart';

@RestApi()
@Injectable(as: InventoryItemService)

/// 🌐 InventoryItemService
abstract class InventoryItemServiceClient implements InventoryItemService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory InventoryItemServiceClient(Dio dio) =>
      _InventoryItemServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔑 🔍 Retrieves an inventory item by ID from the API.
  @GET('/api/{api_version}/inventory_items/{inventory_item_ids}.json')
  Future<InventoryItemByIdResponse> inventoryItemById({
    @Path('api_version') required String apiVersion,
    @Path('inventory_item_ids') required String inventoryItemId,
  });

  /// 🔑 🔄 Updates the SKU of an inventory item in the API.
  @PUT('/api/{api_version}/inventory_items/{inventory_item_id}.json')
  Future<UpdateInventoryItemSkuResponse> updateInventoryItemSku({
    @Path('api_version') required String apiVersion,
    @Path('inventory_item_id') required String inventoryItemId,
    @Body() required UpdateInventoryItemSkuRequest model,
  });
}
