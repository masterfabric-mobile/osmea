import 'package:apis/network/remote/store_properties/province/freezed_model/request/updates_existing_province_for_country_request.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_count_of_provinces_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_list_of_provinces_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_single_province_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/updates_existing_province_for_country_response.dart';

/// 🗺️ Abstract contract for Province Service
/// Implement this to interact with Shopify Provinces API
abstract class ProvinceService {
  /// 📍 Retrieve list of provinces for a specific country
  Future<RetrievesListOfProvincesForCountryResponse>
      retrieveProvincesForCountry({
    required String apiVersion,
    required String countryId,
    String? sinceId,
    String? fields,
  });

  /// 📍 Retrieve a single province by ID
  Future<RetrievesSingleProvinceForCountryResponse>
      retrieveSingleProvinceForCountry({
    required String apiVersion,
    required String countryId,
    required String provinceId,
    String? fields,
  });

  /// 🔢 Retrieve the count of provinces for a specific country
  Future<RetrievesCountOfProvincesForCountryResponse>
      retrieveCountOfProvincesForCountry({
    required String apiVersion,
    required String countryId,
  });

  /// ✏️ Update an existing province by ID
  Future<UpdatesExistingProvinceForCountryResponse> updateProvinceForCountry({
    required String apiVersion,
    required String countryId,
    required String provinceId,
    required UpdatesExistingProvinceForCountryRequest model,
  });
}
