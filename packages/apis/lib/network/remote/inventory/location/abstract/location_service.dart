import 'package:apis/network/remote/inventory/location/freezed_model/list_all_locations_response.dart';

abstract class LocationService {
  Future<ListAllLocationsResponse> listAllLocations({
    required String apiVersion,
  });
}