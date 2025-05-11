import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/store_properties/currency/abstract/currency_service.dart';
import 'package:apis/network/remote/store_properties/currency/freezed_model//retrieves_list_of_currencies_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_currency_service.g.dart';

@RestApi()
@Injectable(as: CurrencyService)
abstract class CurrencyServiceClient implements CurrencyService {
  @factoryMethod
  factory CurrencyServiceClient(Dio dio) => _CurrencyServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @GET('/api/{api_version}/currencies.json')
  Future<RetrievesListOfCurrenciesResponse> retrieveListOfCurrencies({
    @Path('api_version') required String apiVersion,
  });
}
