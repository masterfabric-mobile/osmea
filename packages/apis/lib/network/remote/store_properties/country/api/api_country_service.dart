import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/store_properties/country/abstract/country_service.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/response/receive_list_of_countries_response.dart';
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

  /// 🌍 Receive a list of countries and their provinces (with optional filters)
  @override
  @GET('/api/{api_version}/countries.json')
  Future<ReceiveListOfCountriesResponse> receiveListOfCountries({
    @Path('api_version') required String apiVersion,
    @Query('since_id') String? sinceId,
    @Query('fields') String? fields,
  });
}
