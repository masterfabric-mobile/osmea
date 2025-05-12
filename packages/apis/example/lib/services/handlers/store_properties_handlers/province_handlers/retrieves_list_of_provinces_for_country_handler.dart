import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/province/abstract/province_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:example/services/api_service_registry.dart';

///**************************************************************
///************* 🗺️ RETRIEVE PROVINCES FOR COUNTRY *************
///**************************************************************

class RetrievesListOfProvincesForCountryHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "error": "Method $method not supported. Only GET is allowed.",
      };
    }

    final countryId = params['country_id'];
    final sinceId = params['since_id'];
    final fields = params['fields'];

    if (countryId == null || countryId.isEmpty) {
      return {
        "status": "error",
        "message": "Missing required parameter: country_id",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final response =
          await GetIt.I<ProvinceService>().retrieveProvincesForCountry(
        apiVersion: ApiNetwork.apiVersion,
        countryId: countryId,
        sinceId: sinceId,
        fields: fields,
      );

      return {
        "status": "success",
        "data": {
          "provinces": response.provinces?.map((e) => e.toJson()).toList(),
        },
        "params": {
          "country_id": countryId,
          "since_id": sinceId,
          "fields": fields,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve provinces: ${e.toString()}",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['GET'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'country_id',
            label: 'Country ID',
            hint: 'The ID of the country to fetch provinces for',
            isRequired: true,
          ),
          const ApiField(
            name: 'since_id',
            label: 'Since ID',
            hint: 'Only return provinces after this ID',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
          ),
        ],
      };
}
