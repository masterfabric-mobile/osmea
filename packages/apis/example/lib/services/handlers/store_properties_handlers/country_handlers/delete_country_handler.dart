import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/country/abstract/country_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';

import 'package:get_it/get_it.dart';

///**************************************************************
///******************** ❌ DELETE COUNTRY BY ID *****************
///**************************************************************

class DeleteCountryHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'DELETE') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only DELETE is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    final id = params['id'];
    if (id == null || id.isEmpty) {
      return {
        "status": "error",
        "message": "Missing required parameter: 'id'",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      await GetIt.I<CountryService>().deleteCountry(
        apiVersion: ApiNetwork.apiVersion,
        id: id,
      );

      return {
        "status": "success",
        "message": "Country deleted successfully.",
        "country_id": id,
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to delete country: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'DELETE': [
          const ApiField(
            name: 'id',
            label: 'Country ID',
            hint: 'The ID of the country to delete',
            isRequired: true,
          ),
        ],
      };
}
