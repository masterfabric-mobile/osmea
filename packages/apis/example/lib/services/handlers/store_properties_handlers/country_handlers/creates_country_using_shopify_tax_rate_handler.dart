import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/country/abstract/country_service.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/create_country_using_shopify_tax_rate_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*********** 🌍 CREATE COUNTRY WITH SHOPIFY TAX **************
///**************************************************************

class CreateCountryUsingShopifyTaxRateHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only POST is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    final name = params['name'];
    final code = params['code'];

    if (name == null || name.isEmpty || code == null || code.isEmpty) {
      return {
        "status": "error",
        "message": "Missing required parameters: 'name' and/or 'code'.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final request = CreateCountryUsingShopifyTaxRateRequest(
        country: Country(
          name: name,
          code: code,
          tax: null, // Shopify default tax
          taxName: "Shopify VAT",
          provinces: [],
        ),
      );

      await GetIt.I<CountryService>().createCountryUsingShopifyTaxRate(
        apiVersion: ApiNetwork.apiVersion,
        model: request,
      );

      return {
        "status": "success",
        "message": "Country created successfully using Shopify tax rate.",
        "country": request.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to create country: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
            name: 'name',
            label: 'Country Name',
            hint: 'Name of the country to be created',
            isRequired: true,
          ),
          const ApiField(
            name: 'code',
            label: 'Country Code',
            hint: 'ISO 2-letter country code (e.g., US, TR)',
            isRequired: true,
          ),
        ],
      };
}
