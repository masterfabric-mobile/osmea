import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/province/abstract/province_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

///**************************************************************
///********** 🔢 COUNT PROVINCES FOR SPECIFIC COUNTRY **********
///**************************************************************

class RetrievesCountOfProvincesForCountryHandler implements ApiRequestHandler {
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
        "message": "Missing required query parameter: country_id",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final response =
          await GetIt.I<ProvinceService>().retrieveCountOfProvincesForCountry(
        apiVersion: ApiNetwork.apiVersion,
        countryId: countryId,
      );

      return {
        "status": "success",
        "data": response.toJson(),
        "params": {"country_id": countryId},
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve province count: ${e.toString()}",
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
            hint: 'The ID of the country to count provinces for',
            isRequired: true,
          ),
        ],
      };
}
