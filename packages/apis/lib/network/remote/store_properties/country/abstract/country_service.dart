import 'package:apis/network/remote/store_properties/country/freezed_model/request/creates_country_request.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/create_country_using_custom_tax_rate_request.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/create_country_using_shopify_tax_rate_request.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/response/receive_list_of_countries_response.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/response/retrieves_count_of_countries_response.dart';

/// 🌍 Abstract contract for Country Service
/// Implement this to interact with Shopify Country API
abstract class CountryService {
  /// 📋 Receive a list of countries and their provinces (with optional filters)
  Future<ReceiveListOfCountriesResponse> receiveListOfCountries({
    required String apiVersion,
    String? sinceId,
    String? fields,
  });

  /// 🔢 Retrieve count of countries
  Future<RetrievesCountOfCountriesResponse> retrievesCountOfCountries({
    required String apiVersion,
  });

  /// 🏋️ Create a new country with default tax rate
  Future<void> createCountry({
    required String apiVersion,
    required CreatesCountryRequest model,
  });

  /// 🏋️ Create a new country using custom tax rate
  Future<void> createCountryUsingCustomTaxRate({
    required String apiVersion,
    required CreateCountryUsingCustomTaxRateRequest model,
  });

  /// 🏋️ Create a new country using Shopify tax rate
  Future<void> createCountryUsingShopifyTaxRate({
    required String apiVersion,
    required CreateCountryUsingShopifyTaxRateRequest model,
  });
}
