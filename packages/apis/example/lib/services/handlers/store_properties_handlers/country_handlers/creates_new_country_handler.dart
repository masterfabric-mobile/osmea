import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/country/abstract/country_service.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/creates_country_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:example/services/api_service_registry.dart';

///**************************************************************
///******************** 🌍 CREATE COUNTRY ***********************
///**************************************************************

class CreateCountryHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'POST') {
      return _errorResponse(
        "Method $method not supported. Only POST is allowed.",
      );
    }

    final name = params['name'];
    final code = params['code'];

    if (name == null || name.isEmpty || code == null || code.isEmpty) {
      return _errorResponse(
        "Missing required parameters: 'name' and/or 'code'.",
      );
    }

    try {
      final request = CreatesCountryRequest(
        country: Country(
          name: name,
          code: code,
          tax: 0,
          taxName: "Default VAT",
          provinces: [],
        ),
      );

      await GetIt.I<CountryService>().createCountry(
        apiVersion: ApiNetwork.apiVersion,
        model: request,
      );

      return {
        "status": "success",
        "message": "Country created successfully.",
        "country": request.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return _errorResponse("Failed to create country: ${e.toString()}");
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

  Map<String, dynamic> _errorResponse(String message) => {
        "status": "error",
        "message": message,
        "timestamp": DateTime.now().toIso8601String(),
      };
}
