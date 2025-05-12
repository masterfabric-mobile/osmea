import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/province/abstract/province_service.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:example/services/api_service_registry.dart';

///**************************************************************
///*********** 🗺️ RETRIEVE SINGLE PROVINCE HANDLER ************
///**************************************************************

class RetrievesSingleProvinceForCountryHandler implements ApiRequestHandler {
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
    final provinceId = params['province_id'];
    final fields = params['fields'];

    if (countryId == null ||
        countryId.isEmpty ||
        provinceId == null ||
        provinceId.isEmpty) {
      return {
        "status": "error",
        "message": "Missing required parameter: country_id or province_id",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final response =
          await GetIt.I<ProvinceService>().retrieveSingleProvinceForCountry(
        apiVersion: ApiNetwork.apiVersion,
        countryId: countryId,
        provinceId: provinceId,
        fields: fields,
      );

      final province = response.province;

      if (province == null) {
        return {
          "status": "error",
          "message": "Province not found",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }

      final jsonMap = province.toJson();
      final fieldList = fields?.split(',').map((f) => f.trim()).toList();

      final filtered = (fieldList == null || fieldList.isEmpty)
          ? jsonMap
          : Map.fromEntries(
              jsonMap.entries.where((e) => fieldList.contains(e.key)),
            );

      return {
        "status": "success",
        "data": {
          "province": filtered,
        },
        "params": {
          "country_id": countryId,
          "province_id": provinceId,
          "fields": fields,
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to retrieve province: ${e.toString()}",
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
            hint: 'The ID of the country to fetch the province from',
            isRequired: true,
          ),
          const ApiField(
            name: 'province_id',
            label: 'Province ID',
            hint: 'The ID of the specific province to fetch',
            isRequired: true,
          ),
          const ApiField(
            name: 'fields',
            label: 'Fields',
            hint: 'Comma-separated list of fields to include in the response',
          ),
        ],
      };
}
