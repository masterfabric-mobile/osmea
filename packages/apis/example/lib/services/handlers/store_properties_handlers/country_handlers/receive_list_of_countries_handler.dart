import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/country/abstract/country_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import '../../../api_service_registry.dart';

///**************************************************************
///*************** 🌍 LIST COUNTRIES HANDLER *******************
///**************************************************************

class ReceivesListOfCountriesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    if (method != 'GET') {
      return {
        "error": "Method $method not supported. Only GET is allowed.",
      };
    }

    try {
      final sinceId = params['since_id'];
      final fields = params['fields'];

      final response =
          await GetIt.I.get<CountryService>().receiveListOfCountries(
                apiVersion: ApiNetwork.apiVersion,
                sinceId: sinceId,
                fields: fields,
              );

      return {
        "status": "success",
        "data": response.toJson(),
        "params": {
          "since_id": sinceId,
          "fields": fields,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve countries: ${e.toString()}",
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
            name: 'since_id',
            label: 'Since ID',
            hint: 'Restrict results to after the specified ID',
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
          ),
        ],
      };
}
