import 'package:apis/network/remote/store_properties/currency/freezed_model//retrieves_list_of_currencies_response.dart';

/// 💱 Abstract contract for Currency Service
/// Implement this to interact with Shopify Currency API
abstract class CurrencyService {
  /// 📥 Retrieve a list of currencies from Shopify
  Future<RetrievesListOfCurrenciesResponse> retrieveListOfCurrencies({
    required String apiVersion,
  });
}
