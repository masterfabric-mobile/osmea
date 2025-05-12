import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/store_properties/province/abstract/province_service.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/request/updates_existing_province_for_country_request.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_list_of_provinces_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_single_province_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_count_of_provinces_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/updates_existing_province_for_country_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_province_service.g.dart';

@RestApi()
@Injectable(as: ProvinceService)
abstract class ProvinceServiceClient implements ProvinceService {
  @factoryMethod
  factory ProvinceServiceClient(Dio dio) => _ProvinceServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  /// 🗺️ Get list of provinces for a country
  @override
  @GET('/api/{api_version}/countries/{country_id}/provinces.json')
  Future<RetrievesListOfProvincesForCountryResponse>
      retrieveProvincesForCountry({
    @Path('api_version') required String apiVersion,
    @Path('country_id') required String countryId,
    @Query('since_id') String? sinceId,
    @Query('fields') String? fields,
  });

  /// 📍 Get a single province by ID
  @override
  @GET('/api/{api_version}/countries/{country_id}/provinces/{province_id}.json')
  Future<RetrievesSingleProvinceForCountryResponse>
      retrieveSingleProvinceForCountry({
    @Path('api_version') required String apiVersion,
    @Path('country_id') required String countryId,
    @Path('province_id') required String provinceId,
    @Query('fields') String? fields,
  });

  /// 🔢 Get count of provinces for a country
  @override
  @GET('/api/{api_version}/countries/{country_id}/provinces/count.json')
  Future<RetrievesCountOfProvincesForCountryResponse>
      retrieveCountOfProvincesForCountry({
    @Path('api_version') required String apiVersion,
    @Path('country_id') required String countryId,
  });

  /// ✏️ Update a province for a country
  @override
  @PUT('/api/{api_version}/countries/{country_id}/provinces/{province_id}.json')
  Future<UpdatesExistingProvinceForCountryResponse> updateProvinceForCountry({
    @Path('api_version') required String apiVersion,
    @Path('country_id') required String countryId,
    @Path('province_id') required String provinceId,
    @Body() required UpdatesExistingProvinceForCountryRequest model,
  });
}
