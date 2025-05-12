import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_list_of_provinces_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_single_province_for_country_response.dart';

abstract class ProvinceService {
  /// 📍 Retrieve list of provinces for a specific country
  Future<RetrievesListOfProvincesForCountryResponse>
      retrieveProvincesForCountry({
    required String apiVersion,
    required String countryId,
    String? sinceId,
    String? fields,
  });

  /// 📍 Retrieve a single province for a specific country
  Future<RetrievesSingleProvinceForCountryResponse>
      retrieveSingleProvinceForCountry({
    required String apiVersion,
    required String countryId,
    required String provinceId,
    String? fields,
  });
}
