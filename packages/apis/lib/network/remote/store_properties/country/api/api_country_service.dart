// ✅ api_country_service.dart
import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/store_properties/country/abstract/country_service.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/creates_country_request.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/create_country_using_custom_tax_rate_request.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/create_country_using_shopify_tax_rate_request.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/updates_existing_country_request.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/response/receive_list_of_countries_response.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/response/retrieves_count_of_countries_response.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/response/updates_existing_country_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_country_service.g.dart';

@RestApi()
@Injectable(as: CountryService)
abstract class CountryServiceClient implements CountryService {
  @factoryMethod
  factory CountryServiceClient(Dio dio) => _CountryServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @GET('/api/{api_version}/countries.json')
  Future<ReceiveListOfCountriesResponse> receiveListOfCountries({
    @Path('api_version') required String apiVersion,
    @Query('since_id') String? sinceId,
    @Query('fields') String? fields,
  });

  @override
  @GET('/api/{api_version}/countries/count.json')
  Future<RetrievesCountOfCountriesResponse> retrievesCountOfCountries({
    @Path('api_version') required String apiVersion,
  });

  @override
  @POST('/api/{api_version}/countries.json')
  Future<void> createCountry({
    @Path('api_version') required String apiVersion,
    @Body() required CreatesCountryRequest model,
  });

  @override
  @POST('/api/{api_version}/countries.json')
  Future<void> createCountryUsingCustomTaxRate({
    @Path('api_version') required String apiVersion,
    @Body() required CreateCountryUsingCustomTaxRateRequest model,
  });

  @override
  @POST('/api/{api_version}/countries.json')
  Future<void> createCountryUsingShopifyTaxRate({
    @Path('api_version') required String apiVersion,
    @Body() required CreateCountryUsingShopifyTaxRateRequest model,
  });

  @override
  @PUT('/api/{api_version}/countries/{id}.json')
  Future<UpdatesExistingCountryResponse> updateCountry({
    @Path('api_version') required String apiVersion,
    @Path('id') required String id,
    @Body() required UpdatesExistingCountryRequest model,
  });
}
