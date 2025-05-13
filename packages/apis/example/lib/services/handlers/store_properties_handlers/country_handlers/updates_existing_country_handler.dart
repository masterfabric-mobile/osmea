import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/country/abstract/country_service.dart';
import 'package:apis/network/remote/store_properties/country/freezed_model/request/updates_existing_country_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///******************** 🌍 UPDATE EXISTING COUNTRY **************
///**************************************************************

class UpdatesExistingCountryHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'PUT') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only PUT is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    final id = params['id'];
    final name = params['name'];
    final code = params['code'];
    final tax = double.tryParse(params['tax'] ?? '');
    final taxName = params['tax_name'];

    if (id == null || id.isEmpty) {
      return {
        "status": "error",
        "message": "Missing required parameter: 'id'.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final request = UpdatesExistingCountryRequest(
        country: Country(
          id: int.tryParse(id) ?? 0,
          name: name,
          code: code,
          tax: tax,
          taxName: taxName,
          provinces: [],
        ),
      );

      final response = await GetIt.I<CountryService>().updateCountry(
        apiVersion: ApiNetwork.apiVersion,
        id: id,
        model: request,
      );

      return {
        "status": "success",
        "message": "Country updated successfully.",
        "country": response.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to update country: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['PUT'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'PUT': [
          const ApiField(
            name: 'id',
            label: 'Country ID',
            hint: 'ID of the country to update',
            isRequired: true,
          ),
          const ApiField(
            name: 'name',
            label: 'Country Name',
            hint: 'Name of the country',
          ),
          const ApiField(
            name: 'code',
            label: 'Country Code',
            hint: 'ISO 2-letter country code',
          ),
          const ApiField(
            name: 'tax',
            label: 'Tax',
            hint: 'Tax percentage (e.g. 0.18)',
          ),
          const ApiField(
            name: 'tax_name',
            label: 'Tax Name',
            hint: 'Label for the tax (e.g. VAT)',
          ),
        ],
      };
}
