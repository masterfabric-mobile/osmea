import 'package:apis/apis.dart';
import 'package:apis/network/remote/store_properties/province/abstract/province_service.dart';
import 'package:apis/network/remote/store_properties/province/freezed_model/request/updates_existing_province_for_country_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:get_it/get_it.dart';
import 'package:example/services/api_service_registry.dart';

///**************************************************************
///************* ✏️ UPDATE PROVINCE FOR COUNTRY ****************
///**************************************************************

class UpdatesProvinceForCountryHandler implements ApiRequestHandler {
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

    final countryId = params['country_id'];
    final provinceId = params['province_id'];
    final name = params['name'];
    final tax = params['tax'];

    if (countryId == null ||
        countryId.isEmpty ||
        provinceId == null ||
        provinceId.isEmpty ||
        name == null ||
        name.isEmpty) {
      return {
        "status": "error",
        "message":
            "Missing required parameters: country_id, province_id, name.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final request = UpdatesExistingProvinceForCountryRequest(
        province: ProvinceUpdate(
          name: name,
          tax: tax != null ? double.tryParse(tax) : null,
        ),
      );

      final response =
          await GetIt.I<ProvinceService>().updateProvinceForCountry(
        apiVersion: ApiNetwork.apiVersion,
        countryId: countryId,
        provinceId: provinceId,
        model: request,
      );

      return {
        "status": "success",
        "data": response.toJson(),
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Failed to update province: ${e.toString()}",
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
            name: 'country_id',
            label: 'Country ID',
            hint: 'ID of the country containing the province',
            isRequired: true,
          ),
          const ApiField(
            name: 'province_id',
            label: 'Province ID',
            hint: 'ID of the province to be updated',
            isRequired: true,
          ),
          const ApiField(
            name: 'name',
            label: 'Province Name',
            hint: 'New name of the province',
            isRequired: true,
          ),
          const ApiField(
            name: 'tax',
            label: 'Province Tax',
            hint: 'New tax value (optional)',
          ),
        ],
      };
}
