import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/inventory/location/abstract/location_service.dart';
import 'package:apis/network/remote/inventory/location/freezed_model/list_all_locations_response.dart';
import 'package:apis/network/remote/inventory/location/freezed_model/single_location_by_id_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_location_service.g.dart';

@RestApi()
@Injectable(as: LocationService)
/// 🌐 LocationService
abstract class LocationServiceClient implements LocationService {
  /// 🏭 Factory for dependency injection
  @factoryMethod
  factory LocationServiceClient(Dio dio) =>
      _LocationServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🔑 🔍 List all locations
  @GET('/api/{api_version}/locations.json')
  Future<ListAllLocationsResponse> listAllLocations({
    @Path('api_version') required String apiVersion,
  });

  /// 🔑 🔍 Retrieves a single location by its ID
  @GET('/api/{api_version}/locations/{location_id}.json')
  Future<SingleLocationByIdResponse> getLocationById({
    @Path('api_version') required String apiVersion,
    @Path('location_id') required int locationId,
  });
}