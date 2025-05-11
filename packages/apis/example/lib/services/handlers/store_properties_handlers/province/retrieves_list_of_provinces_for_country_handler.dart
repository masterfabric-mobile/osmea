import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/province/abstract/province_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///*************** 🏞️ RETRIEVE PROVINCES FOR COUNTRY ***********
///**************************************************************

class RetrievesListOfProvincesHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported. Only GET is allowed.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    final countryId = params['country_id'];
    if (countryId == null || countryId.isEmpty) {
      return {
        "status": "error",
        "message": "Missing required parameter: 'country_id'",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final response =
          await GetIt.I<ProvinceService>().retrieveListOfProvincesForCountry(
        apiVersion: ApiNetwork.apiVersion,
        countryId: countryId,
      );

      return {
        "status": "success",
        "message": "Provinces retrieved successfully.",
        "provinces": response.toJson(),
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
            hint: 'ID of the country to fetch provinces for',
            isRequired: true,
          ),
        ],
      };
}
