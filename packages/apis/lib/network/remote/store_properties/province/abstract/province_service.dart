import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_list_of_provinces_for_country_response.dart';

/// 🗺️ Abstract contract for Province Service
/// Implement this to interact with Shopify Provinces API
abstract class ProvinceService {
  /// 📍 Retrieve list of provinces for a specific country
  Future<RetrievesListOfProvincesForCountryResponse>
      retrieveListOfProvincesForCountry({
    required String apiVersion,
    required String countryId,
  });
}
