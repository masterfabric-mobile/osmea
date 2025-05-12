import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/country/abstract/country_service.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/create_country_using_custom_tax_rate_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:example/services/api_service_registry.dart';

///**************************************************************
///************* 🌍 CREATE COUNTRY WITH CUSTOM TAX *************
///**************************************************************

class CreateCountryWithCustomTaxHandler implements ApiRequestHandler {
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
    final tax = double.tryParse(params['tax'] ?? '0');

    if (name == null ||
        name.isEmpty ||
        code == null ||
        code.isEmpty ||
        tax == null) {
      return {
        "status": "error",
        "message": "Missing or invalid parameters: 'name', 'code', or 'tax'.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final request = CreateCountryUsingCustomTaxRateRequest(
        country: Country(
          name: name,
          code: code,
          tax: tax,
          taxName: "Custom VAT",
          provinces: [],
        ),
      );

      await GetIt.I<CountryService>().createCountryUsingCustomTaxRate(
        apiVersion: ApiNetwork.apiVersion,
        model: request,
      );

      return {
        "status": "success",
        "message": "Country created with custom tax rate successfully.",
        "country": request.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to create country with custom tax: ${e.toString()}",
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
          const ApiField(
            name: 'tax',
            label: 'Tax Rate',
            hint: 'Decimal tax value (e.g., 0.18)',
            isRequired: true,
          ),
        ],
      };
}
