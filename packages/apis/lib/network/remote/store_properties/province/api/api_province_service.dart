import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/store_properties/province/abstract/province_service.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_list_of_provinces_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_single_province_for_country_response.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/response/retrieves_count_of_provinces_for_country_response.dart';
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

  @override
  @GET('/api/{api_version}/countries/{country_id}/provinces.json')
  Future<RetrievesListOfProvincesForCountryResponse>
      retrieveProvincesForCountry({
    @Path('api_version') required String apiVersion,
    @Path('country_id') required String countryId,
    @Query('since_id') String? sinceId,
    @Query('fields') String? fields,
  });

  @override
  @GET('/api/{api_version}/countries/{country_id}/provinces/{province_id}.json')
  Future<RetrievesSingleProvinceForCountryResponse>
      retrieveSingleProvinceForCountry({
    @Path('api_version') required String apiVersion,
    @Path('country_id') required String countryId,
    @Path('province_id') required String provinceId,
    @Query('fields') String? fields,
  });
  @override
  @GET('/api/{api_version}/countries/{country_id}/provinces/count.json')
  Future<RetrievesCountOfProvincesForCountryResponse>
      retrieveCountOfProvincesForCountry({
    @Path('api_version') required String apiVersion,
    @Path('country_id') required String countryId,
  });
}
