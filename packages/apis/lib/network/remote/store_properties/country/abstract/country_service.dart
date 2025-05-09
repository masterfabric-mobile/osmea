import 'package:apis/network/remote/store_properties/country/freezed_model/response/receive_list_of_countries_response.dart';

/// 🌍 Abstract contract for Country Service
/// Implement this to interact with Shopify Country API
abstract class CountryService {
  /// 📋 Receive a list of countries and their provinces (with optional filters)
  Future<ReceiveListOfCountriesResponse> receiveListOfCountries({
    required String apiVersion,
    String? sinceId,
    String? fields,
  });
}
